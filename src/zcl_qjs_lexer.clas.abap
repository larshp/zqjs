CLASS zcl_qjs_lexer DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    CONSTANTS token_eof     TYPE i VALUE 0.
    CONSTANTS token_number  TYPE i VALUE 1.
    CONSTANTS token_plus    TYPE i VALUE 2.
    CONSTANTS token_minus   TYPE i VALUE 3.
    CONSTANTS token_star    TYPE i VALUE 4.
    CONSTANTS token_slash   TYPE i VALUE 5.
    CONSTANTS token_lparen  TYPE i VALUE 6.
    CONSTANTS token_rparen  TYPE i VALUE 7.
    CONSTANTS token_identifier TYPE i VALUE 8.
    CONSTANTS token_string  TYPE i VALUE 9.
    CONSTANTS token_lt TYPE i VALUE 10.
    CONSTANTS token_lte TYPE i VALUE 11.
    CONSTANTS token_gt TYPE i VALUE 12.
    CONSTANTS token_gte TYPE i VALUE 13.
    CONSTANTS token_strict_eq TYPE i VALUE 14.
    CONSTANTS token_strict_neq TYPE i VALUE 15.
    CONSTANTS token_true TYPE i VALUE 16.
    CONSTANTS token_false TYPE i VALUE 17.
    CONSTANTS token_null TYPE i VALUE 18.
    CONSTANTS token_undefined TYPE i VALUE 19.
    CONSTANTS token_semicolon TYPE i VALUE 20.
    CONSTANTS token_lbrace TYPE i VALUE 21.
    CONSTANTS token_rbrace TYPE i VALUE 22.
    CONSTANTS token_if TYPE i VALUE 23.
    CONSTANTS token_else TYPE i VALUE 24.
    CONSTANTS token_assign TYPE i VALUE 25.
    CONSTANTS token_var TYPE i VALUE 26.
    CONSTANTS token_while TYPE i VALUE 27.
    CONSTANTS token_for TYPE i VALUE 28.
    CONSTANTS token_break TYPE i VALUE 29.
    CONSTANTS token_continue TYPE i VALUE 30.
    CONSTANTS token_function TYPE i VALUE 31.
    CONSTANTS token_return TYPE i VALUE 32.
    CONSTANTS token_comma TYPE i VALUE 33.
    CONSTANTS token_dot TYPE i VALUE 34.
    CONSTANTS token_colon TYPE i VALUE 35.
    CONSTANTS token_new TYPE i VALUE 36.
    CONSTANTS token_throw TYPE i VALUE 37.
    CONSTANTS token_try TYPE i VALUE 38.
    CONSTANTS token_catch TYPE i VALUE 39.
    CONSTANTS token_finally TYPE i VALUE 40.
    CONSTANTS token_let TYPE i VALUE 41.
    CONSTANTS token_const TYPE i VALUE 42.
    CONSTANTS token_percent TYPE i VALUE 43.
    CONSTANTS token_bang TYPE i VALUE 44.
    CONSTANTS token_eq TYPE i VALUE 45.
    CONSTANTS token_neq TYPE i VALUE 46.
    CONSTANTS token_and TYPE i VALUE 47.
    CONSTANTS token_or TYPE i VALUE 48.
    CONSTANTS token_lbracket TYPE i VALUE 49.
    CONSTANTS token_rbracket TYPE i VALUE 50.
    CONSTANTS token_this TYPE i VALUE 51.
    CONSTANTS token_instanceof TYPE i VALUE 52.
    CONSTANTS token_delete TYPE i VALUE 53.
    CONSTANTS token_typeof TYPE i VALUE 54.
    CONSTANTS token_bit_and TYPE i VALUE 55.
    CONSTANTS token_bit_or TYPE i VALUE 56.
    CONSTANTS token_bit_xor TYPE i VALUE 57.
    CONSTANTS token_bit_not TYPE i VALUE 58.
    CONSTANTS token_shift_left TYPE i VALUE 59.
    CONSTANTS token_shift_right TYPE i VALUE 60.
    CONSTANTS token_shift_right_unsigned TYPE i VALUE 61.
    CONSTANTS token_increment TYPE i VALUE 62.
    CONSTANTS token_decrement TYPE i VALUE 63.
    CONSTANTS token_add_assign TYPE i VALUE 64.
    CONSTANTS token_subtract_assign TYPE i VALUE 65.
    CONSTANTS token_multiply_assign TYPE i VALUE 66.
    CONSTANTS token_divide_assign TYPE i VALUE 67.
    CONSTANTS token_modulo_assign TYPE i VALUE 68.
    CONSTANTS token_bit_and_assign TYPE i VALUE 69.
    CONSTANTS token_bit_or_assign TYPE i VALUE 70.
    CONSTANTS token_bit_xor_assign TYPE i VALUE 71.
    CONSTANTS token_shift_left_assign TYPE i VALUE 72.
    CONSTANTS token_shift_right_assign TYPE i VALUE 73.
    CONSTANTS token_ushift_right_assign TYPE i VALUE 74.

    TYPES:
      BEGIN OF ty_token,
        kind   TYPE i,
        number TYPE i,
        text   TYPE string,
        offset TYPE i,
        line_terminator_before TYPE abap_bool,
        integer_literal TYPE abap_bool,
      END OF ty_token.

    METHODS constructor
      IMPORTING
        source TYPE string.

    METHODS next
      RETURNING
        VALUE(result) TYPE ty_token
      RAISING
        zcx_qjs_error.

    METHODS get_offset RETURNING VALUE(result) TYPE i.
    METHODS set_offset IMPORTING offset TYPE i RAISING zcx_qjs_error.

  PRIVATE SECTION.
    DATA mv_source TYPE string.
    DATA mv_offset TYPE i.
    DATA mv_had_line_terminator TYPE abap_bool.

    METHODS skip_whitespace RAISING zcx_qjs_error.
ENDCLASS.

CLASS zcl_qjs_lexer IMPLEMENTATION.
  METHOD constructor.
    mv_source = source.
    mv_offset = 0.
  ENDMETHOD.

  METHOD skip_whitespace.
    DATA lv_char TYPE c LENGTH 1.
    DATA lv_next TYPE c LENGTH 1.
    DATA lv_closed TYPE abap_bool.
    DATA lv_lookahead TYPE i.
    mv_had_line_terminator = abap_false.
    WHILE mv_offset < strlen( mv_source ).
      lv_char = mv_source+mv_offset(1).
      IF lv_char = cl_abap_char_utilities=>newline
          OR lv_char = cl_abap_char_utilities=>cr_lf+0(1).
        mv_had_line_terminator = abap_true.
        mv_offset = mv_offset + 1.
      ELSEIF lv_char = space
          OR lv_char = cl_abap_char_utilities=>horizontal_tab.
        mv_offset = mv_offset + 1.
      ELSEIF lv_char = '/' AND mv_offset + 1 < strlen( mv_source ).
        lv_lookahead = mv_offset + 1.
        lv_next = mv_source+lv_lookahead(1).
        IF lv_next = '/'.
          mv_offset = mv_offset + 2.
          WHILE mv_offset < strlen( mv_source ).
            lv_char = mv_source+mv_offset(1).
            IF lv_char = cl_abap_char_utilities=>newline
                OR lv_char = cl_abap_char_utilities=>cr_lf+0(1).
              EXIT.
            ENDIF.
            mv_offset = mv_offset + 1.
          ENDWHILE.
        ELSEIF lv_next = '*'.
          mv_offset = mv_offset + 2.
          lv_closed = abap_false.
          WHILE mv_offset < strlen( mv_source ).
            lv_char = mv_source+mv_offset(1).
            lv_lookahead = mv_offset + 1.
            IF lv_char = cl_abap_char_utilities=>newline
                OR lv_char = cl_abap_char_utilities=>cr_lf+0(1).
              mv_had_line_terminator = abap_true.
            ENDIF.
            IF lv_char = '*' AND mv_offset + 1 < strlen( mv_source )
                AND mv_source+lv_lookahead(1) = '/'.
              mv_offset = mv_offset + 2.
              lv_closed = abap_true.
              EXIT.
            ENDIF.
            mv_offset = mv_offset + 1.
          ENDWHILE.
          IF lv_closed = abap_false.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Unterminated JavaScript block comment'.
          ENDIF.
        ELSE.
          RETURN.
        ENDIF.
      ELSE.
        RETURN.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD next.
    DATA lv_char TYPE c LENGTH 1.
    DATA lv_string_char TYPE string.
    DATA lv_value TYPE int8.
    DATA lv_quote TYPE c LENGTH 1.
    DATA lv_next_offset TYPE i.
    DATA lv_start TYPE i.
    DATA lv_has_dot TYPE abap_bool.
    DATA lv_has_exponent TYPE abap_bool.
    DATA lv_is_radix TYPE abap_bool.
    skip_whitespace( ).
    CLEAR result.
    result-offset = mv_offset.
    result-line_terminator_before = mv_had_line_terminator.
    IF mv_offset >= strlen( mv_source ).
      result-kind = token_eof.
      RETURN.
    ENDIF.

    lv_char = mv_source+mv_offset(1).
    lv_next_offset = mv_offset + 1.
    CASE lv_char.
      WHEN '+'.
        IF lv_next_offset < strlen( mv_source ) AND mv_source+lv_next_offset(1) = '+'.
          result-kind = token_increment.
          mv_offset = mv_offset + 1.
        ELSEIF lv_next_offset < strlen( mv_source ) AND mv_source+lv_next_offset(1) = '='.
          result-kind = token_add_assign.
          mv_offset = mv_offset + 1.
        ELSE.
          result-kind = token_plus.
        ENDIF.
      WHEN '-'.
        IF lv_next_offset < strlen( mv_source ) AND mv_source+lv_next_offset(1) = '-'.
          result-kind = token_decrement.
          mv_offset = mv_offset + 1.
        ELSEIF lv_next_offset < strlen( mv_source ) AND mv_source+lv_next_offset(1) = '='.
          result-kind = token_subtract_assign.
          mv_offset = mv_offset + 1.
        ELSE.
          result-kind = token_minus.
        ENDIF.
      WHEN '*'.
        IF lv_next_offset < strlen( mv_source ) AND mv_source+lv_next_offset(1) = '='.
          result-kind = token_multiply_assign.
          mv_offset = mv_offset + 1.
        ELSE.
          result-kind = token_star.
        ENDIF.
      WHEN '/'.
        IF lv_next_offset < strlen( mv_source ) AND mv_source+lv_next_offset(1) = '='.
          result-kind = token_divide_assign.
          mv_offset = mv_offset + 1.
        ELSE.
          result-kind = token_slash.
        ENDIF.
      WHEN '%'.
        IF lv_next_offset < strlen( mv_source ) AND mv_source+lv_next_offset(1) = '='.
          result-kind = token_modulo_assign.
          mv_offset = mv_offset + 1.
        ELSE.
          result-kind = token_percent.
        ENDIF.
      WHEN '('.
        result-kind = token_lparen.
      WHEN ')'.
        result-kind = token_rparen.
      WHEN '['.
        result-kind = token_lbracket.
      WHEN ']'.
        result-kind = token_rbracket.
      WHEN ';'.
        result-kind = token_semicolon.
      WHEN '{'.
        result-kind = token_lbrace.
      WHEN '}'.
        result-kind = token_rbrace.
      WHEN ','.
        result-kind = token_comma.
      WHEN '.'.
        result-kind = token_dot.
      WHEN ':'.
        result-kind = token_colon.
      WHEN '<'.
        result-kind = token_lt.
        IF mv_offset + 2 < strlen( mv_source ) AND mv_source+mv_offset(3) = '<<='.
          result-kind = token_shift_left_assign.
          mv_offset = mv_offset + 2.
        ELSEIF lv_next_offset < strlen( mv_source ) AND mv_source+lv_next_offset(1) = '<'.
          result-kind = token_shift_left.
          mv_offset = mv_offset + 1.
        ELSEIF lv_next_offset < strlen( mv_source ) AND mv_source+lv_next_offset(1) = '='.
          result-kind = token_lte.
          mv_offset = mv_offset + 1.
        ENDIF.
      WHEN '>'.
        result-kind = token_gt.
        IF mv_offset + 3 < strlen( mv_source ) AND mv_source+mv_offset(4) = '>>>='.
          result-kind = token_ushift_right_assign.
          mv_offset = mv_offset + 3.
        ELSEIF mv_offset + 2 < strlen( mv_source ) AND mv_source+mv_offset(3) = '>>='.
          result-kind = token_shift_right_assign.
          mv_offset = mv_offset + 2.
        ELSEIF mv_offset + 2 < strlen( mv_source ) AND mv_source+mv_offset(3) = '>>>'.
          result-kind = token_shift_right_unsigned.
          mv_offset = mv_offset + 2.
        ELSEIF lv_next_offset < strlen( mv_source ) AND mv_source+lv_next_offset(1) = '>'.
          result-kind = token_shift_right.
          mv_offset = mv_offset + 1.
        ELSEIF lv_next_offset < strlen( mv_source ) AND mv_source+lv_next_offset(1) = '='.
          result-kind = token_gte.
          mv_offset = mv_offset + 1.
        ENDIF.
      WHEN '='.
        IF mv_offset + 2 < strlen( mv_source ) AND mv_source+mv_offset(3) = '==='.
          result-kind = token_strict_eq.
          mv_offset = mv_offset + 2.
        ELSEIF lv_next_offset < strlen( mv_source )
            AND mv_source+lv_next_offset(1) = '='.
          result-kind = token_eq.
          mv_offset = mv_offset + 1.
        ELSE.
          result-kind = token_assign.
        ENDIF.
      WHEN '!'.
        IF mv_offset + 2 < strlen( mv_source ) AND mv_source+mv_offset(3) = '!=='.
          result-kind = token_strict_neq.
          mv_offset = mv_offset + 2.
        ELSEIF lv_next_offset < strlen( mv_source )
            AND mv_source+lv_next_offset(1) = '='.
          result-kind = token_neq.
          mv_offset = mv_offset + 1.
        ELSE.
          result-kind = token_bang.
        ENDIF.
      WHEN '&'.
        IF lv_next_offset < strlen( mv_source )
            AND mv_source+lv_next_offset(1) = '&'.
          result-kind = token_and.
          mv_offset = mv_offset + 1.
        ELSE.
          IF lv_next_offset < strlen( mv_source )
              AND mv_source+lv_next_offset(1) = '='.
            result-kind = token_bit_and_assign.
            mv_offset = mv_offset + 1.
          ELSE.
            result-kind = token_bit_and.
          ENDIF.
        ENDIF.
      WHEN '|'.
        IF lv_next_offset < strlen( mv_source )
            AND mv_source+lv_next_offset(1) = '|'.
          result-kind = token_or.
          mv_offset = mv_offset + 1.
        ELSE.
          IF lv_next_offset < strlen( mv_source )
              AND mv_source+lv_next_offset(1) = '='.
            result-kind = token_bit_or_assign.
            mv_offset = mv_offset + 1.
          ELSE.
            result-kind = token_bit_or.
          ENDIF.
        ENDIF.
      WHEN '^'.
        IF lv_next_offset < strlen( mv_source ) AND mv_source+lv_next_offset(1) = '='.
          result-kind = token_bit_xor_assign.
          mv_offset = mv_offset + 1.
        ELSE.
          result-kind = token_bit_xor.
        ENDIF.
      WHEN '~'.
        result-kind = token_bit_not.
      WHEN OTHERS.
        IF lv_char CO '0123456789'.
          lv_start = mv_offset.
          IF lv_char = '0' AND mv_offset + 1 < strlen( mv_source ).
            lv_next_offset = mv_offset + 1.
            DATA(lv_prefix) = mv_source+lv_next_offset(1).
          ENDIF.
          IF lv_prefix = 'x' OR lv_prefix = 'X' OR lv_prefix = 'o'
              OR lv_prefix = 'O' OR lv_prefix = 'b' OR lv_prefix = 'B'.
            lv_is_radix = abap_true.
            mv_offset = mv_offset + 2.
            WHILE mv_offset < strlen( mv_source ).
              lv_char = mv_source+mv_offset(1).
              IF NOT lv_char CO '0123456789abcdefABCDEF'.
                EXIT.
              ENDIF.
              mv_offset = mv_offset + 1.
            ENDWHILE.
          ELSE.
            WHILE mv_offset < strlen( mv_source ).
              lv_char = mv_source+mv_offset(1).
              IF lv_char CO '0123456789'.
                mv_offset = mv_offset + 1.
              ELSEIF lv_char = '.' AND lv_has_dot = abap_false
                  AND lv_has_exponent = abap_false.
                lv_has_dot = abap_true.
                mv_offset = mv_offset + 1.
              ELSEIF ( lv_char = 'e' OR lv_char = 'E' )
                  AND lv_has_exponent = abap_false.
                lv_has_exponent = abap_true.
                mv_offset = mv_offset + 1.
                IF mv_offset < strlen( mv_source )
                    AND ( mv_source+mv_offset(1) = '+'
                      OR mv_source+mv_offset(1) = '-' ).
                  mv_offset = mv_offset + 1.
                ENDIF.
              ELSE.
                EXIT.
              ENDIF.
            ENDWHILE.
          ENDIF.
          result-kind = token_number.
          DATA(lv_literal_length) = mv_offset - lv_start.
          result-text = mv_source+lv_start(lv_literal_length).
          IF lv_is_radix = abap_false AND lv_has_dot = abap_false
              AND lv_has_exponent = abap_false.
            TRY.
                lv_value = result-text.
                IF lv_value <= 2147483647.
                  result-number = CONV i( lv_value ).
                  result-integer_literal = abap_true.
                ENDIF.
              CATCH cx_sy_conversion_error cx_sy_arithmetic_error.
            ENDTRY.
          ENDIF.
          RETURN.
        ELSEIF lv_char CO 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$'.
          WHILE mv_offset < strlen( mv_source ).
            lv_char = mv_source+mv_offset(1).
            IF NOT lv_char CO 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$0123456789'.
              EXIT.
            ENDIF.
            result-text = result-text && lv_char.
            mv_offset = mv_offset + 1.
          ENDWHILE.
          CASE result-text.
            WHEN 'true'. result-kind = token_true.
            WHEN 'false'. result-kind = token_false.
            WHEN 'null'. result-kind = token_null.
            WHEN 'undefined'. result-kind = token_undefined.
            WHEN 'if'. result-kind = token_if.
            WHEN 'else'. result-kind = token_else.
            WHEN 'var'. result-kind = token_var.
            WHEN 'while'. result-kind = token_while.
            WHEN 'for'. result-kind = token_for.
            WHEN 'break'. result-kind = token_break.
            WHEN 'continue'. result-kind = token_continue.
            WHEN 'function'. result-kind = token_function.
            WHEN 'return'. result-kind = token_return.
            WHEN 'new'. result-kind = token_new.
            WHEN 'throw'. result-kind = token_throw.
            WHEN 'try'. result-kind = token_try.
            WHEN 'catch'. result-kind = token_catch.
            WHEN 'finally'. result-kind = token_finally.
            WHEN 'let'. result-kind = token_let.
            WHEN 'const'. result-kind = token_const.
            WHEN 'this'. result-kind = token_this.
            WHEN 'instanceof'. result-kind = token_instanceof.
            WHEN 'delete'. result-kind = token_delete.
            WHEN 'typeof'. result-kind = token_typeof.
            WHEN OTHERS. result-kind = token_identifier.
          ENDCASE.
          RETURN.
        ELSEIF lv_char = `"` OR lv_char = `'`.
          lv_quote = lv_char.
          mv_offset = mv_offset + 1.
          WHILE mv_offset < strlen( mv_source ).
            lv_string_char = mv_source+mv_offset(1).
            lv_char = lv_string_char.
            mv_offset = mv_offset + 1.
            IF lv_char = lv_quote.
              result-kind = token_string.
              RETURN.
            ENDIF.
            IF lv_char = `\`.
              IF mv_offset >= strlen( mv_source ).
                EXIT.
              ENDIF.
              lv_string_char = mv_source+mv_offset(1).
              lv_char = lv_string_char.
              mv_offset = mv_offset + 1.
              CASE lv_char.
                WHEN 'n'.
                  result-text = result-text && cl_abap_char_utilities=>newline.
                WHEN 't'.
                  result-text = result-text && cl_abap_char_utilities=>horizontal_tab.
                WHEN 'r'.
                  result-text = result-text && cl_abap_char_utilities=>cr_lf+0(1).
                WHEN OTHERS.
                  result-text = result-text && lv_string_char.
              ENDCASE.
            ELSEIF lv_char = cl_abap_char_utilities=>newline.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'Unterminated JavaScript string literal'.
            ELSE.
              result-text = result-text && lv_string_char.
            ENDIF.
          ENDWHILE.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Unterminated JavaScript string literal'.
        ENDIF.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING
            reason = 'Unexpected character in JavaScript source'.
    ENDCASE.
    mv_offset = mv_offset + 1.
  ENDMETHOD.

  METHOD get_offset.
    result = mv_offset.
  ENDMETHOD.

  METHOD set_offset.
    IF offset < 0 OR offset > strlen( mv_source ).
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Lexer offset is out of bounds'.
    ENDIF.
    mv_offset = offset.
  ENDMETHOD.
ENDCLASS.
