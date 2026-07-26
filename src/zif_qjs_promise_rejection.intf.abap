INTERFACE zif_qjs_promise_rejection PUBLIC.
  METHODS track
    IMPORTING
      promise TYPE REF TO zcl_qjs_object
      reason  TYPE zcl_qjs_value=>ty_value
      handled TYPE abap_bool.
ENDINTERFACE.
