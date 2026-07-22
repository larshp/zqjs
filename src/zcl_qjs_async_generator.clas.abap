CLASS zcl_qjs_async_generator DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING runtime TYPE REF TO zcl_qjs_runtime
        function TYPE REF TO zcl_qjs_function
        closure TYPE REF TO zcl_qjs_closure
        this_value TYPE zcl_qjs_value=>ty_value
        arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
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
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_request,
      kind TYPE i,
      input TYPE zcl_qjs_value=>ty_value,
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
    METHODS process RAISING zcx_qjs_error.
    METHODS execute_current
      IMPORTING resume TYPE abap_bool DEFAULT abap_false
        resume_value TYPE zcl_qjs_value=>ty_value OPTIONAL
        resume_rejected TYPE abap_bool DEFAULT abap_false
      RAISING zcx_qjs_error.
    METHODS await_value
      IMPORTING value TYPE zcl_qjs_value=>ty_value result_mode TYPE abap_bool
        done TYPE abap_bool DEFAULT abap_false
      RAISING zcx_qjs_error.
    METHODS finish_current
      IMPORTING value TYPE zcl_qjs_value=>ty_value rejected TYPE abap_bool
        done TYPE abap_bool DEFAULT abap_false
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
            resume_kind = COND i( WHEN resume_rejected = abap_true THEN 2 ELSE 0 )
            resume_value = resume_value ).
        ELSEIF mv_state = 1.
          ls_value = mo_vm->execute(
            function = mo_function initial_closure = mo_closure
            initial_this = ms_this initial_arguments = mt_arguments ).
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
    IF mo_vm->was_await_suspended( ) = abap_true.
      await_value( value = ls_value result_mode = abap_false ).
    ELSEIF mo_vm->was_suspended( ) = abap_true.
      mv_state = 2.
      await_value( value = ls_value result_mode = abap_true done = abap_false ).
    ELSE.
      mv_state = 3.
      await_value( value = ls_value result_mode = abap_true done = abap_true ).
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
      lv_fulfill_id = zcl_qjs_native_function=>id_async_generator_result_fulfill.
      lv_reject_id = zcl_qjs_native_function=>id_async_generator_result_reject.
    ELSE.
      lv_fulfill_id = zcl_qjs_native_function=>id_async_generator_await_fulfill.
      lv_reject_id = zcl_qjs_native_function=>id_async_generator_await_reject.
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
    lo_awaited->promise_add_reaction(
      on_fulfilled = zcl_qjs_value=>new_object( lo_fulfill_ref )
      on_rejected  = zcl_qjs_value=>new_object( lo_reject_ref )
      next_promise = lo_dummy ).
  ENDMETHOD.

  METHOD resume_await.
    mv_waiting = abap_false.
    execute_current(
      resume = abap_true resume_value = value resume_rejected = rejected ).
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
ENDCLASS.
