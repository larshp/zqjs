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
      IMPORTING left          TYPE zcl_qjs_value=>ty_value
        right                 TYPE zcl_qjs_value=>ty_value
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

    CLASS-METHODS parse_int
      IMPORTING text          TYPE string
        radix                 TYPE i DEFAULT 0
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.

    CLASS-METHODS parse_float
      IMPORTING text          TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.

    CLASS-METHODS format_finite
      IMPORTING value         TYPE f
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
      IMPORTING left          TYPE zcl_qjs_value=>ty_value
        right                 TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.

    CLASS-METHODS less_than
      IMPORTING left          TYPE zcl_qjs_value=>ty_value
        right                 TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    CLASS-METHODS bitwise
      IMPORTING left          TYPE zcl_qjs_value=>ty_value
        right                 TYPE zcl_qjs_value=>ty_value
        operation             TYPE i
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    CLASS-METHODS bitwise_not
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    CLASS-METHODS shift
      IMPORTING left          TYPE zcl_qjs_value=>ty_value
        right                 TYPE zcl_qjs_value=>ty_value
        operation             TYPE i
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
    CLASS-METHODS trim_leading_whitespace
      IMPORTING text          TYPE string
      RETURNING VALUE(result) TYPE string.
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
    IF ls_value-int_value = zcl_qjs_value=>number_neg_inf
        OR ls_value-int_value = zcl_qjs_value=>number_neg_zero.
      result = -1.
    ELSEIF ls_value-int_value = zcl_qjs_value=>number_finite
        AND ls_value-float_value < 0.
      result = -1.
    ELSEIF ls_value-int_value = zcl_qjs_value=>number_nan.
      result = 0.
    ENDIF.
  ENDMETHOD.

  METHOD is_zero.
    DATA ls_value TYPE zcl_qjs_value=>ty_value.
    ls_value = normalized( value ).
    result = abap_false.
    IF ls_value-int_value = zcl_qjs_value=>number_neg_zero.
      result = abap_true.
    ELSEIF ls_value-int_value = zcl_qjs_value=>number_finite
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
      WHEN 'g' OR 'G'. result = 16.
      WHEN 'h' OR 'H'. result = 17.
      WHEN 'i' OR 'I'. result = 18.
      WHEN 'j' OR 'J'. result = 19.
      WHEN 'k' OR 'K'. result = 20.
      WHEN 'l' OR 'L'. result = 21.
      WHEN 'm' OR 'M'. result = 22.
      WHEN 'n' OR 'N'. result = 23.
      WHEN 'o' OR 'O'. result = 24.
      WHEN 'p' OR 'P'. result = 25.
      WHEN 'q' OR 'Q'. result = 26.
      WHEN 'r' OR 'R'. result = 27.
      WHEN 's' OR 'S'. result = 28.
      WHEN 't' OR 'T'. result = 29.
      WHEN 'u' OR 'U'. result = 30.
      WHEN 'v' OR 'V'. result = 31.
      WHEN 'w' OR 'W'. result = 32.
      WHEN 'x' OR 'X'. result = 33.
      WHEN 'y' OR 'Y'. result = 34.
      WHEN 'z' OR 'Z'. result = 35.
    ENDCASE.
  ENDMETHOD.

  METHOD trim_leading_whitespace.
    DATA lv_first TYPE c LENGTH 1.
    result = text.
    WHILE result IS NOT INITIAL.
      lv_first = result+0(1).
      IF lv_first = space
          OR lv_first = cl_abap_char_utilities=>horizontal_tab
          OR lv_first = cl_abap_char_utilities=>vertical_tab
          OR lv_first = cl_abap_char_utilities=>newline
          OR lv_first = cl_abap_char_utilities=>form_feed
          OR lv_first = cl_abap_char_utilities=>cr_lf+0(1).
        result = result+1.
      ELSE.
        RETURN.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD parse_int.
    DATA lv_text TYPE string.
    DATA lv_sign TYPE i VALUE 1.
    DATA lv_radix TYPE i.
    DATA lv_index TYPE i.
    DATA lv_digit TYPE i.
    DATA lv_char TYPE c LENGTH 1.
    DATA lv_value TYPE f.
    DATA lv_has_digit TYPE abap_bool VALUE abap_false.
    lv_text = trim_leading_whitespace( text ).
    IF lv_text IS NOT INITIAL AND lv_text+0(1) = '+'.
      lv_text = lv_text+1.
    ELSEIF lv_text IS NOT INITIAL AND lv_text+0(1) = '-'.
      lv_sign = -1.
      lv_text = lv_text+1.
    ENDIF.
    lv_radix = radix.
    IF lv_radix <> 0 AND ( lv_radix < 2 OR lv_radix > 36 ).
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    IF lv_radix = 0.
      lv_radix = 10.
      IF strlen( lv_text ) >= 2 AND lv_text+0(1) = '0'
          AND ( lv_text+1(1) = 'x' OR lv_text+1(1) = 'X' ).
        lv_radix = 16.
        lv_text = lv_text+2.
      ENDIF.
    ELSEIF lv_radix = 16 AND strlen( lv_text ) >= 2
        AND lv_text+0(1) = '0'
        AND ( lv_text+1(1) = 'x' OR lv_text+1(1) = 'X' ).
      lv_text = lv_text+2.
    ENDIF.
    WHILE lv_index < strlen( lv_text ).
      lv_char = lv_text+lv_index(1).
      lv_digit = digit_value( lv_char ).
      IF lv_digit < 0 OR lv_digit >= lv_radix.
        EXIT.
      ENDIF.
      lv_has_digit = abap_true.
      TRY.
          lv_value = lv_value * lv_radix + lv_digit.
        CATCH cx_sy_arithmetic_error.
          result = infinity_with_sign( lv_sign ).
          RETURN.
      ENDTRY.
      lv_index = lv_index + 1.
    ENDWHILE.
    IF lv_has_digit = abap_false.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
    ELSEIF lv_value = 0 AND lv_sign < 0.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_zero ).
    ELSEIF lv_sign < 0.
      result = zcl_qjs_value=>new_finite( 0 - lv_value ).
    ELSE.
      result = zcl_qjs_value=>new_finite( lv_value ).
    ENDIF.
  ENDMETHOD.

  METHOD parse_float.
    DATA lv_text TYPE string.
    DATA lv_sign TYPE i VALUE 1.
    DATA lv_index TYPE i.
    DATA lv_end TYPE i.
    DATA lv_exp_start TYPE i.
    DATA lv_has_digit TYPE abap_bool VALUE abap_false.
    DATA lv_exp_digit TYPE abap_bool.
    lv_text = trim_leading_whitespace( text ).
    IF lv_text IS NOT INITIAL AND lv_text+0(1) = '+'.
      lv_text = lv_text+1.
    ELSEIF lv_text IS NOT INITIAL AND lv_text+0(1) = '-'.
      lv_sign = -1.
      lv_text = lv_text+1.
    ENDIF.
    IF strlen( lv_text ) >= 8 AND lv_text+0(8) = 'Infinity'.
      result = infinity_with_sign( lv_sign ).
      RETURN.
    ENDIF.
    WHILE lv_index < strlen( lv_text ) AND lv_text+lv_index(1) CO '0123456789'.
      lv_has_digit = abap_true.
      lv_index = lv_index + 1.
    ENDWHILE.
    IF lv_index < strlen( lv_text ) AND lv_text+lv_index(1) = '.'.
      lv_index = lv_index + 1.
      WHILE lv_index < strlen( lv_text ) AND lv_text+lv_index(1) CO '0123456789'.
        lv_has_digit = abap_true.
        lv_index = lv_index + 1.
      ENDWHILE.
    ENDIF.
    IF lv_has_digit = abap_false.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    lv_end = lv_index.
    IF lv_index < strlen( lv_text )
        AND ( lv_text+lv_index(1) = 'e' OR lv_text+lv_index(1) = 'E' ).
      lv_exp_start = lv_index.
      lv_index = lv_index + 1.
      IF lv_index < strlen( lv_text )
          AND ( lv_text+lv_index(1) = '+' OR lv_text+lv_index(1) = '-' ).
        lv_index = lv_index + 1.
      ENDIF.
      WHILE lv_index < strlen( lv_text ) AND lv_text+lv_index(1) CO '0123456789'.
        lv_exp_digit = abap_true.
        lv_index = lv_index + 1.
      ENDWHILE.
      IF lv_exp_digit = abap_true.
        lv_end = lv_index.
      ELSE.
        lv_end = lv_exp_start.
      ENDIF.
    ENDIF.
    DATA(lv_literal) = lv_text+0(lv_end).
    result = parse_literal( lv_literal ).
    IF lv_sign < 0.
      result = negate( result ).
    ENDIF.
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
    DATA lv_sign TYPE i VALUE 1.
    DATA lv_had_sign TYPE abap_bool VALUE abap_false.
    CASE value-tag.
      WHEN zcl_qjs_value=>tag_int OR zcl_qjs_value=>tag_number.
        result = normalized( value ).
      WHEN zcl_qjs_value=>tag_bool.
        IF value-int_value <> 0.
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
          IF lv_text+0(1) = '+'.
            lv_had_sign = abap_true.
            lv_text = lv_text+1.
          ELSEIF lv_text+0(1) = '-'.
            lv_had_sign = abap_true.
            lv_sign = -1.
            lv_text = lv_text+1.
          ENDIF.
          IF lv_text = 'Infinity'.
            result = infinity_with_sign( lv_sign ).
            RETURN.
          ELSEIF lv_text IS INITIAL.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
            RETURN.
          ELSEIF lv_had_sign = abap_true AND strlen( lv_text ) >= 2
              AND lv_text+0(1) = '0'
              AND ( lv_text+1(1) = 'x' OR lv_text+1(1) = 'X'
                OR lv_text+1(1) = 'o' OR lv_text+1(1) = 'O'
                OR lv_text+1(1) = 'b' OR lv_text+1(1) = 'B' ).
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
            RETURN.
          ENDIF.
          TRY.
              result = parse_literal( lv_text ).
              IF lv_sign < 0.
                result = negate( result ).
              ENDIF.
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
    IF ls_number-int_value <> zcl_qjs_value=>number_finite
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
    IF ls_left-int_value = zcl_qjs_value=>number_nan
        OR ls_right-int_value = zcl_qjs_value=>number_nan.
      RETURN.
    ENDIF.
    IF is_zero( ls_left ) = abap_true AND is_zero( ls_right ) = abap_true.
      result = abap_true.
    ELSEIF ls_left-int_value = ls_right-int_value.
      IF ls_left-int_value <> zcl_qjs_value=>number_finite
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
    IF ls_left-int_value = zcl_qjs_value=>number_nan
        OR ls_right-int_value = zcl_qjs_value=>number_nan
        OR ls_left-int_value = zcl_qjs_value=>number_pos_inf
        OR ls_right-int_value = zcl_qjs_value=>number_neg_inf.
      RETURN.
    ENDIF.
    IF ls_left-int_value = zcl_qjs_value=>number_neg_inf
        OR ls_right-int_value = zcl_qjs_value=>number_pos_inf.
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
    CASE ls_value-int_value.
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

    IF ls_left-int_value = zcl_qjs_value=>number_nan
        OR ls_right-int_value = zcl_qjs_value=>number_nan.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    IF ( ls_left-int_value = zcl_qjs_value=>number_pos_inf
          AND ls_right-int_value = zcl_qjs_value=>number_neg_inf )
        OR ( ls_left-int_value = zcl_qjs_value=>number_neg_inf
          AND ls_right-int_value = zcl_qjs_value=>number_pos_inf ).
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    IF ls_left-int_value = zcl_qjs_value=>number_pos_inf
        OR ls_right-int_value = zcl_qjs_value=>number_pos_inf.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
      RETURN.
    ENDIF.
    IF ls_left-int_value = zcl_qjs_value=>number_neg_inf
        OR ls_right-int_value = zcl_qjs_value=>number_neg_inf.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_inf ).
      RETURN.
    ENDIF.
    IF ls_left-int_value = zcl_qjs_value=>number_neg_zero
        AND ls_right-int_value = zcl_qjs_value=>number_neg_zero.
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

    IF ls_left-int_value = zcl_qjs_value=>number_nan
        OR ls_right-int_value = zcl_qjs_value=>number_nan.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    IF ( is_zero( ls_left ) = abap_true
          AND ( ls_right-int_value = zcl_qjs_value=>number_pos_inf
            OR ls_right-int_value = zcl_qjs_value=>number_neg_inf ) )
        OR ( is_zero( ls_right ) = abap_true
          AND ( ls_left-int_value = zcl_qjs_value=>number_pos_inf
            OR ls_left-int_value = zcl_qjs_value=>number_neg_inf ) ).
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    IF ls_left-int_value = zcl_qjs_value=>number_pos_inf
        OR ls_left-int_value = zcl_qjs_value=>number_neg_inf
        OR ls_right-int_value = zcl_qjs_value=>number_pos_inf
        OR ls_right-int_value = zcl_qjs_value=>number_neg_inf.
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
    IF ls_left-int_value = zcl_qjs_value=>number_pos_inf
        OR ls_left-int_value = zcl_qjs_value=>number_neg_inf.
      lv_left_inf = abap_true.
    ENDIF.
    IF ls_right-int_value = zcl_qjs_value=>number_pos_inf
        OR ls_right-int_value = zcl_qjs_value=>number_neg_inf.
      lv_right_inf = abap_true.
    ENDIF.

    IF ls_left-int_value = zcl_qjs_value=>number_nan
        OR ls_right-int_value = zcl_qjs_value=>number_nan.
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
    IF ls_left-int_value = zcl_qjs_value=>number_nan
        OR ls_right-int_value = zcl_qjs_value=>number_nan
        OR ls_left-int_value = zcl_qjs_value=>number_pos_inf
        OR ls_left-int_value = zcl_qjs_value=>number_neg_inf
        OR is_zero( ls_right ) = abap_true.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    IF is_zero( ls_left ) = abap_true.
      result = ls_left.
      RETURN.
    ENDIF.
    IF ls_right-int_value = zcl_qjs_value=>number_pos_inf
        OR ls_right-int_value = zcl_qjs_value=>number_neg_inf.
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
