CLASS zcl_qjs_number DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS add
      IMPORTING
        left          TYPE zcl_qjs_value=>ty_value
        right         TYPE zcl_qjs_value=>ty_value
      RETURNING
        VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING
        zcx_qjs_error.

    CLASS-METHODS subtract
      IMPORTING
        left          TYPE zcl_qjs_value=>ty_value
        right         TYPE zcl_qjs_value=>ty_value
      RETURNING
        VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING
        zcx_qjs_error.

    CLASS-METHODS multiply
      IMPORTING
        left          TYPE zcl_qjs_value=>ty_value
        right         TYPE zcl_qjs_value=>ty_value
      RETURNING
        VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING
        zcx_qjs_error.

    CLASS-METHODS divide
      IMPORTING
        left          TYPE zcl_qjs_value=>ty_value
        right         TYPE zcl_qjs_value=>ty_value
      RETURNING
        VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING
        zcx_qjs_error.

    CLASS-METHODS modulo
      IMPORTING left TYPE zcl_qjs_value=>ty_value right TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.

    CLASS-METHODS negate
      IMPORTING
        value         TYPE zcl_qjs_value=>ty_value
      RETURNING
        VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING
        zcx_qjs_error.

    CLASS-METHODS parse_literal
      IMPORTING
        literal       TYPE string
      RETURNING
        VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING
        zcx_qjs_error.

    CLASS-METHODS format_finite
      IMPORTING value TYPE f
      RETURNING VALUE(result) TYPE string
      RAISING zcx_qjs_error.

    CLASS-METHODS to_number
      IMPORTING
        value         TYPE zcl_qjs_value=>ty_value
      RETURNING
        VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING
        zcx_qjs_error.

    CLASS-METHODS to_uint32
      IMPORTING
        value         TYPE zcl_qjs_value=>ty_value
      RETURNING
        VALUE(result) TYPE int8
      RAISING
        zcx_qjs_error.

    CLASS-METHODS to_int32
      IMPORTING
        value         TYPE zcl_qjs_value=>ty_value
      RETURNING
        VALUE(result) TYPE int8
      RAISING
        zcx_qjs_error.

    CLASS-METHODS equal
      IMPORTING left TYPE zcl_qjs_value=>ty_value right TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.

    CLASS-METHODS less_than
      IMPORTING left TYPE zcl_qjs_value=>ty_value right TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    CLASS-METHODS bitwise
      IMPORTING left TYPE zcl_qjs_value=>ty_value right TYPE zcl_qjs_value=>ty_value
        operation TYPE i
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    CLASS-METHODS bitwise_not
      IMPORTING value TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    CLASS-METHODS shift
      IMPORTING left TYPE zcl_qjs_value=>ty_value right TYPE zcl_qjs_value=>ty_value
        operation TYPE i
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.

  PRIVATE SECTION.
    CLASS-METHODS normalized
      IMPORTING
        value         TYPE zcl_qjs_value=>ty_value
      RETURNING
        VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING
        zcx_qjs_error.

    CLASS-METHODS sign_of
      IMPORTING
        value         TYPE zcl_qjs_value=>ty_value
      RETURNING
        VALUE(result) TYPE i
      RAISING
        zcx_qjs_error.

    CLASS-METHODS is_zero
      IMPORTING
        value         TYPE zcl_qjs_value=>ty_value
      RETURNING
        VALUE(result) TYPE abap_bool
      RAISING
        zcx_qjs_error.

    CLASS-METHODS zero_with_sign
      IMPORTING
        sign          TYPE i
      RETURNING
        VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING
        zcx_qjs_error.

    CLASS-METHODS infinity_with_sign
      IMPORTING
        sign          TYPE i
      RETURNING
        VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING
        zcx_qjs_error.

    CLASS-METHODS digit_value
      IMPORTING
        character     TYPE c
      RETURNING
        VALUE(result) TYPE i.
ENDCLASS.

CLASS zcl_qjs_number IMPLEMENTATION.
  METHOD format_finite.
    DATA lv_raw TYPE string.
    DATA lv_mantissa TYPE string.
    DATA lv_exponent_text TYPE string.
    DATA lv_digits TYPE string.
    DATA lv_sign TYPE string.
    DATA lv_exponent TYPE i.
    DATA lv_length TYPE i.
    DATA lv_candidate TYPE string.
    DATA lv_candidate_digits TYPE string.
    DATA lv_first_digit TYPE string.
    DATA lv_rest TYPE string.
    DATA lv_test TYPE f.
    DATA lv_rounded TYPE int8.
    DATA lv_rounded_text TYPE string.
    DATA lv_position TYPE i.
    DATA lv_zero_count TYPE i.
    DATA lv_zeros TYPE string.

    IF value = 0.
      result = '0'.
      RETURN.
    ENDIF.
    lv_raw = value.
    CONDENSE lv_raw NO-GAPS.
    TRANSLATE lv_raw TO UPPER CASE.
    SPLIT lv_raw AT 'E' INTO lv_mantissa lv_exponent_text.
    IF lv_exponent_text IS INITIAL.
      result = lv_raw.
      RETURN.
    ENDIF.
    IF lv_mantissa+0(1) = '-'.
      lv_sign = '-'.
      lv_mantissa = lv_mantissa+1.
    ENDIF.
    lv_exponent = lv_exponent_text.
    lv_digits = lv_mantissa.
    REPLACE ALL OCCURRENCES OF '.' IN lv_digits WITH ''.

    DO strlen( lv_digits ) TIMES.
      lv_length = sy-index.
      lv_candidate_digits = lv_digits+0(lv_length).
      lv_first_digit = lv_candidate_digits+0(1).
      CLEAR lv_rest.
      IF lv_length > 1.
        DATA(lv_rest_length) = lv_length - 1.
        lv_rest = lv_candidate_digits+1(lv_rest_length).
      ENDIF.
      lv_candidate = lv_sign && lv_first_digit.
      IF lv_rest IS NOT INITIAL.
        lv_candidate = lv_candidate && '.' && lv_rest.
      ENDIF.
      lv_candidate = lv_candidate && 'E' && lv_exponent_text.
      TRY.
          lv_test = lv_candidate.
          IF lv_test = value.
            EXIT.
          ENDIF.
        CATCH cx_sy_conversion_no_number cx_sy_arithmetic_error.
      ENDTRY.

      IF lv_length < 18.
        lv_rounded = lv_candidate_digits.
        lv_rounded = lv_rounded + 1.
        lv_rounded_text = lv_rounded.
        CONDENSE lv_rounded_text NO-GAPS.
        IF strlen( lv_rounded_text ) = lv_length.
          lv_candidate_digits = lv_rounded_text.
          lv_first_digit = lv_candidate_digits+0(1).
          CLEAR lv_rest.
          IF lv_length > 1.
            lv_rest_length = lv_length - 1.
            lv_rest = lv_candidate_digits+1(lv_rest_length).
          ENDIF.
          lv_candidate = lv_sign && lv_first_digit.
          IF lv_rest IS NOT INITIAL.
            lv_candidate = lv_candidate && '.' && lv_rest.
          ENDIF.
          lv_candidate = lv_candidate && 'E' && lv_exponent_text.
          TRY.
              lv_test = lv_candidate.
              IF lv_test = value.
                EXIT.
              ENDIF.
            CATCH cx_sy_conversion_no_number cx_sy_arithmetic_error.
          ENDTRY.
        ELSEIF strlen( lv_rounded_text ) = lv_length + 1.
          DATA(lv_scale) = lv_exponent - lv_length + 1.
          DATA(lv_absolute_scale) = abs( lv_scale ).
          DATA(lv_scale_text) = CONV string( lv_absolute_scale ).
          CONDENSE lv_scale_text NO-GAPS.
          IF lv_scale < 0.
            lv_scale_text = '-' && lv_scale_text.
          ELSE.
            lv_scale_text = '+' && lv_scale_text.
          ENDIF.
          lv_candidate = lv_sign && lv_rounded_text && 'E' && lv_scale_text.
          TRY.
              lv_test = lv_candidate.
              IF lv_test = value.
                lv_candidate_digits = lv_rounded_text.
                lv_exponent = lv_scale + strlen( lv_candidate_digits ) - 1.
                WHILE strlen( lv_candidate_digits ) > 1.
                  DATA(lv_last_offset) = strlen( lv_candidate_digits ) - 1.
                  IF lv_candidate_digits+lv_last_offset(1) <> '0'.
                    EXIT.
                  ENDIF.
                  lv_candidate_digits = lv_candidate_digits+0(lv_last_offset).
                ENDWHILE.
                EXIT.
              ENDIF.
            CATCH cx_sy_conversion_no_number cx_sy_arithmetic_error.
          ENDTRY.
        ENDIF.
      ENDIF.
    ENDDO.

    lv_position = lv_exponent + 1.
    IF lv_exponent >= -6 AND lv_exponent < 21.
      IF lv_position <= 0.
        CLEAR lv_zeros.
        lv_zero_count = 0 - lv_position.
        DO lv_zero_count TIMES.
          lv_zeros = lv_zeros && '0'.
        ENDDO.
        result = lv_sign && '0.' && lv_zeros && lv_candidate_digits.
      ELSEIF lv_position >= strlen( lv_candidate_digits ).
        CLEAR lv_zeros.
        lv_zero_count = lv_position - strlen( lv_candidate_digits ).
        DO lv_zero_count TIMES.
          lv_zeros = lv_zeros && '0'.
        ENDDO.
        result = lv_sign && lv_candidate_digits && lv_zeros.
      ELSE.
        DATA(lv_fraction_length) = strlen( lv_candidate_digits ) - lv_position.
        DATA(lv_integer_part) = lv_candidate_digits+0(lv_position).
        DATA(lv_fraction_part) = lv_candidate_digits+lv_position(lv_fraction_length).
        result = lv_sign && lv_integer_part && '.' && lv_fraction_part.
      ENDIF.
    ELSE.
      lv_first_digit = lv_candidate_digits+0(1).
      CLEAR lv_rest.
      IF strlen( lv_candidate_digits ) > 1.
        lv_rest_length = strlen( lv_candidate_digits ) - 1.
        lv_rest = lv_candidate_digits+1(lv_rest_length).
      ENDIF.
      result = lv_sign && lv_first_digit.
      IF lv_rest IS NOT INITIAL.
        result = result && '.' && lv_rest.
      ENDIF.
      result = result && 'e'.
      IF lv_exponent >= 0.
        result = result && '+'.
      ENDIF.
      DATA(lv_normalized_exponent) = abs( lv_exponent ).
      DATA(lv_normalized_exponent_text) = CONV string( lv_normalized_exponent ).
      CONDENSE lv_normalized_exponent_text NO-GAPS.
      IF lv_exponent < 0.
        lv_normalized_exponent_text = '-' && lv_normalized_exponent_text.
      ENDIF.
      result = result && lv_normalized_exponent_text.
    ENDIF.
  ENDMETHOD.

  METHOD normalized.
    DATA lv_float TYPE f.
    IF value-tag = zcl_qjs_value=>tag_int.
      lv_float = value-int_value.
      result = zcl_qjs_value=>new_finite( lv_float ).
    ELSEIF value-tag = zcl_qjs_value=>tag_number.
      result = value.
    ELSE.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING
          reason = 'Numeric operation on a non-Number value'.
    ENDIF.
  ENDMETHOD.

  METHOD sign_of.
    DATA ls_value TYPE zcl_qjs_value=>ty_value.
    ls_value = normalized( value ).
    result = 1.
    IF ls_value-number_kind = zcl_qjs_value=>number_neg_inf
        OR ls_value-number_kind = zcl_qjs_value=>number_neg_zero.
      result = -1.
    ELSEIF ls_value-number_kind = zcl_qjs_value=>number_finite
        AND ls_value-float_value < 0.
      result = -1.
    ELSEIF ls_value-number_kind = zcl_qjs_value=>number_nan.
      result = 0.
    ENDIF.
  ENDMETHOD.

  METHOD is_zero.
    DATA ls_value TYPE zcl_qjs_value=>ty_value.
    ls_value = normalized( value ).
    result = abap_false.
    IF ls_value-number_kind = zcl_qjs_value=>number_neg_zero.
      result = abap_true.
    ELSEIF ls_value-number_kind = zcl_qjs_value=>number_finite
        AND ls_value-float_value = 0.
      result = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD zero_with_sign.
    DATA lv_zero TYPE f.
    IF sign < 0.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_zero ).
    ELSE.
      lv_zero = 0.
      result = zcl_qjs_value=>new_finite( lv_zero ).
    ENDIF.
  ENDMETHOD.

  METHOD infinity_with_sign.
    IF sign < 0.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_inf ).
    ELSE.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
    ENDIF.
  ENDMETHOD.

  METHOD digit_value.
    result = -1.
    CASE character.
      WHEN '0'. result = 0.
      WHEN '1'. result = 1.
      WHEN '2'. result = 2.
      WHEN '3'. result = 3.
      WHEN '4'. result = 4.
      WHEN '5'. result = 5.
      WHEN '6'. result = 6.
      WHEN '7'. result = 7.
      WHEN '8'. result = 8.
      WHEN '9'. result = 9.
      WHEN 'a' OR 'A'. result = 10.
      WHEN 'b' OR 'B'. result = 11.
      WHEN 'c' OR 'C'. result = 12.
      WHEN 'd' OR 'D'. result = 13.
      WHEN 'e' OR 'E'. result = 14.
      WHEN 'f' OR 'F'. result = 15.
    ENDCASE.
  ENDMETHOD.

  METHOD bitwise.
    DATA lv_left TYPE int8.
    DATA lv_right TYPE int8.
    DATA lv_unsigned TYPE int8.
    DATA lv_factor TYPE int8 VALUE 1.
    DATA lv_left_bit TYPE i.
    DATA lv_right_bit TYPE i.
    DATA lv_bit TYPE i.
    lv_left = to_uint32( left ).
    lv_right = to_uint32( right ).
    DO 32 TIMES.
      lv_left_bit = lv_left MOD 2.
      lv_right_bit = lv_right MOD 2.
      CLEAR lv_bit.
      CASE operation.
        WHEN 1.
          IF lv_left_bit = 1 AND lv_right_bit = 1. lv_bit = 1. ENDIF.
        WHEN 2.
          IF lv_left_bit <> lv_right_bit. lv_bit = 1. ENDIF.
        WHEN 3.
          IF lv_left_bit = 1 OR lv_right_bit = 1. lv_bit = 1. ENDIF.
        WHEN OTHERS.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Unknown bitwise operation'.
      ENDCASE.
      IF lv_bit = 1.
        lv_unsigned = lv_unsigned + lv_factor.
      ENDIF.
      lv_left = trunc( lv_left / 2 ).
      lv_right = trunc( lv_right / 2 ).
      lv_factor = lv_factor * 2.
    ENDDO.
    IF lv_unsigned >= 2147483648.
      lv_unsigned = lv_unsigned - 4294967296.
    ENDIF.
    result = zcl_qjs_value=>new_int( CONV i( lv_unsigned ) ).
  ENDMETHOD.

  METHOD bitwise_not.
    DATA lv_value TYPE int8.
    lv_value = 4294967295 - to_uint32( value ).
    IF lv_value >= 2147483648.
      lv_value = lv_value - 4294967296.
    ENDIF.
    result = zcl_qjs_value=>new_int( CONV i( lv_value ) ).
  ENDMETHOD.

  METHOD shift.
    DATA lv_count TYPE int8.
    DATA lv_factor TYPE int8 VALUE 1.
    DATA lv_value TYPE int8.
    lv_count = to_uint32( right ) MOD 32.
    DO lv_count TIMES.
      lv_factor = lv_factor * 2.
    ENDDO.
    CASE operation.
      WHEN 1.
        lv_value = to_uint32( left ) * lv_factor MOD 4294967296.
        IF lv_value >= 2147483648.
          lv_value = lv_value - 4294967296.
        ENDIF.
      WHEN 2.
        lv_value = floor( to_int32( left ) / lv_factor ).
      WHEN 3.
        lv_value = trunc( to_uint32( left ) / lv_factor ).
      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Unknown shift operation'.
    ENDCASE.
    IF lv_value >= -2147483648 AND lv_value <= 2147483647.
      result = zcl_qjs_value=>new_int( CONV i( lv_value ) ).
    ELSE.
      result = zcl_qjs_value=>new_finite( CONV f( lv_value ) ).
    ENDIF.
  ENDMETHOD.

  METHOD parse_literal.
    DATA lv_radix TYPE i VALUE 10.
    DATA lv_offset TYPE i VALUE 0.
    DATA lv_index TYPE i.
    DATA lv_digit TYPE i.
    DATA lv_char TYPE c LENGTH 1.
    DATA lv_float TYPE f.
    DATA lv_has_digit TYPE abap_bool VALUE abap_false.
    DATA lv_has_dot TYPE abap_bool VALUE abap_false.
    DATA lv_has_exp TYPE abap_bool VALUE abap_false.
    DATA lv_exp_digit TYPE abap_bool VALUE abap_false.
    DATA lv_previous_offset TYPE i.

    IF strlen( literal ) >= 2 AND literal+0(1) = '0'.
      lv_char = literal+1(1).
      IF lv_char = 'x' OR lv_char = 'X'.
        lv_radix = 16.
        lv_offset = 2.
      ELSEIF lv_char = 'o' OR lv_char = 'O'.
        lv_radix = 8.
        lv_offset = 2.
      ELSEIF lv_char = 'b' OR lv_char = 'B'.
        lv_radix = 2.
        lv_offset = 2.
      ENDIF.
    ENDIF.

    IF lv_radix <> 10.
      IF lv_offset >= strlen( literal ).
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Invalid JavaScript numeric literal'.
      ENDIF.
      lv_float = 0.
      lv_index = lv_offset.
      WHILE lv_index < strlen( literal ).
        lv_char = literal+lv_index(1).
        lv_digit = digit_value( lv_char ).
        IF lv_digit < 0 OR lv_digit >= lv_radix.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Invalid JavaScript numeric literal'.
        ENDIF.
        TRY.
            lv_float = lv_float * lv_radix + lv_digit.
          CATCH cx_sy_arithmetic_error.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
            RETURN.
        ENDTRY.
        lv_index = lv_index + 1.
      ENDWHILE.
      result = zcl_qjs_value=>new_finite( lv_float ).
      RETURN.
    ENDIF.

    lv_index = 0.
    WHILE lv_index < strlen( literal ).
      lv_char = literal+lv_index(1).
      IF lv_char CO '0123456789'.
        lv_has_digit = abap_true.
        IF lv_has_exp = abap_true.
          lv_exp_digit = abap_true.
        ENDIF.
      ELSEIF lv_char = '.' AND lv_has_dot = abap_false AND lv_has_exp = abap_false.
        lv_has_dot = abap_true.
      ELSEIF ( lv_char = 'e' OR lv_char = 'E' )
          AND lv_has_digit = abap_true AND lv_has_exp = abap_false.
        lv_has_exp = abap_true.
      ELSEIF ( lv_char = '+' OR lv_char = '-' )
          AND lv_has_exp = abap_true AND lv_index > 0.
        lv_previous_offset = lv_index - 1.
        DATA(lv_previous) = literal+lv_previous_offset(1).
        IF lv_previous <> 'e' AND lv_previous <> 'E'.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Invalid JavaScript numeric literal'.
        ENDIF.
      ELSE.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Invalid JavaScript numeric literal'.
      ENDIF.
      lv_index = lv_index + 1.
    ENDWHILE.
    IF lv_has_digit = abap_false
        OR ( lv_has_exp = abap_true AND lv_exp_digit = abap_false ).
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Invalid JavaScript numeric literal'.
    ENDIF.

    TRY.
        lv_float = literal.
        result = zcl_qjs_value=>new_finite( lv_float ).
      CATCH cx_sy_conversion_no_number cx_sy_arithmetic_error.
        result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
    ENDTRY.
  ENDMETHOD.

  METHOD to_number.
    DATA lv_text TYPE string.
    DATA lv_zero TYPE f.
    CASE value-tag.
      WHEN zcl_qjs_value=>tag_int OR zcl_qjs_value=>tag_number.
        result = normalized( value ).
      WHEN zcl_qjs_value=>tag_bool.
        IF value-bool_value = abap_true.
          result = zcl_qjs_value=>new_finite( 1 ).
        ELSE.
          result = zcl_qjs_value=>new_finite( lv_zero ).
        ENDIF.
      WHEN zcl_qjs_value=>tag_null.
        result = zcl_qjs_value=>new_finite( lv_zero ).
      WHEN zcl_qjs_value=>tag_undefined.
        result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      WHEN zcl_qjs_value=>tag_string.
        lv_text = value-string_ref->as_string( ).
        SHIFT lv_text LEFT DELETING LEADING space.
        SHIFT lv_text RIGHT DELETING TRAILING space.
        IF lv_text IS INITIAL.
          result = zcl_qjs_value=>new_finite( lv_zero ).
        ELSE.
          TRY.
              result = parse_literal( lv_text ).
            CATCH zcx_qjs_error.
              result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
          ENDTRY.
        ENDIF.
      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Object-to-primitive conversion is not implemented'.
    ENDCASE.
  ENDMETHOD.

  METHOD to_uint32.
    DATA ls_number TYPE zcl_qjs_value=>ty_value.
    DATA lv_integer TYPE f.
    DATA lv_modulo TYPE f.
    ls_number = to_number( value ).
    IF ls_number-number_kind <> zcl_qjs_value=>number_finite
        OR ls_number-float_value = 0.
      result = 0.
      RETURN.
    ENDIF.
    lv_integer = trunc( ls_number-float_value ).
    IF lv_integer < 0.
      lv_integer = 0 - lv_integer.
      lv_modulo = lv_integer - trunc( lv_integer / 4294967296 ) * 4294967296.
      IF lv_modulo <> 0.
        lv_modulo = 4294967296 - lv_modulo.
      ENDIF.
    ELSE.
      lv_modulo = lv_integer - trunc( lv_integer / 4294967296 ) * 4294967296.
    ENDIF.
    result = lv_modulo.
  ENDMETHOD.

  METHOD to_int32.
    result = to_uint32( value ).
    IF result >= 2147483648.
      result = result - 4294967296.
    ENDIF.
  ENDMETHOD.

  METHOD equal.
    DATA ls_left TYPE zcl_qjs_value=>ty_value.
    DATA ls_right TYPE zcl_qjs_value=>ty_value.
    ls_left = normalized( left ).
    ls_right = normalized( right ).
    result = abap_false.
    IF ls_left-number_kind = zcl_qjs_value=>number_nan
        OR ls_right-number_kind = zcl_qjs_value=>number_nan.
      RETURN.
    ENDIF.
    IF is_zero( ls_left ) = abap_true AND is_zero( ls_right ) = abap_true.
      result = abap_true.
    ELSEIF ls_left-number_kind = ls_right-number_kind.
      IF ls_left-number_kind <> zcl_qjs_value=>number_finite
          OR ls_left-float_value = ls_right-float_value.
        result = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD less_than.
    DATA ls_left TYPE zcl_qjs_value=>ty_value.
    DATA ls_right TYPE zcl_qjs_value=>ty_value.
    IF left-tag = zcl_qjs_value=>tag_string
        AND right-tag = zcl_qjs_value=>tag_string.
      result = xsdbool(
        left-string_ref->as_string( ) < right-string_ref->as_string( ) ).
      RETURN.
    ENDIF.
    ls_left = normalized( left ).
    ls_right = normalized( right ).
    result = abap_false.
    IF ls_left-number_kind = zcl_qjs_value=>number_nan
        OR ls_right-number_kind = zcl_qjs_value=>number_nan
        OR ls_left-number_kind = zcl_qjs_value=>number_pos_inf
        OR ls_right-number_kind = zcl_qjs_value=>number_neg_inf.
      RETURN.
    ENDIF.
    IF ls_left-number_kind = zcl_qjs_value=>number_neg_inf
        OR ls_right-number_kind = zcl_qjs_value=>number_pos_inf.
      IF equal( left = ls_left right = ls_right ) = abap_false.
        result = abap_true.
      ENDIF.
      RETURN.
    ENDIF.
    IF ls_left-float_value < ls_right-float_value.
      result = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD negate.
    DATA ls_value TYPE zcl_qjs_value=>ty_value.
    DATA lv_float TYPE f.
    ls_value = normalized( value ).
    CASE ls_value-number_kind.
      WHEN zcl_qjs_value=>number_nan.
        result = ls_value.
      WHEN zcl_qjs_value=>number_pos_inf.
        result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_inf ).
      WHEN zcl_qjs_value=>number_neg_inf.
        result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
      WHEN zcl_qjs_value=>number_neg_zero.
        lv_float = 0.
        result = zcl_qjs_value=>new_finite( lv_float ).
      WHEN OTHERS.
        IF ls_value-float_value = 0.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_zero ).
        ELSE.
          lv_float = 0 - ls_value-float_value.
          result = zcl_qjs_value=>new_finite( lv_float ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD add.
    DATA ls_left TYPE zcl_qjs_value=>ty_value.
    DATA ls_right TYPE zcl_qjs_value=>ty_value.
    DATA lv_float TYPE f.
    IF left-tag = zcl_qjs_value=>tag_string
        OR right-tag = zcl_qjs_value=>tag_string.
      DATA(lv_text) = zcl_qjs_value=>to_string( left )
        && zcl_qjs_value=>to_string( right ).
      result = zcl_qjs_value=>new_string( lv_text ).
      RETURN.
    ENDIF.
    ls_left = normalized( left ).
    ls_right = normalized( right ).

    IF ls_left-number_kind = zcl_qjs_value=>number_nan
        OR ls_right-number_kind = zcl_qjs_value=>number_nan.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    IF ( ls_left-number_kind = zcl_qjs_value=>number_pos_inf
          AND ls_right-number_kind = zcl_qjs_value=>number_neg_inf )
        OR ( ls_left-number_kind = zcl_qjs_value=>number_neg_inf
          AND ls_right-number_kind = zcl_qjs_value=>number_pos_inf ).
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    IF ls_left-number_kind = zcl_qjs_value=>number_pos_inf
        OR ls_right-number_kind = zcl_qjs_value=>number_pos_inf.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
      RETURN.
    ENDIF.
    IF ls_left-number_kind = zcl_qjs_value=>number_neg_inf
        OR ls_right-number_kind = zcl_qjs_value=>number_neg_inf.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_inf ).
      RETURN.
    ENDIF.
    IF ls_left-number_kind = zcl_qjs_value=>number_neg_zero
        AND ls_right-number_kind = zcl_qjs_value=>number_neg_zero.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_zero ).
      RETURN.
    ENDIF.

    TRY.
        lv_float = ls_left-float_value + ls_right-float_value.
        result = zcl_qjs_value=>new_finite( lv_float ).
      CATCH cx_sy_arithmetic_error.
        result = infinity_with_sign( sign_of( ls_left ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD subtract.
    DATA ls_negated TYPE zcl_qjs_value=>ty_value.
    ls_negated = negate( right ).
    result = add( left = left right = ls_negated ).
  ENDMETHOD.

  METHOD multiply.
    DATA ls_left TYPE zcl_qjs_value=>ty_value.
    DATA ls_right TYPE zcl_qjs_value=>ty_value.
    DATA lv_sign TYPE i.
    DATA lv_float TYPE f.
    ls_left = normalized( left ).
    ls_right = normalized( right ).
    lv_sign = sign_of( ls_left ) * sign_of( ls_right ).

    IF ls_left-number_kind = zcl_qjs_value=>number_nan
        OR ls_right-number_kind = zcl_qjs_value=>number_nan.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    IF ( is_zero( ls_left ) = abap_true
          AND ( ls_right-number_kind = zcl_qjs_value=>number_pos_inf
            OR ls_right-number_kind = zcl_qjs_value=>number_neg_inf ) )
        OR ( is_zero( ls_right ) = abap_true
          AND ( ls_left-number_kind = zcl_qjs_value=>number_pos_inf
            OR ls_left-number_kind = zcl_qjs_value=>number_neg_inf ) ).
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    IF ls_left-number_kind = zcl_qjs_value=>number_pos_inf
        OR ls_left-number_kind = zcl_qjs_value=>number_neg_inf
        OR ls_right-number_kind = zcl_qjs_value=>number_pos_inf
        OR ls_right-number_kind = zcl_qjs_value=>number_neg_inf.
      result = infinity_with_sign( lv_sign ).
      RETURN.
    ENDIF.
    IF is_zero( ls_left ) = abap_true OR is_zero( ls_right ) = abap_true.
      result = zero_with_sign( lv_sign ).
      RETURN.
    ENDIF.

    TRY.
        lv_float = ls_left-float_value * ls_right-float_value.
        result = zcl_qjs_value=>new_finite( lv_float ).
      CATCH cx_sy_arithmetic_error.
        result = infinity_with_sign( lv_sign ).
    ENDTRY.
  ENDMETHOD.

  METHOD divide.
    DATA ls_left TYPE zcl_qjs_value=>ty_value.
    DATA ls_right TYPE zcl_qjs_value=>ty_value.
    DATA lv_sign TYPE i.
    DATA lv_float TYPE f.
    DATA lv_left_inf TYPE abap_bool.
    DATA lv_right_inf TYPE abap_bool.
    ls_left = normalized( left ).
    ls_right = normalized( right ).
    lv_sign = sign_of( ls_left ) * sign_of( ls_right ).
    lv_left_inf = abap_false.
    lv_right_inf = abap_false.
    IF ls_left-number_kind = zcl_qjs_value=>number_pos_inf
        OR ls_left-number_kind = zcl_qjs_value=>number_neg_inf.
      lv_left_inf = abap_true.
    ENDIF.
    IF ls_right-number_kind = zcl_qjs_value=>number_pos_inf
        OR ls_right-number_kind = zcl_qjs_value=>number_neg_inf.
      lv_right_inf = abap_true.
    ENDIF.

    IF ls_left-number_kind = zcl_qjs_value=>number_nan
        OR ls_right-number_kind = zcl_qjs_value=>number_nan.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    IF lv_left_inf = abap_true AND lv_right_inf = abap_true.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    IF is_zero( ls_left ) = abap_true AND is_zero( ls_right ) = abap_true.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    IF lv_left_inf = abap_true OR is_zero( ls_right ) = abap_true.
      result = infinity_with_sign( lv_sign ).
      RETURN.
    ENDIF.
    IF lv_right_inf = abap_true OR is_zero( ls_left ) = abap_true.
      result = zero_with_sign( lv_sign ).
      RETURN.
    ENDIF.

    TRY.
        lv_float = ls_left-float_value / ls_right-float_value.
        result = zcl_qjs_value=>new_finite( lv_float ).
      CATCH cx_sy_arithmetic_error.
        result = infinity_with_sign( lv_sign ).
    ENDTRY.
  ENDMETHOD.

  METHOD modulo.
    DATA ls_left TYPE zcl_qjs_value=>ty_value.
    DATA ls_right TYPE zcl_qjs_value=>ty_value.
    DATA lv_float TYPE f.
    ls_left = normalized( left ).
    ls_right = normalized( right ).
    IF ls_left-number_kind = zcl_qjs_value=>number_nan
        OR ls_right-number_kind = zcl_qjs_value=>number_nan
        OR ls_left-number_kind = zcl_qjs_value=>number_pos_inf
        OR ls_left-number_kind = zcl_qjs_value=>number_neg_inf
        OR is_zero( ls_right ) = abap_true.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    IF is_zero( ls_left ) = abap_true.
      result = ls_left.
      RETURN.
    ENDIF.
    IF ls_right-number_kind = zcl_qjs_value=>number_pos_inf
        OR ls_right-number_kind = zcl_qjs_value=>number_neg_inf.
      result = ls_left.
      RETURN.
    ENDIF.
    TRY.
        lv_float = ls_left-float_value
          - trunc( ls_left-float_value / ls_right-float_value ) * ls_right-float_value.
        IF lv_float = 0 AND sign_of( ls_left ) < 0.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_zero ).
        ELSE.
          result = zcl_qjs_value=>new_finite( lv_float ).
        ENDIF.
      CATCH cx_sy_arithmetic_error.
        result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
