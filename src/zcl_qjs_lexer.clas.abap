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
    CONSTANTS token_question TYPE i VALUE 75.
    CONSTANTS token_in TYPE i VALUE 76.
    CONSTANTS token_template_head TYPE i VALUE 77.
    CONSTANTS token_template_middle TYPE i VALUE 78.
    CONSTANTS token_template_tail TYPE i VALUE 79.
    CONSTANTS token_ellipsis TYPE i VALUE 80.
    CONSTANTS token_class TYPE i VALUE 81.
    CONSTANTS token_extends TYPE i VALUE 82.
    CONSTANTS token_super TYPE i VALUE 83.
    CONSTANTS token_private_identifier TYPE i VALUE 84.
    CONSTANTS token_yield TYPE i VALUE 85.
    CONSTANTS token_arrow TYPE i VALUE 86.
    CONSTANTS token_void TYPE i VALUE 87.
    CONSTANTS token_regexp TYPE i VALUE 88.
    CONSTANTS token_optional_chain TYPE i VALUE 89.

    TYPES:
      BEGIN OF ty_token,
        kind                   TYPE i,
        number                 TYPE i,
        text                   TYPE string,
        raw                    TYPE string,
        offset                 TYPE i,
        end_offset             TYPE i,
        line_terminator_before TYPE abap_bool,
        integer_literal        TYPE abap_bool,
        template_continuation  TYPE abap_bool,
      END OF ty_token.

    METHODS constructor
      IMPORTING
        source TYPE string OPTIONAL
        cache  TYPE REF TO zcl_qjs_lexer OPTIONAL.

    METHODS next
      RETURNING
        VALUE(result) TYPE ty_token
      RAISING
        zcx_qjs_error.

    METHODS next_into
      CHANGING token TYPE ty_token
      RAISING zcx_qjs_error.

    METHODS prepare
      RAISING zcx_qjs_error.

    METHODS get_offset RETURNING VALUE(result) TYPE i.
    METHODS set_offset IMPORTING offset TYPE i RAISING zcx_qjs_error.

  PRIVATE SECTION.
    TYPES ty_template_depths TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    TYPES ty_tokens TYPE STANDARD TABLE OF ty_token WITH DEFAULT KEY.
    DATA mv_source TYPE string.
    DATA mv_source_length TYPE i.
    DATA mv_offset TYPE i.
    DATA mv_cursor_index TYPE i VALUE 1.
    DATA mv_cursor_offset TYPE i.
    DATA mv_had_line_terminator TYPE abap_bool.
    DATA mt_template_depths TYPE ty_template_depths.
    DATA mv_regexp_allowed TYPE abap_bool VALUE abap_true.
    DATA mr_tokens TYPE REF TO ty_tokens.
    DATA mo_cache TYPE REF TO zcl_qjs_lexer.
    DATA mv_prepared TYPE abap_bool.

    METHODS skip_whitespace RAISING zcx_qjs_error.
    METHODS decode_hex_escape
      IMPORTING digits        TYPE string
      RETURNING VALUE(result) TYPE string
      RAISING zcx_qjs_error.
    METHODS hex_escape_value
      IMPORTING digits        TYPE string
      RETURNING VALUE(result) TYPE i
      RAISING zcx_qjs_error.
    METHODS decode_surrogate_pair
      IMPORTING high TYPE i low TYPE i
      RETURNING VALUE(result) TYPE string
      RAISING zcx_qjs_error.
    METHODS scan_template_part
      IMPORTING first         TYPE abap_bool DEFAULT abap_false
      RETURNING VALUE(result) TYPE ty_token
      RAISING zcx_qjs_error.
    METHODS scan_regexp
      RETURNING VALUE(result) TYPE ty_token
      RAISING zcx_qjs_error.
    METHODS update_regexp_context IMPORTING kind TYPE i.
    METHODS scan_next
      RETURNING VALUE(result) TYPE ty_token
      RAISING zcx_qjs_error.
    METHODS cached_token
      IMPORTING index         TYPE i
      RETURNING VALUE(result) TYPE ty_token
      RAISING zcx_qjs_error.
    METHODS token_index_at
      IMPORTING offset        TYPE i
      RETURNING VALUE(result) TYPE i
      RAISING zcx_qjs_error.
ENDCLASS.

CLASS zcl_qjs_lexer IMPLEMENTATION.
  METHOD update_regexp_context.
    mv_regexp_allowed = abap_true.
    IF kind = token_number OR kind = token_identifier OR kind = token_string
        OR kind = token_true OR kind = token_false OR kind = token_null
        OR kind = token_undefined OR kind = token_this
        OR kind = token_private_identifier OR kind = token_rparen
        OR kind = token_rbracket OR kind = token_increment
        OR kind = token_decrement OR kind = token_template_tail
        OR kind = token_regexp.
      mv_regexp_allowed = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD scan_regexp.
    DATA lv_char TYPE string.
    DATA lv_escaped TYPE abap_bool.
    DATA lv_in_class TYPE abap_bool.
    result-kind = token_regexp.
    result-offset = mv_offset.
    result-line_terminator_before = mv_had_line_terminator.
    mv_offset = mv_offset + 1.
    WHILE mv_offset < mv_source_length.
      lv_char = mv_source+mv_offset(1).
      IF lv_char = cl_abap_char_utilities=>newline
          OR lv_char = cl_abap_char_utilities=>cr_lf+0(1).
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Unterminated regular expression literal'.
      ENDIF.
      IF lv_escaped = abap_true.
        result-text = result-text && `\` && lv_char.
        lv_escaped = abap_false.
        mv_offset = mv_offset + 1.
        CONTINUE.
      ENDIF.
      IF lv_char = `\`.
        lv_escaped = abap_true.
        mv_offset = mv_offset + 1.
        CONTINUE.
      ENDIF.
      IF lv_char = '['.
        lv_in_class = abap_true.
      ELSEIF lv_char = ']' AND lv_in_class = abap_true.
        lv_in_class = abap_false.
      ELSEIF lv_char = '/' AND lv_in_class = abap_false.
        mv_offset = mv_offset + 1.
        WHILE mv_offset < mv_source_length
            AND mv_source+mv_offset(1)
              CO 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.
          result-raw = result-raw && mv_source+mv_offset(1).
          mv_offset = mv_offset + 1.
        ENDWHILE.
        update_regexp_context( result-kind ).
        RETURN.
      ENDIF.
      result-text = result-text && lv_char.
      mv_offset = mv_offset + 1.
    ENDWHILE.
    RAISE EXCEPTION TYPE zcx_qjs_error
      EXPORTING reason = 'Unterminated regular expression literal'.
  ENDMETHOD.

  METHOD decode_hex_escape.
    DATA(lv_code) = hex_escape_value( digits ).
    TRY.
        IF lv_code >= 55296 AND lv_code <= 57343.
          result = cl_abap_conv_in_ce=>uccpi( 65533 ).
        ELSE.
          result = cl_abap_conv_in_ce=>uccpi( lv_code ).
        ENDIF.
      CATCH cx_sy_conversion_codepage.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Invalid Unicode string escape'.
    ENDTRY.
  ENDMETHOD.

  METHOD hex_escape_value.
    DATA lv_digit TYPE i.
    DATA lv_character TYPE string.
    DATA lv_hex_digits TYPE string VALUE '0123456789ABCDEFabcdef'.
    DATA lv_index TYPE i.
    WHILE lv_index < strlen( digits ).
      lv_character = digits+lv_index(1).
      FIND FIRST OCCURRENCE OF lv_character IN lv_hex_digits
        MATCH OFFSET lv_digit.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Invalid hexadecimal string escape'.
      ENDIF.
      IF lv_digit >= 16.
        lv_digit = lv_digit - 6.
      ENDIF.
      result = result * 16 + lv_digit.
      lv_index = lv_index + 1.
    ENDWHILE.
  ENDMETHOD.

  METHOD decode_surrogate_pair.
    DATA lv_high_hex TYPE x LENGTH 2.
    DATA lv_low_hex TYPE x LENGTH 2.
    DATA lv_utf16 TYPE xstring.
    DATA lv_converter TYPE REF TO cl_abap_conv_in_ce.
    lv_high_hex = high.
    lv_low_hex = low.
    CONCATENATE lv_high_hex+1(1) lv_high_hex(1)
      lv_low_hex+1(1) lv_low_hex(1) INTO lv_utf16 IN BYTE MODE.
    TRY.
        lv_converter = cl_abap_conv_in_ce=>create( encoding = '4103' ).
        lv_converter->convert(
          EXPORTING input = lv_utf16
          IMPORTING data  = result ).
      CATCH cx_sy_conversion_codepage.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Invalid Unicode surrogate pair'.
    ENDTRY.
  ENDMETHOD.

  METHOD scan_template_part.
    DATA lv_char TYPE string.
    DATA lv_next_offset TYPE i.
    DATA lv_raw_start TYPE i.
    DATA lv_raw_length TYPE i.
    result-offset = mv_offset.
    result-template_continuation = xsdbool( first = abap_false ).
    lv_raw_start = mv_offset.
    WHILE mv_offset < mv_source_length.
      lv_char = mv_source+mv_offset(1).
      IF lv_char = '`'.
        lv_raw_length = mv_offset - lv_raw_start.
        result-raw = mv_source+lv_raw_start(lv_raw_length).
        result-kind = token_template_tail.
        mv_offset = mv_offset + 1.
        RETURN.
      ENDIF.
      lv_next_offset = mv_offset + 1.
      IF lv_char = '$' AND lv_next_offset < strlen( mv_source )
          AND mv_source+lv_next_offset(1) = '{'.
        lv_raw_length = mv_offset - lv_raw_start.
        result-raw = mv_source+lv_raw_start(lv_raw_length).
        IF first = abap_true.
          result-kind = token_template_head.
        ELSE.
          result-kind = token_template_middle.
        ENDIF.
        mv_offset = mv_offset + 2.
        APPEND 0 TO mt_template_depths.
        RETURN.
      ENDIF.
      mv_offset = mv_offset + 1.
      IF lv_char <> `\`.
        result-text = result-text && lv_char.
        CONTINUE.
      ENDIF.
      IF mv_offset >= strlen( mv_source ).
        EXIT.
      ENDIF.
      lv_char = mv_source+mv_offset(1).
      mv_offset = mv_offset + 1.
      CASE lv_char.
        WHEN 'n'.
          result-text = result-text && cl_abap_char_utilities=>newline.
        WHEN 't'.
          result-text = result-text && cl_abap_char_utilities=>horizontal_tab.
        WHEN 'r'.
          result-text = result-text && cl_abap_char_utilities=>cr_lf+0(1).
        WHEN 'x'.
          IF mv_offset + 2 > strlen( mv_source ).
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Incomplete hexadecimal template escape'.
          ENDIF.
          DATA(lv_hex_byte) = mv_source+mv_offset(2).
          result-text = result-text && decode_hex_escape( lv_hex_byte ).
          mv_offset = mv_offset + 2.
        WHEN 'u'.
          IF mv_offset + 4 > strlen( mv_source ).
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Incomplete Unicode template escape'.
          ENDIF.
          DATA(lv_hex_unit) = mv_source+mv_offset(4).
          DATA(lv_hex_code) = hex_escape_value( lv_hex_unit ).
          DATA(lv_pair_offset) = mv_offset + 4.
          IF lv_hex_code >= 55296 AND lv_hex_code <= 56319
              AND lv_pair_offset + 6 <= strlen( mv_source )
              AND mv_source+lv_pair_offset(2) = `\u`.
            DATA(lv_low_offset) = lv_pair_offset + 2.
            DATA(lv_low_digits) = mv_source+lv_low_offset(4).
            DATA(lv_low_code) = hex_escape_value( lv_low_digits ).
            IF lv_low_code >= 56320 AND lv_low_code <= 57343.
              result-text = result-text && decode_surrogate_pair(
                high = lv_hex_code low = lv_low_code ).
              mv_offset = mv_offset + 10.
            ELSE.
              result-text = result-text && decode_hex_escape( lv_hex_unit ).
              mv_offset = mv_offset + 4.
            ENDIF.
          ELSE.
            result-text = result-text && decode_hex_escape( lv_hex_unit ).
            mv_offset = mv_offset + 4.
          ENDIF.
        WHEN cl_abap_char_utilities=>newline.
        WHEN OTHERS.
          result-text = result-text && lv_char.
      ENDCASE.
    ENDWHILE.
    RAISE EXCEPTION TYPE zcx_qjs_error
      EXPORTING reason = 'Unterminated JavaScript template literal'.
  ENDMETHOD.

  METHOD constructor.
    IF cache IS BOUND.
      mo_cache = cache.
      mr_tokens = cache->mr_tokens.
    ELSE.
      mv_source = source.
      mv_source_length = strlen( source ).
      mv_offset = 0.
      CREATE DATA mr_tokens.
    ENDIF.
    mv_cursor_index = 1.
    mv_cursor_offset = 0.
  ENDMETHOD.

  METHOD skip_whitespace.
    DATA lv_char TYPE c LENGTH 1.
    DATA lv_next TYPE c LENGTH 1.
    DATA lv_closed TYPE abap_bool.
    DATA lv_lookahead TYPE i.
    mv_had_line_terminator = abap_false.
    WHILE mv_offset < mv_source_length.
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
          WHILE mv_offset < mv_source_length.
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
          WHILE mv_offset < mv_source_length.
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

  METHOD scan_next.
    DATA lv_char TYPE c LENGTH 1.
    DATA lv_string_char TYPE string.
    DATA lv_quote TYPE c LENGTH 1.
    DATA lv_next_offset TYPE i.
    DATA lv_start TYPE i.
    DATA lv_has_dot TYPE abap_bool.
    DATA lv_has_exponent TYPE abap_bool.
    DATA lv_is_radix TYPE abap_bool.
    DATA lv_value TYPE int8.
    DATA lv_template_index TYPE i.
    DATA lv_chunk_length TYPE i.
    FIELD-SYMBOLS <template_depth> TYPE i.
    skip_whitespace( ).
    CLEAR result.
    result-offset = mv_offset.
    result-line_terminator_before = mv_had_line_terminator.
    IF mv_offset >= mv_source_length.
      result-kind = token_eof.
      update_regexp_context( result-kind ).
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
        IF mv_regexp_allowed = abap_true.
          result = scan_regexp( ).
          RETURN.
        ELSEIF lv_next_offset < strlen( mv_source ) AND mv_source+lv_next_offset(1) = '='.
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
        lv_template_index = lines( mt_template_depths ).
        IF lv_template_index > 0.
          READ TABLE mt_template_depths INDEX lv_template_index
            ASSIGNING <template_depth>.
          <template_depth> = <template_depth> + 1.
        ENDIF.
      WHEN '}'.
        lv_template_index = lines( mt_template_depths ).
        IF lv_template_index > 0.
          READ TABLE mt_template_depths INDEX lv_template_index
            ASSIGNING <template_depth>.
          IF <template_depth> = 0.
            DELETE mt_template_depths INDEX lv_template_index.
            mv_offset = mv_offset + 1.
            result = scan_template_part( ).
            update_regexp_context( result-kind ).
            RETURN.
          ENDIF.
          <template_depth> = <template_depth> - 1.
        ENDIF.
        result-kind = token_rbrace.
      WHEN ','.
        result-kind = token_comma.
      WHEN '.'.
        IF mv_offset + 2 < strlen( mv_source )
            AND mv_source+mv_offset(3) = '...'.
          result-kind = token_ellipsis.
          mv_offset = mv_offset + 2.
        ELSE.
          result-kind = token_dot.
        ENDIF.
      WHEN ':'.
        result-kind = token_colon.
      WHEN '?'.
        IF lv_next_offset < strlen( mv_source )
            AND mv_source+lv_next_offset(1) = '.'.
          result-kind = token_optional_chain.
          mv_offset = mv_offset + 1.
        ELSE.
          result-kind = token_question.
        ENDIF.
      WHEN '#'.
        mv_offset = mv_offset + 1.
        IF mv_offset >= mv_source_length
            OR NOT mv_source+mv_offset(1)
              CO 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$'.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Invalid private identifier'.
        ENDIF.
        lv_start = mv_offset.
        WHILE mv_offset < mv_source_length.
          lv_char = mv_source+mv_offset(1).
          IF NOT lv_char
              CO 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$0123456789'.
            EXIT.
          ENDIF.
          mv_offset = mv_offset + 1.
        ENDWHILE.
        DATA(lv_private_length) = mv_offset - lv_start.
        result-text = mv_source+lv_start(lv_private_length).
        result-kind = token_private_identifier.
        update_regexp_context( result-kind ).
        RETURN.
      WHEN '`'.
        mv_offset = mv_offset + 1.
        result = scan_template_part( first = abap_true ).
        update_regexp_context( result-kind ).
        RETURN.
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
        IF lv_next_offset < strlen( mv_source )
            AND mv_source+lv_next_offset(1) = '>'.
          result-kind = token_arrow.
          mv_offset = mv_offset + 1.
        ELSEIF mv_offset + 2 < strlen( mv_source )
            AND mv_source+mv_offset(3) = '==='.
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
            WHILE mv_offset < mv_source_length.
              lv_char = mv_source+mv_offset(1).
              IF NOT lv_char CO '0123456789abcdefABCDEF'.
                EXIT.
              ENDIF.
              mv_offset = mv_offset + 1.
            ENDWHILE.
          ELSE.
            WHILE mv_offset < mv_source_length.
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
          update_regexp_context( result-kind ).
          RETURN.
        ELSEIF lv_char CO 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$'.
          lv_start = mv_offset.
          WHILE mv_offset < mv_source_length.
            lv_char = mv_source+mv_offset(1).
            IF NOT lv_char CO 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$0123456789'.
              EXIT.
            ENDIF.
            mv_offset = mv_offset + 1.
          ENDWHILE.
          DATA(lv_identifier_length) = mv_offset - lv_start.
          result-text = mv_source+lv_start(lv_identifier_length).
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
            WHEN 'yield'. result-kind = token_yield.
            WHEN 'new'. result-kind = token_new.
            WHEN 'throw'. result-kind = token_throw.
            WHEN 'try'. result-kind = token_try.
            WHEN 'catch'. result-kind = token_catch.
            WHEN 'finally'. result-kind = token_finally.
            WHEN 'let'. result-kind = token_let.
            WHEN 'const'. result-kind = token_const.
            WHEN 'this'. result-kind = token_this.
            WHEN 'instanceof'. result-kind = token_instanceof.
            WHEN 'in'. result-kind = token_in.
            WHEN 'delete'. result-kind = token_delete.
            WHEN 'typeof'. result-kind = token_typeof.
            WHEN 'void'. result-kind = token_void.
            WHEN 'class'. result-kind = token_class.
            WHEN 'extends'. result-kind = token_extends.
            WHEN 'super'. result-kind = token_super.
            WHEN OTHERS. result-kind = token_identifier.
          ENDCASE.
          update_regexp_context( result-kind ).
          RETURN.
        ELSEIF lv_char = `"` OR lv_char = `'`.
          lv_quote = lv_char.
          mv_offset = mv_offset + 1.
          lv_start = mv_offset.
          WHILE mv_offset < mv_source_length.
            lv_string_char = mv_source+mv_offset(1).
            lv_char = lv_string_char.
            IF lv_char = lv_quote.
              lv_chunk_length = mv_offset - lv_start.
              IF lv_chunk_length > 0.
                result-text = result-text
                  && mv_source+lv_start(lv_chunk_length).
              ENDIF.
              mv_offset = mv_offset + 1.
              result-kind = token_string.
              update_regexp_context( result-kind ).
              RETURN.
            ENDIF.
            IF lv_char = `\`.
              lv_chunk_length = mv_offset - lv_start.
              IF lv_chunk_length > 0.
                result-text = result-text
                  && mv_source+lv_start(lv_chunk_length).
              ENDIF.
              mv_offset = mv_offset + 1.
              IF mv_offset >= mv_source_length.
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
                WHEN 'x'.
                  IF mv_offset + 2 > mv_source_length.
                    RAISE EXCEPTION TYPE zcx_qjs_error
                      EXPORTING reason = 'Incomplete hexadecimal string escape'.
                  ENDIF.
                  DATA(lv_hex_byte) = mv_source+mv_offset(2).
                  result-text = result-text && decode_hex_escape( lv_hex_byte ).
                  mv_offset = mv_offset + 2.
                WHEN 'u'.
                  IF mv_offset + 4 > mv_source_length.
                    RAISE EXCEPTION TYPE zcx_qjs_error
                      EXPORTING reason = 'Incomplete Unicode string escape'.
                  ENDIF.
                  DATA(lv_hex_unit) = mv_source+mv_offset(4).
                  DATA(lv_hex_code) = hex_escape_value( lv_hex_unit ).
                  DATA(lv_pair_offset) = mv_offset + 4.
                  IF lv_hex_code >= 55296 AND lv_hex_code <= 56319
                      AND lv_pair_offset + 6 <= mv_source_length
                      AND mv_source+lv_pair_offset(2) = `\u`.
                    DATA(lv_low_offset) = lv_pair_offset + 2.
                    DATA(lv_low_digits) = mv_source+lv_low_offset(4).
                    DATA(lv_low_code) = hex_escape_value( lv_low_digits ).
                    IF lv_low_code >= 56320 AND lv_low_code <= 57343.
                      result-text = result-text
                        && decode_surrogate_pair(
                          high = lv_hex_code low = lv_low_code ).
                      mv_offset = mv_offset + 10.
                    ELSE.
                      result-text = result-text && decode_hex_escape( lv_hex_unit ).
                      mv_offset = mv_offset + 4.
                    ENDIF.
                  ELSE.
                    result-text = result-text && decode_hex_escape( lv_hex_unit ).
                    mv_offset = mv_offset + 4.
                  ENDIF.
                WHEN OTHERS.
                  result-text = result-text && lv_string_char.
              ENDCASE.
              lv_start = mv_offset.
            ELSEIF lv_char = cl_abap_char_utilities=>newline.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'Unterminated JavaScript string literal'.
            ELSE.
              mv_offset = mv_offset + 1.
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
    update_regexp_context( result-kind ).
  ENDMETHOD.

  METHOD cached_token.
    IF mo_cache IS BOUND.
      result = mo_cache->cached_token( index ).
      RETURN.
    ENDIF.
    WHILE lines( mr_tokens->* ) < index.
      READ TABLE mr_tokens->* INDEX lines( mr_tokens->* )
        ASSIGNING FIELD-SYMBOL(<ls_last>).
      IF sy-subrc = 0 AND <ls_last>-kind = token_eof.
        result = <ls_last>.
        RETURN.
      ENDIF.
      DATA(ls_token) = scan_next( ).
      ls_token-end_offset = mv_offset.
      APPEND ls_token TO mr_tokens->*.
    ENDWHILE.
    READ TABLE mr_tokens->* INDEX index INTO result.
  ENDMETHOD.

  METHOD token_index_at.
    DATA lv_low TYPE i VALUE 1.
    DATA lv_high TYPE i.
    DATA lv_middle TYPE i.
    prepare( ).
    IF offset < 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Lexer offset is out of bounds'.
    ENDIF.
    lv_high = lines( mr_tokens->* ).
    READ TABLE mr_tokens->* INDEX lv_high ASSIGNING FIELD-SYMBOL(<ls_eof>).
    IF offset > <ls_eof>-offset.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Lexer offset is out of bounds'.
    ENDIF.
    result = lv_high.
    WHILE lv_low <= lv_high.
      lv_middle = ( lv_low + lv_high ) DIV 2.
      READ TABLE mr_tokens->* INDEX lv_middle ASSIGNING FIELD-SYMBOL(<ls_token>).
      IF <ls_token>-end_offset > offset OR <ls_token>-offset >= offset
          OR <ls_token>-kind = token_eof.
        result = lv_middle.
        lv_high = lv_middle - 1.
      ELSE.
        lv_low = lv_middle + 1.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD next.
    next_into( CHANGING token = result ).
  ENDMETHOD.

  METHOD next_into.
    READ TABLE mr_tokens->* INDEX mv_cursor_index INTO token.
    IF sy-subrc <> 0.
      token = cached_token( mv_cursor_index ).
    ENDIF.
    mv_cursor_index = mv_cursor_index + 1.
    mv_cursor_offset = token-end_offset.
  ENDMETHOD.

  METHOD prepare.
    IF mo_cache IS BOUND.
      mo_cache->prepare( ).
      RETURN.
    ENDIF.
    IF mv_prepared = abap_true.
      RETURN.
    ENDIF.
    WHILE abap_true = abap_true.
      DATA(ls_token) = cached_token( lines( mr_tokens->* ) + 1 ).
      IF ls_token-kind = token_eof.
        mv_prepared = abap_true.
        RETURN.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD get_offset.
    result = mv_cursor_offset.
  ENDMETHOD.

  METHOD set_offset.
    mv_cursor_index = token_index_at( offset ).
    mv_cursor_offset = offset.
  ENDMETHOD.
ENDCLASS.
