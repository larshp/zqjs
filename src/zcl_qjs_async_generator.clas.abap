CLASS zcl_qjs_async_generator DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING runtime TYPE REF TO zcl_qjs_runtime
        function        TYPE REF TO zcl_qjs_function
        closure         TYPE REF TO zcl_qjs_closure
        this_value      TYPE zcl_qjs_value=>ty_value
        arguments       TYPE zif_qjs_callable=>ty_arguments OPTIONAL
      RAISING zcx_qjs_error.
    METHODS enqueue
      IMPORTING kind TYPE i input TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS resume_await
      IMPORTING value TYPE zcl_qjs_value=>ty_value rejected TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS resume_result
      IMPORTING value TYPE zcl_qjs_value=>ty_value rejected TYPE abap_bool
        done TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS resume_delegate
      IMPORTING value TYPE zcl_qjs_value=>ty_value rejected TYPE abap_bool
      RAISING zcx_qjs_error.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_request,
      kind    TYPE i,
      input   TYPE zcl_qjs_value=>ty_value,
      promise TYPE REF TO zcl_qjs_object,
      END OF ty_request.
    TYPES ty_requests TYPE STANDARD TABLE OF ty_request WITH DEFAULT KEY.
    DATA mo_runtime TYPE REF TO zcl_qjs_runtime.
    DATA mo_function TYPE REF TO zcl_qjs_function.
    DATA mo_closure TYPE REF TO zcl_qjs_closure.
    DATA mo_vm TYPE REF TO zcl_qjs_vm.
    DATA ms_this TYPE zcl_qjs_value=>ty_value.
    DATA mt_arguments TYPE zif_qjs_callable=>ty_arguments.
    DATA mt_requests TYPE ty_requests.
    DATA mv_state TYPE i.
    DATA mv_waiting TYPE abap_bool.
    DATA mv_await_resume_kind TYPE i.
    DATA mv_delegating TYPE abap_bool.
    DATA mv_delegate_initial TYPE abap_bool.
    DATA mv_delegate_close TYPE abap_bool.
    DATA mv_delegate_kind TYPE i.
    DATA ms_delegate_iterator TYPE zcl_qjs_value=>ty_value.
    DATA ms_delegate_next TYPE zcl_qjs_value=>ty_value.
    METHODS process RAISING zcx_qjs_error.
    METHODS execute_current
      IMPORTING resume  TYPE abap_bool DEFAULT abap_false
        resume_value    TYPE zcl_qjs_value=>ty_value OPTIONAL
        resume_rejected TYPE abap_bool DEFAULT abap_false
        resume_kind     TYPE i DEFAULT 0
      RAISING zcx_qjs_error.
    METHODS await_value
      IMPORTING value TYPE zcl_qjs_value=>ty_value result_mode TYPE abap_bool
        done TYPE abap_bool DEFAULT abap_false
        resume_kind TYPE i DEFAULT 0
      RAISING zcx_qjs_error.
    METHODS finish_current
      IMPORTING value TYPE zcl_qjs_value=>ty_value rejected TYPE abap_bool
        done TYPE abap_bool DEFAULT abap_false
      RAISING zcx_qjs_error.
    METHODS delegate_current RAISING zcx_qjs_error.
    METHODS await_delegate
      IMPORTING value TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS delegate_error
      IMPORTING value TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
ENDCLASS.

CLASS zcl_qjs_async_generator IMPLEMENTATION.
  METHOD constructor.
    IF runtime IS NOT BOUND OR function IS NOT BOUND OR closure IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Async generator requires runtime, function, and closure'.
    ENDIF.
    mo_runtime = runtime.
    mo_function = function.
    mo_closure = closure.
    ms_this = this_value.
    mt_arguments = arguments.
    CREATE OBJECT mo_vm
      EXPORTING runtime = mo_runtime limits = mo_runtime->get_limits( ).
    mo_vm->execute(
      function = mo_function initial_closure = mo_closure
      initial_this = ms_this initial_arguments = mt_arguments ).
    IF mo_vm->was_suspended( ) = abap_false
        OR mo_vm->was_await_suspended( ) = abap_true.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Async generator did not reach its initial suspension'.
    ENDIF.
    mv_state = 1.
  ENDMETHOD.

  METHOD enqueue.
    DATA(lo_promise) = mo_runtime->create_promise( ).
    APPEND VALUE #( kind = kind input = input promise = lo_promise ) TO mt_requests.
    process( ).
    result = zcl_qjs_value=>new_object( lo_promise ).
  ENDMETHOD.

  METHOD process.
    IF mv_waiting = abap_true OR mt_requests IS INITIAL.
      RETURN.
    ENDIF.
    READ TABLE mt_requests INDEX 1 INTO DATA(ls_request).
    IF mv_state = 3.
      IF ls_request-kind = 2.
        finish_current(
          value = ls_request-input rejected = abap_true done = abap_true ).
      ELSEIF ls_request-kind = 1.
        await_value(
          value = ls_request-input result_mode = abap_true done = abap_true ).
      ELSE.
        finish_current(
          value = zcl_qjs_value=>new_undefined( )
          rejected = abap_false done = abap_true ).
      ENDIF.
      RETURN.
    ENDIF.
    IF mv_state = 1 AND ls_request-kind <> 0.
      mv_state = 3.
      IF ls_request-kind = 2.
        finish_current(
          value = ls_request-input rejected = abap_true done = abap_true ).
      ELSE.
        await_value(
          value = ls_request-input result_mode = abap_true done = abap_true ).
      ENDIF.
      RETURN.
    ENDIF.
    IF mv_delegating = abap_true.
      delegate_current( ).
      RETURN.
    ENDIF.
    IF mv_state = 2 AND ls_request-kind = 1.
      await_value(
        value = ls_request-input result_mode = abap_false resume_kind = 1 ).
      RETURN.
    ENDIF.
    execute_current( ).
  ENDMETHOD.

  METHOD execute_current.
    READ TABLE mt_requests INDEX 1 INTO DATA(ls_request).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    DATA ls_value TYPE zcl_qjs_value=>ty_value.
    TRY.
        IF resume = abap_true.
          ls_value = mo_vm->execute(
            function = mo_function resume = abap_true
            resume_kind = COND i(
              WHEN resume_rejected = abap_true THEN 2 ELSE resume_kind )
            resume_value = resume_value ).
        ELSEIF mv_state = 1.
          ls_value = mo_vm->execute(
            function = mo_function resume = abap_true resume_kind = 0
            resume_value = zcl_qjs_value=>new_undefined( ) ).
        ELSE.
          ls_value = mo_vm->execute(
            function = mo_function resume = abap_true
            resume_kind = ls_request-kind resume_value = ls_request-input ).
        ENDIF.
      CATCH zcx_qjs_throw INTO DATA(lx_throw).
        mv_state = 3.
        finish_current(
          value = lx_throw->value rejected = abap_true done = abap_true ).
        RETURN.
      CATCH zcx_qjs_error INTO DATA(lx_error).
        mv_state = 3.
        finish_current(
          value = mo_runtime->create_error_from_reason( lx_error->reason )
          rejected = abap_true done = abap_true ).
        RETURN.
    ENDTRY.
    IF mo_vm->was_async_yield_star_suspended( ) = abap_true.
      mv_state = 2.
      mv_delegating = abap_true.
      mv_delegate_initial = abap_true.
      ms_delegate_iterator = ls_value.
      delegate_current( ).
    ELSEIF mo_vm->was_await_suspended( ) = abap_true.
      await_value( value = ls_value result_mode = abap_false ).
    ELSEIF mo_vm->was_suspended( ) = abap_true.
      mv_state = 2.
      await_value( value = ls_value result_mode = abap_true done = abap_false ).
    ELSE.
      mv_state = 3.
      finish_current(
        value = ls_value rejected = abap_false done = abap_true ).
    ENDIF.
  ENDMETHOD.

  METHOD await_value.
    DATA(lo_awaited) = mo_runtime->create_promise( ).
    lo_awaited->promise_settle( value = value rejected = abap_false ).
    DATA lo_self_ref TYPE REF TO object.
    lo_self_ref = me.
    DATA(ls_self) = zcl_qjs_value=>new_object( lo_self_ref ).
    DATA lv_fulfill_id TYPE i.
    DATA lv_reject_id TYPE i.
    IF result_mode = abap_true.
      lv_fulfill_id = zcl_qjs_native_function=>id_async_gen_result_fulfill.
      lv_reject_id = zcl_qjs_native_function=>id_async_gen_result_reject.
    ELSE.
      lv_fulfill_id = zcl_qjs_native_function=>id_async_gen_await_fulfill.
      lv_reject_id = zcl_qjs_native_function=>id_async_gen_await_reject.
    ENDIF.
    DATA(lo_fulfill) = NEW zcl_qjs_native_function(
      id = lv_fulfill_id runtime = mo_runtime bound_target = ls_self
      bound_this = zcl_qjs_value=>new_boolean( done ) ).
    DATA(lo_reject) = NEW zcl_qjs_native_function(
      id = lv_reject_id runtime = mo_runtime bound_target = ls_self
      bound_this = zcl_qjs_value=>new_boolean( done ) ).
    DATA lo_fulfill_ref TYPE REF TO object.
    DATA lo_reject_ref TYPE REF TO object.
    lo_fulfill_ref = lo_fulfill.
    lo_reject_ref = lo_reject.
    DATA(lo_dummy) = mo_runtime->create_promise( ).
    mv_waiting = abap_true.
    mv_await_resume_kind = resume_kind.
    lo_awaited->promise_add_reaction(
      on_fulfilled = zcl_qjs_value=>new_object( lo_fulfill_ref )
      on_rejected  = zcl_qjs_value=>new_object( lo_reject_ref )
      next_promise = lo_dummy ).
  ENDMETHOD.

  METHOD resume_await.
    mv_waiting = abap_false.
    execute_current(
      resume = abap_true resume_value = value resume_rejected = rejected
      resume_kind = mv_await_resume_kind ).
  ENDMETHOD.

  METHOD resume_result.
    mv_waiting = abap_false.
    IF rejected = abap_true AND done = abap_false.
      execute_current(
        resume = abap_true resume_value = value resume_rejected = abap_true ).
      RETURN.
    ENDIF.
    finish_current( value = value rejected = rejected done = done ).
  ENDMETHOD.

  METHOD finish_current.
    READ TABLE mt_requests INDEX 1 INTO DATA(ls_request).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    IF rejected = abap_true.
      ls_request-promise->promise_settle( value = value rejected = abap_true ).
    ELSE.
      DATA(lo_result) = mo_runtime->create_object( ).
      lo_result->define_property( name = 'value' value = value ).
      lo_result->define_property(
        name = 'done' value = zcl_qjs_value=>new_boolean( done ) ).
      ls_request-promise->promise_settle(
        value = zcl_qjs_value=>new_object( lo_result ) rejected = abap_false ).
    ENDIF.
    DELETE mt_requests INDEX 1.
    CLEAR mv_waiting.
    process( ).
  ENDMETHOD.

  METHOD delegate_current.
    READ TABLE mt_requests INDEX 1 INTO DATA(ls_request).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    DATA lv_kind TYPE i.
    DATA lv_initial TYPE abap_bool.
    DATA ls_input TYPE zcl_qjs_value=>ty_value.
    IF mv_delegate_initial = abap_true.
      lv_initial = abap_true.
      lv_kind = 0.
      ls_input = zcl_qjs_value=>new_undefined( ).
      CLEAR mv_delegate_initial.
    ELSE.
      lv_kind = ls_request-kind.
      ls_input = ls_request-input.
    ENDIF.
    TRY.
        IF lv_kind = 0.
          IF lv_initial = abap_true.
            ms_delegate_next = mo_runtime->iterator_method(
              iterator = ms_delegate_iterator name = 'next' ).
          ENDIF.
          DATA lt_delegate_arguments TYPE zif_qjs_callable=>ty_arguments.
          APPEND ls_input TO lt_delegate_arguments.
          DATA(ls_delegate_step) = mo_runtime->invoke_callable(
            callable = ms_delegate_next this_value = ms_delegate_iterator
            arguments = lt_delegate_arguments ).
          DATA(ls_call) = VALUE zcl_qjs_runtime=>ty_iterator_call_result(
            found = abap_true value = ls_delegate_step ).
        ELSE.
          ls_call = mo_runtime->iterator_resume_value(
            iterator = ms_delegate_iterator kind = lv_kind value = ls_input
            pass_value = abap_true ).
        ENDIF.
        IF ls_call-found = abap_false.
          IF lv_kind = 1.
            CLEAR mv_delegating.
            await_value(
              value = ls_input result_mode = abap_false resume_kind = 1 ).
            RETURN.
          ELSEIF lv_kind = 2.
            DATA(ls_close) = mo_runtime->iterator_resume_value(
              iterator = ms_delegate_iterator kind = 1
              value = zcl_qjs_value=>new_undefined( ) pass_value = abap_false ).
            IF ls_close-found = abap_false.
              CLEAR mv_delegating.
              delegate_error( mo_runtime->create_error(
                name = 'TypeError' message = 'iterator has no throw method' ) ).
              RETURN.
            ENDIF.
            mv_delegate_close = abap_true.
            mv_delegate_kind = 2.
            await_delegate( ls_close-value ).
            RETURN.
          ELSE.
            CLEAR mv_delegating.
            delegate_error( mo_runtime->create_error(
              name = 'TypeError' message = 'iterator has no next method' ) ).
            RETURN.
          ENDIF.
        ENDIF.
        mv_delegate_kind = lv_kind.
        await_delegate( ls_call-value ).
      CATCH zcx_qjs_throw INTO DATA(lx_delegate_throw).
        CLEAR mv_delegating.
        delegate_error( lx_delegate_throw->value ).
      CATCH zcx_qjs_error INTO DATA(lx_delegate_error).
        CLEAR mv_delegating.
        delegate_error(
          mo_runtime->create_error_from_reason( lx_delegate_error->reason ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD await_delegate.
    DATA(lo_awaited) = mo_runtime->create_promise( ).
    lo_awaited->promise_settle( value = value rejected = abap_false ).
    DATA lo_self_ref TYPE REF TO object.
    lo_self_ref = me.
    DATA(ls_self) = zcl_qjs_value=>new_object( lo_self_ref ).
    DATA(lo_fulfill) = NEW zcl_qjs_native_function(
      id = zcl_qjs_native_function=>id_async_gen_delegate_fulfill
      runtime = mo_runtime bound_target = ls_self ).
    DATA(lo_reject) = NEW zcl_qjs_native_function(
      id = zcl_qjs_native_function=>id_async_gen_delegate_reject
      runtime = mo_runtime bound_target = ls_self ).
    DATA lo_fulfill_ref TYPE REF TO object.
    DATA lo_reject_ref TYPE REF TO object.
    lo_fulfill_ref = lo_fulfill.
    lo_reject_ref = lo_reject.
    DATA(lo_dummy) = mo_runtime->create_promise( ).
    mv_waiting = abap_true.
    lo_awaited->promise_add_reaction(
      on_fulfilled = zcl_qjs_value=>new_object( lo_fulfill_ref )
      on_rejected  = zcl_qjs_value=>new_object( lo_reject_ref )
      next_promise = lo_dummy ).
  ENDMETHOD.

  METHOD resume_delegate.
    mv_waiting = abap_false.
    IF rejected = abap_true.
      CLEAR mv_delegating.
      CLEAR mv_delegate_close.
      delegate_error( value ).
      RETURN.
    ENDIF.
    IF mv_delegate_close = abap_true.
      CLEAR mv_delegate_close.
      CLEAR mv_delegating.
      IF value-tag <> zcl_qjs_value=>tag_object.
        delegate_error( mo_runtime->create_error(
          name = 'TypeError' message = 'iterator result is not an object' ) ).
      ELSE.
        delegate_error( mo_runtime->create_error(
          name = 'TypeError' message = 'iterator has no throw method' ) ).
      ENDIF.
      RETURN.
    ENDIF.
    TRY.
        DATA(ls_step) = mo_runtime->iterator_result( value ).
      CATCH zcx_qjs_throw INTO DATA(lx_result_throw).
        CLEAR mv_delegating.
        delegate_error( lx_result_throw->value ).
        RETURN.
      CATCH zcx_qjs_error INTO DATA(lx_result_error).
        CLEAR mv_delegating.
        delegate_error(
          mo_runtime->create_error_from_reason( lx_result_error->reason ) ).
        RETURN.
    ENDTRY.
    IF ls_step-done = abap_true.
      CLEAR mv_delegating.
      IF mv_delegate_kind = 1.
        await_value(
          value = ls_step-value result_mode = abap_false resume_kind = 1 ).
      ELSE.
        execute_current(
          resume = abap_true resume_value = ls_step-value resume_kind = 0 ).
      ENDIF.
      RETURN.
    ENDIF.
    mv_state = 2.
    finish_current(
      value = ls_step-value rejected = abap_false done = abap_false ).
  ENDMETHOD.

  METHOD delegate_error.
    execute_current(
      resume = abap_true resume_value = value resume_rejected = abap_true ).
  ENDMETHOD.
ENDCLASS.
