INTERFACE zif_qjs_property_container PUBLIC.
  METHODS get_property
    IMPORTING name          TYPE string
    RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
    RAISING zcx_qjs_error.
  METHODS set_property
    IMPORTING name TYPE string value TYPE zcl_qjs_value=>ty_value
    RAISING zcx_qjs_error.
  METHODS delete_property
    IMPORTING name          TYPE string
    RETURNING VALUE(result) TYPE abap_bool.
  METHODS get_symbol_property
    IMPORTING identity      TYPE i
    RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
    RAISING zcx_qjs_error.
  METHODS set_symbol_property
    IMPORTING identity TYPE i value TYPE zcl_qjs_value=>ty_value
    RAISING zcx_qjs_error.
  METHODS delete_symbol_property
    IMPORTING identity      TYPE i
    RETURNING VALUE(result) TYPE abap_bool.
ENDINTERFACE.
