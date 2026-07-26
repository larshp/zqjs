INTERFACE zif_qjs_constructable PUBLIC.
  METHODS construct
    IMPORTING
      runtime       TYPE REF TO zcl_qjs_runtime
      arguments     TYPE zif_qjs_callable=>ty_arguments
    RETURNING
      VALUE(result) TYPE zcl_qjs_value=>ty_value
    RAISING
      zcx_qjs_error.
ENDINTERFACE.
