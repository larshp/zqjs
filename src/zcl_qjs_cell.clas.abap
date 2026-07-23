CLASS zcl_qjs_cell DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING value TYPE zcl_qjs_value=>ty_value
        initialized TYPE abap_bool DEFAULT abap_true
        mutable TYPE abap_bool DEFAULT abap_true
        runtime TYPE REF TO zcl_qjs_runtime OPTIONAL.
    METHODS get RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value.
    METHODS set IMPORTING value TYPE zcl_qjs_value=>ty_value.
    METHODS initialize IMPORTING value TYPE zcl_qjs_value=>ty_value.
    METHODS reset_uninitialized.
    DATA ms_value TYPE zcl_qjs_value=>ty_value.
    DATA mv_initialized TYPE abap_bool.
    DATA mv_mutable TYPE abap_bool.
  PRIVATE SECTION.
    DATA mo_runtime TYPE REF TO zcl_qjs_runtime.
    METHODS error_value
      IMPORTING name TYPE string message TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value.
ENDCLASS.

CLASS zcl_qjs_cell IMPLEMENTATION.
  METHOD constructor.
    ms_value = value.
    mv_initialized = initialized.
    mv_mutable = mutable.
    mo_runtime = runtime.
  ENDMETHOD.
  METHOD error_value.
    IF mo_runtime IS BOUND.
      TRY.
          result = mo_runtime->create_error( name = name message = message ).
          RETURN.
        CATCH zcx_qjs_error.
      ENDTRY.
    ENDIF.
    DATA lv_separator TYPE string VALUE ': '.
    result = zcl_qjs_value=>new_string( name && lv_separator && message ).
  ENDMETHOD.
  METHOD get.
    IF mv_initialized = abap_false.
      RAISE EXCEPTION TYPE zcx_qjs_throw
        EXPORTING value = error_value(
          name = 'ReferenceError' message = 'lexical binding is uninitialized' ).
    ENDIF.
    result = ms_value.
  ENDMETHOD.
  METHOD set.
    IF mv_initialized = abap_false.
      RAISE EXCEPTION TYPE zcx_qjs_throw
        EXPORTING value = error_value(
          name = 'ReferenceError' message = 'lexical binding is uninitialized' ).
    ENDIF.
    IF mv_mutable = abap_false.
      RAISE EXCEPTION TYPE zcx_qjs_throw
        EXPORTING value = error_value(
          name = 'TypeError' message = 'assignment to constant binding' ).
    ENDIF.
    ms_value = value.
  ENDMETHOD.
  METHOD initialize.
    IF mv_initialized = abap_true.
      RAISE EXCEPTION TYPE zcx_qjs_throw
        EXPORTING value = error_value(
          name = 'ReferenceError' message = 'lexical binding is already initialized' ).
    ENDIF.
    ms_value = value.
    mv_initialized = abap_true.
  ENDMETHOD.
  METHOD reset_uninitialized.
    CLEAR ms_value.
    mv_initialized = abap_false.
  ENDMETHOD.
ENDCLASS.
