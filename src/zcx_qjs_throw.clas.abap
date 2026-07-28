CLASS zcx_qjs_throw DEFINITION PUBLIC INHERITING FROM cx_no_check.
  PUBLIC SECTION.
    DATA value TYPE zcl_qjs_value=>ty_value READ-ONLY.

    METHODS constructor
      IMPORTING
        value TYPE zcl_qjs_value=>ty_value.
ENDCLASS.

CLASS zcx_qjs_throw IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    me->value = value.
  ENDMETHOD.
ENDCLASS.

