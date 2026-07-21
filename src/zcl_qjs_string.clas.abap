CLASS zcl_qjs_string DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS create
      IMPORTING
        value         TYPE string
      RETURNING
        VALUE(result) TYPE REF TO zcl_qjs_string.

    METHODS length
      RETURNING
        VALUE(result) TYPE i.

    METHODS code_unit_at
      IMPORTING
        index         TYPE i
      RETURNING
        VALUE(result) TYPE string
      RAISING
        zcx_qjs_error.

    METHODS concat
      IMPORTING
        other         TYPE REF TO zcl_qjs_string
      RETURNING
        VALUE(result) TYPE REF TO zcl_qjs_string.

    METHODS equals
      IMPORTING
        other         TYPE REF TO zcl_qjs_string
      RETURNING
        VALUE(result) TYPE abap_bool.

    METHODS as_string
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
    DATA mv_value TYPE string.

    METHODS constructor
      IMPORTING
        value TYPE string.
ENDCLASS.

CLASS zcl_qjs_string IMPLEMENTATION.
  METHOD constructor.
    mv_value = value.
  ENDMETHOD.

  METHOD create.
    CREATE OBJECT result
      EXPORTING
        value = value.
  ENDMETHOD.

  METHOD length.
    result = strlen( mv_value ).
  ENDMETHOD.

  METHOD code_unit_at.
    IF index < 0 OR index >= strlen( mv_value ).
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING
          reason = 'String code-unit index out of bounds'.
    ENDIF.
    result = mv_value+index(1).
  ENDMETHOD.

  METHOD concat.
    DATA lv_value TYPE string.
    lv_value = mv_value && other->as_string( ).
    result = create( lv_value ).
  ENDMETHOD.

  METHOD equals.
    result = abap_false.
    IF other IS BOUND AND mv_value = other->as_string( ).
      result = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD as_string.
    result = mv_value.
  ENDMETHOD.
ENDCLASS.
