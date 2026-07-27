CLASS zcl_qjs_json DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS parse
      IMPORTING source        TYPE string
        runtime               TYPE REF TO zcl_qjs_runtime
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    CLASS-METHODS stringify
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_serialized,
      supported TYPE abap_bool,
      text      TYPE string,
      END OF ty_serialized.
    DATA mv_source TYPE string.
    DATA mv_offset TYPE i.
    DATA mo_runtime TYPE REF TO zcl_qjs_runtime.
    DATA mt_seen TYPE STANDARD TABLE OF REF TO object WITH DEFAULT KEY.
    DATA mv_depth TYPE i.
    METHODS constructor IMPORTING source TYPE string OPTIONAL
      runtime                            TYPE REF TO zcl_qjs_runtime OPTIONAL.
    METHODS parse_document RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS parse_value RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS parse_object RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS parse_array RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS parse_string RETURNING VALUE(result) TYPE string
      RAISING zcx_qjs_error.
    METHODS parse_number RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS parse_hex_quad RETURNING VALUE(result) TYPE i
      RAISING zcx_qjs_error.
    METHODS skip_whitespace.
    METHODS current RETURNING VALUE(result) TYPE string.
    METHODS consume IMPORTING expected TYPE string RAISING zcx_qjs_error.
    METHODS fail RAISING zcx_qjs_error.
    METHODS serialize IMPORTING value TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result)         TYPE ty_serialized RAISING zcx_qjs_error.
    METHODS quote IMPORTING value TYPE string RETURNING VALUE(result) TYPE string.
    METHODS enter_object IMPORTING reference TYPE REF TO object RAISING zcx_qjs_error.
    METHODS leave_object.
    METHODS enter_depth RAISING zcx_qjs_error.
    METHODS leave_depth.
ENDCLASS.

CLASS zcl_qjs_json IMPLEMENTATION.
  METHOD constructor.
    mv_source = source.
    mo_runtime = runtime.
  ENDMETHOD.

  METHOD parse.
    DATA lo_json TYPE REF TO zcl_qjs_json.
    IF runtime IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'JSON parser requires an active runtime'.
    ENDIF.
    CREATE OBJECT lo_json EXPORTING source = source runtime = runtime.
    runtime->get_limits( )->check_source_length( strlen( source ) ).
    runtime->get_limits( )->consume( CONV int8( strlen( source ) + 1 ) ).
    result = lo_json->parse_document( ).
  ENDMETHOD.

  METHOD stringify.
    DATA lo_json TYPE REF TO zcl_qjs_json.
    CREATE OBJECT lo_json.
    DATA(ls_serialized) = lo_json->serialize( value ).
    IF ls_serialized-supported = abap_true.
      result = zcl_qjs_value=>new_string( ls_serialized-text ).
    ELSE.
      result = zcl_qjs_value=>new_undefined( ).
    ENDIF.
  ENDMETHOD.

  METHOD fail.
    RAISE EXCEPTION TYPE zcx_qjs_error
      EXPORTING reason = 'SyntaxError: invalid JSON text'.
  ENDMETHOD.

  METHOD current.
    IF mv_offset < strlen( mv_source ).
      result = mv_source+mv_offset(1).
    ENDIF.
  ENDMETHOD.

  METHOD skip_whitespace.
    DATA lv_char TYPE string.
    DATA lv_code TYPE i.
    WHILE mv_offset < strlen( mv_source ).
      lv_char = current( ).
      lv_code = cl_abap_conv_out_ce=>uccpi( lv_char ).
      IF lv_code <> 9 AND lv_code <> 10 AND lv_code <> 13 AND lv_code <> 32.
        RETURN.
      ENDIF.
      mv_offset = mv_offset + 1.
    ENDWHILE.
  ENDMETHOD.

  METHOD consume.
    IF current( ) <> expected.
      fail( ).
    ENDIF.
    mv_offset = mv_offset + 1.
  ENDMETHOD.

  METHOD parse_document.
    skip_whitespace( ).
    result = parse_value( ).
    skip_whitespace( ).
    IF mv_offset <> strlen( mv_source ).
      fail( ).
    ENDIF.
  ENDMETHOD.

  METHOD parse_value.
    skip_whitespace( ).
    DATA(lv_char) = current( ).
    CASE lv_char.
      WHEN `"`.
        result = zcl_qjs_value=>new_string( parse_string( ) ).
      WHEN '{'.
        enter_depth( ).
        TRY.
            result = parse_object( ).
          CLEANUP.
            leave_depth( ).
        ENDTRY.
        leave_depth( ).
      WHEN '['.
        enter_depth( ).
        TRY.
            result = parse_array( ).
          CLEANUP.
            leave_depth( ).
        ENDTRY.
        leave_depth( ).
      WHEN 't'.
        IF strlen( mv_source ) - mv_offset < 4 OR mv_source+mv_offset(4) <> 'true'.
          fail( ).
        ENDIF.
        mv_offset = mv_offset + 4.
        result = zcl_qjs_value=>new_boolean( abap_true ).
      WHEN 'f'.
        IF strlen( mv_source ) - mv_offset < 5 OR mv_source+mv_offset(5) <> 'false'.
          fail( ).
        ENDIF.
        mv_offset = mv_offset + 5.
        result = zcl_qjs_value=>new_boolean( abap_false ).
      WHEN 'n'.
        IF strlen( mv_source ) - mv_offset < 4 OR mv_source+mv_offset(4) <> 'null'.
          fail( ).
        ENDIF.
        mv_offset = mv_offset + 4.
        result = zcl_qjs_value=>new_null( ).
      WHEN OTHERS.
        IF lv_char = '-' OR lv_char CO '0123456789'.
          result = parse_number( ).
        ELSE.
          fail( ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD parse_object.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    consume( '{' ).
    lo_object = mo_runtime->create_object( ).
    skip_whitespace( ).
    IF current( ) = '}'.
      mv_offset = mv_offset + 1.
      result = zcl_qjs_value=>new_object( lo_object ).
      RETURN.
    ENDIF.
    WHILE abap_true = abap_true.
      IF current( ) <> `"`.
        fail( ).
      ENDIF.
      DATA(lv_name) = parse_string( ).
      skip_whitespace( ).
      consume( ':' ).
      DATA(ls_value) = parse_value( ).
      lo_object->set( name = lv_name value = ls_value ).
      skip_whitespace( ).
      IF current( ) = '}'.
        mv_offset = mv_offset + 1.
        EXIT.
      ENDIF.
      consume( ',' ).
      skip_whitespace( ).
    ENDWHILE.
    result = zcl_qjs_value=>new_object( lo_object ).
  ENDMETHOD.

  METHOD parse_array.
    DATA lo_array TYPE REF TO zcl_qjs_object.
    DATA lv_index TYPE int8.
    consume( '[' ).
    lo_array = mo_runtime->create_array( ).
    skip_whitespace( ).
    IF current( ) = ']'.
      mv_offset = mv_offset + 1.
      result = zcl_qjs_value=>new_object( lo_array ).
      RETURN.
    ENDIF.
    WHILE abap_true = abap_true.
      DATA(ls_value) = parse_value( ).
      lo_array->set_element( index = lv_index value = ls_value ).
      lv_index = lv_index + 1.
      skip_whitespace( ).
      IF current( ) = ']'.
        mv_offset = mv_offset + 1.
        EXIT.
      ENDIF.
      consume( ',' ).
      skip_whitespace( ).
    ENDWHILE.
    result = zcl_qjs_value=>new_object( lo_array ).
  ENDMETHOD.

  METHOD parse_hex_quad.
    DATA lv_char TYPE string.
    DATA lv_digit TYPE i.
    DO 4 TIMES.
      IF mv_offset >= strlen( mv_source ).
        fail( ).
      ENDIF.
      lv_char = current( ).
      IF lv_char CO '0123456789'.
        lv_digit = CONV i( lv_char ).
      ELSEIF lv_char CO 'abcdef'.
        CASE lv_char.
          WHEN 'a'. lv_digit = 10.
          WHEN 'b'. lv_digit = 11.
          WHEN 'c'. lv_digit = 12.
          WHEN 'd'. lv_digit = 13.
          WHEN 'e'. lv_digit = 14.
          WHEN 'f'. lv_digit = 15.
        ENDCASE.
      ELSEIF lv_char CO 'ABCDEF'.
        CASE lv_char.
          WHEN 'A'. lv_digit = 10.
          WHEN 'B'. lv_digit = 11.
          WHEN 'C'. lv_digit = 12.
          WHEN 'D'. lv_digit = 13.
          WHEN 'E'. lv_digit = 14.
          WHEN 'F'. lv_digit = 15.
        ENDCASE.
      ELSE.
        fail( ).
      ENDIF.
      result = result * 16 + lv_digit.
      mv_offset = mv_offset + 1.
    ENDDO.
  ENDMETHOD.

  METHOD parse_string.
    DATA lv_char TYPE string.
    DATA lv_code TYPE i.
    consume( `"` ).
    WHILE mv_offset < strlen( mv_source ).
      lv_char = current( ).
      mv_offset = mv_offset + 1.
      IF lv_char = `"`.
        RETURN.
      ELSEIF lv_char = `\`.
        IF mv_offset >= strlen( mv_source ).
          fail( ).
        ENDIF.
        lv_char = current( ).
        mv_offset = mv_offset + 1.
        CASE lv_char.
          WHEN `"` OR `\` OR '/'.
            result = result && lv_char.
          WHEN 'b'.
            result = result && cl_abap_conv_in_ce=>uccpi( 8 ).
          WHEN 'f'.
            result = result && cl_abap_conv_in_ce=>uccpi( 12 ).
          WHEN 'n'.
            result = result && cl_abap_char_utilities=>newline.
          WHEN 'r'.
            result = result && cl_abap_char_utilities=>cr_lf+0(1).
          WHEN 't'.
            result = result && cl_abap_char_utilities=>horizontal_tab.
          WHEN 'u'.
            lv_code = parse_hex_quad( ).
            IF lv_code >= 55296 AND lv_code <= 56319
                AND strlen( mv_source ) - mv_offset >= 6
                AND mv_source+mv_offset(2) = `\u`.
              mv_offset = mv_offset + 2.
              DATA(lv_low) = parse_hex_quad( ).
              IF lv_low < 56320 OR lv_low > 57343.
                fail( ).
              ENDIF.
              lv_code = 65536 + ( lv_code - 55296 ) * 1024 + lv_low - 56320.
            ENDIF.
            result = result && cl_abap_conv_in_ce=>uccpi( lv_code ).
          WHEN OTHERS.
            fail( ).
        ENDCASE.
      ELSEIF cl_abap_conv_out_ce=>uccpi( lv_char ) < 32.
        fail( ).
      ELSE.
        result = result && lv_char.
      ENDIF.
    ENDWHILE.
    fail( ).
  ENDMETHOD.

  METHOD parse_number.
    DATA lv_start TYPE i.
    DATA lv_char TYPE string.
    DATA lv_negative TYPE abap_bool.
    lv_start = mv_offset.
    IF current( ) = '-'.
      lv_negative = abap_true.
      mv_offset = mv_offset + 1.
    ENDIF.
    IF current( ) = '0'.
      mv_offset = mv_offset + 1.
      IF mv_offset < strlen( mv_source ) AND current( ) CO '0123456789'.
        fail( ).
      ENDIF.
    ELSEIF mv_offset < strlen( mv_source ) AND current( ) CO '123456789'.
      WHILE mv_offset < strlen( mv_source ) AND current( ) CO '0123456789'.
        mv_offset = mv_offset + 1.
      ENDWHILE.
    ELSE.
      fail( ).
    ENDIF.
    IF current( ) = '.'.
      mv_offset = mv_offset + 1.
      IF mv_offset >= strlen( mv_source ) OR NOT current( ) CO '0123456789'.
        fail( ).
      ENDIF.
      WHILE mv_offset < strlen( mv_source ) AND current( ) CO '0123456789'.
        mv_offset = mv_offset + 1.
      ENDWHILE.
    ENDIF.
    lv_char = current( ).
    IF lv_char = 'e' OR lv_char = 'E'.
      mv_offset = mv_offset + 1.
      lv_char = current( ).
      IF lv_char = '+' OR lv_char = '-'.
        mv_offset = mv_offset + 1.
      ENDIF.
      IF mv_offset >= strlen( mv_source ) OR NOT current( ) CO '0123456789'.
        fail( ).
      ENDIF.
      WHILE mv_offset < strlen( mv_source ) AND current( ) CO '0123456789'.
        mv_offset = mv_offset + 1.
      ENDWHILE.
    ENDIF.
    DATA(lv_length) = mv_offset - lv_start.
    DATA(lv_literal) = mv_source+lv_start(lv_length).
    IF lv_negative = abap_true.
      DATA(lv_magnitude_length) = lv_length - 1.
      DATA(lv_magnitude_offset) = lv_start + 1.
      DATA(lv_magnitude) = mv_source+lv_magnitude_offset(lv_magnitude_length).
      result = zcl_qjs_number=>parse_literal( lv_magnitude ).
    ELSE.
      result = zcl_qjs_number=>parse_literal( lv_literal ).
    ENDIF.
    IF lv_negative = abap_true
        AND result-tag = zcl_qjs_value=>tag_number
        AND result-int_value = zcl_qjs_value=>number_finite
        AND result-float_value = 0.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_zero ).
    ELSEIF lv_negative = abap_true.
      result = zcl_qjs_number=>negate( result ).
    ENDIF.
  ENDMETHOD.

  METHOD quote.
    DATA lv_char TYPE string.
    DATA lv_code TYPE i.
    DATA lv_hex TYPE string VALUE '0123456789abcdef'.
    result = `"`.
    DO strlen( value ) TIMES.
      DATA(lv_index) = sy-index - 1.
      lv_char = value+lv_index(1).
      CASE lv_char.
        WHEN `"`. result = result && `\"`.
        WHEN `\`. result = result && `\\`.
        WHEN cl_abap_char_utilities=>newline. result = result && `\n`.
        WHEN cl_abap_char_utilities=>horizontal_tab. result = result && `\t`.
        WHEN cl_abap_char_utilities=>cr_lf+0(1). result = result && `\r`.
        WHEN OTHERS.
          lv_code = cl_abap_conv_out_ce=>uccpi( lv_char ).
          IF lv_code < 32.
            DATA(lv_high) = trunc( lv_code / 16 ).
            DATA(lv_low) = lv_code MOD 16.
            result = result && `\u00` && lv_hex+lv_high(1) && lv_hex+lv_low(1).
          ELSE.
            result = result && lv_char.
          ENDIF.
      ENDCASE.
    ENDDO.
    result = result && `"`.
  ENDMETHOD.

  METHOD enter_object.
    LOOP AT mt_seen INTO DATA(lo_seen).
      IF lo_seen = reference.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'TypeError: cyclic object value'.
      ENDIF.
    ENDLOOP.
    enter_depth( ).
    APPEND reference TO mt_seen.
  ENDMETHOD.

  METHOD leave_object.
    DELETE mt_seen INDEX lines( mt_seen ).
    leave_depth( ).
  ENDMETHOD.

  METHOD enter_depth.
    IF mo_runtime IS BOUND.
      mo_runtime->get_limits( )->check_parser_depth( mv_depth + 1 ).
    ELSEIF mv_depth >= 256.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'JavaScript parser depth budget exhausted'.
    ENDIF.
    mv_depth = mv_depth + 1.
  ENDMETHOD.

  METHOD leave_depth.
    IF mv_depth > 0.
      mv_depth = mv_depth - 1.
    ENDIF.
  ENDMETHOD.

  METHOD serialize.
    result-supported = abap_true.
    CASE value-tag.
      WHEN zcl_qjs_value=>tag_null.
        result-text = 'null'.
      WHEN zcl_qjs_value=>tag_bool.
        IF value-int_value <> 0.
          result-text = 'true'.
        ELSE.
          result-text = 'false'.
        ENDIF.
      WHEN zcl_qjs_value=>tag_int.
        result-text = zcl_qjs_value=>to_string( value ).
      WHEN zcl_qjs_value=>tag_number.
        IF value-int_value = zcl_qjs_value=>number_nan
            OR value-int_value = zcl_qjs_value=>number_pos_inf
            OR value-int_value = zcl_qjs_value=>number_neg_inf.
          result-text = 'null'.
        ELSE.
          result-text = zcl_qjs_value=>to_string( value ).
        ENDIF.
      WHEN zcl_qjs_value=>tag_string.
        result-text = quote( value-string_ref->as_string( ) ).
      WHEN zcl_qjs_value=>tag_undefined OR zcl_qjs_value=>tag_symbol.
        result-supported = abap_false.
      WHEN zcl_qjs_value=>tag_object.
        DATA lo_object TYPE REF TO zcl_qjs_object.
        TRY.
            lo_object ?= value-object_ref.
          CATCH cx_sy_move_cast_error.
            result-supported = abap_false.
            RETURN.
        ENDTRY.
        enter_object( value-object_ref ).
        IF lo_object->is_array( ) = abap_true.
          result-text = '['.
          DATA(ls_length) = lo_object->get( 'length' ).
          DATA lv_index TYPE int8.
          WHILE lv_index < ls_length-int_value.
            IF lv_index > 0.
              result-text = result-text && ','.
            ENDIF.
            DATA(ls_item) = serialize( lo_object->get_element( lv_index ) ).
            IF ls_item-supported = abap_true.
              result-text = result-text && ls_item-text.
            ELSE.
              result-text = result-text && 'null'.
            ENDIF.
            lv_index = lv_index + 1.
          ENDWHILE.
          result-text = result-text && ']'.
        ELSE.
          result-text = '{'.
          DATA(lt_names) = lo_object->own_keys( ).
          DATA lv_first TYPE abap_bool VALUE abap_true.
          LOOP AT lt_names INTO DATA(lv_name).
            DATA(ls_property) = serialize( lo_object->get( lv_name ) ).
            IF ls_property-supported = abap_false.
              CONTINUE.
            ENDIF.
            IF lv_first = abap_false.
              result-text = result-text && ','.
            ENDIF.
            result-text = result-text && quote( lv_name ) && ':' && ls_property-text.
            lv_first = abap_false.
          ENDLOOP.
          result-text = result-text && '}'.
        ENDIF.
        leave_object( ).
      WHEN OTHERS.
        result-supported = abap_false.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
