CLASS zcl_qjs_accessor_pair DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    DATA getter TYPE zcl_qjs_value=>ty_value READ-ONLY.
    DATA setter TYPE zcl_qjs_value=>ty_value READ-ONLY.
    METHODS constructor IMPORTING getter TYPE zcl_qjs_value=>ty_value
      setter TYPE zcl_qjs_value=>ty_value.
ENDCLASS.

CLASS zcl_qjs_accessor_pair IMPLEMENTATION.
  METHOD constructor.
    me->getter = getter.
    me->setter = setter.
  ENDMETHOD.
ENDCLASS.
