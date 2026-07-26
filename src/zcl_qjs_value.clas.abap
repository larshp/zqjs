CLASS zcl_qjs_value DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CONSTANTS tag_int       TYPE i VALUE 1.
    CONSTANTS tag_number    TYPE i VALUE 2.
    CONSTANTS tag_bool      TYPE i VALUE 3.
    CONSTANTS tag_null      TYPE i VALUE 4.
    CONSTANTS tag_undefined TYPE i VALUE 5.
    CONSTANTS tag_string    TYPE i VALUE 6.
    CONSTANTS tag_object    TYPE i VALUE 7.
    CONSTANTS tag_symbol    TYPE i VALUE 8.

    CONSTANTS number_finite  TYPE i VALUE 1.
    CONSTANTS number_nan     TYPE i VALUE 2.
    CONSTANTS number_pos_inf TYPE i VALUE 3.
    CONSTANTS number_neg_inf TYPE i VALUE 4.
    CONSTANTS number_neg_zero TYPE i VALUE 5.

    TYPES:
      BEGIN OF ty_value,
        tag         TYPE i,
        int_value   TYPE i,
        float_value TYPE f,
        string_ref  TYPE REF TO zcl_qjs_string,
        object_ref  TYPE REF TO object,
      END OF ty_value.

    CLASS-METHODS new_int
      IMPORTING
        value         TYPE i
      RETURNING
        VALUE(result) TYPE ty_value.

    CLASS-METHODS new_finite
      IMPORTING
        value         TYPE f
      RETURNING
        VALUE(result) TYPE ty_value.

    CLASS-METHODS new_special
      IMPORTING
        kind          TYPE i
      RETURNING
        VALUE(result) TYPE ty_value
      RAISING
        zcx_qjs_error.

    CLASS-METHODS new_boolean
      IMPORTING
        value         TYPE abap_bool
      RETURNING
        VALUE(result) TYPE ty_value.
    CLASS-METHODS as_boolean
      IMPORTING value TYPE ty_value
      RETURNING VALUE(result) TYPE abap_bool.

    CLASS-METHODS new_null
      RETURNING
        VALUE(result) TYPE ty_value.

    CLASS-METHODS new_undefined
      RETURNING
        VALUE(result) TYPE ty_value.

    CLASS-METHODS new_string
      IMPORTING
        value         TYPE string
      RETURNING
        VALUE(result) TYPE ty_value.

    CLASS-METHODS new_symbol
      IMPORTING
        identity      TYPE i
      RETURNING
        VALUE(result) TYPE ty_value
      RAISING
        zcx_qjs_error.

    CLASS-METHODS new_object
      IMPORTING reference TYPE REF TO object
      RETURNING VALUE(result) TYPE ty_value
      RAISING zcx_qjs_error.

    CLASS-METHODS is_number
      IMPORTING
        value         TYPE ty_value
      RETURNING
        VALUE(result) TYPE abap_bool.

    CLASS-METHODS as_finite_number
      IMPORTING
        value         TYPE ty_value
      RETURNING
        VALUE(result) TYPE f
      RAISING
        zcx_qjs_error.

    CLASS-METHODS strict_equal
      IMPORTING left TYPE ty_value right TYPE ty_value
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    CLASS-METHODS abstract_equal
      IMPORTING left TYPE ty_value right TYPE ty_value
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.

    CLASS-METHODS to_boolean
      IMPORTING value TYPE ty_value
      RETURNING VALUE(result) TYPE abap_bool.

    CLASS-METHODS to_string
      IMPORTING value TYPE ty_value
      RETURNING VALUE(result) TYPE string
      RAISING zcx_qjs_error.
ENDCLASS.

CLASS zcl_qjs_value IMPLEMENTATION.
  METHOD new_int.
    CLEAR result.
    result-tag = tag_int.
    result-int_value = value.
  ENDMETHOD.

  METHOD new_finite.
    CLEAR result.
    result-tag = tag_number.
    result-int_value = number_finite.
    result-float_value = value.
  ENDMETHOD.

  METHOD new_special.
    IF kind <> number_nan
        AND kind <> number_pos_inf
        AND kind <> number_neg_inf
        AND kind <> number_neg_zero.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING
          reason = 'Invalid special Number kind'.
    ENDIF.
    CLEAR result.
    result-tag = tag_number.
    result-int_value = kind.
  ENDMETHOD.

  METHOD new_boolean.
    CLEAR result.
    result-tag = tag_bool.
    IF value = abap_true.
      result-int_value = 1.
    ENDIF.
  ENDMETHOD.

  METHOD as_boolean.
    result = xsdbool( value-int_value <> 0 ).
  ENDMETHOD.

  METHOD new_null.
    CLEAR result.
    result-tag = tag_null.
  ENDMETHOD.

  METHOD new_undefined.
    CLEAR result.
    result-tag = tag_undefined.
  ENDMETHOD.

  METHOD new_string.
    CLEAR result.
    result-tag = tag_string.
    result-string_ref = zcl_qjs_string=>create( value ).
  ENDMETHOD.

  METHOD new_symbol.
    IF identity <= 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Symbol identity must be positive'.
    ENDIF.
    CLEAR result.
    result-tag = tag_symbol.
    result-int_value = identity.
  ENDMETHOD.

  METHOD new_object.
    IF reference IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'JavaScript object reference must be bound'.
    ENDIF.
    CLEAR result.
    result-tag = tag_object.
    result-object_ref = reference.
  ENDMETHOD.

  METHOD is_number.
    result = abap_false.
    IF value-tag = tag_int OR value-tag = tag_number.
      result = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD as_finite_number.
    IF value-tag = tag_int.
      result = value-int_value.
    ELSEIF value-tag = tag_number AND value-int_value = number_finite.
      result = value-float_value.
    ELSE.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING
          reason = 'Value is not a finite Number'.
    ENDIF.
  ENDMETHOD.

  METHOD strict_equal.
    " Match QuickJS's tag-first strict equality path: integer pairs and
    " non-number tag mismatches never enter the generic number machinery.
    result = abap_false.
    IF left-tag = tag_int AND right-tag = tag_int.
      result = xsdbool( left-int_value = right-int_value ).
      RETURN.
    ELSEIF ( left-tag = tag_int OR left-tag = tag_number )
        AND ( right-tag = tag_int OR right-tag = tag_number ).
      result = zcl_qjs_number=>equal( left = left right = right ).
      RETURN.
    ELSEIF left-tag <> right-tag.
      RETURN.
    ENDIF.
    CASE left-tag.
      WHEN tag_undefined OR tag_null.
        result = abap_true.
      WHEN tag_bool OR tag_symbol.
        result = xsdbool( left-int_value = right-int_value ).
      WHEN tag_string.
        result = xsdbool(
          left-string_ref->as_string( ) = right-string_ref->as_string( ) ).
      WHEN tag_object.
        result = xsdbool( left-object_ref = right-object_ref ).
    ENDCASE.
  ENDMETHOD.

  METHOD abstract_equal.
    DATA ls_converted TYPE ty_value.
    IF left-tag = right-tag
        OR ( is_number( left ) = abap_true AND is_number( right ) = abap_true ).
      result = strict_equal( left = left right = right ).
    ELSEIF ( left-tag = tag_null AND right-tag = tag_undefined )
        OR ( left-tag = tag_undefined AND right-tag = tag_null ).
      result = abap_true.
    ELSEIF is_number( left ) = abap_true AND right-tag = tag_string.
      ls_converted = zcl_qjs_number=>to_number( right ).
      result = zcl_qjs_number=>equal( left = left right = ls_converted ).
    ELSEIF left-tag = tag_string AND is_number( right ) = abap_true.
      ls_converted = zcl_qjs_number=>to_number( left ).
      result = zcl_qjs_number=>equal( left = ls_converted right = right ).
    ELSEIF left-tag = tag_bool.
      ls_converted = zcl_qjs_number=>to_number( left ).
      result = abstract_equal( left = ls_converted right = right ).
    ELSEIF right-tag = tag_bool.
      ls_converted = zcl_qjs_number=>to_number( right ).
      result = abstract_equal( left = left right = ls_converted ).
    ELSE.
      result = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD to_boolean.
    result = abap_false.
    CASE value-tag.
      WHEN tag_bool.
        result = xsdbool( value-int_value <> 0 ).
      WHEN tag_int.
        IF value-int_value <> 0. result = abap_true. ENDIF.
      WHEN tag_number.
        IF value-int_value = number_pos_inf OR value-int_value = number_neg_inf.
          result = abap_true.
        ELSEIF value-int_value = number_finite AND value-float_value <> 0.
          result = abap_true.
        ENDIF.
      WHEN tag_string.
        IF value-string_ref->as_string( ) IS NOT INITIAL.
          result = abap_true.
        ENDIF.
      WHEN tag_object OR tag_symbol.
        result = abap_true.
    ENDCASE.
  ENDMETHOD.

  METHOD to_string.
    CASE value-tag.
      WHEN tag_undefined. result = 'undefined'.
      WHEN tag_null. result = 'null'.
      WHEN tag_bool.
        IF value-int_value <> 0. result = 'true'. ELSE. result = 'false'. ENDIF.
      WHEN tag_int.
        result = value-int_value.
        CONDENSE result NO-GAPS.
      WHEN tag_number.
        CASE value-int_value.
          WHEN number_nan. result = 'NaN'.
          WHEN number_pos_inf. result = 'Infinity'.
          WHEN number_neg_inf. result = '-Infinity'.
          WHEN number_neg_zero. result = '0'.
          WHEN OTHERS.
            result = zcl_qjs_number=>format_finite( value-float_value ).
        ENDCASE.
      WHEN tag_string.
        result = value-string_ref->as_string( ).
      WHEN tag_symbol.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Cannot convert a Symbol value to a string'.
      WHEN OTHERS.
        result = '[object Object]'.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
