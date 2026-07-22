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

    METHODS code_unit_value_at
      IMPORTING
        index TYPE i
      RETURNING
        VALUE(result) TYPE i
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

  METHOD code_unit_value_at.
    DATA lv_hex TYPE x LENGTH 2.
    TRY.
        lv_hex = cl_abap_conv_out_ce=>uccp( code_unit_at( index ) ).
      CATCH cx_sy_conversion_codepage cx_sy_codepage_converter_init
          cx_parameter_invalid_range.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Invalid UTF-16 code unit'.
    ENDTRY.
    result = lv_hex.
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
