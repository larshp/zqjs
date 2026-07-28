CLASS zcx_qjs_error DEFINITION PUBLIC INHERITING FROM cx_static_check.
  PUBLIC SECTION.
    DATA reason TYPE string READ-ONLY.

    METHODS constructor
      IMPORTING
        reason TYPE string.
ENDCLASS.

CLASS zcx_qjs_error IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    me->reason = reason.
  ENDMETHOD.
ENDCLASS.

