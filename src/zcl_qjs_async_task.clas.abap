CLASS zcl_qjs_async_task DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING runtime TYPE REF TO zcl_qjs_runtime
        closure         TYPE REF TO zcl_qjs_closure
        this_value      TYPE zcl_qjs_value=>ty_value
        arguments       TYPE zif_qjs_callable=>ty_arguments OPTIONAL
      RAISING zcx_qjs_error.
    METHODS start
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS resume
      IMPORTING value TYPE zcl_qjs_value=>ty_value
        rejected      TYPE abap_bool
      RAISING zcx_qjs_error.
  PRIVATE SECTION.
    DATA mo_runtime TYPE REF TO zcl_qjs_runtime.
    DATA mo_closure TYPE REF TO zcl_qjs_closure.
    DATA mo_vm TYPE REF TO zcl_qjs_vm.
    DATA mo_promise TYPE REF TO zcl_qjs_object.
    DATA ms_this TYPE zcl_qjs_value=>ty_value.
    DATA mt_arguments TYPE zif_qjs_callable=>ty_arguments.
    DATA mv_started TYPE abap_bool.
    DATA mv_complete TYPE abap_bool.
    METHODS execute_step
      IMPORTING resume_value TYPE zcl_qjs_value=>ty_value OPTIONAL
        rejected             TYPE abap_bool DEFAULT abap_false
      RAISING zcx_qjs_error.
    METHODS await_value
      IMPORTING value TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
ENDCLASS.

CLASS zcl_qjs_async_task IMPLEMENTATION.
  METHOD constructor.
    IF runtime IS NOT BOUND OR closure IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Async task requires a runtime and closure'.
    ENDIF.
    mo_runtime = runtime.
    mo_closure = closure.
    ms_this = this_value.
    mt_arguments = arguments.
    mo_promise = mo_runtime->create_promise( ).
    CREATE OBJECT mo_vm
      EXPORTING runtime = mo_runtime limits = mo_runtime->get_limits( ).
  ENDMETHOD.

  METHOD start.
    IF mv_started = abap_false.
      mv_started = abap_true.
      execute_step( ).
    ENDIF.
    result = zcl_qjs_value=>new_object( mo_promise ).
  ENDMETHOD.

  METHOD resume.
    IF mv_complete = abap_false.
      execute_step( resume_value = value rejected = rejected ).
    ENDIF.
  ENDMETHOD.

  METHOD execute_step.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    TRY.
        IF mv_started = abap_true AND mo_vm->was_suspended( ) = abap_true.
          ls_result = mo_vm->execute(
            function = mo_closure->get_function( ) resume = abap_true
            resume_kind = COND i( WHEN rejected = abap_true THEN 2 ELSE 0 )
            resume_value = resume_value ).
        ELSE.
          ls_result = mo_vm->execute(
            function = mo_closure->get_function( ) initial_closure = mo_closure
            initial_this = ms_this initial_arguments = mt_arguments ).
        ENDIF.
      CATCH zcx_qjs_throw INTO DATA(lx_throw).
        mv_complete = abap_true.
        mo_promise->promise_settle( value = lx_throw->value rejected = abap_true ).
        RETURN.
      CATCH zcx_qjs_error INTO DATA(lx_error).
        mv_complete = abap_true.
        mo_promise->promise_settle(
          value    = mo_runtime->create_error_from_reason( lx_error->reason )
          rejected = abap_true ).
        RETURN.
    ENDTRY.
    IF mo_vm->was_await_suspended( ) = abap_true.
      await_value( ls_result ).
    ELSE.
      mv_complete = abap_true.
      mo_promise->promise_settle( value = ls_result rejected = abap_false ).
    ENDIF.
  ENDMETHOD.

  METHOD await_value.
    DATA(lo_awaited) = mo_runtime->create_promise( ).
    lo_awaited->promise_settle( value = value rejected = abap_false ).
    DATA lo_self_ref TYPE REF TO object.
    lo_self_ref = me.
    DATA(ls_self) = zcl_qjs_value=>new_object( lo_self_ref ).
    DATA(lo_fulfill) = NEW zcl_qjs_native_function(
      id = zcl_qjs_native_function=>id_async_resume_fulfill runtime = mo_runtime
      bound_target = ls_self ).
    DATA(lo_reject) = NEW zcl_qjs_native_function(
      id = zcl_qjs_native_function=>id_async_resume_reject runtime = mo_runtime
      bound_target = ls_self ).
    DATA lo_fulfill_ref TYPE REF TO object.
    DATA lo_reject_ref TYPE REF TO object.
    lo_fulfill_ref = lo_fulfill.
    lo_reject_ref = lo_reject.
    DATA(lo_dummy) = mo_runtime->create_promise( ).
    lo_awaited->promise_add_reaction(
      on_fulfilled = zcl_qjs_value=>new_object( lo_fulfill_ref )
      on_rejected  = zcl_qjs_value=>new_object( lo_reject_ref )
      next_promise = lo_dummy ).
  ENDMETHOD.
ENDCLASS.
