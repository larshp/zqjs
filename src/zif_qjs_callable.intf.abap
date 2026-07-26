INTERFACE zif_qjs_callable PUBLIC.
  TYPES ty_arguments TYPE STANDARD TABLE OF zcl_qjs_value=>ty_value WITH DEFAULT KEY.

  METHODS call
    IMPORTING
      this_value    TYPE zcl_qjs_value=>ty_value
      arguments     TYPE ty_arguments
    RETURNING
      VALUE(result) TYPE zcl_qjs_value=>ty_value
    RAISING
      zcx_qjs_error.
ENDINTERFACE.
