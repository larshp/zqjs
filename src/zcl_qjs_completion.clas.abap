CLASS zcl_qjs_completion DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CONSTANTS kind_normal   TYPE i VALUE 1.
    CONSTANTS kind_return   TYPE i VALUE 2.
    CONSTANTS kind_throw    TYPE i VALUE 3.
    CONSTANTS kind_break    TYPE i VALUE 4.
    CONSTANTS kind_continue TYPE i VALUE 5.

    TYPES:
      BEGIN OF ty_completion,
        kind  TYPE i,
        value TYPE zcl_qjs_value=>ty_value,
      END OF ty_completion.

    CLASS-METHODS normal
      IMPORTING
        value         TYPE zcl_qjs_value=>ty_value
      RETURNING
        VALUE(result) TYPE ty_completion.

    CLASS-METHODS returned
      IMPORTING
        value         TYPE zcl_qjs_value=>ty_value
      RETURNING
        VALUE(result) TYPE ty_completion.

    CLASS-METHODS thrown
      IMPORTING
        value         TYPE zcl_qjs_value=>ty_value
      RETURNING
        VALUE(result) TYPE ty_completion.

    CLASS-METHODS broken
      IMPORTING
        value         TYPE zcl_qjs_value=>ty_value
      RETURNING
        VALUE(result) TYPE ty_completion.

    CLASS-METHODS continued
      IMPORTING
        value         TYPE zcl_qjs_value=>ty_value
      RETURNING
        VALUE(result) TYPE ty_completion.
ENDCLASS.

CLASS zcl_qjs_completion IMPLEMENTATION.
  METHOD normal.
    result-kind = kind_normal.
    result-value = value.
  ENDMETHOD.

  METHOD returned.
    result-kind = kind_return.
    result-value = value.
  ENDMETHOD.

  METHOD thrown.
    result-kind = kind_throw.
    result-value = value.
  ENDMETHOD.

  METHOD broken.
    result-kind = kind_break.
    result-value = value.
  ENDMETHOD.

  METHOD continued.
    result-kind = kind_continue.
    result-value = value.
  ENDMETHOD.
ENDCLASS.
