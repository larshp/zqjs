CLASS zcl_qjs_template_site DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS add_part IMPORTING cooked TYPE string raw TYPE string.
    METHODS materialize
      IMPORTING runtime TYPE REF TO zcl_qjs_runtime
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_part,
      cooked TYPE string,
      raw TYPE string,
    END OF ty_part.
    TYPES ty_parts TYPE STANDARD TABLE OF ty_part WITH DEFAULT KEY.
    DATA mt_parts TYPE ty_parts.
    DATA mo_runtime TYPE REF TO zcl_qjs_runtime.
    DATA mo_template TYPE REF TO zcl_qjs_object.
ENDCLASS.

CLASS zcl_qjs_template_site IMPLEMENTATION.
  METHOD add_part.
    APPEND VALUE #( cooked = cooked raw = raw ) TO mt_parts.
  ENDMETHOD.

  METHOD materialize.
    IF mo_template IS BOUND AND mo_runtime = runtime.
      result = zcl_qjs_value=>new_object( mo_template ).
      RETURN.
    ENDIF.

    DATA(lo_raw) = runtime->create_array( ).
    DATA(lo_cooked) = runtime->create_array( ).
    DATA lv_index TYPE i.
    DATA lv_name TYPE string.
    LOOP AT mt_parts INTO DATA(ls_part).
      lv_index = sy-tabix - 1.
      lv_name = lv_index.
      CONDENSE lv_name NO-GAPS.
      lo_raw->define_property(
        name = lv_name value = zcl_qjs_value=>new_string( ls_part-raw )
        writable = abap_false enumerable = abap_true configurable = abap_false ).
      lo_cooked->define_property(
        name = lv_name value = zcl_qjs_value=>new_string( ls_part-cooked )
        writable = abap_false enumerable = abap_true configurable = abap_false ).
    ENDLOOP.
    lo_raw->set_array_length( lines( mt_parts ) ).
    lo_raw->lock_array_length( ).
    lo_raw->prevent_extensions( ).
    lo_cooked->set_array_length( lines( mt_parts ) ).
    lo_cooked->lock_array_length( ).
    lo_cooked->define_property(
      name = 'raw' value = zcl_qjs_value=>new_object( lo_raw )
      writable = abap_false enumerable = abap_false configurable = abap_false ).
    lo_cooked->prevent_extensions( ).
    mo_runtime = runtime.
    mo_template = lo_cooked.
    result = zcl_qjs_value=>new_object( mo_template ).
  ENDMETHOD.
ENDCLASS.
