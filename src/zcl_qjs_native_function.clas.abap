CLASS zcl_qjs_native_function DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_qjs_callable.
    INTERFACES zif_qjs_constructable.
    INTERFACES zif_qjs_property_container.
    CONSTANTS id_number TYPE i VALUE 1.
    CONSTANTS id_string TYPE i VALUE 2.
    CONSTANTS id_boolean TYPE i VALUE 3.
    CONSTANTS id_object TYPE i VALUE 4.
    CONSTANTS id_array TYPE i VALUE 5.
    CONSTANTS id_is_nan TYPE i VALUE 6.
    CONSTANTS id_is_finite TYPE i VALUE 7.
    CONSTANTS id_parse_int TYPE i VALUE 8.
    CONSTANTS id_parse_float TYPE i VALUE 9.
    CONSTANTS id_number_is_nan TYPE i VALUE 10.
    CONSTANTS id_number_is_finite TYPE i VALUE 11.
    CONSTANTS id_number_is_integer TYPE i VALUE 12.
    CONSTANTS id_number_is_safe_int TYPE i VALUE 13.
    CONSTANTS id_math_abs TYPE i VALUE 20.
    CONSTANTS id_math_floor TYPE i VALUE 21.
    CONSTANTS id_math_ceil TYPE i VALUE 22.
    CONSTANTS id_math_max TYPE i VALUE 23.
    CONSTANTS id_math_min TYPE i VALUE 24.
    CONSTANTS id_array_is_array TYPE i VALUE 25.
    CONSTANTS id_object_keys TYPE i VALUE 26.
    CONSTANTS id_object_define_property TYPE i VALUE 27.
    CONSTANTS id_object_get_own_descriptor TYPE i VALUE 28.
    CONSTANTS id_object_create TYPE i VALUE 29.
    CONSTANTS id_object_get_prototype TYPE i VALUE 30.
    CONSTANTS id_object_set_prototype TYPE i VALUE 31.
    CONSTANTS id_object_define_properties TYPE i VALUE 32.
    CONSTANTS id_object_get_own_names TYPE i VALUE 33.
    CONSTANTS id_json_parse TYPE i VALUE 34.
    CONSTANTS id_json_stringify TYPE i VALUE 35.
    CONSTANTS id_error TYPE i VALUE 40.
    CONSTANTS id_type_error TYPE i VALUE 41.
    CONSTANTS id_range_error TYPE i VALUE 42.
    CONSTANTS id_syntax_error TYPE i VALUE 43.
    CONSTANTS id_reference_error TYPE i VALUE 44.
    CONSTANTS id_error_to_string TYPE i VALUE 45.
    CONSTANTS id_symbol TYPE i VALUE 46.
    CONSTANTS id_symbol_for TYPE i VALUE 47.
    CONSTANTS id_symbol_key_for TYPE i VALUE 48.
    CONSTANTS id_math_trunc TYPE i VALUE 49.
    CONSTANTS id_math_round TYPE i VALUE 50.
    CONSTANTS id_math_sign TYPE i VALUE 51.
    CONSTANTS id_math_sqrt TYPE i VALUE 52.
    CONSTANTS id_object_assign TYPE i VALUE 53.
    CONSTANTS id_object_values TYPE i VALUE 54.
    CONSTANTS id_object_entries TYPE i VALUE 55.
    CONSTANTS id_object_has_own TYPE i VALUE 56.
    CONSTANTS id_object_is TYPE i VALUE 57.
    CONSTANTS id_math_exp TYPE i VALUE 58.
    CONSTANTS id_math_log TYPE i VALUE 59.
    CONSTANTS id_math_log10 TYPE i VALUE 60.
    CONSTANTS id_math_log2 TYPE i VALUE 61.
    CONSTANTS id_math_sin TYPE i VALUE 62.
    CONSTANTS id_math_cos TYPE i VALUE 63.
    CONSTANTS id_math_tan TYPE i VALUE 64.
    CONSTANTS id_math_pow TYPE i VALUE 65.
    CONSTANTS id_math_cbrt TYPE i VALUE 66.
    CONSTANTS id_math_expm1 TYPE i VALUE 67.
    CONSTANTS id_math_log1p TYPE i VALUE 68.
    CONSTANTS id_math_atan TYPE i VALUE 69.
    CONSTANTS id_math_asin TYPE i VALUE 70.
    CONSTANTS id_math_acos TYPE i VALUE 71.
    CONSTANTS id_math_atan2 TYPE i VALUE 72.
    CONSTANTS id_math_sinh TYPE i VALUE 73.
    CONSTANTS id_math_cosh TYPE i VALUE 74.
    CONSTANTS id_math_tanh TYPE i VALUE 75.
    CONSTANTS id_math_asinh TYPE i VALUE 76.
    CONSTANTS id_math_acosh TYPE i VALUE 77.
    CONSTANTS id_math_atanh TYPE i VALUE 78.
    CONSTANTS id_math_clz32 TYPE i VALUE 79.
    CONSTANTS id_math_imul TYPE i VALUE 80.
    CONSTANTS id_math_hypot TYPE i VALUE 81.
    CONSTANTS id_math_fround TYPE i VALUE 82.
    CONSTANTS id_math_f16round TYPE i VALUE 83.
    CONSTANTS id_math_random TYPE i VALUE 84.
    CONSTANTS id_uri_error TYPE i VALUE 85.
    CONSTANTS id_encode_uri TYPE i VALUE 86.
    CONSTANTS id_encode_uri_component TYPE i VALUE 87.
    CONSTANTS id_decode_uri TYPE i VALUE 88.
    CONSTANTS id_decode_uri_component TYPE i VALUE 89.
    CONSTANTS id_function TYPE i VALUE 90.
    CONSTANTS id_function_call TYPE i VALUE 91.
    CONSTANTS id_function_apply TYPE i VALUE 92.
    CONSTANTS id_function_bind TYPE i VALUE 93.
    CONSTANTS id_bound_function TYPE i VALUE 94.
    CONSTANTS id_object_get_own_symbols TYPE i VALUE 95.
    CONSTANTS id_array_push TYPE i VALUE 96.
    CONSTANTS id_array_pop TYPE i VALUE 97.
    CONSTANTS id_array_join TYPE i VALUE 98.
    CONSTANTS id_array_index_of TYPE i VALUE 99.
    CONSTANTS id_array_includes TYPE i VALUE 100.
    CONSTANTS id_array_shift TYPE i VALUE 101.
    CONSTANTS id_array_unshift TYPE i VALUE 102.
    CONSTANTS id_array_reverse TYPE i VALUE 103.
    CONSTANTS id_array_last_index_of TYPE i VALUE 104.
    CONSTANTS id_array_at TYPE i VALUE 105.
    CONSTANTS id_array_slice TYPE i VALUE 106.
    CONSTANTS id_object_to_string TYPE i VALUE 107.
    CONSTANTS id_array_for_each TYPE i VALUE 108.
    CONSTANTS id_array_map TYPE i VALUE 109.
    CONSTANTS id_array_filter TYPE i VALUE 110.
    CONSTANTS id_array_some TYPE i VALUE 111.
    CONSTANTS id_array_every TYPE i VALUE 112.
    CONSTANTS id_array_find TYPE i VALUE 113.
    CONSTANTS id_array_find_index TYPE i VALUE 114.
    CONSTANTS id_array_reduce TYPE i VALUE 115.
    CONSTANTS id_array_reduce_right TYPE i VALUE 116.
    CONSTANTS id_array_fill TYPE i VALUE 117.
    CONSTANTS id_array_copy_within TYPE i VALUE 118.
    METHODS constructor IMPORTING id TYPE i runtime TYPE REF TO zcl_qjs_runtime
      context TYPE REF TO zcl_qjs_context OPTIONAL
      bound_target TYPE zcl_qjs_value=>ty_value OPTIONAL
      bound_this TYPE zcl_qjs_value=>ty_value OPTIONAL
      bound_arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL.
    METHODS get_property
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value.
    METHODS set_property IMPORTING name TYPE string value TYPE zcl_qjs_value=>ty_value.
    METHODS delete_property
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_property,
      name TYPE string,
      value TYPE zcl_qjs_value=>ty_value,
    END OF ty_property.
    TYPES ty_properties TYPE HASHED TABLE OF ty_property WITH UNIQUE KEY name.
    TYPES: BEGIN OF ty_symbol_property,
      identity TYPE int8,
      value TYPE zcl_qjs_value=>ty_value,
    END OF ty_symbol_property.
    TYPES ty_symbol_properties TYPE HASHED TABLE OF ty_symbol_property
      WITH UNIQUE KEY identity.
    DATA mv_id TYPE i.
    DATA mo_runtime TYPE REF TO zcl_qjs_runtime.
    DATA mo_context TYPE REF TO zcl_qjs_context.
    DATA mo_random TYPE REF TO cl_abap_random_int.
    DATA mt_properties TYPE ty_properties.
    DATA mt_symbol_properties TYPE ty_symbol_properties.
    DATA ms_bound_target TYPE zcl_qjs_value=>ty_value.
    DATA ms_bound_this TYPE zcl_qjs_value=>ty_value.
    DATA mt_bound_arguments TYPE zif_qjs_callable=>ty_arguments.
    METHODS is_callable
      IMPORTING value TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS get_callable_property
      IMPORTING value TYPE zcl_qjs_value=>ty_value name TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS array_to_length
      IMPORTING value TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE int8
      RAISING zcx_qjs_error.
    METHODS array_length_value
      IMPORTING length TYPE int8
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value.
    METHODS array_set_length
      IMPORTING object TYPE REF TO zcl_qjs_object length TYPE int8
      RAISING zcx_qjs_error.
    METHODS array_slice_index
      IMPORTING value TYPE zcl_qjs_value=>ty_value length TYPE int8
      RETURNING VALUE(result) TYPE int8
      RAISING zcx_qjs_error.
    METHODS same_value_zero
      IMPORTING left TYPE zcl_qjs_value=>ty_value right TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS math_exp_f
      IMPORTING value TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_log_f
      IMPORTING value TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_log10_f
      IMPORTING value TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_reduce_angle
      IMPORTING value TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_sin_f
      IMPORTING value TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_cos_f
      IMPORTING value TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_pow_value
      IMPORTING base TYPE zcl_qjs_value=>ty_value
        exponent TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS math_cbrt_f
      IMPORTING value TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_expm1_f
      IMPORTING value TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_log1p_f
      IMPORTING value TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_atan_f
      IMPORTING value TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_atan2_value
      IMPORTING y TYPE zcl_qjs_value=>ty_value x TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS math_sinh_f
      IMPORTING value TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_cosh_f
      IMPORTING value TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_tanh_f
      IMPORTING value TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_asinh_f
      IMPORTING value TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_acosh_f
      IMPORTING value TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_atanh_f
      IMPORTING value TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_round_binary_f
      IMPORTING value TYPE f fraction_bits TYPE i min_exponent TYPE i
      RETURNING VALUE(result) TYPE f.
    METHODS uri_hex_value
      IMPORTING character TYPE string
      RETURNING VALUE(result) TYPE i.
    METHODS uri_percent_byte
      IMPORTING byte TYPE i
      RETURNING VALUE(result) TYPE string.
    METHODS uri_code_unit
      IMPORTING character TYPE string
      RETURNING VALUE(result) TYPE i
      RAISING zcx_qjs_error.
    METHODS uri_code_point
      IMPORTING code TYPE i
      RETURNING VALUE(result) TYPE string
      RAISING zcx_qjs_error.
    METHODS uri_is_reserved
      IMPORTING character TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS uri_encode
      IMPORTING value TYPE string component TYPE abap_bool
      RETURNING VALUE(result) TYPE string
      RAISING zcx_qjs_error.
    METHODS uri_decode
      IMPORTING value TYPE string component TYPE abap_bool
      RETURNING VALUE(result) TYPE string
      RAISING zcx_qjs_error.
ENDCLASS.

CLASS zcl_qjs_native_function IMPLEMENTATION.
  METHOD array_to_length.
    DATA(ls_number) = zcl_qjs_number=>to_number( value ).
    DATA lv_max_safe TYPE int8.
    DATA lv_max_safe_f TYPE f.
    lv_max_safe = '9007199254740991'.
    lv_max_safe_f = '9007199254740991'.
    IF ls_number-tag = zcl_qjs_value=>tag_int.
      IF ls_number-int_value > 0.
        result = ls_number-int_value.
      ENDIF.
    ELSEIF ls_number-tag = zcl_qjs_value=>tag_number.
      IF ls_number-number_kind = zcl_qjs_value=>number_pos_inf.
        result = lv_max_safe.
      ELSEIF ls_number-number_kind = zcl_qjs_value=>number_finite
          AND ls_number-float_value > 0.
        IF ls_number-float_value >= lv_max_safe_f.
          result = lv_max_safe.
        ELSE.
          result = trunc( ls_number-float_value ).
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD array_length_value.
    IF length <= 2147483647.
      result = zcl_qjs_value=>new_int( CONV i( length ) ).
    ELSE.
      result = zcl_qjs_value=>new_finite( CONV f( length ) ).
    ENDIF.
  ENDMETHOD.

  METHOD array_set_length.
    IF object->is_array( ) = abap_true.
      object->set_array_length( length ).
    ELSE.
      object->set( name = 'length' value = array_length_value( length ) ).
    ENDIF.
  ENDMETHOD.

  METHOD array_slice_index.
    DATA(ls_number) = zcl_qjs_number=>to_number( value ).
    DATA(lv_relative) = CONV int8( 0 ).
    DATA(lv_positive_overflow) = abap_false.
    DATA(lv_negative_overflow) = abap_false.
    DATA lv_max_safe_f TYPE f.
    lv_max_safe_f = '9007199254740991'.
    IF ls_number-tag = zcl_qjs_value=>tag_int.
      lv_relative = ls_number-int_value.
    ELSEIF ls_number-tag = zcl_qjs_value=>tag_number
        AND ls_number-number_kind = zcl_qjs_value=>number_finite.
      IF ls_number-float_value >= lv_max_safe_f.
        lv_positive_overflow = abap_true.
      ELSEIF ls_number-float_value <= 0 - lv_max_safe_f.
        lv_negative_overflow = abap_true.
      ELSE.
        lv_relative = trunc( ls_number-float_value ).
      ENDIF.
    ELSEIF ls_number-tag = zcl_qjs_value=>tag_number
        AND ls_number-number_kind = zcl_qjs_value=>number_pos_inf.
      lv_positive_overflow = abap_true.
    ELSEIF ls_number-tag = zcl_qjs_value=>tag_number
        AND ls_number-number_kind = zcl_qjs_value=>number_neg_inf.
      lv_negative_overflow = abap_true.
    ENDIF.
    IF lv_positive_overflow = abap_true OR lv_relative >= length.
      result = length.
    ELSEIF lv_negative_overflow = abap_true OR lv_relative <= 0 - length.
      result = 0.
    ELSEIF lv_relative < 0.
      result = length + lv_relative.
    ELSE.
      result = lv_relative.
    ENDIF.
  ENDMETHOD.

  METHOD same_value_zero.
    result = zcl_qjs_value=>strict_equal( left = left right = right ).
    IF result = abap_false
        AND left-tag = zcl_qjs_value=>tag_number
        AND right-tag = zcl_qjs_value=>tag_number
        AND left-number_kind = zcl_qjs_value=>number_nan
        AND right-number_kind = zcl_qjs_value=>number_nan.
      result = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD constructor.
    mv_id = id.
    mo_runtime = runtime.
    mo_context = context.
    ms_bound_target = bound_target.
    ms_bound_this = bound_this.
    mt_bound_arguments = bound_arguments.
    IF mv_id = id_math_random.
      TRY.
          mo_random = cl_abap_random_int=>create( min = 0 max = 2147483646 ).
        CATCH cx_abap_random.
          CLEAR mo_random.
      ENDTRY.
    ENDIF.
  ENDMETHOD.

  METHOD get_property.
    DATA ls_property TYPE ty_property.
    READ TABLE mt_properties WITH TABLE KEY name = name INTO ls_property.
    IF sy-subrc = 0.
      result = ls_property-value.
    ELSE.
      DATA(lo_function_prototype) = mo_runtime->get_function_prototype( ).
      IF lo_function_prototype IS BOUND.
        DATA(ls_prototype_property) = lo_function_prototype->get_own_property( name ).
        IF ls_prototype_property-found = abap_true.
          result = ls_prototype_property-value.
        ELSE.
          result = zcl_qjs_value=>new_undefined( ).
        ENDIF.
      ELSE.
        result = zcl_qjs_value=>new_undefined( ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD set_property.
    DATA ls_property TYPE ty_property.
    ls_property-name = name.
    ls_property-value = value.
    DELETE TABLE mt_properties WITH TABLE KEY name = name.
    INSERT ls_property INTO TABLE mt_properties.
  ENDMETHOD.

  METHOD delete_property.
    DELETE TABLE mt_properties WITH TABLE KEY name = name.
    result = abap_true.
  ENDMETHOD.

  METHOD is_callable.
    DATA lo_closure TYPE REF TO zcl_qjs_closure.
    DATA lo_callable TYPE REF TO zif_qjs_callable.
    result = abap_false.
    IF value-tag <> zcl_qjs_value=>tag_object.
      RETURN.
    ENDIF.
    TRY.
        lo_closure ?= value-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    TRY.
        lo_callable ?= value-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_closure IS BOUND OR lo_callable IS BOUND.
      result = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD get_callable_property.
    DATA lo_closure TYPE REF TO zcl_qjs_closure.
    DATA lo_properties TYPE REF TO zif_qjs_property_container.
    IF value-tag <> zcl_qjs_value=>tag_object.
      result = zcl_qjs_value=>new_undefined( ).
      RETURN.
    ENDIF.
    TRY.
        lo_closure ?= value-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_closure IS BOUND.
      result = lo_closure->get_property( name ).
      RETURN.
    ENDIF.
    lo_properties = value-property_ref.
    IF lo_properties IS NOT BOUND.
      TRY.
          lo_properties ?= value-object_ref.
        CATCH cx_sy_move_cast_error.
      ENDTRY.
    ENDIF.
    IF lo_properties IS BOUND.
      result = lo_properties->get_property( name ).
    ELSE.
      result = zcl_qjs_value=>new_undefined( ).
    ENDIF.
  ENDMETHOD.

  METHOD math_exp_f.
    DATA lv_ln2 TYPE f.
    DATA lv_reduced TYPE f.
    DATA lv_term TYPE f.
    DATA lv_sum TYPE f.
    DATA lv_scale TYPE i.
    DATA lv_steps TYPE i.
    lv_ln2 = '0.6931471805599453'.
    lv_scale = floor( value / lv_ln2 + CONV f( '0.5' ) ).
    lv_reduced = value - lv_scale * lv_ln2.
    lv_term = 1.
    lv_sum = 1.
    DO 24 TIMES.
      lv_term = lv_term * lv_reduced / sy-index.
      lv_sum = lv_sum + lv_term.
    ENDDO.
    lv_steps = abs( lv_scale ).
    DO lv_steps TIMES.
      IF lv_scale > 0.
        lv_sum = lv_sum * 2.
      ELSE.
        lv_sum = lv_sum / 2.
      ENDIF.
    ENDDO.
    result = lv_sum.
  ENDMETHOD.

  METHOD math_log_f.
    DATA lv_ln2 TYPE f.
    DATA lv_sqrt_half TYPE f.
    DATA lv_sqrt_two TYPE f.
    DATA lv_reduced TYPE f.
    DATA lv_ratio TYPE f.
    DATA lv_ratio_square TYPE f.
    DATA lv_term TYPE f.
    DATA lv_sum TYPE f.
    DATA lv_denominator TYPE i.
    DATA lv_scale TYPE i.
    lv_ln2 = '0.6931471805599453'.
    lv_sqrt_half = '0.7071067811865476'.
    lv_sqrt_two = '1.4142135623730951'.
    lv_reduced = value.
    WHILE lv_reduced > lv_sqrt_two.
      lv_reduced = lv_reduced / 2.
      lv_scale = lv_scale + 1.
    ENDWHILE.
    WHILE lv_reduced < lv_sqrt_half.
      lv_reduced = lv_reduced * 2.
      lv_scale = lv_scale - 1.
    ENDWHILE.
    lv_ratio = ( lv_reduced - 1 ) / ( lv_reduced + 1 ).
    lv_ratio_square = lv_ratio * lv_ratio.
    lv_term = lv_ratio.
    lv_sum = lv_ratio.
    lv_denominator = 3.
    DO 24 TIMES.
      lv_term = lv_term * lv_ratio_square.
      lv_sum = lv_sum + lv_term / lv_denominator.
      lv_denominator = lv_denominator + 2.
    ENDDO.
    result = 2 * lv_sum + lv_scale * lv_ln2.
  ENDMETHOD.

  METHOD math_log10_f.
    DATA lv_reduced TYPE f.
    DATA lv_power TYPE i.
    lv_reduced = value.
    IF lv_reduced >= 1.
      WHILE lv_reduced >= 10.
        lv_reduced = lv_reduced / 10.
        lv_power = lv_power + 1.
      ENDWHILE.
    ELSE.
      WHILE lv_reduced < 1 AND lv_power > -324.
        lv_reduced = lv_reduced * 10.
        lv_power = lv_power - 1.
      ENDWHILE.
    ENDIF.
    IF lv_reduced = 1.
      result = lv_power.
    ELSE.
      result = math_log_f( value ) / CONV f( '2.302585092994046' ).
    ENDIF.
  ENDMETHOD.

  METHOD math_reduce_angle.
    DATA lv_pi TYPE f.
    DATA lv_two_pi TYPE f.
    lv_pi = '3.141592653589793'.
    lv_two_pi = '6.283185307179586'.
    result = value - trunc( value / lv_two_pi ) * lv_two_pi.
    IF result > lv_pi.
      result = result - lv_two_pi.
    ELSEIF result < 0 - lv_pi.
      result = result + lv_two_pi.
    ENDIF.
  ENDMETHOD.

  METHOD math_sin_f.
    DATA lv_pi TYPE f.
    DATA lv_half_pi TYPE f.
    DATA lv_reduced TYPE f.
    DATA lv_square TYPE f.
    DATA lv_term TYPE f.
    DATA lv_sum TYPE f.
    DATA lv_left_factor TYPE i.
    DATA lv_right_factor TYPE i.
    lv_pi = '3.141592653589793'.
    lv_half_pi = '1.5707963267948966'.
    lv_reduced = math_reduce_angle( value ).
    IF lv_reduced > lv_half_pi.
      lv_reduced = lv_pi - lv_reduced.
    ELSEIF lv_reduced < 0 - lv_half_pi.
      lv_reduced = 0 - lv_pi - lv_reduced.
    ENDIF.
    lv_square = lv_reduced * lv_reduced.
    lv_term = lv_reduced.
    lv_sum = lv_reduced.
    DO 12 TIMES.
      lv_left_factor = 2 * sy-index.
      lv_right_factor = lv_left_factor + 1.
      lv_term = ( 0 - lv_term ) * lv_square
        / ( lv_left_factor * lv_right_factor ).
      lv_sum = lv_sum + lv_term.
    ENDDO.
    result = lv_sum.
  ENDMETHOD.

  METHOD math_cos_f.
    DATA lv_pi TYPE f.
    DATA lv_half_pi TYPE f.
    DATA lv_reduced TYPE f.
    DATA lv_square TYPE f.
    DATA lv_term TYPE f.
    DATA lv_sum TYPE f.
    DATA lv_sign TYPE i VALUE 1.
    DATA lv_left_factor TYPE i.
    DATA lv_right_factor TYPE i.
    lv_pi = '3.141592653589793'.
    lv_half_pi = '1.5707963267948966'.
    lv_reduced = math_reduce_angle( value ).
    IF lv_reduced > lv_half_pi.
      lv_reduced = lv_pi - lv_reduced.
      lv_sign = -1.
    ELSEIF lv_reduced < 0 - lv_half_pi.
      lv_reduced = 0 - lv_pi - lv_reduced.
      lv_sign = -1.
    ENDIF.
    lv_square = lv_reduced * lv_reduced.
    lv_term = 1.
    lv_sum = 1.
    DO 12 TIMES.
      lv_left_factor = 2 * sy-index - 1.
      lv_right_factor = lv_left_factor + 1.
      lv_term = ( 0 - lv_term ) * lv_square
        / ( lv_left_factor * lv_right_factor ).
      lv_sum = lv_sum + lv_term.
    ENDDO.
    result = lv_sign * lv_sum.
  ENDMETHOD.

  METHOD math_pow_value.
    DATA(ls_base) = zcl_qjs_number=>to_number( base ).
    DATA(ls_exponent) = zcl_qjs_number=>to_number( exponent ).
    DATA lv_base_abs TYPE f.
    DATA lv_exponent_value TYPE f.
    DATA lv_exponent_integer TYPE abap_bool.
    DATA lv_exponent_odd TYPE abap_bool.
    DATA lv_negative_result TYPE abap_bool.
    DATA lv_exponent_inf TYPE abap_bool.
    DATA lv_base_inf TYPE abap_bool.
    DATA lv_base_zero TYPE abap_bool.
    DATA lv_magnitude TYPE f.
    DATA lv_accumulator TYPE f.
    DATA lv_factor TYPE f.
    DATA lv_remaining TYPE int8.
    DATA lv_max_finite TYPE f.
    DATA lv_exp_input TYPE f.
    DATA lv_exp_underflow TYPE f.
    DATA lv_exp_overflow TYPE f.
    DATA lv_pow_overflow TYPE abap_bool.
    lv_max_finite = '1.7976931348623157e308'.
    lv_exp_underflow = '-745.1332191019411'.
    lv_exp_overflow = '709.782712893384'.

    IF ls_exponent-number_kind = zcl_qjs_value=>number_nan.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    IF ls_exponent-number_kind = zcl_qjs_value=>number_neg_zero
        OR ( ls_exponent-number_kind = zcl_qjs_value=>number_finite
          AND ls_exponent-float_value = 0 ).
      result = zcl_qjs_value=>new_finite( 1 ).
      RETURN.
    ENDIF.
    IF ls_base-number_kind = zcl_qjs_value=>number_nan.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.

    IF ls_base-number_kind = zcl_qjs_value=>number_pos_inf
        OR ls_base-number_kind = zcl_qjs_value=>number_neg_inf.
      lv_base_inf = abap_true.
      lv_base_abs = lv_max_finite.
    ELSEIF ls_base-number_kind = zcl_qjs_value=>number_neg_zero
        OR ls_base-float_value = 0.
      lv_base_zero = abap_true.
    ELSE.
      lv_base_abs = abs( ls_base-float_value ).
    ENDIF.
    IF ls_exponent-number_kind = zcl_qjs_value=>number_pos_inf
        OR ls_exponent-number_kind = zcl_qjs_value=>number_neg_inf.
      lv_exponent_inf = abap_true.
    ELSE.
      lv_exponent_value = ls_exponent-float_value.
      IF trunc( lv_exponent_value ) = lv_exponent_value.
        lv_exponent_integer = abap_true.
        IF lv_exponent_value - 2 * trunc( lv_exponent_value / 2 ) <> 0.
          lv_exponent_odd = abap_true.
        ENDIF.
      ENDIF.
    ENDIF.
    IF ( ls_base-number_kind = zcl_qjs_value=>number_neg_inf
          OR ls_base-number_kind = zcl_qjs_value=>number_neg_zero
          OR ( ls_base-number_kind = zcl_qjs_value=>number_finite
            AND ls_base-float_value < 0 ) )
        AND lv_exponent_odd = abap_true.
      lv_negative_result = abap_true.
    ENDIF.

    IF lv_exponent_inf = abap_true.
      IF lv_base_inf = abap_false AND lv_base_zero = abap_false
          AND lv_base_abs = 1.
        result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      ELSEIF ( ls_exponent-number_kind = zcl_qjs_value=>number_pos_inf
            AND ( lv_base_inf = abap_true OR lv_base_abs > 1 ) )
          OR ( ls_exponent-number_kind = zcl_qjs_value=>number_neg_inf
            AND ( lv_base_zero = abap_true OR lv_base_abs < 1 ) ).
        result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
      ELSE.
        result = zcl_qjs_value=>new_finite( 0 ).
      ENDIF.
      RETURN.
    ENDIF.

    IF lv_base_inf = abap_true OR lv_base_zero = abap_true.
      IF lv_exponent_value > 0.
        IF lv_base_inf = abap_true.
          IF lv_negative_result = abap_true.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_inf ).
          ELSE.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
          ENDIF.
        ELSEIF lv_negative_result = abap_true.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_zero ).
        ELSE.
          result = zcl_qjs_value=>new_finite( 0 ).
        ENDIF.
      ELSEIF lv_base_inf = abap_true.
        IF lv_negative_result = abap_true.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_zero ).
        ELSE.
          result = zcl_qjs_value=>new_finite( 0 ).
        ENDIF.
      ELSEIF lv_negative_result = abap_true.
        result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_inf ).
      ELSE.
        result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
      ENDIF.
      RETURN.
    ENDIF.

    IF ls_base-float_value < 0 AND lv_exponent_integer = abap_false.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.

    IF lv_exponent_integer = abap_true
        AND abs( lv_exponent_value ) <= 2147483647.
      lv_remaining = abs( trunc( lv_exponent_value ) ).
      lv_accumulator = 1.
      lv_factor = lv_base_abs.
      WHILE lv_remaining > 0.
        IF lv_remaining MOD 2 = 1.
          IF lv_factor <> 0 AND lv_accumulator > lv_max_finite / lv_factor.
            lv_pow_overflow = abap_true.
            CLEAR lv_accumulator.
            EXIT.
          ENDIF.
          lv_accumulator = lv_accumulator * lv_factor.
        ENDIF.
        lv_remaining = floor( CONV f( lv_remaining ) / 2 ).
        IF lv_remaining > 0.
          IF lv_factor <> 0 AND lv_factor > lv_max_finite / lv_factor.
            lv_pow_overflow = abap_true.
            CLEAR lv_accumulator.
            EXIT.
          ENDIF.
          lv_factor = lv_factor * lv_factor.
        ENDIF.
      ENDWHILE.
      IF lv_pow_overflow = abap_true.
        IF lv_exponent_value < 0.
          result = zcl_qjs_value=>new_finite( 0 ).
        ELSE.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
        ENDIF.
      ELSEIF lv_accumulator = 0.
        IF lv_exponent_value < 0.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
        ELSE.
          lv_magnitude = 0.
        ENDIF.
      ELSE.
        IF lv_exponent_value < 0.
          IF lv_accumulator < 1 / lv_max_finite.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
          ELSE.
            lv_accumulator = 1 / lv_accumulator.
          ENDIF.
        ENDIF.
        IF result-tag = 0.
          lv_magnitude = lv_accumulator.
        ENDIF.
      ENDIF.
    ELSE.
      lv_exp_input = lv_exponent_value * math_log_f( lv_base_abs ).
      IF lv_exp_input > lv_exp_overflow.
        result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
      ELSEIF lv_exp_input < lv_exp_underflow.
        result = zcl_qjs_value=>new_finite( 0 ).
      ELSE.
        lv_magnitude = math_exp_f( lv_exp_input ).
      ENDIF.
    ENDIF.
    IF result-tag <> 0.
      IF lv_negative_result = abap_true.
        IF result-number_kind = zcl_qjs_value=>number_pos_inf.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_inf ).
        ELSEIF result-number_kind = zcl_qjs_value=>number_finite
            AND result-float_value = 0.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_zero ).
        ENDIF.
      ENDIF.
      RETURN.
    ENDIF.
    IF lv_negative_result = abap_true.
      lv_magnitude = 0 - lv_magnitude.
    ENDIF.
    result = zcl_qjs_value=>new_finite( lv_magnitude ).
  ENDMETHOD.

  METHOD math_cbrt_f.
    DATA lv_absolute TYPE f.
    DATA lv_guess TYPE f.
    lv_absolute = abs( value ).
    lv_guess = math_exp_f( math_log_f( lv_absolute ) / 3 ).
    DO 8 TIMES.
      lv_guess = ( 2 * lv_guess + lv_absolute / ( lv_guess * lv_guess ) ) / 3.
    ENDDO.
    IF value < 0.
      result = 0 - lv_guess.
    ELSE.
      result = lv_guess.
    ENDIF.
  ENDMETHOD.

  METHOD math_expm1_f.
    DATA lv_term TYPE f.
    DATA lv_sum TYPE f.
    DATA lv_denominator TYPE i.
    IF abs( value ) < CONV f( '0.5' ).
      lv_term = value.
      lv_sum = value.
      lv_denominator = 2.
      DO 30 TIMES.
        lv_term = lv_term * value / lv_denominator.
        lv_sum = lv_sum + lv_term.
        lv_denominator = lv_denominator + 1.
      ENDDO.
      result = lv_sum.
    ELSE.
      result = math_exp_f( value ) - 1.
    ENDIF.
  ENDMETHOD.

  METHOD math_log1p_f.
    DATA lv_term TYPE f.
    DATA lv_sum TYPE f.
    DATA lv_denominator TYPE i.
    lv_term = value.
    lv_sum = value.
    lv_denominator = 2.
    DO 40 TIMES.
      lv_term = lv_term * value.
      IF lv_denominator MOD 2 = 0.
        lv_sum = lv_sum - lv_term / lv_denominator.
      ELSE.
        lv_sum = lv_sum + lv_term / lv_denominator.
      ENDIF.
      lv_denominator = lv_denominator + 1.
    ENDDO.
    result = lv_sum.
  ENDMETHOD.

  METHOD math_atan_f.
    DATA lv_absolute TYPE f.
    DATA lv_reduced TYPE f.
    DATA lv_square TYPE f.
    DATA lv_term TYPE f.
    DATA lv_sum TYPE f.
    DATA lv_denominator TYPE i.
    DATA lv_pi_quarter TYPE f.
    DATA lv_pi_half TYPE f.
    DATA lv_boundary TYPE f.
    DATA lv_reciprocal TYPE abap_bool.
    DATA lv_shifted TYPE abap_bool.
    lv_pi_quarter = '0.7853981633974483'.
    lv_pi_half = '1.5707963267948966'.
    lv_boundary = '0.4142135623730951'.
    lv_absolute = abs( value ).
    IF lv_absolute > 1.
      lv_reduced = 1 / lv_absolute.
      lv_reciprocal = abap_true.
    ELSEIF lv_absolute > lv_boundary.
      lv_reduced = ( lv_absolute - 1 ) / ( lv_absolute + 1 ).
      lv_shifted = abap_true.
    ELSE.
      lv_reduced = lv_absolute.
    ENDIF.
    lv_square = lv_reduced * lv_reduced.
    lv_term = lv_reduced.
    lv_sum = lv_reduced.
    lv_denominator = 3.
    DO 32 TIMES.
      lv_term = 0 - lv_term * lv_square.
      lv_sum = lv_sum + lv_term / lv_denominator.
      lv_denominator = lv_denominator + 2.
    ENDDO.
    IF lv_reciprocal = abap_true.
      lv_sum = lv_pi_half - lv_sum.
    ELSEIF lv_shifted = abap_true.
      lv_sum = lv_pi_quarter + lv_sum.
    ENDIF.
    IF value < 0.
      result = 0 - lv_sum.
    ELSE.
      result = lv_sum.
    ENDIF.
  ENDMETHOD.

  METHOD math_atan2_value.
    DATA(ls_y) = zcl_qjs_number=>to_number( y ).
    DATA(ls_x) = zcl_qjs_number=>to_number( x ).
    DATA lv_y_negative TYPE abap_bool.
    DATA lv_x_negative TYPE abap_bool.
    DATA lv_y_zero TYPE abap_bool.
    DATA lv_x_zero TYPE abap_bool.
    DATA lv_y_infinite TYPE abap_bool.
    DATA lv_x_infinite TYPE abap_bool.
    DATA lv_angle TYPE f.
    DATA lv_pi TYPE f.
    DATA lv_pi_half TYPE f.
    DATA lv_pi_quarter TYPE f.
    DATA lv_three_quarters TYPE f.
    lv_pi = '3.141592653589793'.
    lv_pi_half = '1.5707963267948966'.
    lv_pi_quarter = '0.7853981633974483'.
    lv_three_quarters = '2.356194490192345'.
    IF ls_y-number_kind = zcl_qjs_value=>number_nan
        OR ls_x-number_kind = zcl_qjs_value=>number_nan.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    IF ls_y-number_kind = zcl_qjs_value=>number_neg_inf
        OR ls_y-number_kind = zcl_qjs_value=>number_neg_zero
        OR ( ls_y-number_kind = zcl_qjs_value=>number_finite
          AND ls_y-float_value < 0 ).
      lv_y_negative = abap_true.
    ENDIF.
    IF ls_x-number_kind = zcl_qjs_value=>number_neg_inf
        OR ls_x-number_kind = zcl_qjs_value=>number_neg_zero
        OR ( ls_x-number_kind = zcl_qjs_value=>number_finite
          AND ls_x-float_value < 0 ).
      lv_x_negative = abap_true.
    ENDIF.
    IF ls_y-number_kind = zcl_qjs_value=>number_neg_zero
        OR ( ls_y-number_kind = zcl_qjs_value=>number_finite
          AND ls_y-float_value = 0 ).
      lv_y_zero = abap_true.
    ENDIF.
    IF ls_x-number_kind = zcl_qjs_value=>number_neg_zero
        OR ( ls_x-number_kind = zcl_qjs_value=>number_finite
          AND ls_x-float_value = 0 ).
      lv_x_zero = abap_true.
    ENDIF.
    IF ls_y-number_kind = zcl_qjs_value=>number_pos_inf
        OR ls_y-number_kind = zcl_qjs_value=>number_neg_inf.
      lv_y_infinite = abap_true.
    ENDIF.
    IF ls_x-number_kind = zcl_qjs_value=>number_pos_inf
        OR ls_x-number_kind = zcl_qjs_value=>number_neg_inf.
      lv_x_infinite = abap_true.
    ENDIF.
    IF lv_y_infinite = abap_true AND lv_x_infinite = abap_true.
      IF lv_x_negative = abap_true.
        lv_angle = lv_three_quarters.
      ELSE.
        lv_angle = lv_pi_quarter.
      ENDIF.
    ELSEIF lv_y_infinite = abap_true.
      lv_angle = lv_pi_half.
    ELSEIF lv_y_zero = abap_true.
      IF lv_x_negative = abap_true.
        lv_angle = lv_pi.
      ELSE.
        result = ls_y.
        RETURN.
      ENDIF.
    ELSEIF lv_x_infinite = abap_true.
      IF lv_x_negative = abap_true.
        lv_angle = lv_pi.
      ELSEIF lv_y_negative = abap_true.
        result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_zero ).
        RETURN.
      ELSE.
        result = zcl_qjs_value=>new_finite( 0 ).
        RETURN.
      ENDIF.
    ELSEIF lv_x_zero = abap_true.
      lv_angle = lv_pi_half.
    ELSE.
      lv_angle = math_atan_f( abs( ls_y-float_value / ls_x-float_value ) ).
      IF lv_x_negative = abap_true.
        lv_angle = lv_pi - lv_angle.
      ENDIF.
    ENDIF.
    IF lv_y_negative = abap_true.
      lv_angle = 0 - lv_angle.
    ENDIF.
    result = zcl_qjs_value=>new_finite( lv_angle ).
  ENDMETHOD.

  METHOD math_sinh_f.
    DATA lv_absolute TYPE f.
    DATA lv_term TYPE f.
    DATA lv_sum TYPE f.
    DATA lv_square TYPE f.
    DATA lv_left_factor TYPE i.
    DATA lv_right_factor TYPE i.
    DATA lv_ln2 TYPE f.
    lv_absolute = abs( value ).
    IF lv_absolute < CONV f( '0.5' ).
      lv_square = value * value.
      lv_term = value.
      lv_sum = value.
      DO 18 TIMES.
        lv_left_factor = 2 * sy-index.
        lv_right_factor = lv_left_factor + 1.
        lv_term = lv_term * lv_square / ( lv_left_factor * lv_right_factor ).
        lv_sum = lv_sum + lv_term.
      ENDDO.
      result = lv_sum.
      RETURN.
    ENDIF.
    lv_ln2 = '0.6931471805599453'.
    lv_sum = math_exp_f( lv_absolute - lv_ln2 )
      - math_exp_f( 0 - lv_absolute - lv_ln2 ).
    IF value < 0.
      result = 0 - lv_sum.
    ELSE.
      result = lv_sum.
    ENDIF.
  ENDMETHOD.

  METHOD math_cosh_f.
    DATA lv_absolute TYPE f.
    DATA lv_ln2 TYPE f.
    lv_absolute = abs( value ).
    lv_ln2 = '0.6931471805599453'.
    result = math_exp_f( lv_absolute - lv_ln2 )
      + math_exp_f( 0 - lv_absolute - lv_ln2 ).
  ENDMETHOD.

  METHOD math_tanh_f.
    DATA lv_absolute TYPE f.
    DATA lv_expm1 TYPE f.
    lv_absolute = abs( value ).
    IF lv_absolute > 20.
      result = 1.
    ELSE.
      lv_expm1 = math_expm1_f( 2 * lv_absolute ).
      result = lv_expm1 / ( lv_expm1 + 2 ).
    ENDIF.
    IF value < 0.
      result = 0 - result.
    ENDIF.
  ENDMETHOD.

  METHOD math_asinh_f.
    DATA lv_absolute TYPE f.
    DATA lv_delta TYPE f.
    DATA lv_reciprocal TYPE f.
    DATA lv_value TYPE f.
    lv_absolute = abs( value ).
    IF lv_absolute > 1.
      lv_reciprocal = 1 / lv_absolute.
      lv_value = math_log_f( lv_absolute )
        + math_log_f( 1 + sqrt( 1 + lv_reciprocal * lv_reciprocal ) ).
    ELSE.
      lv_delta = lv_absolute + lv_absolute * lv_absolute
        / ( 1 + sqrt( 1 + lv_absolute * lv_absolute ) ).
      IF lv_delta < CONV f( '0.1' ).
        lv_value = math_log1p_f( lv_delta ).
      ELSE.
        lv_value = math_log_f( 1 + lv_delta ).
      ENDIF.
    ENDIF.
    IF value < 0.
      result = 0 - lv_value.
    ELSE.
      result = lv_value.
    ENDIF.
  ENDMETHOD.

  METHOD math_acosh_f.
    DATA lv_delta TYPE f.
    DATA lv_reciprocal TYPE f.
    IF value > 2.
      lv_reciprocal = 1 / value.
      result = math_log_f( value ) + math_log_f(
        1 + sqrt( 1 - lv_reciprocal ) * sqrt( 1 + lv_reciprocal ) ).
    ELSE.
      lv_delta = value - 1 + sqrt( value - 1 ) * sqrt( value + 1 ).
      IF lv_delta < CONV f( '0.1' ).
        result = math_log1p_f( lv_delta ).
      ELSE.
        result = math_log_f( 1 + lv_delta ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD math_atanh_f.
    DATA lv_absolute TYPE f.
    DATA lv_delta TYPE f.
    DATA lv_value TYPE f.
    lv_absolute = abs( value ).
    lv_delta = 2 * lv_absolute / ( 1 - lv_absolute ).
    IF lv_delta < CONV f( '0.1' ).
      lv_value = math_log1p_f( lv_delta ) / 2.
    ELSE.
      lv_value = math_log_f( 1 + lv_delta ) / 2.
    ENDIF.
    IF value < 0.
      result = 0 - lv_value.
    ELSE.
      result = lv_value.
    ENDIF.
  ENDMETHOD.

  METHOD math_round_binary_f.
    DATA lv_absolute TYPE f.
    DATA lv_normalized TYPE f.
    DATA lv_quantum TYPE f.
    DATA lv_scaled TYPE f.
    DATA lv_integer TYPE int8.
    DATA lv_integer_float TYPE f.
    DATA lv_fraction TYPE f.
    DATA lv_exponent TYPE i.
    DATA lv_quantum_exponent TYPE i.
    lv_absolute = abs( value ).
    lv_normalized = lv_absolute.
    IF lv_normalized < 1.
      WHILE lv_normalized < 1.
        lv_normalized = lv_normalized * 2.
        lv_exponent = lv_exponent - 1.
      ENDWHILE.
    ELSE.
      WHILE lv_normalized >= 2.
        lv_normalized = lv_normalized / 2.
        lv_exponent = lv_exponent + 1.
      ENDWHILE.
    ENDIF.
    IF lv_exponent < min_exponent.
      lv_quantum_exponent = min_exponent - fraction_bits.
    ELSE.
      lv_quantum_exponent = lv_exponent - fraction_bits.
    ENDIF.
    lv_quantum = 1.
    IF lv_quantum_exponent < 0.
      DATA(lv_divisions) = 0 - lv_quantum_exponent.
      DO lv_divisions TIMES.
        lv_quantum = lv_quantum / 2.
      ENDDO.
    ELSE.
      DO lv_quantum_exponent TIMES.
        lv_quantum = lv_quantum * 2.
      ENDDO.
    ENDIF.
    lv_scaled = lv_absolute / lv_quantum.
    lv_integer_float = floor( lv_scaled ).
    lv_integer = lv_integer_float.
    lv_fraction = lv_scaled - lv_integer_float.
    IF lv_fraction > CONV f( '0.5' )
        OR ( lv_fraction = CONV f( '0.5' ) AND lv_integer MOD 2 = 1 ).
      lv_integer = lv_integer + 1.
    ENDIF.
    lv_integer_float = lv_integer.
    result = lv_integer_float * lv_quantum.
    IF value < 0.
      result = 0 - result.
    ENDIF.
  ENDMETHOD.

  METHOD uri_hex_value.
    DATA lv_digits TYPE string VALUE '0123456789ABCDEFabcdef'.
    result = -1.
    FIND FIRST OCCURRENCE OF character IN lv_digits MATCH OFFSET result.
    IF sy-subrc <> 0.
      result = -1.
    ELSEIF result >= 16.
      result = result - 6.
    ENDIF.
  ENDMETHOD.

  METHOD uri_percent_byte.
    DATA lv_digits TYPE string VALUE '0123456789ABCDEF'.
    DATA(lv_high) = byte DIV 16.
    DATA(lv_low) = byte MOD 16.
    result = '%' && lv_digits+lv_high(1) && lv_digits+lv_low(1).
  ENDMETHOD.

  METHOD uri_code_unit.
    DATA lv_hex TYPE x LENGTH 2.
    TRY.
        lv_hex = cl_abap_conv_out_ce=>uccp( character ).
      CATCH cx_sy_conversion_codepage cx_sy_codepage_converter_init
          cx_parameter_invalid_range.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'URIError: malformed URI sequence'.
    ENDTRY.
    result = lv_hex.
  ENDMETHOD.

  METHOD uri_code_point.
    TRY.
        IF code = 32.
          result = ` `.
        ELSEIF code <= 65535.
          result = cl_abap_conv_in_ce=>uccpi( code ).
        ELSE.
          DATA(lv_remainder) = code - 65536.
          DATA(lv_high) = 55296 + lv_remainder DIV 1024.
          DATA(lv_low) = 56320 + lv_remainder MOD 1024.
          DATA lv_high_hex TYPE x LENGTH 2.
          DATA lv_low_hex TYPE x LENGTH 2.
          DATA lv_utf16 TYPE xstring.
          DATA lv_converter TYPE REF TO cl_abap_conv_in_ce.
          lv_high_hex = lv_high.
          lv_low_hex = lv_low.
          CONCATENATE lv_high_hex+1(1) lv_high_hex(1)
            lv_low_hex+1(1) lv_low_hex(1) INTO lv_utf16 IN BYTE MODE.
          lv_converter = cl_abap_conv_in_ce=>create( encoding = '4103' ).
          lv_converter->convert(
            EXPORTING input = lv_utf16
            IMPORTING data  = result ).
        ENDIF.
      CATCH cx_sy_conversion_codepage.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'URIError: malformed URI sequence'.
    ENDTRY.
  ENDMETHOD.

  METHOD uri_is_reserved.
    result = abap_false.
    CASE character.
      WHEN ';' OR '/' OR '?' OR ':' OR '@' OR '&' OR '=' OR '+' OR '$' OR ',' OR '#'.
        result = abap_true.
    ENDCASE.
  ENDMETHOD.

  METHOD uri_encode.
    DATA lv_unescaped TYPE string
      VALUE `ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.!~*'()`.
    DATA lv_offset TYPE i.
    DATA lv_character TYPE string.
    DATA lv_code TYPE i.
    DATA lv_low_code TYPE i.
    WHILE lv_offset < strlen( value ).
      lv_character = value+lv_offset(1).
      lv_code = uri_code_unit( lv_character ).
      IF lv_unescaped CS lv_character
          OR ( component = abap_false AND uri_is_reserved( lv_character ) = abap_true ).
        result = result && lv_character.
        lv_offset = lv_offset + 1.
        CONTINUE.
      ENDIF.
      IF lv_code >= 55296 AND lv_code <= 56319.
        IF lv_offset + 1 >= strlen( value ).
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'URIError: malformed URI sequence'.
        ENDIF.
        DATA(lv_surrogate_offset) = lv_offset + 1.
        DATA(lv_low_character) = value+lv_surrogate_offset(1).
        lv_low_code = uri_code_unit( lv_low_character ).
        IF lv_low_code < 56320 OR lv_low_code > 57343.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'URIError: malformed URI sequence'.
        ENDIF.
        lv_code = 65536 + ( lv_code - 55296 ) * 1024 + lv_low_code - 56320.
        lv_offset = lv_offset + 2.
      ELSEIF lv_code >= 56320 AND lv_code <= 57343.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'URIError: malformed URI sequence'.
      ELSE.
        lv_offset = lv_offset + 1.
      ENDIF.
      IF lv_code <= 127.
        result = result && uri_percent_byte( lv_code ).
      ELSEIF lv_code <= 2047.
        result = result && uri_percent_byte( 192 + lv_code DIV 64 )
          && uri_percent_byte( 128 + lv_code MOD 64 ).
      ELSEIF lv_code <= 65535.
        result = result && uri_percent_byte( 224 + lv_code DIV 4096 )
          && uri_percent_byte( 128 + ( lv_code DIV 64 ) MOD 64 )
          && uri_percent_byte( 128 + lv_code MOD 64 ).
      ELSE.
        result = result && uri_percent_byte( 240 + lv_code DIV 262144 )
          && uri_percent_byte( 128 + ( lv_code DIV 4096 ) MOD 64 )
          && uri_percent_byte( 128 + ( lv_code DIV 64 ) MOD 64 )
          && uri_percent_byte( 128 + lv_code MOD 64 ).
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD uri_decode.
    DATA lv_offset TYPE i.
    DATA lv_character TYPE string.
    DATA lv_high TYPE i.
    DATA lv_low TYPE i.
    DATA lv_byte TYPE i.
    DATA lv_first_byte TYPE i.
    DATA lv_continuation TYPE i.
    DATA lv_count TYPE i.
    DATA lv_index TYPE i.
    DATA lv_position TYPE i.
    DATA lv_code TYPE i.
    DATA lv_triplet TYPE string.
    WHILE lv_offset < strlen( value ).
      lv_character = value+lv_offset(1).
      IF lv_character <> '%'.
        result = result && lv_character.
        lv_offset = lv_offset + 1.
        CONTINUE.
      ENDIF.
      IF lv_offset + 2 >= strlen( value ).
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'URIError: malformed URI sequence'.
      ENDIF.
      DATA(lv_first_hex_offset) = lv_offset + 1.
      DATA(lv_second_hex_offset) = lv_offset + 2.
      DATA(lv_hex_character) = value+lv_first_hex_offset(1).
      lv_high = uri_hex_value( lv_hex_character ).
      lv_hex_character = value+lv_second_hex_offset(1).
      lv_low = uri_hex_value( lv_hex_character ).
      IF lv_high < 0 OR lv_low < 0.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'URIError: malformed URI sequence'.
      ENDIF.
      lv_byte = lv_high * 16 + lv_low.
      lv_triplet = value+lv_offset(3).
      IF lv_byte <= 127.
        lv_character = uri_code_point( lv_byte ).
        IF component = abap_false AND uri_is_reserved( lv_character ) = abap_true.
          result = result && lv_triplet.
        ELSE.
          result = result && lv_character.
        ENDIF.
        lv_offset = lv_offset + 3.
        CONTINUE.
      ELSEIF lv_byte >= 194 AND lv_byte <= 223.
        lv_count = 2.
        lv_code = lv_byte - 192.
      ELSEIF lv_byte >= 224 AND lv_byte <= 239.
        lv_count = 3.
        lv_code = lv_byte - 224.
      ELSEIF lv_byte >= 240 AND lv_byte <= 244.
        lv_count = 4.
        lv_code = lv_byte - 240.
      ELSE.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'URIError: malformed URI sequence'.
      ENDIF.
      lv_first_byte = lv_byte.
      lv_index = 1.
      WHILE lv_index < lv_count.
        lv_position = lv_offset + lv_index * 3.
        IF lv_position + 2 >= strlen( value ) OR value+lv_position(1) <> '%'.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'URIError: malformed URI sequence'.
        ENDIF.
        DATA(lv_cont_high_offset) = lv_position + 1.
        DATA(lv_cont_low_offset) = lv_position + 2.
        lv_hex_character = value+lv_cont_high_offset(1).
        lv_high = uri_hex_value( lv_hex_character ).
        lv_hex_character = value+lv_cont_low_offset(1).
        lv_low = uri_hex_value( lv_hex_character ).
        IF lv_high < 0 OR lv_low < 0.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'URIError: malformed URI sequence'.
        ENDIF.
        lv_continuation = lv_high * 16 + lv_low.
        IF lv_continuation < 128 OR lv_continuation > 191
            OR ( lv_index = 1 AND lv_first_byte = 224 AND lv_continuation < 160 )
            OR ( lv_index = 1 AND lv_first_byte = 237 AND lv_continuation > 159 )
            OR ( lv_index = 1 AND lv_first_byte = 240 AND lv_continuation < 144 )
            OR ( lv_index = 1 AND lv_first_byte = 244 AND lv_continuation > 143 ).
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'URIError: malformed URI sequence'.
        ENDIF.
        lv_code = lv_code * 64 + lv_continuation - 128.
        lv_index = lv_index + 1.
      ENDWHILE.
      result = result && uri_code_point( lv_code ).
      lv_offset = lv_offset + lv_count * 3.
    ENDWHILE.
  ENDMETHOD.

  METHOD zif_qjs_property_container~get_property.
    result = get_property( name ).
  ENDMETHOD.

  METHOD zif_qjs_property_container~set_property.
    set_property( name = name value = value ).
  ENDMETHOD.

  METHOD zif_qjs_property_container~delete_property.
    result = delete_property( name ).
  ENDMETHOD.

  METHOD zif_qjs_property_container~get_symbol_property.
    READ TABLE mt_symbol_properties WITH TABLE KEY identity = identity
      INTO DATA(ls_property).
    IF sy-subrc = 0.
      result = ls_property-value.
    ELSE.
      DATA(lo_function_prototype) = mo_runtime->get_function_prototype( ).
      IF lo_function_prototype IS BOUND.
        result = lo_function_prototype->get_symbol( identity ).
      ELSE.
        result = zcl_qjs_value=>new_undefined( ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD zif_qjs_property_container~set_symbol_property.
    DATA(ls_property) = VALUE ty_symbol_property(
      identity = identity value = value ).
    DELETE TABLE mt_symbol_properties WITH TABLE KEY identity = identity.
    INSERT ls_property INTO TABLE mt_symbol_properties.
  ENDMETHOD.

  METHOD zif_qjs_property_container~delete_symbol_property.
    DELETE TABLE mt_symbol_properties WITH TABLE KEY identity = identity.
    result = abap_true.
  ENDMETHOD.

  METHOD zif_qjs_callable~call.
    DATA ls_argument TYPE zcl_qjs_value=>ty_value.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    DATA lv_index TYPE int8.
    DATA ls_number TYPE zcl_qjs_value=>ty_value.
    DATA ls_best TYPE zcl_qjs_value=>ty_value.
    DATA lv_first TYPE abap_bool VALUE abap_true.
    DATA lt_names TYPE zcl_qjs_shape=>ty_names.
    DATA lv_name TYPE string.
    DATA lv_error_name TYPE string.
    DATA lv_error_message TYPE string.
    DATA lv_to_string_property TYPE string VALUE 'toString'.
    DATA lv_error_separator TYPE string VALUE ': '.
    DATA ls_this_argument TYPE zcl_qjs_value=>ty_value.
    DATA ls_argument_list TYPE zcl_qjs_value=>ty_value.
    DATA lt_forwarded TYPE zif_qjs_callable=>ty_arguments.
    DATA lo_array_like TYPE REF TO zcl_qjs_object.
    DATA lv_length TYPE i.
    DATA lv_apply_index TYPE i.
    DATA lo_bound TYPE REF TO zcl_qjs_native_function.
    DATA lo_reference TYPE REF TO object.
    READ TABLE arguments INDEX 1 INTO ls_argument.
    CASE mv_id.
      WHEN id_function.
        DATA lv_parameters TYPE string.
        DATA lv_body TYPE string.
        DATA lv_argument_index TYPE i.
        DATA lv_argument_count TYPE i.
        lv_argument_count = lines( arguments ).
        LOOP AT arguments INTO ls_argument.
          lv_argument_index = sy-tabix.
          IF lv_argument_index = lv_argument_count.
            lv_body = zcl_qjs_value=>to_string( ls_argument ).
          ELSE.
            IF lv_parameters IS NOT INITIAL.
              lv_parameters = lv_parameters && ','.
            ENDIF.
            lv_parameters = lv_parameters && zcl_qjs_value=>to_string( ls_argument ).
          ENDIF.
        ENDLOOP.
        DATA(lv_source) = |function anonymous({ lv_parameters })\{{ lv_body }\} anonymous|.
        TRY.
            IF mo_context IS BOUND.
              result = mo_context->eval( lv_source ).
            ELSE.
              DATA(lo_parser) = NEW zcl_qjs_parser(
                source = lv_source limits = mo_runtime->get_limits( ) ).
              DATA(lo_function) = lo_parser->compile( ).
              DATA(lo_vm) = NEW zcl_qjs_vm(
                runtime = mo_runtime limits = mo_runtime->get_limits( ) ).
              result = lo_vm->execute( lo_function ).
            ENDIF.
          CATCH zcx_qjs_error INTO DATA(lx_function_syntax).
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'SyntaxError: ' && lx_function_syntax->reason.
        ENDTRY.
      WHEN id_function_call.
        IF is_callable( this_value ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Function.prototype.call receiver is not callable'.
        ENDIF.
        READ TABLE arguments INDEX 1 INTO ls_this_argument.
        IF sy-subrc <> 0.
          ls_this_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        LOOP AT arguments INTO ls_argument FROM 2.
          APPEND ls_argument TO lt_forwarded.
        ENDLOOP.
        result = mo_runtime->invoke_callable(
          callable = this_value this_value = ls_this_argument arguments = lt_forwarded ).
      WHEN id_function_apply.
        IF is_callable( this_value ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Function.prototype.apply receiver is not callable'.
        ENDIF.
        READ TABLE arguments INDEX 1 INTO ls_this_argument.
        IF sy-subrc <> 0.
          ls_this_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        READ TABLE arguments INDEX 2 INTO ls_argument_list.
        IF sy-subrc = 0 AND ls_argument_list-tag <> zcl_qjs_value=>tag_null
            AND ls_argument_list-tag <> zcl_qjs_value=>tag_undefined.
          IF ls_argument_list-tag <> zcl_qjs_value=>tag_object.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Function.prototype.apply arguments are not array-like'.
          ENDIF.
          TRY.
              lo_array_like ?= ls_argument_list-object_ref.
            CATCH cx_sy_move_cast_error.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: Function.prototype.apply arguments are not array-like'.
          ENDTRY.
          DATA(ls_length) = zcl_qjs_number=>to_number( lo_array_like->get( 'length' ) ).
          IF ls_length-tag = zcl_qjs_value=>tag_int AND ls_length-int_value > 0.
            lv_length = ls_length-int_value.
          ELSEIF ls_length-tag = zcl_qjs_value=>tag_number
              AND ls_length-number_kind = zcl_qjs_value=>number_finite
              AND ls_length-float_value > 0.
            lv_length = floor( ls_length-float_value ).
          ENDIF.
          mo_runtime->get_limits( )->consume( CONV int8( lv_length ) ).
          lv_apply_index = 0.
          WHILE lv_apply_index < lv_length.
            APPEND lo_array_like->get_element( CONV int8( lv_apply_index ) )
              TO lt_forwarded.
            lv_apply_index = lv_apply_index + 1.
          ENDWHILE.
        ENDIF.
        result = mo_runtime->invoke_callable(
          callable = this_value this_value = ls_this_argument arguments = lt_forwarded ).
      WHEN id_function_bind.
        IF is_callable( this_value ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Function.prototype.bind receiver is not callable'.
        ENDIF.
        READ TABLE arguments INDEX 1 INTO ls_this_argument.
        IF sy-subrc <> 0.
          ls_this_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        LOOP AT arguments INTO ls_argument FROM 2.
          APPEND ls_argument TO lt_forwarded.
        ENDLOOP.
        CREATE OBJECT lo_bound
          EXPORTING id = id_bound_function runtime = mo_runtime
            bound_target = this_value bound_this = ls_this_argument
            bound_arguments = lt_forwarded.
        DATA(ls_target_length) = get_callable_property(
          value = this_value name = 'length' ).
        DATA(lv_bound_length) = 0.
        IF ls_target_length-tag = zcl_qjs_value=>tag_int.
          lv_bound_length = ls_target_length-int_value - lines( lt_forwarded ).
          IF lv_bound_length < 0.
            lv_bound_length = 0.
          ENDIF.
        ENDIF.
        lo_bound->set_property(
          name = 'length' value = zcl_qjs_value=>new_int( lv_bound_length ) ).
        DATA(ls_target_name) = get_callable_property(
          value = this_value name = 'name' ).
        DATA(lv_bound_name) = `bound `.
        IF ls_target_name-tag = zcl_qjs_value=>tag_string.
          lv_bound_name = lv_bound_name && ls_target_name-string_ref->as_string( ).
        ENDIF.
        lo_bound->set_property(
          name = 'name' value = zcl_qjs_value=>new_string( lv_bound_name ) ).
        lo_reference = lo_bound.
        result = zcl_qjs_value=>new_object( lo_reference ).
      WHEN id_bound_function.
        lt_forwarded = mt_bound_arguments.
        APPEND LINES OF arguments TO lt_forwarded.
        result = mo_runtime->invoke_callable(
          callable = ms_bound_target this_value = ms_bound_this arguments = lt_forwarded ).
      WHEN id_number.
        IF sy-subrc = 0.
          result = zcl_qjs_number=>to_number( ls_argument ).
        ELSE.
          result = zcl_qjs_value=>new_int( 0 ).
        ENDIF.
      WHEN id_string.
        IF sy-subrc = 0.
          result = zcl_qjs_value=>new_string( zcl_qjs_value=>to_string( ls_argument ) ).
        ELSE.
          result = zcl_qjs_value=>new_string( '' ).
        ENDIF.
      WHEN id_boolean.
        IF sy-subrc = 0.
          result = zcl_qjs_value=>new_boolean( zcl_qjs_value=>to_boolean( ls_argument ) ).
        ELSE.
          result = zcl_qjs_value=>new_boolean( abap_false ).
        ENDIF.
      WHEN id_object.
        IF sy-subrc = 0 AND ls_argument-tag = zcl_qjs_value=>tag_object.
          result = ls_argument.
        ELSE.
          lo_object = mo_runtime->create_object( ).
          IF sy-subrc = 0 AND ls_argument-tag <> zcl_qjs_value=>tag_null
              AND ls_argument-tag <> zcl_qjs_value=>tag_undefined.
            lo_object->define_property(
              name = '[[PrimitiveValue]]' value = ls_argument
              writable = abap_false enumerable = abap_false configurable = abap_false ).
          ENDIF.
          result = zcl_qjs_value=>new_object( lo_object ).
        ENDIF.
      WHEN id_object_to_string.
        DATA lv_object_tag TYPE string.
        CASE this_value-tag.
          WHEN zcl_qjs_value=>tag_undefined.
            lv_object_tag = 'Undefined'.
          WHEN zcl_qjs_value=>tag_null.
            lv_object_tag = 'Null'.
          WHEN zcl_qjs_value=>tag_bool.
            lv_object_tag = 'Boolean'.
          WHEN zcl_qjs_value=>tag_int OR zcl_qjs_value=>tag_number.
            lv_object_tag = 'Number'.
          WHEN zcl_qjs_value=>tag_string.
            lv_object_tag = 'String'.
          WHEN zcl_qjs_value=>tag_symbol.
            lv_object_tag = 'Symbol'.
          WHEN zcl_qjs_value=>tag_object.
            CLEAR lo_object.
            TRY.
                lo_object ?= this_value-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
            IF lo_object IS BOUND.
              IF lo_object->is_array( ) = abap_true.
                lv_object_tag = 'Array'.
              ELSE.
                DATA(ls_primitive_property) = lo_object->get_own_property(
                  '[[PrimitiveValue]]' ).
                IF ls_primitive_property-found = abap_true.
                  CASE ls_primitive_property-value-tag.
                    WHEN zcl_qjs_value=>tag_bool. lv_object_tag = 'Boolean'.
                    WHEN zcl_qjs_value=>tag_int OR zcl_qjs_value=>tag_number.
                      lv_object_tag = 'Number'.
                    WHEN zcl_qjs_value=>tag_string. lv_object_tag = 'String'.
                    WHEN zcl_qjs_value=>tag_symbol. lv_object_tag = 'Symbol'.
                    WHEN OTHERS. lv_object_tag = 'Object'.
                  ENDCASE.
                ELSE.
                  lv_object_tag = 'Object'.
                ENDIF.
              ENDIF.
              DATA(ls_to_string_tag_symbol) = mo_runtime->well_known_symbol(
                'toStringTag' ).
              DATA(ls_custom_object_tag) = lo_object->get_symbol(
                ls_to_string_tag_symbol-symbol_id ).
              IF ls_custom_object_tag-tag = zcl_qjs_value=>tag_string.
                lv_object_tag = ls_custom_object_tag-string_ref->as_string( ).
              ENDIF.
            ELSEIF is_callable( this_value ) = abap_true.
              lv_object_tag = 'Function'.
            ELSE.
              lv_object_tag = 'Object'.
            ENDIF.
        ENDCASE.
        result = zcl_qjs_value=>new_string( |[object { lv_object_tag }]| ).
      WHEN id_array.
        lo_object = mo_runtime->create_array( ).
        IF lines( arguments ) = 1 AND ls_argument-tag = zcl_qjs_value=>tag_int
            AND ls_argument-int_value >= 0.
          lo_object->set_array_length( CONV int8( ls_argument-int_value ) ).
        ELSE.
          lv_index = 0.
          LOOP AT arguments INTO ls_argument.
            lo_object->set_element( index = lv_index value = ls_argument ).
            lv_index = lv_index + 1.
          ENDLOOP.
        ENDIF.
        result = zcl_qjs_value=>new_object( lo_object ).
      WHEN id_array_push OR id_array_pop.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array method receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array method receiver is not an ordinary object'.
        ENDTRY.
        DATA(lv_array_length) = array_to_length( lo_object->get( 'length' ) ).
        DATA lv_array_max_safe TYPE int8.
        lv_array_max_safe = '9007199254740991'.
        IF mv_id = id_array_push.
          IF lv_array_length > lv_array_max_safe - lines( arguments ).
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: array-like length exceeds maximum safe integer'.
          ENDIF.
          mo_runtime->get_limits( )->consume( CONV int8( lines( arguments ) ) ).
          LOOP AT arguments INTO ls_argument.
            IF lo_object->is_array( ) = abap_true.
              lo_object->set_element(
                index = lv_array_length value = ls_argument ).
            ELSE.
              lv_name = lv_array_length.
              CONDENSE lv_name NO-GAPS.
              lo_object->set( name = lv_name value = ls_argument ).
            ENDIF.
            lv_array_length = lv_array_length + 1.
          ENDLOOP.
        ELSEIF lv_array_length > 0.
          lv_array_length = lv_array_length - 1.
          lv_name = lv_array_length.
          CONDENSE lv_name NO-GAPS.
          result = lo_object->get( lv_name ).
          IF lo_object->delete( lv_name ) = abap_false.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: array element is not configurable'.
          ENDIF.
        ELSE.
          result = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        array_set_length( object = lo_object length = lv_array_length ).
        IF mv_id = id_array_push.
          result = array_length_value( lv_array_length ).
        ENDIF.
      WHEN id_array_join.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array.prototype.join receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array.prototype.join requires an ordinary object'.
        ENDTRY.
        DATA(lv_join_length) = array_to_length( lo_object->get( 'length' ) ).
        DATA(lv_separator) = `,`.
        READ TABLE arguments INDEX 1 INTO DATA(ls_separator).
        IF sy-subrc = 0 AND ls_separator-tag <> zcl_qjs_value=>tag_undefined.
          lv_separator = zcl_qjs_value=>to_string( ls_separator ).
        ENDIF.
        mo_runtime->get_limits( )->consume( lv_join_length ).
        DATA(lv_joined) = ``.
        DATA(lv_join_index) = CONV int8( 0 ).
        WHILE lv_join_index < lv_join_length.
          IF lv_join_index > 0.
            lv_joined = lv_joined && lv_separator.
          ENDIF.
          lv_name = lv_join_index.
          CONDENSE lv_name NO-GAPS.
          DATA(ls_join_element) = lo_object->get( lv_name ).
          IF ls_join_element-tag <> zcl_qjs_value=>tag_undefined
              AND ls_join_element-tag <> zcl_qjs_value=>tag_null.
            lv_joined = lv_joined && zcl_qjs_value=>to_string( ls_join_element ).
          ENDIF.
          lv_join_index = lv_join_index + 1.
        ENDWHILE.
        result = zcl_qjs_value=>new_string( lv_joined ).
      WHEN id_array_index_of OR id_array_includes.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array search receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array search requires an ordinary object'.
        ENDTRY.
        DATA(lv_search_length) = array_to_length( lo_object->get( 'length' ) ).
        READ TABLE arguments INDEX 1 INTO DATA(ls_search_element).
        IF sy-subrc <> 0.
          ls_search_element = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lv_search_index) = CONV int8( 0 ).
        DATA(lv_search_past_end) = abap_false.
        DATA lv_search_max_safe TYPE int8.
        DATA lv_search_max_safe_f TYPE f.
        lv_search_max_safe = '9007199254740991'.
        lv_search_max_safe_f = '9007199254740991'.
        READ TABLE arguments INDEX 2 INTO DATA(ls_from_index).
        IF sy-subrc = 0.
          DATA(ls_from_number) = zcl_qjs_number=>to_number( ls_from_index ).
          IF ls_from_number-tag = zcl_qjs_value=>tag_int.
            lv_search_index = ls_from_number-int_value.
          ELSEIF ls_from_number-tag = zcl_qjs_value=>tag_number
              AND ls_from_number-number_kind = zcl_qjs_value=>number_finite.
            IF ls_from_number-float_value >= lv_search_max_safe_f.
              lv_search_past_end = abap_true.
            ELSEIF ls_from_number-float_value <= 0 - lv_search_max_safe_f.
              lv_search_index = 0 - lv_search_max_safe.
            ELSE.
              lv_search_index = trunc( ls_from_number-float_value ).
            ENDIF.
          ELSEIF ls_from_number-tag = zcl_qjs_value=>tag_number
              AND ls_from_number-number_kind = zcl_qjs_value=>number_pos_inf.
            lv_search_past_end = abap_true.
          ENDIF.
        ENDIF.
        IF lv_search_index < 0.
          lv_search_index = lv_search_length + lv_search_index.
          IF lv_search_index < 0.
            lv_search_index = 0.
          ENDIF.
        ENDIF.
        IF lv_search_index >= lv_search_length.
          lv_search_past_end = abap_true.
        ENDIF.
        DATA(lv_search_found) = abap_false.
        IF lv_search_past_end = abap_false.
          mo_runtime->get_limits( )->consume(
            lv_search_length - lv_search_index ).
          WHILE lv_search_index < lv_search_length.
            lv_name = lv_search_index.
            CONDENSE lv_name NO-GAPS.
            IF mv_id = id_array_includes
                OR lo_object->has_property( lv_name ) = abap_true.
              DATA(ls_search_value) = lo_object->get( lv_name ).
              IF ( mv_id = id_array_includes AND same_value_zero(
                    left = ls_search_value right = ls_search_element ) = abap_true )
                  OR ( mv_id = id_array_index_of AND zcl_qjs_value=>strict_equal(
                    left = ls_search_value right = ls_search_element ) = abap_true ).
                lv_search_found = abap_true.
                EXIT.
              ENDIF.
            ENDIF.
            lv_search_index = lv_search_index + 1.
          ENDWHILE.
        ENDIF.
        IF mv_id = id_array_includes.
          result = zcl_qjs_value=>new_boolean( lv_search_found ).
        ELSEIF lv_search_found = abap_true.
          result = array_length_value( lv_search_index ).
        ELSE.
          result = zcl_qjs_value=>new_int( -1 ).
        ENDIF.
      WHEN id_array_shift OR id_array_unshift.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array mutation receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array mutation requires an ordinary object'.
        ENDTRY.
        DATA(lv_mutation_length) = array_to_length( lo_object->get( 'length' ) ).
        IF mv_id = id_array_shift.
          IF lv_mutation_length = 0.
            array_set_length( object = lo_object length = 0 ).
            result = zcl_qjs_value=>new_undefined( ).
          ELSE.
            mo_runtime->get_limits( )->consume( lv_mutation_length ).
            result = lo_object->get( '0' ).
            DATA(lv_shift_index) = CONV int8( 1 ).
            WHILE lv_shift_index < lv_mutation_length.
              DATA(lv_shift_from) = lv_shift_index.
              DATA(lv_shift_to) = lv_shift_index - 1.
              DATA(lv_shift_from_name) = CONV string( lv_shift_from ).
              DATA(lv_shift_to_name) = CONV string( lv_shift_to ).
              CONDENSE lv_shift_from_name NO-GAPS.
              CONDENSE lv_shift_to_name NO-GAPS.
              IF lo_object->has_property( lv_shift_from_name ) = abap_true.
                DATA(ls_shift_value) = lo_object->get( lv_shift_from_name ).
                IF lo_object->is_array( ) = abap_true.
                  lo_object->set_element(
                    index = lv_shift_to value = ls_shift_value ).
                ELSE.
                  lo_object->set(
                    name = lv_shift_to_name value = ls_shift_value ).
                ENDIF.
              ELSEIF lo_object->delete( lv_shift_to_name ) = abap_false.
                RAISE EXCEPTION TYPE zcx_qjs_error
                  EXPORTING reason = 'TypeError: shifted property is not configurable'.
              ENDIF.
              lv_shift_index = lv_shift_index + 1.
            ENDWHILE.
            DATA(lv_shift_last) = lv_mutation_length - 1.
            DATA(lv_shift_last_name) = CONV string( lv_shift_last ).
            CONDENSE lv_shift_last_name NO-GAPS.
            IF lo_object->delete( lv_shift_last_name ) = abap_false.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: shifted property is not configurable'.
            ENDIF.
            array_set_length(
              object = lo_object length = lv_mutation_length - 1 ).
          ENDIF.
        ELSE.
          DATA(lv_unshift_count) = CONV int8( lines( arguments ) ).
          DATA lv_unshift_max_safe TYPE int8.
          lv_unshift_max_safe = '9007199254740991'.
          IF lv_mutation_length > lv_unshift_max_safe - lv_unshift_count.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: array-like length exceeds maximum safe integer'.
          ENDIF.
          mo_runtime->get_limits( )->consume(
            lv_mutation_length + lv_unshift_count ).
          DATA(lv_unshift_index) = lv_mutation_length.
          WHILE lv_unshift_index > 0.
            DATA(lv_unshift_from) = lv_unshift_index - 1.
            DATA(lv_unshift_to) = lv_unshift_from + lv_unshift_count.
            DATA(lv_unshift_from_name) = CONV string( lv_unshift_from ).
            DATA(lv_unshift_to_name) = CONV string( lv_unshift_to ).
            CONDENSE lv_unshift_from_name NO-GAPS.
            CONDENSE lv_unshift_to_name NO-GAPS.
            IF lo_object->has_property( lv_unshift_from_name ) = abap_true.
              DATA(ls_unshift_value) = lo_object->get( lv_unshift_from_name ).
              IF lo_object->is_array( ) = abap_true.
                lo_object->set_element(
                  index = lv_unshift_to value = ls_unshift_value ).
              ELSE.
                lo_object->set(
                  name = lv_unshift_to_name value = ls_unshift_value ).
              ENDIF.
            ELSEIF lo_object->delete( lv_unshift_to_name ) = abap_false.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: unshifted property is not configurable'.
            ENDIF.
            lv_unshift_index = lv_unshift_index - 1.
          ENDWHILE.
          DATA(lv_unshift_argument_index) = CONV int8( 0 ).
          LOOP AT arguments INTO ls_argument.
            IF lo_object->is_array( ) = abap_true.
              lo_object->set_element(
                index = lv_unshift_argument_index value = ls_argument ).
            ELSE.
              DATA(lv_unshift_name) = CONV string( lv_unshift_argument_index ).
              CONDENSE lv_unshift_name NO-GAPS.
              lo_object->set( name = lv_unshift_name value = ls_argument ).
            ENDIF.
            lv_unshift_argument_index = lv_unshift_argument_index + 1.
          ENDLOOP.
          lv_mutation_length = lv_mutation_length + lv_unshift_count.
          array_set_length( object = lo_object length = lv_mutation_length ).
          result = array_length_value( lv_mutation_length ).
        ENDIF.
      WHEN id_array_reverse.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array.prototype.reverse receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array.prototype.reverse requires an ordinary object'.
        ENDTRY.
        DATA(lv_reverse_length) = array_to_length( lo_object->get( 'length' ) ).
        mo_runtime->get_limits( )->consume( lv_reverse_length ).
        DATA(lv_reverse_middle) = lv_reverse_length DIV 2.
        DATA(lv_reverse_lower) = CONV int8( 0 ).
        WHILE lv_reverse_lower < lv_reverse_middle.
          DATA(lv_reverse_upper) = lv_reverse_length - lv_reverse_lower - 1.
          DATA(lv_reverse_lower_name) = CONV string( lv_reverse_lower ).
          DATA(lv_reverse_upper_name) = CONV string( lv_reverse_upper ).
          CONDENSE lv_reverse_lower_name NO-GAPS.
          CONDENSE lv_reverse_upper_name NO-GAPS.
          DATA(lv_reverse_lower_exists) = lo_object->has_property(
            lv_reverse_lower_name ).
          DATA(lv_reverse_upper_exists) = lo_object->has_property(
            lv_reverse_upper_name ).
          DATA ls_reverse_lower_value TYPE zcl_qjs_value=>ty_value.
          DATA ls_reverse_upper_value TYPE zcl_qjs_value=>ty_value.
          IF lv_reverse_lower_exists = abap_true.
            ls_reverse_lower_value = lo_object->get( lv_reverse_lower_name ).
          ENDIF.
          IF lv_reverse_upper_exists = abap_true.
            ls_reverse_upper_value = lo_object->get( lv_reverse_upper_name ).
          ENDIF.
          IF lv_reverse_lower_exists = abap_true
              AND lv_reverse_upper_exists = abap_true.
            IF lo_object->is_array( ) = abap_true.
              lo_object->set_element(
                index = lv_reverse_lower value = ls_reverse_upper_value ).
              lo_object->set_element(
                index = lv_reverse_upper value = ls_reverse_lower_value ).
            ELSE.
              lo_object->set(
                name = lv_reverse_lower_name value = ls_reverse_upper_value ).
              lo_object->set(
                name = lv_reverse_upper_name value = ls_reverse_lower_value ).
            ENDIF.
          ELSEIF lv_reverse_upper_exists = abap_true.
            IF lo_object->is_array( ) = abap_true.
              lo_object->set_element(
                index = lv_reverse_lower value = ls_reverse_upper_value ).
            ELSE.
              lo_object->set(
                name = lv_reverse_lower_name value = ls_reverse_upper_value ).
            ENDIF.
            IF lo_object->delete( lv_reverse_upper_name ) = abap_false.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: reversed property is not configurable'.
            ENDIF.
          ELSEIF lv_reverse_lower_exists = abap_true.
            IF lo_object->delete( lv_reverse_lower_name ) = abap_false.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: reversed property is not configurable'.
            ENDIF.
            IF lo_object->is_array( ) = abap_true.
              lo_object->set_element(
                index = lv_reverse_upper value = ls_reverse_lower_value ).
            ELSE.
              lo_object->set(
                name = lv_reverse_upper_name value = ls_reverse_lower_value ).
            ENDIF.
          ENDIF.
          lv_reverse_lower = lv_reverse_lower + 1.
        ENDWHILE.
        result = this_value.
      WHEN id_array_last_index_of.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array.prototype.lastIndexOf receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array.prototype.lastIndexOf requires an ordinary object'.
        ENDTRY.
        DATA(lv_last_length) = array_to_length( lo_object->get( 'length' ) ).
        READ TABLE arguments INDEX 1 INTO DATA(ls_last_search).
        IF sy-subrc <> 0.
          ls_last_search = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lv_last_not_found) = xsdbool( lv_last_length = 0 ).
        DATA(lv_last_index) = lv_last_length - 1.
        IF lv_last_not_found = abap_false.
          READ TABLE arguments INDEX 2 INTO DATA(ls_last_from).
          IF sy-subrc = 0.
            DATA(ls_last_from_number) = zcl_qjs_number=>to_number( ls_last_from ).
            DATA(lv_last_relative) = CONV int8( 0 ).
            DATA(lv_last_positive_overflow) = abap_false.
            DATA(lv_last_negative_overflow) = abap_false.
            DATA lv_last_max_safe_f TYPE f.
            lv_last_max_safe_f = '9007199254740991'.
            IF ls_last_from_number-tag = zcl_qjs_value=>tag_int.
              lv_last_relative = ls_last_from_number-int_value.
            ELSEIF ls_last_from_number-tag = zcl_qjs_value=>tag_number
                AND ls_last_from_number-number_kind = zcl_qjs_value=>number_finite.
              IF ls_last_from_number-float_value >= lv_last_max_safe_f.
                lv_last_positive_overflow = abap_true.
              ELSEIF ls_last_from_number-float_value <= 0 - lv_last_max_safe_f.
                lv_last_negative_overflow = abap_true.
              ELSE.
                lv_last_relative = trunc( ls_last_from_number-float_value ).
              ENDIF.
            ELSEIF ls_last_from_number-tag = zcl_qjs_value=>tag_number
                AND ls_last_from_number-number_kind = zcl_qjs_value=>number_pos_inf.
              lv_last_positive_overflow = abap_true.
            ELSEIF ls_last_from_number-tag = zcl_qjs_value=>tag_number
                AND ls_last_from_number-number_kind = zcl_qjs_value=>number_neg_inf.
              lv_last_negative_overflow = abap_true.
            ENDIF.
            IF lv_last_negative_overflow = abap_true.
              lv_last_not_found = abap_true.
            ELSEIF lv_last_positive_overflow = abap_true
                OR lv_last_relative >= lv_last_length.
              lv_last_index = lv_last_length - 1.
            ELSEIF lv_last_relative >= 0.
              lv_last_index = lv_last_relative.
            ELSE.
              lv_last_index = lv_last_length + lv_last_relative.
              IF lv_last_index < 0.
                lv_last_not_found = abap_true.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
        DATA(lv_last_found) = abap_false.
        IF lv_last_not_found = abap_false.
          mo_runtime->get_limits( )->consume( lv_last_index + 1 ).
          WHILE lv_last_index >= 0.
            DATA(lv_last_name) = CONV string( lv_last_index ).
            CONDENSE lv_last_name NO-GAPS.
            IF lo_object->has_property( lv_last_name ) = abap_true.
              DATA(ls_last_value) = lo_object->get( lv_last_name ).
              IF zcl_qjs_value=>strict_equal(
                  left = ls_last_value right = ls_last_search ) = abap_true.
                lv_last_found = abap_true.
                EXIT.
              ENDIF.
            ENDIF.
            lv_last_index = lv_last_index - 1.
          ENDWHILE.
        ENDIF.
        IF lv_last_found = abap_true.
          result = array_length_value( lv_last_index ).
        ELSE.
          result = zcl_qjs_value=>new_int( -1 ).
        ENDIF.
      WHEN id_array_at.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array.prototype.at receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array.prototype.at requires an ordinary object'.
        ENDTRY.
        DATA(lv_at_length) = array_to_length( lo_object->get( 'length' ) ).
        READ TABLE arguments INDEX 1 INTO DATA(ls_at_index_value).
        IF sy-subrc <> 0.
          ls_at_index_value = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(ls_at_number) = zcl_qjs_number=>to_number( ls_at_index_value ).
        DATA(lv_at_relative) = CONV int8( 0 ).
        DATA(lv_at_out_of_range) = abap_false.
        DATA lv_at_max_safe_f TYPE f.
        lv_at_max_safe_f = '9007199254740991'.
        IF ls_at_number-tag = zcl_qjs_value=>tag_int.
          lv_at_relative = ls_at_number-int_value.
        ELSEIF ls_at_number-tag = zcl_qjs_value=>tag_number
            AND ls_at_number-number_kind = zcl_qjs_value=>number_finite.
          IF abs( ls_at_number-float_value ) >= lv_at_max_safe_f.
            lv_at_out_of_range = abap_true.
          ELSE.
            lv_at_relative = trunc( ls_at_number-float_value ).
          ENDIF.
        ELSEIF ls_at_number-tag = zcl_qjs_value=>tag_number
            AND ( ls_at_number-number_kind = zcl_qjs_value=>number_pos_inf
              OR ls_at_number-number_kind = zcl_qjs_value=>number_neg_inf ).
          lv_at_out_of_range = abap_true.
        ENDIF.
        DATA(lv_at_index) = lv_at_relative.
        IF lv_at_relative < 0.
          lv_at_index = lv_at_length + lv_at_relative.
        ENDIF.
        IF lv_at_out_of_range = abap_true
            OR lv_at_index < 0 OR lv_at_index >= lv_at_length.
          result = zcl_qjs_value=>new_undefined( ).
        ELSE.
          mo_runtime->get_limits( )->consume( 1 ).
          DATA(lv_at_name) = CONV string( lv_at_index ).
          CONDENSE lv_at_name NO-GAPS.
          result = lo_object->get( lv_at_name ).
        ENDIF.
      WHEN id_array_slice.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array.prototype.slice receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array.prototype.slice requires an ordinary object'.
        ENDTRY.
        DATA(lv_slice_length) = array_to_length( lo_object->get( 'length' ) ).
        READ TABLE arguments INDEX 1 INTO DATA(ls_slice_start_value).
        IF sy-subrc <> 0.
          ls_slice_start_value = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lv_slice_start) = array_slice_index(
          value = ls_slice_start_value length = lv_slice_length ).
        READ TABLE arguments INDEX 2 INTO DATA(ls_slice_end_value).
        IF sy-subrc = 0.
          DATA(lv_slice_end) = array_slice_index(
            value = ls_slice_end_value length = lv_slice_length ).
        ELSE.
          lv_slice_end = lv_slice_length.
        ENDIF.
        DATA(lv_slice_count) = lv_slice_end - lv_slice_start.
        IF lv_slice_count < 0.
          lv_slice_count = 0.
        ENDIF.
        mo_runtime->get_limits( )->consume( lv_slice_count ).
        DATA(lo_slice_result) = mo_runtime->create_array( ).
        lo_slice_result->set_array_length( lv_slice_count ).
        DATA(lv_slice_source) = lv_slice_start.
        DATA(lv_slice_target) = CONV int8( 0 ).
        WHILE lv_slice_source < lv_slice_end.
          DATA(lv_slice_source_name) = CONV string( lv_slice_source ).
          CONDENSE lv_slice_source_name NO-GAPS.
          IF lo_object->has_property( lv_slice_source_name ) = abap_true.
            lo_slice_result->set_element(
              index = lv_slice_target value = lo_object->get( lv_slice_source_name ) ).
          ENDIF.
          lv_slice_source = lv_slice_source + 1.
          lv_slice_target = lv_slice_target + 1.
        ENDWHILE.
        result = zcl_qjs_value=>new_object( lo_slice_result ).
      WHEN id_array_for_each OR id_array_map OR id_array_filter.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array iteration receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array iteration requires an ordinary object'.
        ENDTRY.
        READ TABLE arguments INDEX 1 INTO DATA(ls_array_callback).
        IF sy-subrc <> 0 OR is_callable( ls_array_callback ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array iteration callback is not callable'.
        ENDIF.
        READ TABLE arguments INDEX 2 INTO DATA(ls_array_callback_this).
        IF sy-subrc <> 0.
          ls_array_callback_this = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lv_array_iteration_length) = array_to_length(
          lo_object->get( 'length' ) ).
        mo_runtime->get_limits( )->consume( lv_array_iteration_length ).
        DATA lo_array_iteration_result TYPE REF TO zcl_qjs_object.
        IF mv_id = id_array_map OR mv_id = id_array_filter.
          lo_array_iteration_result = mo_runtime->create_array( ).
          IF mv_id = id_array_map.
            lo_array_iteration_result->set_array_length( lv_array_iteration_length ).
          ENDIF.
        ENDIF.
        DATA(lv_array_iteration_index) = CONV int8( 0 ).
        DATA(lv_array_filter_index) = CONV int8( 0 ).
        DATA lt_array_callback_args TYPE zif_qjs_callable=>ty_arguments.
        WHILE lv_array_iteration_index < lv_array_iteration_length.
          DATA(lv_array_iteration_name) = CONV string( lv_array_iteration_index ).
          CONDENSE lv_array_iteration_name NO-GAPS.
          IF lo_object->has_property( lv_array_iteration_name ) = abap_true.
            DATA(ls_array_iteration_value) = lo_object->get(
              lv_array_iteration_name ).
            CLEAR lt_array_callback_args.
            APPEND ls_array_iteration_value TO lt_array_callback_args.
            APPEND array_length_value( lv_array_iteration_index )
              TO lt_array_callback_args.
            APPEND this_value TO lt_array_callback_args.
            DATA(ls_array_callback_result) = mo_runtime->invoke_callable(
              callable = ls_array_callback this_value = ls_array_callback_this
              arguments = lt_array_callback_args ).
            IF mv_id = id_array_map.
              lo_array_iteration_result->set_element(
                index = lv_array_iteration_index value = ls_array_callback_result ).
            ELSEIF mv_id = id_array_filter
                AND zcl_qjs_value=>to_boolean( ls_array_callback_result ) = abap_true.
              lo_array_iteration_result->set_element(
                index = lv_array_filter_index value = ls_array_iteration_value ).
              lv_array_filter_index = lv_array_filter_index + 1.
            ENDIF.
          ENDIF.
          lv_array_iteration_index = lv_array_iteration_index + 1.
        ENDWHILE.
        IF mv_id = id_array_for_each.
          result = zcl_qjs_value=>new_undefined( ).
        ELSE.
          result = zcl_qjs_value=>new_object( lo_array_iteration_result ).
        ENDIF.
      WHEN id_array_some OR id_array_every OR id_array_find OR id_array_find_index.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array predicate receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array predicate requires an ordinary object'.
        ENDTRY.
        READ TABLE arguments INDEX 1 INTO DATA(ls_array_predicate).
        IF sy-subrc <> 0 OR is_callable( ls_array_predicate ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array predicate callback is not callable'.
        ENDIF.
        READ TABLE arguments INDEX 2 INTO DATA(ls_array_predicate_this).
        IF sy-subrc <> 0.
          ls_array_predicate_this = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lv_array_predicate_length) = array_to_length(
          lo_object->get( 'length' ) ).
        mo_runtime->get_limits( )->consume( lv_array_predicate_length ).
        DATA(lv_array_predicate_index) = CONV int8( 0 ).
        DATA(lv_array_predicate_matched) = abap_false.
        DATA ls_array_predicate_value TYPE zcl_qjs_value=>ty_value.
        DATA lt_array_predicate_args TYPE zif_qjs_callable=>ty_arguments.
        WHILE lv_array_predicate_index < lv_array_predicate_length.
          DATA(lv_array_predicate_name) = CONV string( lv_array_predicate_index ).
          CONDENSE lv_array_predicate_name NO-GAPS.
          DATA(lv_array_predicate_present) = lo_object->has_property(
            lv_array_predicate_name ).
          IF lv_array_predicate_present = abap_true
              OR mv_id = id_array_find OR mv_id = id_array_find_index.
            ls_array_predicate_value = lo_object->get( lv_array_predicate_name ).
            CLEAR lt_array_predicate_args.
            APPEND ls_array_predicate_value TO lt_array_predicate_args.
            APPEND array_length_value( lv_array_predicate_index )
              TO lt_array_predicate_args.
            APPEND this_value TO lt_array_predicate_args.
            DATA(ls_array_predicate_result) = mo_runtime->invoke_callable(
              callable = ls_array_predicate this_value = ls_array_predicate_this
              arguments = lt_array_predicate_args ).
            DATA(lv_array_predicate_truth) = zcl_qjs_value=>to_boolean(
              ls_array_predicate_result ).
            IF ( mv_id = id_array_some OR mv_id = id_array_find
                OR mv_id = id_array_find_index )
                AND lv_array_predicate_truth = abap_true.
              lv_array_predicate_matched = abap_true.
              EXIT.
            ELSEIF mv_id = id_array_every
                AND lv_array_predicate_truth = abap_false.
              lv_array_predicate_matched = abap_true.
              EXIT.
            ENDIF.
          ENDIF.
          lv_array_predicate_index = lv_array_predicate_index + 1.
        ENDWHILE.
        IF mv_id = id_array_some.
          result = zcl_qjs_value=>new_boolean( lv_array_predicate_matched ).
        ELSEIF mv_id = id_array_every.
          result = zcl_qjs_value=>new_boolean(
            xsdbool( lv_array_predicate_matched = abap_false ) ).
        ELSEIF mv_id = id_array_find.
          IF lv_array_predicate_matched = abap_true.
            result = ls_array_predicate_value.
          ELSE.
            result = zcl_qjs_value=>new_undefined( ).
          ENDIF.
        ELSEIF lv_array_predicate_matched = abap_true.
          result = array_length_value( lv_array_predicate_index ).
        ELSE.
          result = zcl_qjs_value=>new_int( -1 ).
        ENDIF.
      WHEN id_array_reduce OR id_array_reduce_right.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array reduction receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array reduction requires an ordinary object'.
        ENDTRY.
        READ TABLE arguments INDEX 1 INTO DATA(ls_array_reducer).
        IF sy-subrc <> 0 OR is_callable( ls_array_reducer ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array reducer is not callable'.
        ENDIF.
        DATA(lv_array_reduce_length) = array_to_length( lo_object->get( 'length' ) ).
        mo_runtime->get_limits( )->consume( lv_array_reduce_length ).
        READ TABLE arguments INDEX 2 INTO DATA(ls_array_accumulator).
        DATA(lv_array_has_accumulator) = xsdbool( sy-subrc = 0 ).
        DATA(lv_array_reduce_index) = CONV int8( 0 ).
        DATA(lv_array_reduce_step) = CONV int8( 1 ).
        IF mv_id = id_array_reduce_right.
          lv_array_reduce_index = lv_array_reduce_length - 1.
          lv_array_reduce_step = -1.
        ENDIF.
        IF lv_array_has_accumulator = abap_false.
          WHILE lv_array_reduce_index >= 0
              AND lv_array_reduce_index < lv_array_reduce_length.
            DATA(lv_array_reduce_name) = CONV string( lv_array_reduce_index ).
            CONDENSE lv_array_reduce_name NO-GAPS.
            IF lo_object->has_property( lv_array_reduce_name ) = abap_true.
              ls_array_accumulator = lo_object->get( lv_array_reduce_name ).
              lv_array_has_accumulator = abap_true.
              lv_array_reduce_index = lv_array_reduce_index + lv_array_reduce_step.
              EXIT.
            ENDIF.
            lv_array_reduce_index = lv_array_reduce_index + lv_array_reduce_step.
          ENDWHILE.
          IF lv_array_has_accumulator = abap_false.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Reduce of empty array with no initial value'.
          ENDIF.
        ENDIF.
        DATA lt_array_reduce_args TYPE zif_qjs_callable=>ty_arguments.
        WHILE lv_array_reduce_index >= 0
            AND lv_array_reduce_index < lv_array_reduce_length.
          lv_array_reduce_name = CONV string( lv_array_reduce_index ).
          CONDENSE lv_array_reduce_name NO-GAPS.
          IF lo_object->has_property( lv_array_reduce_name ) = abap_true.
            DATA(ls_array_reduce_value) = lo_object->get( lv_array_reduce_name ).
            CLEAR lt_array_reduce_args.
            APPEND ls_array_accumulator TO lt_array_reduce_args.
            APPEND ls_array_reduce_value TO lt_array_reduce_args.
            APPEND array_length_value( lv_array_reduce_index ) TO lt_array_reduce_args.
            APPEND this_value TO lt_array_reduce_args.
            ls_array_accumulator = mo_runtime->invoke_callable(
              callable   = ls_array_reducer
              this_value = zcl_qjs_value=>new_undefined( )
              arguments  = lt_array_reduce_args ).
          ENDIF.
          lv_array_reduce_index = lv_array_reduce_index + lv_array_reduce_step.
        ENDWHILE.
        result = ls_array_accumulator.
      WHEN id_array_fill.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array.prototype.fill receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array.prototype.fill requires an ordinary object'.
        ENDTRY.
        DATA(lv_array_fill_length) = array_to_length( lo_object->get( 'length' ) ).
        READ TABLE arguments INDEX 1 INTO DATA(ls_array_fill_value).
        IF sy-subrc <> 0.
          ls_array_fill_value = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        READ TABLE arguments INDEX 2 INTO DATA(ls_array_fill_start_value).
        IF sy-subrc <> 0.
          ls_array_fill_start_value = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lv_array_fill_start) = array_slice_index(
          value = ls_array_fill_start_value length = lv_array_fill_length ).
        READ TABLE arguments INDEX 3 INTO DATA(ls_array_fill_end_value).
        IF sy-subrc <> 0 OR ls_array_fill_end_value-tag = zcl_qjs_value=>tag_undefined.
          DATA(lv_array_fill_end) = lv_array_fill_length.
        ELSE.
          lv_array_fill_end = array_slice_index(
            value = ls_array_fill_end_value length = lv_array_fill_length ).
        ENDIF.
        DATA(lv_array_fill_count) = lv_array_fill_end - lv_array_fill_start.
        IF lv_array_fill_count < 0.
          lv_array_fill_count = 0.
        ENDIF.
        mo_runtime->get_limits( )->consume( lv_array_fill_count ).
        DATA(lv_array_fill_index) = lv_array_fill_start.
        WHILE lv_array_fill_index < lv_array_fill_end.
          DATA(lv_array_fill_name) = CONV string( lv_array_fill_index ).
          CONDENSE lv_array_fill_name NO-GAPS.
          lo_object->set( name = lv_array_fill_name value = ls_array_fill_value ).
          lv_array_fill_index = lv_array_fill_index + 1.
        ENDWHILE.
        result = this_value.
      WHEN id_array_copy_within.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array.prototype.copyWithin receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array.prototype.copyWithin requires an ordinary object'.
        ENDTRY.
        DATA(lv_copy_length) = array_to_length( lo_object->get( 'length' ) ).
        READ TABLE arguments INDEX 1 INTO DATA(ls_copy_target_value).
        IF sy-subrc <> 0.
          ls_copy_target_value = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lv_copy_target) = array_slice_index(
          value = ls_copy_target_value length = lv_copy_length ).
        READ TABLE arguments INDEX 2 INTO DATA(ls_copy_start_value).
        IF sy-subrc <> 0.
          ls_copy_start_value = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lv_copy_from) = array_slice_index(
          value = ls_copy_start_value length = lv_copy_length ).
        READ TABLE arguments INDEX 3 INTO DATA(ls_copy_end_value).
        IF sy-subrc <> 0 OR ls_copy_end_value-tag = zcl_qjs_value=>tag_undefined.
          DATA(lv_copy_end) = lv_copy_length.
        ELSE.
          lv_copy_end = array_slice_index(
            value = ls_copy_end_value length = lv_copy_length ).
        ENDIF.
        DATA(lv_copy_count) = lv_copy_end - lv_copy_from.
        IF lv_copy_length - lv_copy_target < lv_copy_count.
          lv_copy_count = lv_copy_length - lv_copy_target.
        ENDIF.
        IF lv_copy_count < 0.
          lv_copy_count = 0.
        ENDIF.
        mo_runtime->get_limits( )->consume( lv_copy_count ).
        DATA(lv_copy_direction) = CONV int8( 1 ).
        IF lv_copy_from < lv_copy_target
            AND lv_copy_target < lv_copy_from + lv_copy_count.
          lv_copy_direction = -1.
          lv_copy_from = lv_copy_from + lv_copy_count - 1.
          lv_copy_target = lv_copy_target + lv_copy_count - 1.
        ENDIF.
        WHILE lv_copy_count > 0.
          DATA(lv_copy_from_name) = CONV string( lv_copy_from ).
          CONDENSE lv_copy_from_name NO-GAPS.
          DATA(lv_copy_target_name) = CONV string( lv_copy_target ).
          CONDENSE lv_copy_target_name NO-GAPS.
          IF lo_object->has_property( lv_copy_from_name ) = abap_true.
            lo_object->set(
              name = lv_copy_target_name value = lo_object->get( lv_copy_from_name ) ).
          ELSEIF lo_object->delete( lv_copy_target_name ) = abap_false.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array.prototype.copyWithin cannot delete property'.
          ENDIF.
          lv_copy_from = lv_copy_from + lv_copy_direction.
          lv_copy_target = lv_copy_target + lv_copy_direction.
          lv_copy_count = lv_copy_count - 1.
        ENDWHILE.
        result = this_value.
      WHEN id_is_nan.
        IF sy-subrc <> 0.
          result = zcl_qjs_value=>new_boolean( abap_true ).
        ELSE.
          ls_argument = zcl_qjs_number=>to_number( ls_argument ).
          result = zcl_qjs_value=>new_boolean(
            xsdbool( ls_argument-tag = zcl_qjs_value=>tag_number
              AND ls_argument-number_kind = zcl_qjs_value=>number_nan ) ).
        ENDIF.
      WHEN id_is_finite.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        result = zcl_qjs_value=>new_boolean(
          xsdbool( ls_number-tag = zcl_qjs_value=>tag_int
            OR ( ls_number-tag = zcl_qjs_value=>tag_number
              AND ls_number-number_kind <> zcl_qjs_value=>number_nan
              AND ls_number-number_kind <> zcl_qjs_value=>number_pos_inf
              AND ls_number-number_kind <> zcl_qjs_value=>number_neg_inf ) ) ).
      WHEN id_parse_int.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lv_parse_radix) = 0.
        READ TABLE arguments INDEX 2 INTO DATA(ls_parse_radix).
        IF sy-subrc = 0 AND ls_parse_radix-tag <> zcl_qjs_value=>tag_undefined.
          lv_parse_radix = zcl_qjs_number=>to_int32( ls_parse_radix ).
        ENDIF.
        result = zcl_qjs_number=>parse_int(
          text = zcl_qjs_value=>to_string( ls_argument ) radix = lv_parse_radix ).
      WHEN id_parse_float.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        result = zcl_qjs_number=>parse_float(
          zcl_qjs_value=>to_string( ls_argument ) ).
      WHEN id_number_is_nan.
        result = zcl_qjs_value=>new_boolean(
          xsdbool( sy-subrc = 0
            AND ls_argument-tag = zcl_qjs_value=>tag_number
            AND ls_argument-number_kind = zcl_qjs_value=>number_nan ) ).
      WHEN id_number_is_finite.
        result = zcl_qjs_value=>new_boolean(
          xsdbool( sy-subrc = 0
            AND ( ls_argument-tag = zcl_qjs_value=>tag_int
              OR ( ls_argument-tag = zcl_qjs_value=>tag_number
                AND ( ls_argument-number_kind = zcl_qjs_value=>number_finite
                  OR ls_argument-number_kind = zcl_qjs_value=>number_neg_zero ) ) ) ) ).
      WHEN id_number_is_integer OR id_number_is_safe_int.
        DATA(lv_is_integer) = abap_false.
        DATA(lv_integer_value) = CONV f( 0 ).
        IF sy-subrc = 0 AND ls_argument-tag = zcl_qjs_value=>tag_int.
          lv_is_integer = abap_true.
          lv_integer_value = ls_argument-int_value.
        ELSEIF sy-subrc = 0 AND ls_argument-tag = zcl_qjs_value=>tag_number.
          IF ls_argument-number_kind = zcl_qjs_value=>number_neg_zero.
            lv_is_integer = abap_true.
          ELSEIF ls_argument-number_kind = zcl_qjs_value=>number_finite
              AND trunc( ls_argument-float_value ) = ls_argument-float_value.
            lv_is_integer = abap_true.
            lv_integer_value = ls_argument-float_value.
          ENDIF.
        ENDIF.
        IF mv_id = id_number_is_safe_int AND lv_is_integer = abap_true.
          DATA lv_max_safe TYPE f.
          lv_max_safe = '9007199254740991'.
          IF abs( lv_integer_value ) > lv_max_safe.
            lv_is_integer = abap_false.
          ENDIF.
        ENDIF.
        result = zcl_qjs_value=>new_boolean( lv_is_integer ).
      WHEN id_math_abs.
        IF sy-subrc <> 0.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
        ELSE.
          ls_number = zcl_qjs_number=>to_number( ls_argument ).
          IF ls_number-number_kind = zcl_qjs_value=>number_neg_inf.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
          ELSEIF ls_number-number_kind = zcl_qjs_value=>number_neg_zero.
            result = zcl_qjs_value=>new_finite( 0 ).
          ELSEIF ls_number-number_kind = zcl_qjs_value=>number_finite
              AND ls_number-float_value < 0.
            result = zcl_qjs_value=>new_finite( 0 - ls_number-float_value ).
          ELSE.
            result = ls_number.
          ENDIF.
        ENDIF.
      WHEN id_math_floor OR id_math_ceil.
        IF sy-subrc <> 0.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
        ELSE.
          ls_number = zcl_qjs_number=>to_number( ls_argument ).
          IF ls_number-number_kind <> zcl_qjs_value=>number_finite.
            result = ls_number.
          ELSEIF mv_id = id_math_floor.
            result = zcl_qjs_value=>new_finite( floor( ls_number-float_value ) ).
          ELSEIF ls_number-float_value < 0
              AND ceil( ls_number-float_value ) = 0.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_zero ).
          ELSE.
            result = zcl_qjs_value=>new_finite( ceil( ls_number-float_value ) ).
          ENDIF.
        ENDIF.
      WHEN id_math_trunc.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        IF ls_number-number_kind <> zcl_qjs_value=>number_finite.
          result = ls_number.
        ELSEIF ls_number-float_value < 0 AND trunc( ls_number-float_value ) = 0.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_zero ).
        ELSE.
          result = zcl_qjs_value=>new_finite( trunc( ls_number-float_value ) ).
        ENDIF.
      WHEN id_math_round.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        IF ls_number-number_kind <> zcl_qjs_value=>number_finite.
          result = ls_number.
        ELSEIF ls_number-float_value >= -1 / 2
            AND ls_number-float_value < 0.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_zero ).
        ELSEIF trunc( ls_number-float_value ) = ls_number-float_value.
          result = ls_number.
        ELSE.
          result = zcl_qjs_value=>new_finite(
            floor( ls_number-float_value + 1 / 2 ) ).
        ENDIF.
      WHEN id_math_sign.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        IF ls_number-number_kind = zcl_qjs_value=>number_nan
            OR ls_number-number_kind = zcl_qjs_value=>number_neg_zero.
          result = ls_number.
        ELSEIF ls_number-number_kind = zcl_qjs_value=>number_neg_inf
            OR ( ls_number-number_kind = zcl_qjs_value=>number_finite
              AND ls_number-float_value < 0 ).
          result = zcl_qjs_value=>new_int( -1 ).
        ELSEIF ls_number-number_kind = zcl_qjs_value=>number_pos_inf
            OR ( ls_number-number_kind = zcl_qjs_value=>number_finite
              AND ls_number-float_value > 0 ).
          result = zcl_qjs_value=>new_int( 1 ).
        ELSE.
          result = ls_number.
        ENDIF.
      WHEN id_math_sqrt.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        IF ls_number-number_kind = zcl_qjs_value=>number_nan
            OR ls_number-number_kind = zcl_qjs_value=>number_pos_inf
            OR ls_number-number_kind = zcl_qjs_value=>number_neg_zero.
          result = ls_number.
        ELSEIF ls_number-number_kind = zcl_qjs_value=>number_neg_inf
            OR ls_number-float_value < 0.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
        ELSE.
          result = zcl_qjs_value=>new_finite( sqrt( ls_number-float_value ) ).
        ENDIF.
      WHEN id_math_exp.
        DATA lv_exp_underflow TYPE f.
        DATA lv_exp_overflow TYPE f.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        lv_exp_underflow = '-745.1332191019411'.
        lv_exp_overflow = '709.782712893384'.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        IF ls_number-number_kind = zcl_qjs_value=>number_nan
            OR ls_number-number_kind = zcl_qjs_value=>number_pos_inf.
          result = ls_number.
        ELSEIF ls_number-number_kind = zcl_qjs_value=>number_neg_inf
            OR ( ls_number-number_kind = zcl_qjs_value=>number_finite
              AND ls_number-float_value < lv_exp_underflow ).
          result = zcl_qjs_value=>new_finite( 0 ).
        ELSEIF ls_number-number_kind = zcl_qjs_value=>number_neg_zero.
          result = zcl_qjs_value=>new_finite( 1 ).
        ELSEIF ls_number-float_value > lv_exp_overflow.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
        ELSE.
          TRY.
              result = zcl_qjs_value=>new_finite( math_exp_f( ls_number-float_value ) ).
            CATCH cx_sy_arithmetic_error.
              result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
          ENDTRY.
        ENDIF.
      WHEN id_math_log OR id_math_log10 OR id_math_log2.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        IF ls_number-number_kind = zcl_qjs_value=>number_nan
            OR ls_number-number_kind = zcl_qjs_value=>number_neg_inf
            OR ( ls_number-number_kind = zcl_qjs_value=>number_finite
              AND ls_number-float_value < 0 ).
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
        ELSEIF ls_number-number_kind = zcl_qjs_value=>number_pos_inf.
          result = ls_number.
        ELSEIF ls_number-number_kind = zcl_qjs_value=>number_neg_zero
            OR ls_number-float_value = 0.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_inf ).
        ELSEIF mv_id = id_math_log10.
          result = zcl_qjs_value=>new_finite( math_log10_f( ls_number-float_value ) ).
        ELSEIF mv_id = id_math_log2.
          result = zcl_qjs_value=>new_finite(
            math_log_f( ls_number-float_value ) / CONV f( '0.6931471805599453' ) ).
        ELSE.
          result = zcl_qjs_value=>new_finite( math_log_f( ls_number-float_value ) ).
        ENDIF.
      WHEN id_math_sin OR id_math_cos OR id_math_tan.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        IF ls_number-number_kind = zcl_qjs_value=>number_nan
            OR ls_number-number_kind = zcl_qjs_value=>number_pos_inf
            OR ls_number-number_kind = zcl_qjs_value=>number_neg_inf.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
        ELSEIF mv_id <> id_math_cos
            AND ls_number-number_kind = zcl_qjs_value=>number_neg_zero.
          result = ls_number.
        ELSEIF mv_id = id_math_cos.
          result = zcl_qjs_value=>new_finite( math_cos_f( ls_number-float_value ) ).
        ELSEIF mv_id = id_math_sin.
          result = zcl_qjs_value=>new_finite( math_sin_f( ls_number-float_value ) ).
        ELSE.
          result = zcl_qjs_value=>new_finite(
            math_sin_f( ls_number-float_value )
              / math_cos_f( ls_number-float_value ) ).
        ENDIF.
      WHEN id_math_pow.
        READ TABLE arguments INDEX 2 INTO DATA(ls_pow_exponent).
        IF sy-subrc <> 0.
          ls_pow_exponent = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        result = math_pow_value( base = ls_argument exponent = ls_pow_exponent ).
      WHEN id_math_cbrt.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        IF ls_number-number_kind <> zcl_qjs_value=>number_finite
            OR ls_number-float_value = 0.
          result = ls_number.
        ELSE.
          result = zcl_qjs_value=>new_finite( math_cbrt_f( ls_number-float_value ) ).
        ENDIF.
      WHEN id_math_expm1.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        IF ls_number-number_kind = zcl_qjs_value=>number_nan
            OR ls_number-number_kind = zcl_qjs_value=>number_pos_inf
            OR ls_number-number_kind = zcl_qjs_value=>number_neg_zero.
          result = ls_number.
        ELSEIF ls_number-number_kind = zcl_qjs_value=>number_neg_inf.
          result = zcl_qjs_value=>new_finite( -1 ).
        ELSEIF ls_number-float_value > CONV f( '709.782712893384' ).
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
        ELSEIF ls_number-float_value < CONV f( '-745.1332191019411' ).
          result = zcl_qjs_value=>new_finite( -1 ).
        ELSE.
          result = zcl_qjs_value=>new_finite( math_expm1_f( ls_number-float_value ) ).
        ENDIF.
      WHEN id_math_log1p.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        IF ls_number-number_kind = zcl_qjs_value=>number_nan
            OR ls_number-number_kind = zcl_qjs_value=>number_pos_inf
            OR ls_number-number_kind = zcl_qjs_value=>number_neg_zero.
          result = ls_number.
        ELSEIF ls_number-number_kind = zcl_qjs_value=>number_neg_inf
            OR ls_number-float_value < -1.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
        ELSEIF ls_number-float_value = -1.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_inf ).
        ELSEIF abs( ls_number-float_value ) < CONV f( '0.1' ).
          result = zcl_qjs_value=>new_finite( math_log1p_f( ls_number-float_value ) ).
        ELSE.
          result = zcl_qjs_value=>new_finite(
            math_log_f( 1 + ls_number-float_value ) ).
        ENDIF.
      WHEN id_math_atan.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        IF ls_number-number_kind = zcl_qjs_value=>number_nan
            OR ls_number-number_kind = zcl_qjs_value=>number_neg_zero.
          result = ls_number.
        ELSEIF ls_number-number_kind = zcl_qjs_value=>number_pos_inf.
          result = zcl_qjs_value=>new_finite( CONV f( '1.5707963267948966' ) ).
        ELSEIF ls_number-number_kind = zcl_qjs_value=>number_neg_inf.
          result = zcl_qjs_value=>new_finite( CONV f( '-1.5707963267948966' ) ).
        ELSE.
          result = zcl_qjs_value=>new_finite( math_atan_f( ls_number-float_value ) ).
        ENDIF.
      WHEN id_math_asin OR id_math_acos.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        IF ls_number-number_kind = zcl_qjs_value=>number_nan
            OR ls_number-number_kind = zcl_qjs_value=>number_pos_inf
            OR ls_number-number_kind = zcl_qjs_value=>number_neg_inf
            OR abs( ls_number-float_value ) > 1.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
        ELSEIF mv_id = id_math_asin
            AND ls_number-number_kind = zcl_qjs_value=>number_neg_zero.
          result = ls_number.
        ELSEIF mv_id = id_math_asin AND ls_number-float_value = 1.
          result = zcl_qjs_value=>new_finite( CONV f( '1.5707963267948966' ) ).
        ELSEIF mv_id = id_math_asin AND ls_number-float_value = -1.
          result = zcl_qjs_value=>new_finite( CONV f( '-1.5707963267948966' ) ).
        ELSEIF mv_id = id_math_acos AND ls_number-float_value = 1.
          result = zcl_qjs_value=>new_finite( 0 ).
        ELSEIF mv_id = id_math_acos AND ls_number-float_value = -1.
          result = zcl_qjs_value=>new_finite( CONV f( '3.141592653589793' ) ).
        ELSE.
          DATA(lv_asin) = math_atan_f( ls_number-float_value
            / sqrt( 1 - ls_number-float_value * ls_number-float_value ) ).
          IF mv_id = id_math_asin.
            result = zcl_qjs_value=>new_finite( lv_asin ).
          ELSE.
            result = zcl_qjs_value=>new_finite(
              CONV f( '1.5707963267948966' ) - lv_asin ).
          ENDIF.
        ENDIF.
      WHEN id_math_atan2.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        READ TABLE arguments INDEX 2 INTO DATA(ls_atan2_x).
        IF sy-subrc <> 0.
          ls_atan2_x = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        result = math_atan2_value( y = ls_argument x = ls_atan2_x ).
      WHEN id_math_sinh OR id_math_cosh OR id_math_tanh.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        IF ls_number-number_kind = zcl_qjs_value=>number_nan.
          result = ls_number.
        ELSEIF mv_id = id_math_cosh
            AND ( ls_number-number_kind = zcl_qjs_value=>number_pos_inf
              OR ls_number-number_kind = zcl_qjs_value=>number_neg_inf ).
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
        ELSEIF mv_id = id_math_tanh
            AND ls_number-number_kind = zcl_qjs_value=>number_pos_inf.
          result = zcl_qjs_value=>new_finite( 1 ).
        ELSEIF mv_id = id_math_tanh
            AND ls_number-number_kind = zcl_qjs_value=>number_neg_inf.
          result = zcl_qjs_value=>new_finite( -1 ).
        ELSEIF mv_id = id_math_cosh
            AND ls_number-number_kind = zcl_qjs_value=>number_finite
            AND ls_number-float_value = 0.
          result = zcl_qjs_value=>new_finite( 1 ).
        ELSEIF mv_id <> id_math_cosh
            AND ( ls_number-number_kind = zcl_qjs_value=>number_neg_zero
              OR ls_number-float_value = 0 ).
          result = ls_number.
        ELSEIF mv_id = id_math_sinh
            AND ( ls_number-number_kind = zcl_qjs_value=>number_pos_inf
              OR ls_number-number_kind = zcl_qjs_value=>number_neg_inf ).
          result = ls_number.
        ELSEIF mv_id <> id_math_tanh
            AND abs( ls_number-float_value ) > CONV f( '710.4758600739439' ).
          IF mv_id = id_math_sinh AND ls_number-float_value < 0.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_inf ).
          ELSE.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
          ENDIF.
        ELSEIF mv_id = id_math_sinh.
          result = zcl_qjs_value=>new_finite( math_sinh_f( ls_number-float_value ) ).
        ELSEIF mv_id = id_math_cosh.
          result = zcl_qjs_value=>new_finite( math_cosh_f( ls_number-float_value ) ).
        ELSE.
          result = zcl_qjs_value=>new_finite( math_tanh_f( ls_number-float_value ) ).
        ENDIF.
      WHEN id_math_asinh.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        IF ls_number-number_kind <> zcl_qjs_value=>number_finite
            OR ls_number-float_value = 0.
          result = ls_number.
        ELSE.
          result = zcl_qjs_value=>new_finite( math_asinh_f( ls_number-float_value ) ).
        ENDIF.
      WHEN id_math_acosh.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        IF ls_number-number_kind = zcl_qjs_value=>number_pos_inf.
          result = ls_number.
        ELSEIF ls_number-number_kind <> zcl_qjs_value=>number_finite
            OR ls_number-float_value < 1.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
        ELSEIF ls_number-float_value = 1.
          result = zcl_qjs_value=>new_finite( 0 ).
        ELSE.
          result = zcl_qjs_value=>new_finite( math_acosh_f( ls_number-float_value ) ).
        ENDIF.
      WHEN id_math_atanh.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        IF ls_number-number_kind = zcl_qjs_value=>number_nan
            OR ls_number-number_kind = zcl_qjs_value=>number_neg_zero.
          result = ls_number.
        ELSEIF ls_number-number_kind <> zcl_qjs_value=>number_finite
            OR abs( ls_number-float_value ) > 1.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
        ELSEIF ls_number-float_value = 1.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
        ELSEIF ls_number-float_value = -1.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_inf ).
        ELSE.
          result = zcl_qjs_value=>new_finite( math_atanh_f( ls_number-float_value ) ).
        ENDIF.
      WHEN id_math_clz32.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lv_clz_value) = zcl_qjs_number=>to_uint32( ls_argument ).
        DATA(lv_clz_count) = 32.
        IF lv_clz_value <> 0.
          lv_clz_count = 0.
          WHILE lv_clz_value < 2147483648.
            lv_clz_value = lv_clz_value * 2.
            lv_clz_count = lv_clz_count + 1.
          ENDWHILE.
        ENDIF.
        result = zcl_qjs_value=>new_finite( CONV f( lv_clz_count ) ).
      WHEN id_math_imul.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        READ TABLE arguments INDEX 2 INTO DATA(ls_imul_right).
        IF sy-subrc <> 0.
          ls_imul_right = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lv_imul_left) = zcl_qjs_number=>to_uint32( ls_argument ).
        DATA(lv_imul_right) = zcl_qjs_number=>to_uint32( ls_imul_right ).
        DATA(lv_imul_left_low) = lv_imul_left MOD 65536.
        DATA(lv_imul_left_high) = lv_imul_left DIV 65536.
        DATA(lv_imul_right_low) = lv_imul_right MOD 65536.
        DATA(lv_imul_right_high) = lv_imul_right DIV 65536.
        DATA(lv_imul_cross) = ( lv_imul_left_high * lv_imul_right_low
          + lv_imul_left_low * lv_imul_right_high ) MOD 65536.
        DATA(lv_imul_result) = ( lv_imul_left_low * lv_imul_right_low
          + lv_imul_cross * 65536 ) MOD 4294967296.
        IF lv_imul_result >= 2147483648.
          lv_imul_result = lv_imul_result - 4294967296.
        ENDIF.
        result = zcl_qjs_value=>new_finite( CONV f( lv_imul_result ) ).
      WHEN id_math_hypot.
        DATA(lv_hypot_max) = CONV f( 0 ).
        DATA(lv_hypot_sum) = CONV f( 0 ).
        DATA(lv_hypot_nan) = abap_false.
        DATA(lv_hypot_infinite) = abap_false.
        LOOP AT arguments INTO DATA(ls_hypot_argument).
          DATA(ls_hypot_number) = zcl_qjs_number=>to_number( ls_hypot_argument ).
          IF ls_hypot_number-number_kind = zcl_qjs_value=>number_nan.
            lv_hypot_nan = abap_true.
          ELSEIF ls_hypot_number-number_kind = zcl_qjs_value=>number_pos_inf
              OR ls_hypot_number-number_kind = zcl_qjs_value=>number_neg_inf.
            lv_hypot_infinite = abap_true.
          ELSE.
            DATA(lv_hypot_absolute) = abs( ls_hypot_number-float_value ).
            IF lv_hypot_absolute > lv_hypot_max.
              IF lv_hypot_max = 0.
                lv_hypot_sum = 1.
              ELSE.
                DATA(lv_hypot_ratio) = lv_hypot_max / lv_hypot_absolute.
                lv_hypot_sum = lv_hypot_sum * lv_hypot_ratio * lv_hypot_ratio + 1.
              ENDIF.
              lv_hypot_max = lv_hypot_absolute.
            ELSEIF lv_hypot_absolute <> 0.
              lv_hypot_ratio = lv_hypot_absolute / lv_hypot_max.
              lv_hypot_sum = lv_hypot_sum + lv_hypot_ratio * lv_hypot_ratio.
            ENDIF.
          ENDIF.
        ENDLOOP.
        IF lv_hypot_infinite = abap_true.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
        ELSEIF lv_hypot_nan = abap_true.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
        ELSEIF lv_hypot_max = 0.
          result = zcl_qjs_value=>new_finite( 0 ).
        ELSE.
          result = zcl_qjs_value=>new_finite( lv_hypot_max * sqrt( lv_hypot_sum ) ).
        ENDIF.
      WHEN id_math_fround OR id_math_f16round.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        IF ls_number-number_kind <> zcl_qjs_value=>number_finite
            OR ls_number-float_value = 0.
          result = ls_number.
        ELSEIF mv_id = id_math_fround
            AND abs( ls_number-float_value ) >= CONV f( '3.4028235677973366E38' ).
          IF ls_number-float_value < 0.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_inf ).
          ELSE.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
          ENDIF.
        ELSEIF mv_id = id_math_f16round
            AND abs( ls_number-float_value ) >= 65520.
          IF ls_number-float_value < 0.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_inf ).
          ELSE.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
          ENDIF.
        ELSE.
          DATA(lv_rounded_binary) = CONV f( 0 ).
          IF mv_id = id_math_fround.
            lv_rounded_binary = math_round_binary_f(
              value = ls_number-float_value fraction_bits = 23 min_exponent = -126 ).
          ELSE.
            lv_rounded_binary = math_round_binary_f(
              value = ls_number-float_value fraction_bits = 10 min_exponent = -14 ).
          ENDIF.
          IF lv_rounded_binary = 0 AND ls_number-float_value < 0.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_zero ).
          ELSE.
            result = zcl_qjs_value=>new_finite( lv_rounded_binary ).
          ENDIF.
        ENDIF.
      WHEN id_math_random.
        IF mo_random IS NOT BOUND.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Math.random source is unavailable'.
        ENDIF.
        DATA(lv_random_integer) = mo_random->get_next( ).
        DATA(lv_random_float) = CONV f( lv_random_integer ).
        result = zcl_qjs_value=>new_finite( lv_random_float / 2147483647 ).
      WHEN id_encode_uri OR id_encode_uri_component
          OR id_decode_uri OR id_decode_uri_component.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lv_uri_source) = zcl_qjs_value=>to_string( ls_argument ).
        IF mv_id = id_encode_uri OR mv_id = id_encode_uri_component.
          result = zcl_qjs_value=>new_string( uri_encode(
            value     = lv_uri_source
            component = xsdbool( mv_id = id_encode_uri_component ) ) ).
        ELSE.
          result = zcl_qjs_value=>new_string( uri_decode(
            value     = lv_uri_source
            component = xsdbool( mv_id = id_decode_uri_component ) ) ).
        ENDIF.
      WHEN id_math_max OR id_math_min.
        LOOP AT arguments INTO ls_argument.
          ls_number = zcl_qjs_number=>to_number( ls_argument ).
          IF ls_number-number_kind = zcl_qjs_value=>number_nan.
            result = ls_number.
            RETURN.
          ENDIF.
          IF lv_first = abap_true.
            ls_best = ls_number.
            lv_first = abap_false.
          ELSEIF mv_id = id_math_max.
            IF zcl_qjs_number=>less_than( left = ls_best right = ls_number ) = abap_true
                OR ( zcl_qjs_number=>equal( left = ls_best right = ls_number ) = abap_true
                  AND ls_best-number_kind = zcl_qjs_value=>number_neg_zero
                  AND ls_number-number_kind = zcl_qjs_value=>number_finite ).
              ls_best = ls_number.
            ENDIF.
          ELSEIF zcl_qjs_number=>less_than(
              left = ls_number right = ls_best ) = abap_true
              OR ( zcl_qjs_number=>equal( left = ls_number right = ls_best ) = abap_true
                AND ls_number-number_kind = zcl_qjs_value=>number_neg_zero ).
            ls_best = ls_number.
          ENDIF.
        ENDLOOP.
        IF lv_first = abap_true.
          IF mv_id = id_math_max.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_inf ).
          ELSE.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
          ENDIF.
        ELSE.
          result = ls_best.
        ENDIF.
      WHEN id_array_is_array.
        DATA(lv_is_array) = abap_false.
        IF sy-subrc = 0 AND ls_argument-tag = zcl_qjs_value=>tag_object.
          TRY.
              lo_object ?= ls_argument-object_ref.
              lv_is_array = lo_object->is_array( ).
            CATCH cx_sy_move_cast_error.
          ENDTRY.
        ENDIF.
        result = zcl_qjs_value=>new_boolean( lv_is_array ).
      WHEN id_object_keys.
        IF sy-subrc <> 0 OR ls_argument-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Object.keys requires an object'.
        ENDIF.
        TRY.
            lo_object ?= ls_argument-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Object.keys requires an ordinary object'.
        ENDTRY.
        lt_names = lo_object->own_keys( ).
        lo_object = mo_runtime->create_array( ).
        lv_index = 0.
        LOOP AT lt_names INTO lv_name.
          lo_object->set_element(
            index = lv_index value = zcl_qjs_value=>new_string( lv_name ) ).
          lv_index = lv_index + 1.
        ENDLOOP.
        result = zcl_qjs_value=>new_object( lo_object ).
      WHEN id_object_define_property.
        READ TABLE arguments INDEX 1 INTO DATA(ls_define_target).
        IF sy-subrc <> 0 OR ls_define_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Object.defineProperty target is not an object'.
        ENDIF.
        TRY.
            lo_object ?= ls_define_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Object.defineProperty requires an ordinary object'.
        ENDTRY.
        READ TABLE arguments INDEX 2 INTO DATA(ls_define_key).
        IF sy-subrc <> 0.
          ls_define_key = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA lv_define_name TYPE string.
        IF ls_define_key-tag <> zcl_qjs_value=>tag_symbol.
          lv_define_name = zcl_qjs_value=>to_string( ls_define_key ).
        ENDIF.
        READ TABLE arguments INDEX 3 INTO DATA(ls_descriptor_value).
        IF sy-subrc <> 0 OR ls_descriptor_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: property descriptor is not an object'.
        ENDIF.
        DATA lo_descriptor_object TYPE REF TO zcl_qjs_object.
        TRY.
            lo_descriptor_object ?= ls_descriptor_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: property descriptor must be ordinary'.
        ENDTRY.
        DATA(lv_has_getter) = lo_descriptor_object->has_property( 'get' ).
        DATA(lv_has_setter) = lo_descriptor_object->has_property( 'set' ).
        DATA(lv_has_value) = lo_descriptor_object->has_property( 'value' ).
        DATA(lv_has_writable) = lo_descriptor_object->has_property( 'writable' ).
        DATA(lv_has_enumerable) = lo_descriptor_object->has_property( 'enumerable' ).
        DATA(lv_has_configurable) = lo_descriptor_object->has_property( 'configurable' ).
        DATA ls_existing_descriptor TYPE zcl_qjs_object=>ty_own_property.
        IF ls_define_key-tag = zcl_qjs_value=>tag_symbol.
          ls_existing_descriptor = lo_object->get_own_symbol_property(
            ls_define_key-symbol_id ).
        ELSE.
          ls_existing_descriptor = lo_object->get_own_property( lv_define_name ).
        ENDIF.
        IF ( lv_has_getter = abap_true OR lv_has_setter = abap_true )
            AND ( lv_has_value = abap_true OR lv_has_writable = abap_true ).
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: invalid mixed property descriptor'.
        ENDIF.
        DATA(lv_descriptor_enumerable) = abap_false.
        IF lv_has_enumerable = abap_true.
          lv_descriptor_enumerable = zcl_qjs_value=>to_boolean(
            lo_descriptor_object->get( 'enumerable' ) ).
        ELSEIF ls_existing_descriptor-found = abap_true.
          lv_descriptor_enumerable = ls_existing_descriptor-enumerable.
        ENDIF.
        DATA(lv_descriptor_configurable) = abap_false.
        IF lv_has_configurable = abap_true.
          lv_descriptor_configurable = zcl_qjs_value=>to_boolean(
            lo_descriptor_object->get( 'configurable' ) ).
        ELSEIF ls_existing_descriptor-found = abap_true.
          lv_descriptor_configurable = ls_existing_descriptor-configurable.
        ENDIF.
        DATA(lv_accessor_descriptor) = xsdbool(
          lv_has_getter = abap_true OR lv_has_setter = abap_true
          OR ( lv_has_value = abap_false AND lv_has_writable = abap_false
            AND ls_existing_descriptor-found = abap_true
            AND ls_existing_descriptor-accessor = abap_true ) ).
        IF lv_accessor_descriptor = abap_true.
          DATA(ls_descriptor_getter) = zcl_qjs_value=>new_undefined( ).
          DATA(ls_descriptor_setter) = zcl_qjs_value=>new_undefined( ).
          IF lv_has_getter = abap_true.
            ls_descriptor_getter = lo_descriptor_object->get( 'get' ).
            IF ls_descriptor_getter-tag <> zcl_qjs_value=>tag_undefined
                AND is_callable( ls_descriptor_getter ) = abap_false.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: property getter is not callable'.
            ENDIF.
          ELSEIF ls_existing_descriptor-found = abap_true
              AND ls_existing_descriptor-accessor = abap_true.
            ls_descriptor_getter = ls_existing_descriptor-getter.
          ENDIF.
          IF lv_has_setter = abap_true.
            ls_descriptor_setter = lo_descriptor_object->get( 'set' ).
            IF ls_descriptor_setter-tag <> zcl_qjs_value=>tag_undefined
                AND is_callable( ls_descriptor_setter ) = abap_false.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: property setter is not callable'.
            ENDIF.
          ELSEIF ls_existing_descriptor-found = abap_true
              AND ls_existing_descriptor-accessor = abap_true.
            ls_descriptor_setter = ls_existing_descriptor-setter.
          ENDIF.
          IF ls_define_key-tag = zcl_qjs_value=>tag_symbol.
            lo_object->define_symbol_accessor(
              identity = ls_define_key-symbol_id getter = ls_descriptor_getter
              setter = ls_descriptor_setter enumerable = lv_descriptor_enumerable
              configurable = lv_descriptor_configurable ).
          ELSE.
            lo_object->define_accessor(
              name = lv_define_name getter = ls_descriptor_getter
              setter = ls_descriptor_setter enumerable = lv_descriptor_enumerable
              configurable = lv_descriptor_configurable ).
          ENDIF.
        ELSE.
          DATA(ls_descriptor_data_value) = zcl_qjs_value=>new_undefined( ).
          IF lv_has_value = abap_true.
            ls_descriptor_data_value = lo_descriptor_object->get( 'value' ).
          ELSEIF ls_existing_descriptor-found = abap_true
              AND ls_existing_descriptor-accessor = abap_false.
            ls_descriptor_data_value = ls_existing_descriptor-value.
          ENDIF.
          DATA(lv_descriptor_writable) = abap_false.
          IF lv_has_writable = abap_true.
            lv_descriptor_writable = zcl_qjs_value=>to_boolean(
              lo_descriptor_object->get( 'writable' ) ).
          ELSEIF ls_existing_descriptor-found = abap_true
              AND ls_existing_descriptor-accessor = abap_false.
            lv_descriptor_writable = ls_existing_descriptor-writable.
          ENDIF.
          IF ls_define_key-tag = zcl_qjs_value=>tag_symbol.
            lo_object->define_symbol_property(
              identity = ls_define_key-symbol_id value = ls_descriptor_data_value
              writable = lv_descriptor_writable enumerable = lv_descriptor_enumerable
              configurable = lv_descriptor_configurable ).
          ELSE.
            lo_object->define_property(
              name = lv_define_name value = ls_descriptor_data_value
              writable = lv_descriptor_writable enumerable = lv_descriptor_enumerable
              configurable = lv_descriptor_configurable ).
          ENDIF.
        ENDIF.
        result = ls_define_target.
      WHEN id_object_get_own_descriptor.
        READ TABLE arguments INDEX 1 INTO DATA(ls_own_target).
        IF sy-subrc <> 0 OR ls_own_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: descriptor target is not an object'.
        ENDIF.
        TRY.
            lo_object ?= ls_own_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: descriptor target must be ordinary'.
        ENDTRY.
        READ TABLE arguments INDEX 2 INTO DATA(ls_own_key).
        IF sy-subrc <> 0.
          ls_own_key = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA ls_own_property TYPE zcl_qjs_object=>ty_own_property.
        IF ls_own_key-tag = zcl_qjs_value=>tag_symbol.
          ls_own_property = lo_object->get_own_symbol_property(
            ls_own_key-symbol_id ).
        ELSE.
          DATA(lv_own_name) = zcl_qjs_value=>to_string( ls_own_key ).
          ls_own_property = lo_object->get_own_property( lv_own_name ).
        ENDIF.
        IF ls_own_property-found = abap_false.
          result = zcl_qjs_value=>new_undefined( ).
        ELSE.
          DATA(lo_descriptor_result) = mo_runtime->create_object( ).
          IF ls_own_property-accessor = abap_true.
            lo_descriptor_result->set(
              name = 'get' value = ls_own_property-getter ).
            lo_descriptor_result->set(
              name = 'set' value = ls_own_property-setter ).
          ELSE.
            lo_descriptor_result->set(
              name = 'value' value = ls_own_property-value ).
            lo_descriptor_result->set(
              name = 'writable' value = zcl_qjs_value=>new_boolean(
                ls_own_property-writable ) ).
          ENDIF.
          lo_descriptor_result->set(
            name = 'enumerable' value = zcl_qjs_value=>new_boolean(
              ls_own_property-enumerable ) ).
          lo_descriptor_result->set(
            name = 'configurable' value = zcl_qjs_value=>new_boolean(
              ls_own_property-configurable ) ).
          result = zcl_qjs_value=>new_object( lo_descriptor_result ).
        ENDIF.
      WHEN id_object_create.
        READ TABLE arguments INDEX 1 INTO DATA(ls_create_prototype).
        IF sy-subrc <> 0 OR ( ls_create_prototype-tag <> zcl_qjs_value=>tag_object
            AND ls_create_prototype-tag <> zcl_qjs_value=>tag_null ).
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Object.create prototype is invalid'.
        ENDIF.
        DATA lo_created_prototype TYPE REF TO zcl_qjs_object.
        IF ls_create_prototype-tag = zcl_qjs_value=>tag_object.
          TRY.
              lo_created_prototype ?= ls_create_prototype-object_ref.
            CATCH cx_sy_move_cast_error.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: Object.create prototype must be ordinary'.
          ENDTRY.
        ENDIF.
        lo_object = mo_runtime->create_object( prototype = lo_created_prototype ).
        result = zcl_qjs_value=>new_object( lo_object ).
        READ TABLE arguments INDEX 2 INTO DATA(ls_create_properties).
        IF sy-subrc = 0 AND ls_create_properties-tag <> zcl_qjs_value=>tag_undefined.
          IF ls_create_properties-tag <> zcl_qjs_value=>tag_object.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Object.create properties are invalid'.
          ENDIF.
          DATA lo_create_properties TYPE REF TO zcl_qjs_object.
          TRY.
              lo_create_properties ?= ls_create_properties-object_ref.
            CATCH cx_sy_move_cast_error.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: Object.create properties must be ordinary'.
          ENDTRY.
          DATA(lt_create_names) = lo_create_properties->own_keys( ).
          DATA lo_define_helper TYPE REF TO zcl_qjs_native_function.
          DATA lt_define_arguments TYPE zif_qjs_callable=>ty_arguments.
          DATA ls_create_ignored TYPE zcl_qjs_value=>ty_value.
          CREATE OBJECT lo_define_helper
            EXPORTING id = id_object_define_property runtime = mo_runtime.
          LOOP AT lt_create_names INTO DATA(lv_create_name).
            CLEAR lt_define_arguments.
            APPEND result TO lt_define_arguments.
            APPEND zcl_qjs_value=>new_string( lv_create_name ) TO lt_define_arguments.
            APPEND lo_create_properties->get( lv_create_name ) TO lt_define_arguments.
            ls_create_ignored = lo_define_helper->zif_qjs_callable~call(
              this_value = zcl_qjs_value=>new_undefined( )
              arguments  = lt_define_arguments ).
          ENDLOOP.
          DATA(lt_create_symbols) = lo_create_properties->own_property_symbols( ).
          LOOP AT lt_create_symbols INTO DATA(lv_create_symbol).
            DATA(ls_create_symbol_property) =
              lo_create_properties->get_own_symbol_property( lv_create_symbol ).
            IF ls_create_symbol_property-enumerable = abap_false.
              CONTINUE.
            ENDIF.
            CLEAR lt_define_arguments.
            APPEND result TO lt_define_arguments.
            APPEND zcl_qjs_value=>new_symbol( lv_create_symbol )
              TO lt_define_arguments.
            APPEND lo_create_properties->get_symbol( lv_create_symbol )
              TO lt_define_arguments.
            ls_create_ignored = lo_define_helper->zif_qjs_callable~call(
              this_value = zcl_qjs_value=>new_undefined( )
              arguments  = lt_define_arguments ).
          ENDLOOP.
        ENDIF.
      WHEN id_object_get_prototype.
        READ TABLE arguments INDEX 1 INTO DATA(ls_proto_target).
        IF sy-subrc <> 0 OR ls_proto_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: prototype target is not an object'.
        ENDIF.
        TRY.
            lo_object ?= ls_proto_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: prototype target must be ordinary'.
        ENDTRY.
        DATA(lo_current_proto) = lo_object->get_prototype( ).
        IF lo_current_proto IS BOUND.
          result = zcl_qjs_value=>new_object( lo_current_proto ).
        ELSE.
          result = zcl_qjs_value=>new_null( ).
        ENDIF.
      WHEN id_object_set_prototype.
        READ TABLE arguments INDEX 1 INTO DATA(ls_set_proto_target).
        READ TABLE arguments INDEX 2 INTO DATA(ls_set_proto_value).
        IF ls_set_proto_target-tag <> zcl_qjs_value=>tag_object
            OR ( ls_set_proto_value-tag <> zcl_qjs_value=>tag_object
              AND ls_set_proto_value-tag <> zcl_qjs_value=>tag_null ).
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Object.setPrototypeOf arguments are invalid'.
        ENDIF.
        TRY.
            lo_object ?= ls_set_proto_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: prototype target must be ordinary'.
        ENDTRY.
        DATA lo_new_prototype TYPE REF TO zcl_qjs_object.
        IF ls_set_proto_value-tag = zcl_qjs_value=>tag_object.
          TRY.
              lo_new_prototype ?= ls_set_proto_value-object_ref.
            CATCH cx_sy_move_cast_error.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: prototype value must be ordinary'.
          ENDTRY.
        ENDIF.
        lo_object->set_prototype( lo_new_prototype ).
        result = ls_set_proto_target.
      WHEN id_object_define_properties.
        READ TABLE arguments INDEX 1 INTO DATA(ls_define_many_target).
        READ TABLE arguments INDEX 2 INTO DATA(ls_define_many_source).
        IF ls_define_many_target-tag <> zcl_qjs_value=>tag_object
            OR ls_define_many_source-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Object.defineProperties arguments are invalid'.
        ENDIF.
        DATA lo_define_many_source TYPE REF TO zcl_qjs_object.
        TRY.
            lo_object ?= ls_define_many_target-object_ref.
            lo_define_many_source ?= ls_define_many_source-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Object.defineProperties requires ordinary objects'.
        ENDTRY.
        DATA(lt_define_many_names) = lo_define_many_source->own_keys( ).
        DATA lo_define_many_helper TYPE REF TO zcl_qjs_native_function.
        DATA lt_define_many_arguments TYPE zif_qjs_callable=>ty_arguments.
        DATA ls_define_many_ignored TYPE zcl_qjs_value=>ty_value.
        CREATE OBJECT lo_define_many_helper
          EXPORTING id = id_object_define_property runtime = mo_runtime.
        LOOP AT lt_define_many_names INTO DATA(lv_define_many_name).
          CLEAR lt_define_many_arguments.
          APPEND ls_define_many_target TO lt_define_many_arguments.
          APPEND zcl_qjs_value=>new_string( lv_define_many_name )
            TO lt_define_many_arguments.
          APPEND lo_define_many_source->get( lv_define_many_name )
            TO lt_define_many_arguments.
          ls_define_many_ignored = lo_define_many_helper->zif_qjs_callable~call(
            this_value = zcl_qjs_value=>new_undefined( )
            arguments  = lt_define_many_arguments ).
        ENDLOOP.
        DATA(lt_define_many_symbols) =
          lo_define_many_source->own_property_symbols( ).
        LOOP AT lt_define_many_symbols INTO DATA(lv_define_many_symbol).
          DATA(ls_define_many_symbol_property) =
            lo_define_many_source->get_own_symbol_property(
              lv_define_many_symbol ).
          IF ls_define_many_symbol_property-enumerable = abap_false.
            CONTINUE.
          ENDIF.
          CLEAR lt_define_many_arguments.
          APPEND ls_define_many_target TO lt_define_many_arguments.
          APPEND zcl_qjs_value=>new_symbol( lv_define_many_symbol )
            TO lt_define_many_arguments.
          APPEND lo_define_many_source->get_symbol( lv_define_many_symbol )
            TO lt_define_many_arguments.
          ls_define_many_ignored = lo_define_many_helper->zif_qjs_callable~call(
            this_value = zcl_qjs_value=>new_undefined( )
            arguments  = lt_define_many_arguments ).
        ENDLOOP.
        result = ls_define_many_target.
      WHEN id_object_get_own_names.
        READ TABLE arguments INDEX 1 INTO DATA(ls_names_target).
        IF sy-subrc <> 0 OR ls_names_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: own-property-names target is invalid'.
        ENDIF.
        TRY.
            lo_object ?= ls_names_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: own-property-names target must be ordinary'.
        ENDTRY.
        DATA(lt_own_names) = lo_object->own_property_names( ).
        lo_object = mo_runtime->create_array( ).
        lv_index = 0.
        LOOP AT lt_own_names INTO lv_name.
          lo_object->set_element(
            index = lv_index value = zcl_qjs_value=>new_string( lv_name ) ).
          lv_index = lv_index + 1.
        ENDLOOP.
        result = zcl_qjs_value=>new_object( lo_object ).
      WHEN id_object_get_own_symbols.
        READ TABLE arguments INDEX 1 INTO DATA(ls_symbols_target).
        IF sy-subrc <> 0 OR ls_symbols_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: own-property-symbols target is invalid'.
        ENDIF.
        TRY.
            lo_object ?= ls_symbols_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: own-property-symbols target must be ordinary'.
        ENDTRY.
        DATA(lt_own_symbols) = lo_object->own_property_symbols( ).
        lo_object = mo_runtime->create_array( ).
        lv_index = 0.
        LOOP AT lt_own_symbols INTO DATA(lv_symbol_identity).
          lo_object->set_element(
            index = lv_index value = zcl_qjs_value=>new_symbol( lv_symbol_identity ) ).
          lv_index = lv_index + 1.
        ENDLOOP.
        result = zcl_qjs_value=>new_object( lo_object ).
      WHEN id_object_assign.
        READ TABLE arguments INDEX 1 INTO DATA(ls_assign_target).
        IF sy-subrc <> 0 OR ls_assign_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Object.assign target is not an object'.
        ENDIF.
        DATA lo_assign_target TYPE REF TO zcl_qjs_object.
        TRY.
            lo_assign_target ?= ls_assign_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Object.assign target must be ordinary'.
        ENDTRY.
        LOOP AT arguments INTO DATA(ls_assign_source) FROM 2.
          IF ls_assign_source-tag = zcl_qjs_value=>tag_null
              OR ls_assign_source-tag = zcl_qjs_value=>tag_undefined.
            CONTINUE.
          ENDIF.
          IF ls_assign_source-tag <> zcl_qjs_value=>tag_object.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Object.assign source is not an object'.
          ENDIF.
          DATA lo_assign_source TYPE REF TO zcl_qjs_object.
          TRY.
              lo_assign_source ?= ls_assign_source-object_ref.
            CATCH cx_sy_move_cast_error.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: Object.assign source must be ordinary'.
          ENDTRY.
          DATA(lt_assign_names) = lo_assign_source->own_keys( ).
          LOOP AT lt_assign_names INTO DATA(lv_assign_name).
            lo_assign_target->set(
              name = lv_assign_name value = lo_assign_source->get( lv_assign_name ) ).
          ENDLOOP.
          DATA(lt_assign_symbols) = lo_assign_source->own_property_symbols( ).
          LOOP AT lt_assign_symbols INTO DATA(lv_assign_symbol).
            DATA(ls_assign_symbol_property) =
              lo_assign_source->get_own_symbol_property( lv_assign_symbol ).
            IF ls_assign_symbol_property-enumerable = abap_true.
              DATA(ls_assign_symbol_value) =
                lo_assign_source->get_symbol( lv_assign_symbol ).
              lo_assign_target->set_symbol(
                identity = lv_assign_symbol value = ls_assign_symbol_value ).
            ENDIF.
          ENDLOOP.
        ENDLOOP.
        result = ls_assign_target.
      WHEN id_object_values OR id_object_entries.
        READ TABLE arguments INDEX 1 INTO DATA(ls_enumeration_target).
        IF sy-subrc <> 0 OR ls_enumeration_target-tag = zcl_qjs_value=>tag_null
            OR ls_enumeration_target-tag = zcl_qjs_value=>tag_undefined.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Object enumeration target is not an object'.
        ENDIF.
        IF ls_enumeration_target-tag <> zcl_qjs_value=>tag_object.
          lo_object = mo_runtime->create_array( ).
          result = zcl_qjs_value=>new_object( lo_object ).
          RETURN.
        ENDIF.
        DATA lo_enumeration_source TYPE REF TO zcl_qjs_object.
        TRY.
            lo_enumeration_source ?= ls_enumeration_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Object enumeration target must be ordinary'.
        ENDTRY.
        DATA(lt_enumeration_names) = lo_enumeration_source->own_keys( ).
        lo_object = mo_runtime->create_array( ).
        lv_index = 0.
        LOOP AT lt_enumeration_names INTO DATA(lv_enumeration_name).
          DATA(ls_enumeration_value) = lo_enumeration_source->get(
            lv_enumeration_name ).
          IF mv_id = id_object_values.
            lo_object->set_element(
              index = lv_index value = ls_enumeration_value ).
          ELSE.
            DATA(lo_entry) = mo_runtime->create_array( ).
            lo_entry->set_element(
              index = 0 value = zcl_qjs_value=>new_string( lv_enumeration_name ) ).
            lo_entry->set_element( index = 1 value = ls_enumeration_value ).
            lo_object->set_element(
              index = lv_index value = zcl_qjs_value=>new_object( lo_entry ) ).
          ENDIF.
          lv_index = lv_index + 1.
        ENDLOOP.
        result = zcl_qjs_value=>new_object( lo_object ).
      WHEN id_object_has_own.
        READ TABLE arguments INDEX 1 INTO DATA(ls_has_own_target).
        IF sy-subrc <> 0 OR ls_has_own_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Object.hasOwn target is not an object'.
        ENDIF.
        TRY.
            lo_object ?= ls_has_own_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Object.hasOwn target must be ordinary'.
        ENDTRY.
        READ TABLE arguments INDEX 2 INTO DATA(ls_has_own_key).
        IF sy-subrc <> 0.
          ls_has_own_key = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        IF ls_has_own_key-tag = zcl_qjs_value=>tag_symbol.
          result = zcl_qjs_value=>new_boolean(
            lo_object->has_own_symbol( ls_has_own_key-symbol_id ) ).
        ELSE.
          result = zcl_qjs_value=>new_boolean( lo_object->has_own(
            zcl_qjs_value=>to_string( ls_has_own_key ) ) ).
        ENDIF.
      WHEN id_object_is.
        READ TABLE arguments INDEX 1 INTO DATA(ls_is_left).
        IF sy-subrc <> 0.
          ls_is_left = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        READ TABLE arguments INDEX 2 INTO DATA(ls_is_right).
        IF sy-subrc <> 0.
          ls_is_right = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lv_same_value) = abap_false.
        IF zcl_qjs_value=>is_number( ls_is_left ) = abap_true
            AND zcl_qjs_value=>is_number( ls_is_right ) = abap_true.
          IF ls_is_left-number_kind = zcl_qjs_value=>number_nan
              AND ls_is_right-number_kind = zcl_qjs_value=>number_nan.
            lv_same_value = abap_true.
          ELSE.
            DATA(lv_left_negative_zero) = xsdbool(
              ls_is_left-number_kind = zcl_qjs_value=>number_neg_zero ).
            DATA(lv_right_negative_zero) = xsdbool(
              ls_is_right-number_kind = zcl_qjs_value=>number_neg_zero ).
            DATA(lv_left_zero) = xsdbool( lv_left_negative_zero = abap_true
              OR ( ls_is_left-tag = zcl_qjs_value=>tag_int
                AND ls_is_left-int_value = 0 )
              OR ( ls_is_left-number_kind = zcl_qjs_value=>number_finite
                AND ls_is_left-float_value = 0 ) ).
            DATA(lv_right_zero) = xsdbool( lv_right_negative_zero = abap_true
              OR ( ls_is_right-tag = zcl_qjs_value=>tag_int
                AND ls_is_right-int_value = 0 )
              OR ( ls_is_right-number_kind = zcl_qjs_value=>number_finite
                AND ls_is_right-float_value = 0 ) ).
            IF lv_left_zero = abap_true AND lv_right_zero = abap_true.
              lv_same_value = xsdbool(
                lv_left_negative_zero = lv_right_negative_zero ).
            ELSE.
              lv_same_value = zcl_qjs_number=>equal(
                left = ls_is_left right = ls_is_right ).
            ENDIF.
          ENDIF.
        ELSE.
          lv_same_value = zcl_qjs_value=>strict_equal(
            left = ls_is_left right = ls_is_right ).
        ENDIF.
        result = zcl_qjs_value=>new_boolean( lv_same_value ).
      WHEN id_json_parse.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        result = zcl_qjs_json=>parse(
          source = zcl_qjs_value=>to_string( ls_argument ) runtime = mo_runtime ).
      WHEN id_json_stringify.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        result = zcl_qjs_json=>stringify( ls_argument ).
      WHEN id_error OR id_type_error OR id_range_error OR id_syntax_error
          OR id_reference_error OR id_uri_error.
        lv_error_name = 'Error'.
        CASE mv_id.
          WHEN id_type_error. lv_error_name = 'TypeError'.
          WHEN id_range_error. lv_error_name = 'RangeError'.
          WHEN id_syntax_error. lv_error_name = 'SyntaxError'.
          WHEN id_reference_error. lv_error_name = 'ReferenceError'.
          WHEN id_uri_error. lv_error_name = 'URIError'.
        ENDCASE.
        CLEAR lv_error_message.
        IF sy-subrc = 0 AND ls_argument-tag <> zcl_qjs_value=>tag_undefined.
          lv_error_message = zcl_qjs_value=>to_string( ls_argument ).
        ENDIF.
        result = mo_runtime->create_error(
          name = lv_error_name message = lv_error_message ).
      WHEN id_error_to_string.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Error.prototype.toString receiver is invalid'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Error.prototype.toString receiver is invalid'.
        ENDTRY.
        DATA(lv_to_string_name) = zcl_qjs_value=>to_string( lo_object->get( 'name' ) ).
        DATA(lv_to_string_message) = zcl_qjs_value=>to_string(
          lo_object->get( 'message' ) ).
        IF lv_to_string_name IS INITIAL.
          result = zcl_qjs_value=>new_string( lv_to_string_message ).
        ELSEIF lv_to_string_message IS INITIAL.
          result = zcl_qjs_value=>new_string( lv_to_string_name ).
        ELSE.
          result = zcl_qjs_value=>new_string(
            lv_to_string_name && lv_error_separator && lv_to_string_message ).
        ENDIF.
      WHEN id_symbol.
        IF sy-subrc = 0 AND ls_argument-tag <> zcl_qjs_value=>tag_undefined.
          result = mo_runtime->new_symbol(
            zcl_qjs_value=>to_string( ls_argument ) ).
        ELSE.
          result = mo_runtime->new_symbol( ).
        ENDIF.
      WHEN id_symbol_for.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        result = mo_runtime->symbol_for(
          zcl_qjs_value=>to_string( ls_argument ) ).
      WHEN id_symbol_key_for.
        IF sy-subrc <> 0 OR ls_argument-tag <> zcl_qjs_value=>tag_symbol.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Symbol.keyFor requires a symbol'.
        ENDIF.
        DATA(ls_symbol_key) = mo_runtime->symbol_key_for( ls_argument ).
        IF ls_symbol_key-found = abap_true.
          result = zcl_qjs_value=>new_string( ls_symbol_key-key ).
        ELSE.
          result = zcl_qjs_value=>new_undefined( ).
        ENDIF.
      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Unknown native function'.
    ENDCASE.
  ENDMETHOD.

  METHOD zif_qjs_constructable~construct.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    DATA ls_primitive TYPE zcl_qjs_value=>ty_value.
    CASE mv_id.
      WHEN id_object OR id_array OR id_error OR id_type_error OR id_range_error
          OR id_syntax_error OR id_reference_error OR id_uri_error OR id_function.
        result = zif_qjs_callable~call(
          this_value = zcl_qjs_value=>new_undefined( ) arguments = arguments ).
      WHEN id_number OR id_string OR id_boolean.
        ls_primitive = zif_qjs_callable~call(
          this_value = zcl_qjs_value=>new_undefined( ) arguments = arguments ).
        lo_object = runtime->create_object( ).
        lo_object->define_property(
          name = '[[PrimitiveValue]]' value = ls_primitive
          writable = abap_false enumerable = abap_false configurable = abap_false ).
        result = zcl_qjs_value=>new_object( lo_object ).
      WHEN id_symbol.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'TypeError: Symbol is not a constructor'.
      WHEN id_is_nan OR id_is_finite OR id_parse_int OR id_parse_float
          OR id_number_is_nan OR id_number_is_finite OR id_number_is_integer
          OR id_number_is_safe_int OR id_math_trunc OR id_math_round
          OR id_math_sign OR id_math_sqrt OR id_object_assign
          OR id_object_values OR id_object_entries OR id_object_has_own
          OR id_object_is OR id_math_exp OR id_math_log OR id_math_log10
          OR id_math_log2 OR id_math_sin OR id_math_cos OR id_math_tan
          OR id_math_pow OR id_math_cbrt OR id_math_expm1 OR id_math_log1p
          OR id_math_atan OR id_math_asin OR id_math_acos OR id_math_atan2
          OR id_math_sinh OR id_math_cosh OR id_math_tanh OR id_math_asinh
          OR id_math_acosh OR id_math_atanh OR id_math_clz32 OR id_math_imul
          OR id_math_hypot OR id_math_fround OR id_math_f16round OR id_math_random
          OR id_encode_uri OR id_encode_uri_component
          OR id_decode_uri OR id_decode_uri_component OR id_function_call
          OR id_function_apply OR id_function_bind OR id_object_get_own_symbols
          OR id_array_push OR id_array_pop OR id_array_join
          OR id_array_index_of OR id_array_includes
          OR id_array_shift OR id_array_unshift OR id_array_reverse
          OR id_array_last_index_of OR id_array_at OR id_array_slice
          OR id_object_to_string OR id_array_for_each OR id_array_map
          OR id_array_filter OR id_array_some OR id_array_every
          OR id_array_find OR id_array_find_index OR id_array_reduce
          OR id_array_reduce_right OR id_array_fill OR id_array_copy_within.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'TypeError: global function is not a constructor'.
      WHEN id_bound_function.
        DATA(lt_construct_arguments) = mt_bound_arguments.
        APPEND LINES OF arguments TO lt_construct_arguments.
        result = runtime->construct_value(
          constructor = ms_bound_target arguments = lt_construct_arguments ).
      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Native function is not constructable'.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
