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
    CONSTANTS id_array_concat TYPE i VALUE 119.
    CONSTANTS id_array_splice TYPE i VALUE 120.
    CONSTANTS id_array_sort TYPE i VALUE 121.
    CONSTANTS id_array_find_last TYPE i VALUE 122.
    CONSTANTS id_array_find_last_index TYPE i VALUE 123.
    CONSTANTS id_array_flat TYPE i VALUE 124.
    CONSTANTS id_array_flat_map TYPE i VALUE 125.
    CONSTANTS id_array_of TYPE i VALUE 126.
    CONSTANTS id_array_to_string TYPE i VALUE 127.
    CONSTANTS id_array_to_reversed TYPE i VALUE 128.
    CONSTANTS id_array_with TYPE i VALUE 129.
    CONSTANTS id_array_to_sorted TYPE i VALUE 130.
    CONSTANTS id_array_to_spliced TYPE i VALUE 131.
    CONSTANTS id_object_has_own_property TYPE i VALUE 132.
    CONSTANTS id_object_value_of TYPE i VALUE 133.
    CONSTANTS id_object_property_is_enum TYPE i VALUE 134.
    CONSTANTS id_object_is_prototype_of TYPE i VALUE 135.
    CONSTANTS id_string_to_string TYPE i VALUE 136.
    CONSTANTS id_string_value_of TYPE i VALUE 137.
    CONSTANTS id_string_char_at TYPE i VALUE 138.
    CONSTANTS id_string_char_code_at TYPE i VALUE 139.
    CONSTANTS id_string_at TYPE i VALUE 140.
    CONSTANTS id_string_index_of TYPE i VALUE 141.
    CONSTANTS id_string_last_index_of TYPE i VALUE 142.
    CONSTANTS id_string_includes TYPE i VALUE 143.
    CONSTANTS id_string_starts_with TYPE i VALUE 144.
    CONSTANTS id_string_ends_with TYPE i VALUE 145.
    CONSTANTS id_string_slice TYPE i VALUE 146.
    CONSTANTS id_string_substring TYPE i VALUE 147.
    CONSTANTS id_string_concat TYPE i VALUE 148.
    CONSTANTS id_string_repeat TYPE i VALUE 149.
    CONSTANTS id_string_to_lower TYPE i VALUE 150.
    CONSTANTS id_string_to_upper TYPE i VALUE 151.
    CONSTANTS id_string_trim TYPE i VALUE 152.
    CONSTANTS id_string_trim_start TYPE i VALUE 153.
    CONSTANTS id_string_trim_end TYPE i VALUE 154.
    CONSTANTS id_reflect_apply TYPE i VALUE 155.
    CONSTANTS id_reflect_construct TYPE i VALUE 156.
    CONSTANTS id_reflect_define_property TYPE i VALUE 157.
    CONSTANTS id_reflect_delete_property TYPE i VALUE 158.
    CONSTANTS id_reflect_get TYPE i VALUE 159.
    CONSTANTS id_reflect_get_own_descriptor TYPE i VALUE 160.
    CONSTANTS id_reflect_get_prototype TYPE i VALUE 161.
    CONSTANTS id_reflect_has TYPE i VALUE 162.
    CONSTANTS id_reflect_is_extensible TYPE i VALUE 163.
    CONSTANTS id_reflect_own_keys TYPE i VALUE 164.
    CONSTANTS id_reflect_prevent_extensions TYPE i VALUE 165.
    CONSTANTS id_reflect_set TYPE i VALUE 166.
    CONSTANTS id_reflect_set_prototype TYPE i VALUE 167.
    CONSTANTS id_object_is_extensible TYPE i VALUE 168.
    CONSTANTS id_object_prevent_extensions TYPE i VALUE 169.
    CONSTANTS id_map TYPE i VALUE 170.
    CONSTANTS id_set TYPE i VALUE 171.
    CONSTANTS id_map_get TYPE i VALUE 172.
    CONSTANTS id_map_set TYPE i VALUE 173.
    CONSTANTS id_map_has TYPE i VALUE 174.
    CONSTANTS id_map_delete TYPE i VALUE 175.
    CONSTANTS id_map_clear TYPE i VALUE 176.
    CONSTANTS id_map_size TYPE i VALUE 177.
    CONSTANTS id_map_entries TYPE i VALUE 178.
    CONSTANTS id_map_keys TYPE i VALUE 179.
    CONSTANTS id_map_values TYPE i VALUE 180.
    CONSTANTS id_map_for_each TYPE i VALUE 181.
    CONSTANTS id_set_add TYPE i VALUE 182.
    CONSTANTS id_set_has TYPE i VALUE 183.
    CONSTANTS id_set_delete TYPE i VALUE 184.
    CONSTANTS id_set_clear TYPE i VALUE 185.
    CONSTANTS id_set_size TYPE i VALUE 186.
    CONSTANTS id_set_entries TYPE i VALUE 187.
    CONSTANTS id_set_values TYPE i VALUE 188.
    CONSTANTS id_set_for_each TYPE i VALUE 189.
    CONSTANTS id_collection_next TYPE i VALUE 190.
    CONSTANTS id_iterator_self TYPE i VALUE 191.
    CONSTANTS id_array_entries TYPE i VALUE 192.
    CONSTANTS id_array_keys TYPE i VALUE 193.
    CONSTANTS id_array_values TYPE i VALUE 194.
    CONSTANTS id_string_iterator TYPE i VALUE 195.
    CONSTANTS id_generator_next TYPE i VALUE 196.
    CONSTANTS id_generator_throw TYPE i VALUE 197.
    CONSTANTS id_generator_return TYPE i VALUE 198.
    CONSTANTS id_promise TYPE i VALUE 199.
    CONSTANTS id_promise_then TYPE i VALUE 200.
    CONSTANTS id_promise_catch TYPE i VALUE 201.
    CONSTANTS id_promise_resolve TYPE i VALUE 202.
    CONSTANTS id_promise_reject TYPE i VALUE 203.
    CONSTANTS id_promise_fulfill TYPE i VALUE 204.
    CONSTANTS id_promise_reject_fn TYPE i VALUE 205.
    CONSTANTS id_promise_finally TYPE i VALUE 206.
    CONSTANTS id_promise_finalizer TYPE i VALUE 207.
    CONSTANTS id_promise_finally_continue TYPE i VALUE 208.
    CONSTANTS id_promise_all TYPE i VALUE 209.
    CONSTANTS id_promise_race TYPE i VALUE 210.
    CONSTANTS id_promise_all_fulfill TYPE i VALUE 211.
    CONSTANTS id_promise_combinator_reject TYPE i VALUE 212.
    CONSTANTS id_promise_race_fulfill TYPE i VALUE 213.
    CONSTANTS id_aggregate_error TYPE i VALUE 214.
    CONSTANTS id_promise_all_settled TYPE i VALUE 215.
    CONSTANTS id_promise_any TYPE i VALUE 216.
    CONSTANTS id_promise_all_settled_fulfill TYPE i VALUE 217.
    CONSTANTS id_promise_all_settled_reject TYPE i VALUE 218.
    CONSTANTS id_promise_any_reject TYPE i VALUE 219.
    CONSTANTS id_promise_capability_executor TYPE i VALUE 220.
    CONSTANTS id_eval_error TYPE i VALUE 221.
    CONSTANTS id_promise_species_get TYPE i VALUE 222.
    CONSTANTS id_async_resume_fulfill TYPE i VALUE 223.
    CONSTANTS id_async_resume_reject TYPE i VALUE 224.
    CONSTANTS id_async_from_sync_next TYPE i VALUE 225.
    CONSTANTS id_async_from_sync_result TYPE i VALUE 226.
    CONSTANTS id_async_from_sync_return TYPE i VALUE 227.
    CONSTANTS id_async_generator_next TYPE i VALUE 228.
    CONSTANTS id_async_generator_throw TYPE i VALUE 229.
    CONSTANTS id_async_generator_return TYPE i VALUE 230.
    CONSTANTS id_async_gen_await_fulfill TYPE i VALUE 231.
    CONSTANTS id_async_gen_await_reject TYPE i VALUE 232.
    CONSTANTS id_async_gen_result_fulfill TYPE i VALUE 233.
    CONSTANTS id_async_gen_result_reject TYPE i VALUE 234.
    CONSTANTS id_async_from_sync_throw TYPE i VALUE 235.
    CONSTANTS id_async_gen_delegate_fulfill TYPE i VALUE 236.
    CONSTANTS id_async_gen_delegate_reject TYPE i VALUE 237.
    CONSTANTS id_regexp TYPE i VALUE 238.
    CONSTANTS id_regexp_exec TYPE i VALUE 239.
    CONSTANTS id_regexp_test TYPE i VALUE 240.
    CONSTANTS id_regexp_to_string TYPE i VALUE 241.
    CONSTANTS id_string_replace TYPE i VALUE 242.
    CONSTANTS id_string_split TYPE i VALUE 243.
    CONSTANTS id_string_substr TYPE i VALUE 244.
    METHODS constructor IMPORTING id TYPE i runtime TYPE REF TO zcl_qjs_runtime
      context TYPE REF TO zcl_qjs_context OPTIONAL
      bound_target TYPE zcl_qjs_value=>ty_value OPTIONAL
      bound_this TYPE zcl_qjs_value=>ty_value OPTIONAL
      bound_arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL.
    METHODS get_property
      IMPORTING name          TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value.
    METHODS set_property IMPORTING name TYPE string value TYPE zcl_qjs_value=>ty_value.
    TYPES: BEGIN OF ty_own_property,
      found        TYPE abap_bool,
      accessor     TYPE abap_bool,
      value        TYPE zcl_qjs_value=>ty_value,
      getter       TYPE zcl_qjs_value=>ty_value,
      setter       TYPE zcl_qjs_value=>ty_value,
      writable     TYPE abap_bool,
      enumerable   TYPE abap_bool,
      configurable TYPE abap_bool,
    END OF ty_own_property.
    METHODS define_property
      IMPORTING name TYPE string value TYPE zcl_qjs_value=>ty_value
        writable TYPE abap_bool enumerable TYPE abap_bool configurable TYPE abap_bool.
    METHODS get_own_property
      IMPORTING name          TYPE string
      RETURNING VALUE(result) TYPE ty_own_property.
    METHODS delete_property
      IMPORTING name          TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_property
      IMPORTING name          TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_symbol_property
      IMPORTING identity      TYPE i
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS define_symbol_accessor
      IMPORTING identity TYPE i getter TYPE zcl_qjs_value=>ty_value
        setter TYPE zcl_qjs_value=>ty_value enumerable TYPE abap_bool
        configurable TYPE abap_bool.
    METHODS get_own_symbol_property
      IMPORTING identity      TYPE i
      RETURNING VALUE(result) TYPE ty_own_property.
    METHODS get_symbol_with_receiver
      IMPORTING identity TYPE i receiver TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS set_internal_prototype
      IMPORTING prototype TYPE zcl_qjs_value=>ty_value.
    METHODS get_internal_prototype
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_integer,
        value             TYPE int8,
        positive_infinity TYPE abap_bool,
        negative_infinity TYPE abap_bool,
      END OF ty_integer.
    TYPES: BEGIN OF ty_property,
      name         TYPE string,
      value        TYPE zcl_qjs_value=>ty_value,
      writable     TYPE abap_bool,
      enumerable   TYPE abap_bool,
      configurable TYPE abap_bool,
    END OF ty_property.
    TYPES ty_properties TYPE HASHED TABLE OF ty_property WITH UNIQUE KEY name.
    TYPES: BEGIN OF ty_symbol_property,
      identity     TYPE i,
      value        TYPE zcl_qjs_value=>ty_value,
      getter       TYPE zcl_qjs_value=>ty_value,
      setter       TYPE zcl_qjs_value=>ty_value,
      accessor     TYPE abap_bool,
      writable     TYPE abap_bool,
      enumerable   TYPE abap_bool,
      configurable TYPE abap_bool,
    END OF ty_symbol_property.
    TYPES ty_symbol_properties TYPE HASHED TABLE OF ty_symbol_property
      WITH UNIQUE KEY identity.
    TYPES: BEGIN OF ty_promise_capability,
      promise TYPE zcl_qjs_value=>ty_value,
      resolve TYPE zcl_qjs_value=>ty_value,
      reject  TYPE zcl_qjs_value=>ty_value,
    END OF ty_promise_capability.
    TYPES: BEGIN OF ty_error_cause,
      found TYPE abap_bool,
      value TYPE zcl_qjs_value=>ty_value,
    END OF ty_error_cause.
    TYPES: BEGIN OF ty_regexp_match,
      found  TYPE abap_bool,
      offset TYPE i,
      length TYPE i,
      value  TYPE string,
    END OF ty_regexp_match.
    DATA mv_id TYPE i.
    DATA mo_runtime TYPE REF TO zcl_qjs_runtime.
    DATA mo_context TYPE REF TO zcl_qjs_context.
    DATA mo_random TYPE REF TO cl_abap_random_int.
    DATA mt_properties TYPE ty_properties.
    DATA mt_symbol_properties TYPE ty_symbol_properties.
    DATA ms_internal_prototype TYPE zcl_qjs_value=>ty_value.
    DATA ms_bound_target TYPE zcl_qjs_value=>ty_value.
    DATA ms_bound_this TYPE zcl_qjs_value=>ty_value.
    DATA mt_bound_arguments TYPE zif_qjs_callable=>ty_arguments.
    METHODS is_callable
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS is_constructable
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS get_callable_property
      IMPORTING value TYPE zcl_qjs_value=>ty_value name TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS new_promise_capability
      IMPORTING constructor   TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE ty_promise_capability
      RAISING zcx_qjs_error zcx_qjs_throw.
    METHODS promise_species_constructor
      IMPORTING promise       TYPE REF TO zcl_qjs_object
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error zcx_qjs_throw.
    METHODS get_error_cause
      IMPORTING options       TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE ty_error_cause
      RAISING zcx_qjs_error zcx_qjs_throw.
    METHODS regexp_object
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object
      RAISING zcx_qjs_error.
    METHODS regexp_find
      IMPORTING regexp TYPE REF TO zcl_qjs_object text TYPE string
        start TYPE i DEFAULT 0 sticky TYPE abap_bool DEFAULT abap_false
      RETURNING VALUE(result) TYPE ty_regexp_match
      RAISING zcx_qjs_error.
    METHODS array_to_length
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE int8
      RAISING zcx_qjs_error.
    METHODS array_length_value
      IMPORTING length        TYPE int8
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value.
    METHODS array_set_length
      IMPORTING object TYPE REF TO zcl_qjs_object length TYPE int8
      RAISING zcx_qjs_error.
    METHODS array_slice_index
      IMPORTING value TYPE zcl_qjs_value=>ty_value length TYPE int8
      RETURNING VALUE(result) TYPE int8
      RAISING zcx_qjs_error.
    METHODS array_clamped_count
      IMPORTING value TYPE zcl_qjs_value=>ty_value maximum TYPE int8
      RETURNING VALUE(result) TYPE int8
      RAISING zcx_qjs_error.
    METHODS call_array_iterator
      IMPORTING value TYPE zcl_qjs_value=>ty_value kind TYPE i
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS call_collection_next
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS call_collection_common
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
        arguments             TYPE zif_qjs_callable=>ty_arguments
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS call_array_map
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
        arguments             TYPE zif_qjs_callable=>ty_arguments
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS call_array_push
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
        arguments             TYPE zif_qjs_callable=>ty_arguments
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS call_string_index_of
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
        arguments             TYPE zif_qjs_callable=>ty_arguments
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS call_string_replace
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
        arguments             TYPE zif_qjs_callable=>ty_arguments
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS call_string_split
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
        arguments             TYPE zif_qjs_callable=>ty_arguments
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS call_object_set_prototype
      IMPORTING arguments     TYPE zif_qjs_callable=>ty_arguments
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS call_object_define_property
      IMPORTING arguments     TYPE zif_qjs_callable=>ty_arguments
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS call_slow
      IMPORTING this_value    TYPE zcl_qjs_value=>ty_value
        arguments             TYPE zif_qjs_callable=>ty_arguments
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS string_receiver
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
        exact                 TYPE abap_bool DEFAULT abap_false
      RETURNING VALUE(result) TYPE string
      RAISING zcx_qjs_error.
    METHODS primitive_value
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
        prefer_string         TYPE abap_bool DEFAULT abap_false
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS string_value
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE string
      RAISING zcx_qjs_error.
    METHODS string_integer
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE ty_integer
      RAISING zcx_qjs_error.
    METHODS string_trim_value
      IMPORTING value TYPE string trim_start TYPE abap_bool trim_end TYPE abap_bool
      RETURNING VALUE(result) TYPE string
      RAISING zcx_qjs_error.
    METHODS string_is_whitespace
      IMPORTING character     TYPE string
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS initialize_string_wrapper
      IMPORTING object TYPE REF TO zcl_qjs_object
        primitive      TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS reflect_arguments
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zif_qjs_callable=>ty_arguments
      RAISING zcx_qjs_error.
    METHODS array_sort_compare
      IMPORTING left          TYPE zcl_qjs_value=>ty_value
        right                 TYPE zcl_qjs_value=>ty_value
        comparator            TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE i
      RAISING zcx_qjs_error.
    METHODS array_flatten_into
      IMPORTING source TYPE REF TO zcl_qjs_object
        target TYPE REF TO zcl_qjs_object
        source_length TYPE int8 depth TYPE int8
        mapper TYPE zcl_qjs_value=>ty_value
        mapper_this TYPE zcl_qjs_value=>ty_value
        use_mapper TYPE abap_bool
      CHANGING target_index TYPE int8
      RAISING zcx_qjs_error.
    METHODS same_value_zero
      IMPORTING left TYPE zcl_qjs_value=>ty_value right TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS math_exp_f
      IMPORTING value         TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_log_f
      IMPORTING value         TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_log10_f
      IMPORTING value         TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_reduce_angle
      IMPORTING value         TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_sin_f
      IMPORTING value         TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_cos_f
      IMPORTING value         TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_pow_value
      IMPORTING base          TYPE zcl_qjs_value=>ty_value
        exponent              TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS math_cbrt_f
      IMPORTING value         TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_expm1_f
      IMPORTING value         TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_log1p_f
      IMPORTING value         TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_atan_f
      IMPORTING value         TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_atan2_value
      IMPORTING y TYPE zcl_qjs_value=>ty_value x TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS math_sinh_f
      IMPORTING value         TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_cosh_f
      IMPORTING value         TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_tanh_f
      IMPORTING value         TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_asinh_f
      IMPORTING value         TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_acosh_f
      IMPORTING value         TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_atanh_f
      IMPORTING value         TYPE f
      RETURNING VALUE(result) TYPE f.
    METHODS math_round_binary_f
      IMPORTING value TYPE f fraction_bits TYPE i min_exponent TYPE i
      RETURNING VALUE(result) TYPE f.
    METHODS uri_hex_value
      IMPORTING character     TYPE string
      RETURNING VALUE(result) TYPE i.
    METHODS uri_percent_byte
      IMPORTING byte          TYPE i
      RETURNING VALUE(result) TYPE string.
    METHODS uri_code_unit
      IMPORTING character     TYPE string
      RETURNING VALUE(result) TYPE i
      RAISING zcx_qjs_error.
    METHODS uri_code_point
      IMPORTING code          TYPE i
      RETURNING VALUE(result) TYPE string
      RAISING zcx_qjs_error.
    METHODS uri_is_reserved
      IMPORTING character     TYPE string
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
  METHOD regexp_object.
    IF value-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: RegExp receiver is invalid'.
    ENDIF.
    TRY.
        result ?= value-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF result IS NOT BOUND OR result->is_regexp( ) = abap_false.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: RegExp receiver is invalid'.
    ENDIF.
  ENDMETHOD.

  METHOD regexp_find.
    DATA lv_tail TYPE string.
    DATA lv_offset TYPE i.
    DATA lv_length TYPE i.
    IF start < 0 OR start > strlen( text ).
      RETURN.
    ENDIF.
    lv_tail = text+start.
    TRY.
        DATA(lo_regex) = cl_abap_regex=>create_pcre(
          pattern     = regexp->get_regexp_pattern( )
          ignore_case = xsdbool( regexp->get_regexp_flags( ) CS 'i' ) ).
        FIND FIRST OCCURRENCE OF REGEX lo_regex IN lv_tail
          MATCH OFFSET lv_offset MATCH LENGTH lv_length.
        IF sy-subrc <> 0.
          RETURN.
        ENDIF.
      CATCH cx_sy_regex.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'SyntaxError: invalid regular expression'.
    ENDTRY.
    result-offset = lv_offset + start.
    IF sticky = abap_true AND result-offset <> start.
      CLEAR result.
      RETURN.
    ENDIF.
    result-found = abap_true.
    result-length = lv_length.
    result-value = text+result-offset(result-length).
  ENDMETHOD.

  METHOD primitive_value.
    IF value-tag <> zcl_qjs_value=>tag_object.
      result = value.
      RETURN.
    ENDIF.
    DATA lv_first_name TYPE string.
    DATA lv_second_name TYPE string.
    IF prefer_string = abap_true.
      lv_first_name = `toString`.
      lv_second_name = `valueOf`.
    ELSE.
      lv_first_name = `valueOf`.
      lv_second_name = `toString`.
    ENDIF.
    DATA(ls_method) = get_callable_property(
      value = value name = lv_first_name ).
    IF is_callable( ls_method ) = abap_true.
      result = mo_runtime->invoke_callable(
        callable = ls_method this_value = value ).
      IF result-tag <> zcl_qjs_value=>tag_object.
        RETURN.
      ENDIF.
    ENDIF.
    ls_method = get_callable_property(
      value = value name = lv_second_name ).
    IF is_callable( ls_method ) = abap_true.
      result = mo_runtime->invoke_callable(
        callable = ls_method this_value = value ).
      IF result-tag <> zcl_qjs_value=>tag_object.
        RETURN.
      ENDIF.
    ENDIF.
    RAISE EXCEPTION TYPE zcx_qjs_error
      EXPORTING reason = 'TypeError: native conversion cannot produce a primitive'.
  ENDMETHOD.

  METHOD string_value.
    result = zcl_qjs_value=>to_string(
      primitive_value( value = value prefer_string = abap_true ) ).
  ENDMETHOD.

  METHOD string_receiver.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    DATA ls_primitive TYPE zcl_qjs_object=>ty_own_property.
    IF value-tag = zcl_qjs_value=>tag_string.
      result = value-string_ref->as_string( ).
      RETURN.
    ENDIF.
    IF value-tag = zcl_qjs_value=>tag_object.
      TRY.
          lo_object ?= value-object_ref.
        CATCH cx_sy_move_cast_error.
      ENDTRY.
      IF lo_object IS BOUND.
        ls_primitive = lo_object->get_own_property( '[[PrimitiveValue]]' ).
        IF ls_primitive-found = abap_true.
          IF exact = abap_true
              AND ls_primitive-value-tag <> zcl_qjs_value=>tag_string.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: String method receiver is not a string'.
          ENDIF.
          result = zcl_qjs_value=>to_string( ls_primitive-value ).
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
    IF exact = abap_true.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: String method receiver is not a string'.
    ENDIF.
    IF value-tag = zcl_qjs_value=>tag_null
        OR value-tag = zcl_qjs_value=>tag_undefined.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: String method receiver is null or undefined'.
    ENDIF.
    result = string_value( value ).
  ENDMETHOD.

  METHOD string_integer.
    DATA(ls_number) = zcl_qjs_number=>to_number(
      primitive_value( value = value ) ).
    DATA lv_max_safe_f TYPE f.
    lv_max_safe_f = '9007199254740991'.
    IF ls_number-tag = zcl_qjs_value=>tag_int.
      result-value = ls_number-int_value.
    ELSEIF ls_number-tag = zcl_qjs_value=>tag_number.
      IF ls_number-int_value = zcl_qjs_value=>number_pos_inf.
        result-positive_infinity = abap_true.
      ELSEIF ls_number-int_value = zcl_qjs_value=>number_neg_inf.
        result-negative_infinity = abap_true.
      ELSEIF ls_number-int_value = zcl_qjs_value=>number_finite.
        IF ls_number-float_value >= lv_max_safe_f.
          result-positive_infinity = abap_true.
        ELSEIF ls_number-float_value <= 0 - lv_max_safe_f.
          result-negative_infinity = abap_true.
        ELSE.
          result-value = trunc( ls_number-float_value ).
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD string_trim_value.
    DATA lv_start TYPE i.
    DATA lv_end TYPE i.
    DATA lv_character TYPE string.
    lv_end = strlen( value ).
    IF trim_start = abap_true.
      WHILE lv_start < lv_end.
        lv_character = value+lv_start(1).
        IF string_is_whitespace( lv_character ) = abap_false.
          EXIT.
        ENDIF.
        lv_start = lv_start + 1.
      ENDWHILE.
    ENDIF.
    IF trim_end = abap_true.
      WHILE lv_end > lv_start.
        DATA(lv_last) = lv_end - 1.
        lv_character = value+lv_last(1).
        IF string_is_whitespace( lv_character ) = abap_false.
          EXIT.
        ENDIF.
        lv_end = lv_end - 1.
      ENDWHILE.
    ENDIF.
    DATA(lv_length) = lv_end - lv_start.
    result = value+lv_start(lv_length).
  ENDMETHOD.

  METHOD string_is_whitespace.
    DATA(lv_code) = uri_code_unit( character ).
    result = xsdbool(
      lv_code = 9 OR lv_code = 10 OR lv_code = 11 OR lv_code = 12
      OR lv_code = 13 OR lv_code = 32 OR lv_code = 160 OR lv_code = 5760
      OR ( lv_code >= 8192 AND lv_code <= 8202 )
      OR lv_code = 8232 OR lv_code = 8233 OR lv_code = 8239
      OR lv_code = 8287 OR lv_code = 12288 OR lv_code = 65279 ).
  ENDMETHOD.

  METHOD initialize_string_wrapper.
    DATA lv_text TYPE string.
    DATA lv_index TYPE i.
    DATA lv_name TYPE string.
    IF primitive-tag <> zcl_qjs_value=>tag_string.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'String wrapper requires a string primitive'.
    ENDIF.
    lv_text = primitive-string_ref->as_string( ).
    object->define_property(
      name = '[[PrimitiveValue]]' value = primitive
      writable = abap_false enumerable = abap_false configurable = abap_false ).
    object->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( strlen( lv_text ) )
      writable = abap_false enumerable = abap_false configurable = abap_false ).
    WHILE lv_index < strlen( lv_text ).
      lv_name = lv_index.
      CONDENSE lv_name NO-GAPS.
      DATA(lv_wrapper_character) = lv_text+lv_index(1).
      object->define_property(
        name = lv_name value = zcl_qjs_value=>new_string( lv_wrapper_character )
        writable = abap_false enumerable = abap_true configurable = abap_false ).
      lv_index = lv_index + 1.
    ENDWHILE.
  ENDMETHOD.

  METHOD reflect_arguments.
    IF value-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: Reflect argument list is not an object'.
    ENDIF.
    DATA lo_arguments TYPE REF TO zcl_qjs_object.
    TRY.
        lo_arguments ?= value-object_ref.
      CATCH cx_sy_move_cast_error.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'TypeError: Reflect argument list must be ordinary'.
    ENDTRY.
    DATA(lv_argument_length) = array_to_length(
      lo_arguments->get( 'length' ) ).
    DATA lv_argument_index TYPE int8.
    WHILE lv_argument_index < lv_argument_length.
      APPEND lo_arguments->get_element( lv_argument_index ) TO result.
      lv_argument_index = lv_argument_index + 1.
    ENDWHILE.
  ENDMETHOD.

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
      IF ls_number-int_value = zcl_qjs_value=>number_pos_inf.
        result = lv_max_safe.
      ELSEIF ls_number-int_value = zcl_qjs_value=>number_finite
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
        AND ls_number-int_value = zcl_qjs_value=>number_finite.
      IF ls_number-float_value >= lv_max_safe_f.
        lv_positive_overflow = abap_true.
      ELSEIF ls_number-float_value <= 0 - lv_max_safe_f.
        lv_negative_overflow = abap_true.
      ELSE.
        lv_relative = trunc( ls_number-float_value ).
      ENDIF.
    ELSEIF ls_number-tag = zcl_qjs_value=>tag_number
        AND ls_number-int_value = zcl_qjs_value=>number_pos_inf.
      lv_positive_overflow = abap_true.
    ELSEIF ls_number-tag = zcl_qjs_value=>tag_number
        AND ls_number-int_value = zcl_qjs_value=>number_neg_inf.
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

  METHOD array_clamped_count.
    DATA(ls_number) = zcl_qjs_number=>to_number( value ).
    DATA(lv_count) = CONV int8( 0 ).
    IF ls_number-tag = zcl_qjs_value=>tag_int.
      IF ls_number-int_value > 0.
        lv_count = ls_number-int_value.
      ENDIF.
    ELSEIF ls_number-tag = zcl_qjs_value=>tag_number.
      IF ls_number-int_value = zcl_qjs_value=>number_pos_inf.
        result = maximum.
        RETURN.
      ELSEIF ls_number-int_value = zcl_qjs_value=>number_finite
          AND ls_number-float_value > 0.
        IF ls_number-float_value >= CONV f( maximum ).
          result = maximum.
          RETURN.
        ENDIF.
        lv_count = trunc( ls_number-float_value ).
      ENDIF.
    ENDIF.
    IF lv_count > maximum.
      result = maximum.
    ELSE.
      result = lv_count.
    ENDIF.
  ENDMETHOD.

  METHOD array_sort_compare.
    IF left-tag = zcl_qjs_value=>tag_undefined
        AND right-tag = zcl_qjs_value=>tag_undefined.
      RETURN.
    ELSEIF left-tag = zcl_qjs_value=>tag_undefined.
      result = 1.
      RETURN.
    ELSEIF right-tag = zcl_qjs_value=>tag_undefined.
      result = -1.
      RETURN.
    ENDIF.
    IF comparator-tag <> zcl_qjs_value=>tag_undefined.
      DATA lt_compare_arguments TYPE zif_qjs_callable=>ty_arguments.
      APPEND left TO lt_compare_arguments.
      APPEND right TO lt_compare_arguments.
      DATA(ls_compare_result) = zcl_qjs_number=>to_number(
        mo_runtime->invoke_callable(
          callable   = comparator
          this_value = zcl_qjs_value=>new_undefined( )
          arguments  = lt_compare_arguments ) ).
      IF ls_compare_result-tag = zcl_qjs_value=>tag_int.
        IF ls_compare_result-int_value < 0.
          result = -1.
        ELSEIF ls_compare_result-int_value > 0.
          result = 1.
        ENDIF.
      ELSEIF ls_compare_result-tag = zcl_qjs_value=>tag_number.
        IF ls_compare_result-int_value = zcl_qjs_value=>number_neg_inf
            OR ( ls_compare_result-int_value = zcl_qjs_value=>number_finite
              AND ls_compare_result-float_value < 0 ).
          result = -1.
        ELSEIF ls_compare_result-int_value = zcl_qjs_value=>number_pos_inf
            OR ( ls_compare_result-int_value = zcl_qjs_value=>number_finite
              AND ls_compare_result-float_value > 0 ).
          result = 1.
        ENDIF.
      ENDIF.
      RETURN.
    ENDIF.
    DATA(lv_left_string) = zcl_qjs_value=>to_string( left ).
    DATA(lv_right_string) = zcl_qjs_value=>to_string( right ).
    IF lv_left_string < lv_right_string.
      result = -1.
    ELSEIF lv_left_string > lv_right_string.
      result = 1.
    ENDIF.
  ENDMETHOD.

  METHOD array_flatten_into.
    mo_runtime->get_limits( )->consume( source_length ).
    DATA(lv_flat_source_index) = CONV int8( 0 ).
    WHILE lv_flat_source_index < source_length.
      DATA(lv_flat_source_name) = CONV string( lv_flat_source_index ).
      CONDENSE lv_flat_source_name NO-GAPS.
      IF source->has_property( lv_flat_source_name ) = abap_true.
        DATA(ls_flat_element) = source->get( lv_flat_source_name ).
        IF use_mapper = abap_true.
          DATA lt_flat_arguments TYPE zif_qjs_callable=>ty_arguments.
          APPEND ls_flat_element TO lt_flat_arguments.
          APPEND array_length_value( lv_flat_source_index ) TO lt_flat_arguments.
          APPEND zcl_qjs_value=>new_object( source ) TO lt_flat_arguments.
          ls_flat_element = mo_runtime->invoke_callable(
            callable   = mapper
            this_value = mapper_this
            arguments  = lt_flat_arguments ).
        ENDIF.
        DATA lo_flat_nested TYPE REF TO zcl_qjs_object.
        IF depth > 0 AND ls_flat_element-tag = zcl_qjs_value=>tag_object.
          TRY.
              lo_flat_nested ?= ls_flat_element-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
        ENDIF.
        IF depth > 0 AND lo_flat_nested IS BOUND
            AND lo_flat_nested->is_array( ) = abap_true.
          DATA(lv_flat_nested_length) = array_to_length(
            lo_flat_nested->get( 'length' ) ).
          mo_runtime->get_limits( )->enter_nested_frame( ).
          TRY.
              array_flatten_into(
                EXPORTING source = lo_flat_nested target = target
                  source_length = lv_flat_nested_length depth = depth - 1
                  mapper = zcl_qjs_value=>new_undefined( )
                  mapper_this = zcl_qjs_value=>new_undefined( )
                  use_mapper = abap_false
                CHANGING target_index = target_index ).
            CLEANUP.
              mo_runtime->get_limits( )->leave_nested_frame( ).
          ENDTRY.
          mo_runtime->get_limits( )->leave_nested_frame( ).
        ELSE.
          DATA lv_flat_max_array TYPE int8.
          lv_flat_max_array = '4294967295'.
          IF target_index >= lv_flat_max_array.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: flattened array is too large'.
          ENDIF.
          target->set_element( index = target_index value = ls_flat_element ).
          target_index = target_index + 1.
        ENDIF.
      ENDIF.
      lv_flat_source_index = lv_flat_source_index + 1.
    ENDWHILE.
  ENDMETHOD.

  METHOD same_value_zero.
    result = zcl_qjs_value=>strict_equal( left = left right = right ).
    IF result = abap_false
        AND left-tag = zcl_qjs_value=>tag_number
        AND right-tag = zcl_qjs_value=>tag_number
        AND left-int_value = zcl_qjs_value=>number_nan
        AND right-int_value = zcl_qjs_value=>number_nan.
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

  METHOD set_internal_prototype.
    ms_internal_prototype = prototype.
  ENDMETHOD.

  METHOD get_internal_prototype.
    result = ms_internal_prototype.
  ENDMETHOD.

  METHOD get_property.
    DATA ls_property TYPE ty_property.
    READ TABLE mt_properties WITH TABLE KEY name = name INTO ls_property.
    IF sy-subrc = 0.
      result = ls_property-value.
    ELSE.
      DATA(lo_function_prototype) = mo_runtime->get_function_prototype( ).
      WHILE lo_function_prototype IS BOUND.
        DATA(ls_prototype_property) = lo_function_prototype->get_own_property( name ).
        IF ls_prototype_property-found = abap_true.
          result = ls_prototype_property-value.
          RETURN.
        ENDIF.
        lo_function_prototype = lo_function_prototype->get_prototype( ).
      ENDWHILE.
      result = zcl_qjs_value=>new_undefined( ).
    ENDIF.
  ENDMETHOD.

  METHOD set_property.
    DATA ls_property TYPE ty_property.
    READ TABLE mt_properties WITH TABLE KEY name = name INTO ls_property.
    IF sy-subrc = 0 AND ls_property-writable = abap_false.
      RETURN.
    ENDIF.
    ls_property-name = name.
    ls_property-value = value.
    ls_property-writable = abap_true.
    ls_property-enumerable = abap_true.
    ls_property-configurable = abap_true.
    DELETE TABLE mt_properties WITH TABLE KEY name = name.
    INSERT ls_property INTO TABLE mt_properties.
  ENDMETHOD.

  METHOD define_property.
    DATA ls_property TYPE ty_property.
    ls_property-name = name.
    ls_property-value = value.
    ls_property-writable = writable.
    ls_property-enumerable = enumerable.
    ls_property-configurable = configurable.
    DELETE TABLE mt_properties WITH TABLE KEY name = name.
    INSERT ls_property INTO TABLE mt_properties.
  ENDMETHOD.

  METHOD get_own_property.
    DATA ls_property TYPE ty_property.
    READ TABLE mt_properties WITH TABLE KEY name = name INTO ls_property.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    result-found = abap_true.
    result-value = ls_property-value.
    result-writable = ls_property-writable.
    result-enumerable = ls_property-enumerable.
    result-configurable = ls_property-configurable.
  ENDMETHOD.

  METHOD delete_property.
    DATA ls_property TYPE ty_property.
    READ TABLE mt_properties WITH TABLE KEY name = name INTO ls_property.
    IF sy-subrc = 0 AND ls_property-configurable = abap_false.
      result = abap_false.
      RETURN.
    ENDIF.
    DELETE TABLE mt_properties WITH TABLE KEY name = name.
    result = abap_true.
  ENDMETHOD.

  METHOD has_property.
    READ TABLE mt_properties WITH TABLE KEY name = name TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      result = abap_true.
      RETURN.
    ENDIF.
    DATA(lo_function_prototype) = mo_runtime->get_function_prototype( ).
    IF lo_function_prototype IS BOUND.
      result = lo_function_prototype->has_property( name ).
    ENDIF.
  ENDMETHOD.

  METHOD has_symbol_property.
    READ TABLE mt_symbol_properties WITH TABLE KEY identity = identity
      TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      result = abap_true.
      RETURN.
    ENDIF.
    DATA(lo_function_prototype) = mo_runtime->get_function_prototype( ).
    IF lo_function_prototype IS BOUND.
      result = lo_function_prototype->has_symbol_property( identity ).
    ENDIF.
  ENDMETHOD.

  METHOD define_symbol_accessor.
    DATA(ls_property) = VALUE ty_symbol_property(
      identity = identity getter = getter setter = setter accessor = abap_true
      enumerable = enumerable configurable = configurable ).
    DELETE TABLE mt_symbol_properties WITH TABLE KEY identity = identity.
    INSERT ls_property INTO TABLE mt_symbol_properties.
  ENDMETHOD.

  METHOD get_own_symbol_property.
    READ TABLE mt_symbol_properties WITH TABLE KEY identity = identity
      INTO DATA(ls_property).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    result-found = abap_true.
    result-accessor = ls_property-accessor.
    result-value = ls_property-value.
    result-getter = ls_property-getter.
    result-setter = ls_property-setter.
    result-writable = ls_property-writable.
    result-enumerable = ls_property-enumerable.
    result-configurable = ls_property-configurable.
  ENDMETHOD.

  METHOD get_symbol_with_receiver.
    READ TABLE mt_symbol_properties WITH TABLE KEY identity = identity
      INTO DATA(ls_property).
    IF sy-subrc = 0.
      IF ls_property-accessor = abap_true.
        IF ls_property-getter-tag = zcl_qjs_value=>tag_undefined
            OR ls_property-getter-tag = 0.
          result = zcl_qjs_value=>new_undefined( ).
        ELSE.
          result = mo_runtime->invoke_callable(
            callable = ls_property-getter this_value = receiver ).
        ENDIF.
      ELSE.
        result = ls_property-value.
      ENDIF.
      RETURN.
    ENDIF.
    DATA(lo_function_prototype) = mo_runtime->get_function_prototype( ).
    IF lo_function_prototype IS BOUND.
      result = lo_function_prototype->reflect_get_symbol(
        identity = identity receiver = receiver ).
    ELSE.
      result = zcl_qjs_value=>new_undefined( ).
    ENDIF.
  ENDMETHOD.

  METHOD is_callable.
    DATA lo_callable TYPE REF TO zif_qjs_callable.
    result = abap_false.
    IF value-tag <> zcl_qjs_value=>tag_object.
      RETURN.
    ENDIF.
    IF value-object_ref IS INSTANCE OF zcl_qjs_closure
        OR value-object_ref IS INSTANCE OF zcl_qjs_native_function.
      result = abap_true.
      RETURN.
    ENDIF.
    TRY.
        lo_callable ?= value-object_ref.
        result = abap_true.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
  ENDMETHOD.

  METHOD is_constructable.
    DATA lo_closure TYPE REF TO zcl_qjs_closure.
    DATA lo_native TYPE REF TO zcl_qjs_native_function.
    DATA lo_constructor TYPE REF TO zif_qjs_constructable.
    result = abap_false.
    IF value-tag <> zcl_qjs_value=>tag_object.
      RETURN.
    ENDIF.
    TRY.
        lo_closure ?= value-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_closure IS BOUND.
      result = abap_true.
      RETURN.
    ENDIF.
    TRY.
        lo_native ?= value-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_native IS BOUND.
      CASE lo_native->mv_id.
        WHEN id_object OR id_array OR id_error OR id_type_error OR id_range_error
            OR id_syntax_error OR id_reference_error OR id_uri_error OR id_function
            OR id_number OR id_string OR id_boolean OR id_map OR id_set
            OR id_promise OR id_aggregate_error OR id_eval_error.
          result = abap_true.
        WHEN id_bound_function.
          result = is_constructable( lo_native->ms_bound_target ).
      ENDCASE.
      RETURN.
    ENDIF.
    TRY.
        lo_constructor ?= value-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_constructor IS BOUND.
      result = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD get_callable_property.
    DATA lo_closure TYPE REF TO zcl_qjs_closure.
    DATA lo_object TYPE REF TO zcl_qjs_object.
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
    TRY.
        lo_object ?= value-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_object IS BOUND.
      result = lo_object->get( name ).
      RETURN.
    ENDIF.
    TRY.
        lo_properties ?= value-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_properties IS BOUND.
      result = lo_properties->get_property( name ).
    ELSE.
      result = zcl_qjs_value=>new_undefined( ).
    ENDIF.
  ENDMETHOD.

  METHOD new_promise_capability.
    IF is_constructable( constructor ) = abap_false.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: Promise constructor is not constructable'.
    ENDIF.
    DATA(lo_executor) = NEW zcl_qjs_native_function(
      id = id_promise_capability_executor runtime = mo_runtime ).
    lo_executor->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 2 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    DATA lo_executor_ref TYPE REF TO object.
    lo_executor_ref = lo_executor.
    DATA lt_capability_arguments TYPE zif_qjs_callable=>ty_arguments.
    APPEND zcl_qjs_value=>new_object( lo_executor_ref ) TO lt_capability_arguments.
    result-promise = mo_runtime->construct_value(
      constructor = constructor arguments = lt_capability_arguments ).
    IF result-promise-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: Promise constructor returned a non-object'.
    ENDIF.
    DATA(ls_capability_resolve) = lo_executor->get_own_property( '[[Resolve]]' ).
    DATA(ls_capability_reject) = lo_executor->get_own_property( '[[Reject]]' ).
    IF ls_capability_resolve-found = abap_false
        OR ls_capability_reject-found = abap_false
        OR is_callable( ls_capability_resolve-value ) = abap_false
        OR is_callable( ls_capability_reject-value ) = abap_false.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: Promise capability functions are not callable'.
    ENDIF.
    result-resolve = ls_capability_resolve-value.
    result-reject = ls_capability_reject-value.
  ENDMETHOD.

  METHOD promise_species_constructor.
    DATA lv_constructor_name TYPE string VALUE 'constructor'.
    DATA(ls_constructor) = promise->get( lv_constructor_name ).
    DATA(lo_promise_prototype) = mo_runtime->get_promise_prototype( ).
    IF ls_constructor-tag = zcl_qjs_value=>tag_undefined.
      result = lo_promise_prototype->get( lv_constructor_name ).
      RETURN.
    ENDIF.
    IF ls_constructor-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: Promise constructor property is not an object'.
    ENDIF.
    DATA(ls_species_symbol) = mo_runtime->well_known_symbol( 'species' ).
    DATA ls_species TYPE zcl_qjs_value=>ty_value.
    DATA lo_species_object TYPE REF TO zcl_qjs_object.
    DATA lo_species_closure TYPE REF TO zcl_qjs_closure.
    DATA lo_species_properties TYPE REF TO zif_qjs_property_container.
    TRY.
        lo_species_object ?= ls_constructor-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_species_object IS BOUND.
      ls_species = lo_species_object->get_symbol( ls_species_symbol-int_value ).
    ELSE.
      TRY.
          lo_species_closure ?= ls_constructor-object_ref.
        CATCH cx_sy_move_cast_error.
      ENDTRY.
      IF lo_species_closure IS BOUND.
        ls_species = lo_species_closure->get_symbol_property(
          ls_species_symbol-int_value ).
      ELSE.
        TRY.
            lo_species_properties ?= ls_constructor-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
        IF lo_species_properties IS BOUND.
          ls_species = lo_species_properties->get_symbol_property(
            ls_species_symbol-int_value ).
        ENDIF.
      ENDIF.
    ENDIF.
    IF ls_species-tag = 0 OR ls_species-tag = zcl_qjs_value=>tag_undefined
        OR ls_species-tag = zcl_qjs_value=>tag_null.
      result = lo_promise_prototype->get( lv_constructor_name ).
      RETURN.
    ENDIF.
    IF is_constructable( ls_species ) = abap_false.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: Promise species is not constructable'.
    ENDIF.
    result = ls_species.
  ENDMETHOD.

  METHOD get_error_cause.
    IF options-tag <> zcl_qjs_value=>tag_object.
      RETURN.
    ENDIF.
    DATA lv_cause_name TYPE string VALUE 'cause'.
    DATA lo_cause_object TYPE REF TO zcl_qjs_object.
    DATA lo_cause_closure TYPE REF TO zcl_qjs_closure.
    DATA lo_cause_native TYPE REF TO zcl_qjs_native_function.
    TRY.
        lo_cause_object ?= options-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_cause_object IS BOUND.
      result-found = lo_cause_object->has_property( lv_cause_name ).
      IF result-found = abap_true.
        result-value = lo_cause_object->get( lv_cause_name ).
      ENDIF.
      RETURN.
    ENDIF.
    TRY.
        lo_cause_closure ?= options-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_cause_closure IS BOUND.
      result-found = lo_cause_closure->has_property( lv_cause_name ).
      IF result-found = abap_true.
        result-value = lo_cause_closure->get_property( lv_cause_name ).
      ENDIF.
      RETURN.
    ENDIF.
    TRY.
        lo_cause_native ?= options-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_cause_native IS BOUND.
      result-found = lo_cause_native->has_property( lv_cause_name ).
      IF result-found = abap_true.
        result-value = lo_cause_native->get_property( lv_cause_name ).
      ENDIF.
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

    IF ls_exponent-int_value = zcl_qjs_value=>number_nan.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    IF ls_exponent-int_value = zcl_qjs_value=>number_neg_zero
        OR ( ls_exponent-int_value = zcl_qjs_value=>number_finite
          AND ls_exponent-float_value = 0 ).
      result = zcl_qjs_value=>new_finite( 1 ).
      RETURN.
    ENDIF.
    IF ls_base-int_value = zcl_qjs_value=>number_nan.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.

    IF ls_base-int_value = zcl_qjs_value=>number_pos_inf
        OR ls_base-int_value = zcl_qjs_value=>number_neg_inf.
      lv_base_inf = abap_true.
      lv_base_abs = lv_max_finite.
    ELSEIF ls_base-int_value = zcl_qjs_value=>number_neg_zero
        OR ls_base-float_value = 0.
      lv_base_zero = abap_true.
    ELSE.
      lv_base_abs = abs( ls_base-float_value ).
    ENDIF.
    IF ls_exponent-int_value = zcl_qjs_value=>number_pos_inf
        OR ls_exponent-int_value = zcl_qjs_value=>number_neg_inf.
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
    IF ( ls_base-int_value = zcl_qjs_value=>number_neg_inf
          OR ls_base-int_value = zcl_qjs_value=>number_neg_zero
          OR ( ls_base-int_value = zcl_qjs_value=>number_finite
            AND ls_base-float_value < 0 ) )
        AND lv_exponent_odd = abap_true.
      lv_negative_result = abap_true.
    ENDIF.

    IF lv_exponent_inf = abap_true.
      IF lv_base_inf = abap_false AND lv_base_zero = abap_false
          AND lv_base_abs = 1.
        result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      ELSEIF ( ls_exponent-int_value = zcl_qjs_value=>number_pos_inf
            AND ( lv_base_inf = abap_true OR lv_base_abs > 1 ) )
          OR ( ls_exponent-int_value = zcl_qjs_value=>number_neg_inf
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
        IF result-int_value = zcl_qjs_value=>number_pos_inf.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_inf ).
        ELSEIF result-int_value = zcl_qjs_value=>number_finite
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
    IF ls_y-int_value = zcl_qjs_value=>number_nan
        OR ls_x-int_value = zcl_qjs_value=>number_nan.
      result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
      RETURN.
    ENDIF.
    IF ls_y-int_value = zcl_qjs_value=>number_neg_inf
        OR ls_y-int_value = zcl_qjs_value=>number_neg_zero
        OR ( ls_y-int_value = zcl_qjs_value=>number_finite
          AND ls_y-float_value < 0 ).
      lv_y_negative = abap_true.
    ENDIF.
    IF ls_x-int_value = zcl_qjs_value=>number_neg_inf
        OR ls_x-int_value = zcl_qjs_value=>number_neg_zero
        OR ( ls_x-int_value = zcl_qjs_value=>number_finite
          AND ls_x-float_value < 0 ).
      lv_x_negative = abap_true.
    ENDIF.
    IF ls_y-int_value = zcl_qjs_value=>number_neg_zero
        OR ( ls_y-int_value = zcl_qjs_value=>number_finite
          AND ls_y-float_value = 0 ).
      lv_y_zero = abap_true.
    ENDIF.
    IF ls_x-int_value = zcl_qjs_value=>number_neg_zero
        OR ( ls_x-int_value = zcl_qjs_value=>number_finite
          AND ls_x-float_value = 0 ).
      lv_x_zero = abap_true.
    ENDIF.
    IF ls_y-int_value = zcl_qjs_value=>number_pos_inf
        OR ls_y-int_value = zcl_qjs_value=>number_neg_inf.
      lv_y_infinite = abap_true.
    ENDIF.
    IF ls_x-int_value = zcl_qjs_value=>number_pos_inf
        OR ls_x-int_value = zcl_qjs_value=>number_neg_inf.
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
    DATA lo_getter_self TYPE REF TO object.
    lo_getter_self = me.
    result = get_symbol_with_receiver(
      identity = identity receiver = zcl_qjs_value=>new_object( lo_getter_self ) ).
  ENDMETHOD.

  METHOD zif_qjs_property_container~set_symbol_property.
    READ TABLE mt_symbol_properties WITH TABLE KEY identity = identity
      INTO DATA(ls_property).
    IF sy-subrc = 0 AND ls_property-accessor = abap_true.
      IF ls_property-setter-tag <> zcl_qjs_value=>tag_undefined
          AND ls_property-setter-tag <> 0.
        DATA lo_setter_self TYPE REF TO object.
        lo_setter_self = me.
        DATA lt_setter_arguments TYPE zif_qjs_callable=>ty_arguments.
        APPEND value TO lt_setter_arguments.
        DATA(ls_setter_result) = mo_runtime->invoke_callable(
          callable   = ls_property-setter
          this_value = zcl_qjs_value=>new_object( lo_setter_self )
          arguments  = lt_setter_arguments ).
      ENDIF.
      RETURN.
    ELSEIF sy-subrc = 0 AND ls_property-writable = abap_false.
      RETURN.
    ELSEIF sy-subrc <> 0.
      ls_property = VALUE ty_symbol_property(
        identity = identity writable = abap_true enumerable = abap_true
        configurable = abap_true ).
    ENDIF.
    ls_property-value = value.
    DELETE TABLE mt_symbol_properties WITH TABLE KEY identity = identity.
    INSERT ls_property INTO TABLE mt_symbol_properties.
  ENDMETHOD.

  METHOD zif_qjs_property_container~delete_symbol_property.
    READ TABLE mt_symbol_properties WITH TABLE KEY identity = identity
      INTO DATA(ls_property).
    IF sy-subrc = 0 AND ls_property-configurable = abap_false.
      result = abap_false.
      RETURN.
    ENDIF.
    DELETE TABLE mt_symbol_properties WITH TABLE KEY identity = identity.
    result = abap_true.
  ENDMETHOD.

  METHOD call_array_iterator.
    IF value-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: array iterator receiver is not an object'.
    ENDIF.
    DATA lo_source TYPE REF TO zcl_qjs_object.
    TRY.
        lo_source ?= value-object_ref.
      CATCH cx_sy_move_cast_error.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'TypeError: array iterator receiver is unsupported'.
    ENDTRY.
    DATA(lo_iterator) = mo_runtime->create_object(
      mo_runtime->get_array_iterator_proto( ) ).
    lo_iterator->initialize_array_iterator( array = lo_source kind = kind ).
    result = zcl_qjs_value=>new_object( lo_iterator ).
  ENDMETHOD.

  METHOD call_collection_next.
    IF value-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: iterator receiver is incompatible'.
    ENDIF.
    DATA lo_iterator TYPE REF TO zcl_qjs_object.
    TRY.
        lo_iterator ?= value-object_ref.
      CATCH cx_sy_move_cast_error.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'TypeError: iterator receiver is incompatible'.
    ENDTRY.
    IF lo_iterator->iterator_kind( ) = 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: iterator receiver is incompatible'.
    ENDIF.
    DATA(ls_entry) = lo_iterator->iterator_next( ).
    IF ls_entry-found = abap_false.
      DATA(ls_value) = zcl_qjs_value=>new_undefined( ).
    ELSEIF lo_iterator->iterator_kind( ) = zcl_qjs_object=>iterator_entries.
      DATA(lo_pair) = mo_runtime->create_array( ).
      lo_pair->set_element( index = 0 value = ls_entry-key ).
      lo_pair->set_element( index = 1 value = ls_entry-value ).
      ls_value = zcl_qjs_value=>new_object( lo_pair ).
    ELSEIF lo_iterator->iterator_kind( ) = zcl_qjs_object=>iterator_keys.
      ls_value = ls_entry-key.
    ELSE.
      ls_value = ls_entry-value.
    ENDIF.
    result = mo_runtime->create_iterator_result(
      done = xsdbool( ls_entry-found = abap_false ) value = ls_value ).
  ENDMETHOD.

  METHOD call_collection_common.
    DATA lo_collection TYPE REF TO zcl_qjs_object.
    IF value-tag = zcl_qjs_value=>tag_object
        AND value-object_ref IS INSTANCE OF zcl_qjs_object.
      lo_collection ?= value-object_ref.
    ENDIF.
    IF lo_collection IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: collection method receiver is incompatible'.
    ENDIF.
    DATA(lv_kind) = zcl_qjs_object=>collection_map.
    IF mv_id = id_set_add OR mv_id = id_set_has OR mv_id = id_set_delete.
      lv_kind = zcl_qjs_object=>collection_set.
    ENDIF.
    IF lo_collection->collection_kind( ) <> lv_kind.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: collection method receiver is incompatible'.
    ENDIF.
    READ TABLE arguments INDEX 1 INTO DATA(ls_key).
    IF sy-subrc <> 0.
      ls_key = zcl_qjs_value=>new_undefined( ).
    ENDIF.
    IF mv_id = id_map_get.
      DATA(ls_entry) = lo_collection->collection_get( ls_key ).
      IF ls_entry-found = abap_true.
        result = ls_entry-value.
      ELSE.
        result = zcl_qjs_value=>new_undefined( ).
      ENDIF.
    ELSEIF mv_id = id_map_set.
      READ TABLE arguments INDEX 2 INTO DATA(ls_map_value).
      IF sy-subrc <> 0.
        ls_map_value = zcl_qjs_value=>new_undefined( ).
      ENDIF.
      lo_collection->collection_set_entry( key = ls_key value = ls_map_value ).
      result = value.
    ELSEIF mv_id = id_set_add.
      lo_collection->collection_set_entry( key = ls_key value = ls_key ).
      result = value.
    ELSEIF mv_id = id_map_has OR mv_id = id_set_has.
      ls_entry = lo_collection->collection_get( ls_key ).
      result = zcl_qjs_value=>new_boolean( ls_entry-found ).
    ELSE.
      result = zcl_qjs_value=>new_boolean(
        lo_collection->collection_delete( ls_key ) ).
    ENDIF.
  ENDMETHOD.

  METHOD call_array_map.
    IF value-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: Array iteration receiver is not an object'.
    ENDIF.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    TRY.
        lo_object ?= value-object_ref.
      CATCH cx_sy_move_cast_error.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'TypeError: Array iteration requires an ordinary object'.
    ENDTRY.
    READ TABLE arguments INDEX 1 INTO DATA(ls_callback).
    IF sy-subrc <> 0 OR is_callable( ls_callback ) = abap_false.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: Array iteration callback is not callable'.
    ENDIF.
    READ TABLE arguments INDEX 2 INTO DATA(ls_callback_this).
    IF sy-subrc <> 0.
      ls_callback_this = zcl_qjs_value=>new_undefined( ).
    ENDIF.
    DATA(lv_length) = array_to_length( lo_object->get( 'length' ) ).
    mo_runtime->get_limits( )->consume( lv_length ).
    DATA(lo_result) = mo_runtime->create_array( ).
    lo_result->set_array_length( lv_length ).
    DATA(lv_index) = CONV int8( 0 ).
    DATA lt_callback_args TYPE zif_qjs_callable=>ty_arguments.
    WHILE lv_index < lv_length.
      DATA(lv_name) = CONV string( lv_index ).
      CONDENSE lv_name NO-GAPS.
      IF lo_object->has_property( lv_name ) = abap_true.
        CLEAR lt_callback_args.
        APPEND lo_object->get( lv_name ) TO lt_callback_args.
        APPEND array_length_value( lv_index ) TO lt_callback_args.
        APPEND value TO lt_callback_args.
        DATA(ls_callback_result) = mo_runtime->invoke_callable(
          callable = ls_callback this_value = ls_callback_this
          arguments = lt_callback_args ).
        lo_result->set_element( index = lv_index value = ls_callback_result ).
      ENDIF.
      lv_index = lv_index + 1.
    ENDWHILE.
    result = zcl_qjs_value=>new_object( lo_result ).
  ENDMETHOD.

  METHOD call_array_push.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    IF value-tag = zcl_qjs_value=>tag_object
        AND value-object_ref IS INSTANCE OF zcl_qjs_object.
      lo_object ?= value-object_ref.
    ENDIF.
    IF lo_object IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: Array method receiver is not an ordinary object'.
    ENDIF.
    DATA(lv_length) = array_to_length( lo_object->get( 'length' ) ).
    DATA lv_max_safe TYPE int8.
    lv_max_safe = '9007199254740991'.
    IF lv_length > lv_max_safe - lines( arguments ).
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: array-like length exceeds maximum safe integer'.
    ENDIF.
    mo_runtime->get_limits( )->consume( CONV int8( lines( arguments ) ) ).
    LOOP AT arguments INTO DATA(ls_argument).
      IF lo_object->is_array( ) = abap_true.
        lo_object->set_element( index = lv_length value = ls_argument ).
      ELSE.
        DATA(lv_name) = CONV string( lv_length ).
        CONDENSE lv_name NO-GAPS.
        lo_object->set( name = lv_name value = ls_argument ).
      ENDIF.
      lv_length = lv_length + 1.
    ENDLOOP.
    array_set_length( object = lo_object length = lv_length ).
    result = array_length_value( lv_length ).
  ENDMETHOD.

  METHOD call_string_index_of.
    DATA(lv_text) = string_receiver( value ).
    DATA(lv_length) = strlen( lv_text ).
    READ TABLE arguments INDEX 1 INTO DATA(ls_argument).
    IF sy-subrc = 0.
      DATA(lv_needle) = string_value( ls_argument ).
    ELSE.
      lv_needle = 'undefined'.
    ENDIF.
    READ TABLE arguments INDEX 2 INTO ls_argument.
    IF sy-subrc = 0.
      DATA(ls_integer) = string_integer( ls_argument ).
      IF ls_integer-positive_infinity = abap_true.
        DATA(lv_start) = lv_length.
      ELSEIF ls_integer-negative_infinity = abap_true.
        lv_start = 0.
      ELSE.
        lv_start = ls_integer-value.
      ENDIF.
    ELSE.
      lv_start = 0.
    ENDIF.
    IF lv_start < 0. lv_start = 0. ENDIF.
    IF lv_start > lv_length. lv_start = lv_length. ENDIF.
    DATA(lv_offset) = -1.
    IF strlen( lv_needle ) = 0.
      lv_offset = lv_start.
    ELSEIF lv_start < lv_length.
      DATA(lv_tail) = lv_text+lv_start.
      FIND FIRST OCCURRENCE OF lv_needle IN lv_tail MATCH OFFSET lv_offset.
      IF sy-subrc = 0.
        lv_offset = lv_offset + lv_start.
      ELSE.
        lv_offset = -1.
      ENDIF.
    ENDIF.
    result = zcl_qjs_value=>new_int( lv_offset ).
  ENDMETHOD.

  METHOD call_string_replace.
    DATA(lv_text) = string_receiver( value ).
    READ TABLE arguments INDEX 1 INTO DATA(ls_search).
    IF sy-subrc <> 0. ls_search = zcl_qjs_value=>new_undefined( ). ENDIF.
    READ TABLE arguments INDEX 2 INTO DATA(ls_replace_value).
    IF sy-subrc <> 0. ls_replace_value = zcl_qjs_value=>new_undefined( ). ENDIF.
    DATA(lv_replacement) = string_value( ls_replace_value ).
    DATA lo_regexp TYPE REF TO zcl_qjs_object.
    IF ls_search-tag = zcl_qjs_value=>tag_object.
      TRY.
          lo_regexp ?= ls_search-object_ref.
        CATCH cx_sy_move_cast_error.
      ENDTRY.
      IF lo_regexp IS BOUND AND lo_regexp->is_regexp( ) = abap_false.
        CLEAR lo_regexp.
      ENDIF.
    ENDIF.
    DATA lv_result TYPE string.
    IF lo_regexp IS BOUND.
      DATA(lv_global) = xsdbool( lo_regexp->get_regexp_flags( ) CS 'g' ).
      DATA(lv_cursor) = 0.
      WHILE lv_cursor <= strlen( lv_text ).
        DATA(ls_match) = regexp_find(
          regexp = lo_regexp text = lv_text start = lv_cursor ).
        IF ls_match-found = abap_false.
          lv_result = lv_result && lv_text+lv_cursor.
          EXIT.
        ENDIF.
        DATA(lv_count) = ls_match-offset - lv_cursor.
        lv_result = lv_result && lv_text+lv_cursor(lv_count) && lv_replacement.
        lv_cursor = ls_match-offset + ls_match-length.
        IF lv_global = abap_false.
          lv_result = lv_result && lv_text+lv_cursor.
          EXIT.
        ENDIF.
        IF ls_match-length = 0.
          IF lv_cursor >= strlen( lv_text ). EXIT. ENDIF.
          lv_result = lv_result && lv_text+lv_cursor(1).
          lv_cursor = lv_cursor + 1.
        ENDIF.
      ENDWHILE.
      lo_regexp->set( name = 'lastIndex' value = zcl_qjs_value=>new_int( 0 ) ).
    ELSE.
      DATA(lv_needle) = string_value( ls_search ).
      DATA(lv_offset) = -1.
      FIND FIRST OCCURRENCE OF lv_needle IN lv_text MATCH OFFSET lv_offset.
      IF sy-subrc <> 0.
        lv_result = lv_text.
      ELSE.
        lv_count = strlen( lv_needle ).
        DATA(lv_start) = lv_offset + lv_count.
        lv_result = lv_text(lv_offset) && lv_replacement && lv_text+lv_start.
      ENDIF.
    ENDIF.
    result = zcl_qjs_value=>new_string( lv_result ).
  ENDMETHOD.

  METHOD call_string_split.
    DATA(lv_text) = string_receiver( value ).
    DATA(lo_result) = mo_runtime->create_array( ).
    READ TABLE arguments INDEX 1 INTO DATA(ls_separator).
    IF sy-subrc <> 0 OR ls_separator-tag = zcl_qjs_value=>tag_undefined.
      lo_result->set_element(
        index = 0 value = zcl_qjs_value=>new_string( lv_text ) ).
    ELSE.
      DATA(lv_needle) = string_value( ls_separator ).
      DATA(lv_cursor) = 0.
      DATA(lv_index) = CONV int8( 0 ).
      DATA lv_piece TYPE string.
      IF lv_needle IS INITIAL.
        WHILE lv_cursor < strlen( lv_text ).
          lv_piece = lv_text+lv_cursor(1).
          lo_result->set_element(
            index = lv_index value = zcl_qjs_value=>new_string( lv_piece ) ).
          lv_cursor = lv_cursor + 1.
          lv_index = lv_index + 1.
        ENDWHILE.
      ELSE.
        WHILE lv_cursor <= strlen( lv_text ).
          DATA(lv_tail) = lv_text+lv_cursor.
          DATA(lv_offset) = -1.
          FIND FIRST OCCURRENCE OF lv_needle IN lv_tail MATCH OFFSET lv_offset.
          IF sy-subrc <> 0.
            lv_piece = lv_text+lv_cursor.
            lo_result->set_element(
              index = lv_index value = zcl_qjs_value=>new_string( lv_piece ) ).
            EXIT.
          ENDIF.
          lv_piece = lv_text+lv_cursor(lv_offset).
          lo_result->set_element(
            index = lv_index value = zcl_qjs_value=>new_string( lv_piece ) ).
          lv_cursor = lv_cursor + lv_offset + strlen( lv_needle ).
          lv_index = lv_index + 1.
        ENDWHILE.
      ENDIF.
    ENDIF.
    result = zcl_qjs_value=>new_object( lo_result ).
  ENDMETHOD.

  METHOD call_object_set_prototype.
    READ TABLE arguments INDEX 1 INTO DATA(ls_target).
    READ TABLE arguments INDEX 2 INTO DATA(ls_prototype_value).
    IF ls_target-tag <> zcl_qjs_value=>tag_object
        OR ( ls_prototype_value-tag <> zcl_qjs_value=>tag_object
          AND ls_prototype_value-tag <> zcl_qjs_value=>tag_null ).
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: Object.setPrototypeOf arguments are invalid'.
    ENDIF.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    DATA lo_target_closure TYPE REF TO zcl_qjs_closure.
    TRY.
        lo_object ?= ls_target-object_ref.
      CATCH cx_sy_move_cast_error.
        TRY.
            lo_target_closure ?= ls_target-object_ref.
            lo_object = lo_target_closure->get_property_storage( ).
          CATCH cx_sy_move_cast_error.
        ENDTRY.
        IF lo_object IS NOT BOUND.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: prototype target must be ordinary'.
        ENDIF.
    ENDTRY.
    DATA lo_new_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_base_closure TYPE REF TO zcl_qjs_closure.
    DATA(lv_constructable_base) = abap_false.
    IF ls_prototype_value-tag = zcl_qjs_value=>tag_object.
      IF lo_target_closure IS BOUND
          AND is_constructable( ls_prototype_value ) = abap_true.
        lv_constructable_base = abap_true.
      ENDIF.
      TRY.
          lo_new_prototype ?= ls_prototype_value-object_ref.
        CATCH cx_sy_move_cast_error.
          TRY.
              lo_base_closure ?= ls_prototype_value-object_ref.
              lo_new_prototype = lo_base_closure->get_property_storage( ).
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_new_prototype IS NOT BOUND.
            IF lv_constructable_base = abap_true.
              lo_new_prototype = mo_runtime->get_function_prototype( ).
            ELSE.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: prototype value must be ordinary'.
            ENDIF.
          ENDIF.
      ENDTRY.
    ENDIF.
    lo_object->set_prototype( lo_new_prototype ).
    IF lo_target_closure IS BOUND AND lv_constructable_base = abap_true.
      lo_target_closure->set_base_constructor( ls_prototype_value ).
    ENDIF.
    result = ls_target.
  ENDMETHOD.




  METHOD call_object_define_property.
    DATA lo_object TYPE REF TO zcl_qjs_object.
        READ TABLE arguments INDEX 1 INTO DATA(ls_define_target).
        IF sy-subrc <> 0 OR ls_define_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Object.defineProperty target is not an object'.
        ENDIF.
        TRY.
            lo_object ?= ls_define_target-object_ref.
          CATCH cx_sy_move_cast_error.
            DATA lo_define_closure TYPE REF TO zcl_qjs_closure.
            TRY.
                lo_define_closure ?= ls_define_target-object_ref.
                lo_object = lo_define_closure->get_property_storage( ).
              CATCH cx_sy_move_cast_error.
            ENDTRY.
        ENDTRY.
        IF lo_object IS NOT BOUND.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Object.defineProperty target is unsupported'.
        ENDIF.
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
            ls_define_key-int_value ).
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
              identity = ls_define_key-int_value getter = ls_descriptor_getter
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
              identity = ls_define_key-int_value value = ls_descriptor_data_value
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
  ENDMETHOD.

  METHOD zif_qjs_callable~call.
    IF mv_id = id_collection_next.
      result = call_collection_next( this_value ).
    ELSEIF mv_id = id_map_get OR mv_id = id_map_set OR mv_id = id_map_has
        OR mv_id = id_map_delete OR mv_id = id_set_add OR mv_id = id_set_has
        OR mv_id = id_set_delete.
      result = call_collection_common( value = this_value arguments = arguments ).
    ELSEIF mv_id = id_array_entries.
      result = call_array_iterator(
        value = this_value kind = zcl_qjs_object=>iterator_entries ).
    ELSEIF mv_id = id_array_keys.
      result = call_array_iterator(
        value = this_value kind = zcl_qjs_object=>iterator_keys ).
    ELSEIF mv_id = id_array_values.
      result = call_array_iterator(
        value = this_value kind = zcl_qjs_object=>iterator_values ).
    ELSEIF mv_id = id_array_map.
      result = call_array_map( value = this_value arguments = arguments ).
    ELSEIF mv_id = id_string_index_of.
      result = call_string_index_of( value = this_value arguments = arguments ).
    ELSEIF mv_id = id_string_replace.
      result = call_string_replace( value = this_value arguments = arguments ).
    ELSEIF mv_id = id_string_split.
      result = call_string_split( value = this_value arguments = arguments ).
    ELSEIF mv_id = id_object_define_property.
      result = call_object_define_property( arguments ).
    ELSEIF mv_id = id_object_set_prototype.
      result = call_object_set_prototype( arguments ).
    ELSEIF mv_id = id_array_push.
      result = call_array_push( value = this_value arguments = arguments ).
    ELSEIF mv_id = id_string_to_upper.
      result = zcl_qjs_value=>new_string(
        to_upper( val = string_receiver( this_value ) ) ).
    ELSE.
      result = call_slow( this_value = this_value arguments = arguments ).
    ENDIF.
  ENDMETHOD.



  METHOD call_slow.
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
    DATA lv_text_string TYPE string.
    DATA lv_needle_string TYPE string.
    DATA lv_string_result TYPE string.
    DATA lv_string_length TYPE i.
    DATA lv_string_start TYPE i.
    DATA lv_string_end TYPE i.
    DATA lv_string_offset TYPE i.
    DATA lv_string_count TYPE i.
    DATA ls_string_integer TYPE ty_integer.
    DATA lt_empty_combinator_arguments TYPE zif_qjs_callable=>ty_arguments.
    DATA ls_empty_combinator_result TYPE zcl_qjs_value=>ty_value.
    DATA lt_combinator_error_arguments TYPE zif_qjs_callable=>ty_arguments.
    DATA ls_combinator_rejected TYPE zcl_qjs_value=>ty_value.
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
              AND ls_length-int_value = zcl_qjs_value=>number_finite
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
      WHEN id_regexp.
        DATA lv_regexp_pattern TYPE string.
        DATA lv_regexp_flags TYPE string.
        READ TABLE arguments INDEX 1 INTO DATA(ls_regexp_pattern_arg).
        IF sy-subrc = 0 AND ls_regexp_pattern_arg-tag = zcl_qjs_value=>tag_object.
          DATA lo_pattern_regexp TYPE REF TO zcl_qjs_object.
          TRY.
              lo_pattern_regexp ?= ls_regexp_pattern_arg-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
        ENDIF.
        READ TABLE arguments INDEX 2 INTO DATA(ls_regexp_flags_arg).
        IF lo_pattern_regexp IS BOUND
            AND lo_pattern_regexp->is_regexp( ) = abap_true.
          lv_regexp_pattern = lo_pattern_regexp->get_regexp_pattern( ).
          IF sy-subrc <> 0 OR ls_regexp_flags_arg-tag = zcl_qjs_value=>tag_undefined.
            lv_regexp_flags = lo_pattern_regexp->get_regexp_flags( ).
          ENDIF.
        ELSEIF sy-subrc = 0
            AND ls_regexp_pattern_arg-tag <> zcl_qjs_value=>tag_undefined.
          lv_regexp_pattern = string_value( ls_regexp_pattern_arg ).
        ENDIF.
        IF ls_regexp_flags_arg-tag <> 0
            AND ls_regexp_flags_arg-tag <> zcl_qjs_value=>tag_undefined.
          lv_regexp_flags = string_value( ls_regexp_flags_arg ).
        ENDIF.
        DATA(lo_created_regexp) = mo_runtime->create_regexp(
          pattern = lv_regexp_pattern flags = lv_regexp_flags ).
        result = zcl_qjs_value=>new_object( lo_created_regexp ).
      WHEN id_regexp_test OR id_regexp_exec.
        DATA(lo_test_regexp) = regexp_object( this_value ).
        READ TABLE arguments INDEX 1 INTO DATA(ls_regexp_text_arg).
        IF sy-subrc <> 0.
          ls_regexp_text_arg = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lv_regexp_text) = string_value( ls_regexp_text_arg ).
        DATA(lv_regexp_global) = xsdbool(
          lo_test_regexp->get_regexp_flags( ) CS 'g' ).
        DATA(lv_regexp_sticky) = xsdbool(
          lo_test_regexp->get_regexp_flags( ) CS 'y' ).
        DATA(lv_regexp_start) = 0.
        IF lv_regexp_global = abap_true OR lv_regexp_sticky = abap_true.
          DATA(ls_last_index) = lo_test_regexp->get( 'lastIndex' ).
          DATA(ls_last_integer) = string_integer( ls_last_index ).
          lv_regexp_start = ls_last_integer-value.
        ENDIF.
        DATA(ls_regexp_match) = regexp_find(
          regexp = lo_test_regexp text = lv_regexp_text start = lv_regexp_start
          sticky = lv_regexp_sticky ).
        IF ls_regexp_match-found = abap_false.
          IF lv_regexp_global = abap_true OR lv_regexp_sticky = abap_true.
            lo_test_regexp->set(
              name = 'lastIndex' value = zcl_qjs_value=>new_int( 0 ) ).
          ENDIF.
          IF mv_id = id_regexp_test.
            result = zcl_qjs_value=>new_boolean( abap_false ).
          ELSE.
            result = zcl_qjs_value=>new_null( ).
          ENDIF.
        ELSE.
          IF lv_regexp_global = abap_true OR lv_regexp_sticky = abap_true.
            lo_test_regexp->set(
              name = 'lastIndex' value = zcl_qjs_value=>new_int(
                ls_regexp_match-offset + ls_regexp_match-length ) ).
          ENDIF.
          IF mv_id = id_regexp_test.
            result = zcl_qjs_value=>new_boolean( abap_true ).
          ELSE.
            DATA(lo_match_array) = mo_runtime->create_array( ).
            lo_match_array->set_element(
              index = 0 value = zcl_qjs_value=>new_string( ls_regexp_match-value ) ).
            lo_match_array->define_property(
              name = 'index' value = zcl_qjs_value=>new_int( ls_regexp_match-offset )
              writable = abap_true enumerable = abap_false configurable = abap_true ).
            lo_match_array->define_property(
              name = 'input' value = zcl_qjs_value=>new_string( lv_regexp_text )
              writable = abap_true enumerable = abap_false configurable = abap_true ).
            result = zcl_qjs_value=>new_object( lo_match_array ).
          ENDIF.
        ENDIF.
      WHEN id_regexp_to_string.
        DATA(lo_string_regexp) = regexp_object( this_value ).
        result = zcl_qjs_value=>new_string(
          '/' && lo_string_regexp->get_regexp_pattern( ) && '/'
            && lo_string_regexp->get_regexp_flags( ) ).
      WHEN id_number.
        IF sy-subrc = 0.
          result = zcl_qjs_number=>to_number( ls_argument ).
        ELSE.
          result = zcl_qjs_value=>new_int( 0 ).
        ENDIF.
      WHEN id_map OR id_set.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'TypeError: collection constructor requires new'.
      WHEN id_string.
        IF sy-subrc = 0 AND ls_argument-tag = zcl_qjs_value=>tag_symbol.
          result = zcl_qjs_value=>new_string(
            'Symbol(' && mo_runtime->symbol_description( ls_argument ) && ')' ).
        ELSEIF sy-subrc = 0.
          result = zcl_qjs_value=>new_string( string_value( ls_argument ) ).
        ELSE.
          result = zcl_qjs_value=>new_string( '' ).
        ENDIF.
      WHEN id_string_to_string OR id_string_value_of.
        lv_text_string = string_receiver( value = this_value exact = abap_true ).
        result = zcl_qjs_value=>new_string( lv_text_string ).
      WHEN id_string_char_at OR id_string_char_code_at OR id_string_at.
        lv_text_string = string_receiver( this_value ).
        lv_string_length = strlen( lv_text_string ).
        READ TABLE arguments INDEX 1 INTO ls_argument.
        IF sy-subrc = 0.
          ls_string_integer = string_integer( ls_argument ).
        ELSE.
          CLEAR ls_string_integer.
        ENDIF.
        IF ls_string_integer-positive_infinity = abap_true
            OR ls_string_integer-negative_infinity = abap_true.
          lv_string_start = -1.
        ELSE.
          lv_string_start = ls_string_integer-value.
          IF mv_id = id_string_at AND lv_string_start < 0.
            lv_string_start = lv_string_length + lv_string_start.
          ENDIF.
        ENDIF.
        IF lv_string_start < 0 OR lv_string_start >= lv_string_length.
          IF mv_id = id_string_char_code_at.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
          ELSEIF mv_id = id_string_at.
            result = zcl_qjs_value=>new_undefined( ).
          ELSE.
            result = zcl_qjs_value=>new_string( '' ).
          ENDIF.
        ELSE.
          DATA(lv_string_character) = lv_text_string+lv_string_start(1).
          IF mv_id = id_string_char_code_at.
            result = zcl_qjs_value=>new_int( uri_code_unit( lv_string_character ) ).
          ELSE.
            result = zcl_qjs_value=>new_string( lv_string_character ).
          ENDIF.
        ENDIF.
      WHEN id_string_index_of OR id_string_includes
          OR id_string_starts_with.
        lv_text_string = string_receiver( this_value ).
        lv_string_length = strlen( lv_text_string ).
        READ TABLE arguments INDEX 1 INTO ls_argument.
        IF sy-subrc = 0.
          lv_needle_string = string_value( ls_argument ).
        ELSE.
          lv_needle_string = 'undefined'.
        ENDIF.
        READ TABLE arguments INDEX 2 INTO ls_argument.
        IF sy-subrc = 0.
          ls_string_integer = string_integer( ls_argument ).
          IF ls_string_integer-positive_infinity = abap_true.
            lv_string_start = lv_string_length.
          ELSEIF ls_string_integer-negative_infinity = abap_true.
            lv_string_start = 0.
          ELSE.
            lv_string_start = ls_string_integer-value.
          ENDIF.
        ELSE.
          lv_string_start = 0.
        ENDIF.
        IF lv_string_start < 0. lv_string_start = 0. ENDIF.
        IF lv_string_start > lv_string_length.
          lv_string_start = lv_string_length.
        ENDIF.
        lv_string_offset = -1.
        IF strlen( lv_needle_string ) = 0.
          lv_string_offset = lv_string_start.
        ELSEIF lv_string_start < lv_string_length.
          DATA(lv_string_tail) = lv_text_string+lv_string_start.
          FIND FIRST OCCURRENCE OF lv_needle_string IN lv_string_tail
            MATCH OFFSET lv_string_offset.
          IF sy-subrc = 0.
            lv_string_offset = lv_string_offset + lv_string_start.
          ELSE.
            lv_string_offset = -1.
          ENDIF.
        ENDIF.
        IF mv_id = id_string_index_of.
          result = zcl_qjs_value=>new_int( lv_string_offset ).
        ELSEIF mv_id = id_string_includes.
          result = zcl_qjs_value=>new_boolean(
            xsdbool( lv_string_offset >= 0 ) ).
        ELSE.
          result = zcl_qjs_value=>new_boolean(
            xsdbool( lv_string_offset = lv_string_start ) ).
        ENDIF.
      WHEN id_string_last_index_of.
        lv_text_string = string_receiver( this_value ).
        lv_string_length = strlen( lv_text_string ).
        READ TABLE arguments INDEX 1 INTO ls_argument.
        IF sy-subrc = 0.
          lv_needle_string = string_value( ls_argument ).
        ELSE.
          lv_needle_string = 'undefined'.
        ENDIF.
        READ TABLE arguments INDEX 2 INTO ls_argument.
        IF sy-subrc = 0.
          ls_string_integer = string_integer( ls_argument ).
          IF ls_string_integer-negative_infinity = abap_true.
            lv_string_start = 0.
          ELSEIF ls_string_integer-positive_infinity = abap_true.
            lv_string_start = lv_string_length.
          ELSE.
            lv_string_start = ls_string_integer-value.
          ENDIF.
        ELSE.
          lv_string_start = lv_string_length.
        ENDIF.
        IF lv_string_start < 0. lv_string_start = 0. ENDIF.
        IF lv_string_start > lv_string_length.
          lv_string_start = lv_string_length.
        ENDIF.
        lv_string_start = nmin(
          val1 = lv_string_start
          val2 = lv_string_length - strlen( lv_needle_string ) ).
        lv_string_offset = -1.
        IF strlen( lv_needle_string ) = 0.
          lv_string_offset = nmax( val1 = 0 val2 = lv_string_start ).
        ELSEIF lv_string_start >= 0.
          lv_string_offset = lv_string_start.
          lv_string_count = strlen( lv_needle_string ).
          WHILE lv_string_offset >= 0.
            DATA(lv_string_candidate) =
              lv_text_string+lv_string_offset(lv_string_count).
            IF lv_string_candidate = lv_needle_string.
              EXIT.
            ENDIF.
            lv_string_offset = lv_string_offset - 1.
          ENDWHILE.
        ENDIF.
        result = zcl_qjs_value=>new_int( lv_string_offset ).
      WHEN id_string_ends_with.
        lv_text_string = string_receiver( this_value ).
        lv_string_length = strlen( lv_text_string ).
        READ TABLE arguments INDEX 1 INTO ls_argument.
        IF sy-subrc = 0.
          lv_needle_string = string_value( ls_argument ).
        ELSE.
          lv_needle_string = 'undefined'.
        ENDIF.
        READ TABLE arguments INDEX 2 INTO ls_argument.
        IF sy-subrc = 0.
          ls_string_integer = string_integer( ls_argument ).
          IF ls_string_integer-positive_infinity = abap_true.
            lv_string_end = lv_string_length.
          ELSEIF ls_string_integer-negative_infinity = abap_true.
            lv_string_end = 0.
          ELSE.
            lv_string_end = ls_string_integer-value.
          ENDIF.
        ELSE.
          lv_string_end = lv_string_length.
        ENDIF.
        IF lv_string_end < 0. lv_string_end = 0. ENDIF.
        IF lv_string_end > lv_string_length. lv_string_end = lv_string_length. ENDIF.
        lv_string_start = lv_string_end - strlen( lv_needle_string ).
        IF lv_string_start < 0.
          result = zcl_qjs_value=>new_boolean( abap_false ).
        ELSE.
          lv_string_count = strlen( lv_needle_string ).
          result = zcl_qjs_value=>new_boolean(
            xsdbool( lv_text_string+lv_string_start(lv_string_count)
              = lv_needle_string ) ).
        ENDIF.
      WHEN id_string_slice.
        lv_text_string = string_receiver( this_value ).
        lv_string_length = strlen( lv_text_string ).
        READ TABLE arguments INDEX 1 INTO ls_argument.
        IF sy-subrc = 0.
          lv_string_start = array_slice_index(
            value = ls_argument length = CONV int8( lv_string_length ) ).
        ELSE.
          lv_string_start = 0.
        ENDIF.
        READ TABLE arguments INDEX 2 INTO ls_argument.
        IF sy-subrc = 0 AND ls_argument-tag <> zcl_qjs_value=>tag_undefined.
          lv_string_end = array_slice_index(
            value = ls_argument length = CONV int8( lv_string_length ) ).
        ELSE.
          lv_string_end = lv_string_length.
        ENDIF.
        lv_string_count = lv_string_end - lv_string_start.
        IF lv_string_count < 0. lv_string_count = 0. ENDIF.
        lv_string_result = lv_text_string+lv_string_start(lv_string_count).
        result = zcl_qjs_value=>new_string( lv_string_result ).
      WHEN id_string_substring.
        lv_text_string = string_receiver( this_value ).
        lv_string_length = strlen( lv_text_string ).
        READ TABLE arguments INDEX 1 INTO ls_argument.
        IF sy-subrc = 0.
          ls_string_integer = string_integer( ls_argument ).
          IF ls_string_integer-positive_infinity = abap_true.
            lv_string_start = lv_string_length.
          ELSEIF ls_string_integer-negative_infinity = abap_true.
            lv_string_start = 0.
          ELSE.
            lv_string_start = ls_string_integer-value.
          ENDIF.
        ELSE.
          lv_string_start = 0.
        ENDIF.
        READ TABLE arguments INDEX 2 INTO ls_argument.
        IF sy-subrc = 0 AND ls_argument-tag <> zcl_qjs_value=>tag_undefined.
          ls_string_integer = string_integer( ls_argument ).
          IF ls_string_integer-positive_infinity = abap_true.
            lv_string_end = lv_string_length.
          ELSEIF ls_string_integer-negative_infinity = abap_true.
            lv_string_end = 0.
          ELSE.
            lv_string_end = ls_string_integer-value.
          ENDIF.
        ELSE.
          lv_string_end = lv_string_length.
        ENDIF.
        IF lv_string_start < 0. lv_string_start = 0. ENDIF.
        IF lv_string_end < 0. lv_string_end = 0. ENDIF.
        IF lv_string_start > lv_string_length. lv_string_start = lv_string_length. ENDIF.
        IF lv_string_end > lv_string_length. lv_string_end = lv_string_length. ENDIF.
        IF lv_string_start > lv_string_end.
          lv_string_offset = lv_string_start.
          lv_string_start = lv_string_end.
          lv_string_end = lv_string_offset.
        ENDIF.
        lv_string_count = lv_string_end - lv_string_start.
        lv_string_result = lv_text_string+lv_string_start(lv_string_count).
        result = zcl_qjs_value=>new_string( lv_string_result ).
      WHEN id_string_substr.
        lv_text_string = string_receiver( this_value ).
        lv_string_length = strlen( lv_text_string ).
        READ TABLE arguments INDEX 1 INTO ls_argument.
        IF sy-subrc = 0.
          ls_string_integer = string_integer( ls_argument ).
          lv_string_start = ls_string_integer-value.
        ELSE.
          lv_string_start = 0.
        ENDIF.
        IF lv_string_start < 0.
          lv_string_start = nmax(
            val1 = 0 val2 = lv_string_length + lv_string_start ).
        ELSEIF lv_string_start > lv_string_length.
          lv_string_start = lv_string_length.
        ENDIF.
        READ TABLE arguments INDEX 2 INTO ls_argument.
        IF sy-subrc = 0 AND ls_argument-tag <> zcl_qjs_value=>tag_undefined.
          ls_string_integer = string_integer( ls_argument ).
          lv_string_count = ls_string_integer-value.
          IF lv_string_count < 0. lv_string_count = 0. ENDIF.
          lv_string_count = nmin(
            val1 = lv_string_count val2 = lv_string_length - lv_string_start ).
        ELSE.
          lv_string_count = lv_string_length - lv_string_start.
        ENDIF.
        lv_string_result = lv_text_string+lv_string_start(lv_string_count).
        result = zcl_qjs_value=>new_string( lv_string_result ).
      WHEN id_string_replace.
        lv_text_string = string_receiver( this_value ).
        READ TABLE arguments INDEX 1 INTO DATA(ls_replace_search).
        IF sy-subrc <> 0.
          ls_replace_search = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        READ TABLE arguments INDEX 2 INTO DATA(ls_replace_value).
        IF sy-subrc <> 0.
          ls_replace_value = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lv_replacement) = string_value( ls_replace_value ).
        DATA lo_replace_regexp TYPE REF TO zcl_qjs_object.
        IF ls_replace_search-tag = zcl_qjs_value=>tag_object.
          TRY.
              lo_replace_regexp ?= ls_replace_search-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_replace_regexp IS BOUND
              AND lo_replace_regexp->is_regexp( ) = abap_false.
            CLEAR lo_replace_regexp.
          ENDIF.
        ENDIF.
        IF lo_replace_regexp IS BOUND.
          DATA(lv_replace_global) = xsdbool(
            lo_replace_regexp->get_regexp_flags( ) CS 'g' ).
          DATA(lv_replace_cursor) = 0.
          CLEAR lv_string_result.
          WHILE lv_replace_cursor <= strlen( lv_text_string ).
            DATA(ls_replace_match) = regexp_find(
              regexp = lo_replace_regexp text = lv_text_string
              start = lv_replace_cursor ).
            IF ls_replace_match-found = abap_false.
              lv_string_result = lv_string_result && lv_text_string+lv_replace_cursor.
              EXIT.
            ENDIF.
            lv_string_count = ls_replace_match-offset - lv_replace_cursor.
            lv_string_result = lv_string_result
              && lv_text_string+lv_replace_cursor(lv_string_count)
              && lv_replacement.
            lv_replace_cursor = ls_replace_match-offset + ls_replace_match-length.
            IF lv_replace_global = abap_false.
              lv_string_result = lv_string_result && lv_text_string+lv_replace_cursor.
              EXIT.
            ENDIF.
            IF ls_replace_match-length = 0.
              IF lv_replace_cursor >= strlen( lv_text_string ).
                EXIT.
              ENDIF.
              lv_string_result = lv_string_result && lv_text_string+lv_replace_cursor(1).
              lv_replace_cursor = lv_replace_cursor + 1.
            ENDIF.
          ENDWHILE.
          lo_replace_regexp->set(
            name = 'lastIndex' value = zcl_qjs_value=>new_int( 0 ) ).
        ELSE.
          lv_needle_string = string_value( ls_replace_search ).
          FIND FIRST OCCURRENCE OF lv_needle_string IN lv_text_string
            MATCH OFFSET lv_string_offset.
          IF sy-subrc <> 0.
            lv_string_result = lv_text_string.
          ELSE.
            lv_string_count = strlen( lv_needle_string ).
            lv_string_start = lv_string_offset + lv_string_count.
            lv_string_result = lv_text_string(lv_string_offset)
              && lv_replacement
              && lv_text_string+lv_string_start.
          ENDIF.
        ENDIF.
        result = zcl_qjs_value=>new_string( lv_string_result ).
      WHEN id_string_split.
        lv_text_string = string_receiver( this_value ).
        DATA(lo_split_result) = mo_runtime->create_array( ).
        READ TABLE arguments INDEX 1 INTO DATA(ls_split_separator).
        IF sy-subrc <> 0 OR ls_split_separator-tag = zcl_qjs_value=>tag_undefined.
          lo_split_result->set_element(
            index = 0 value = zcl_qjs_value=>new_string( lv_text_string ) ).
        ELSE.
          lv_needle_string = string_value( ls_split_separator ).
          DATA(lv_split_cursor) = 0.
          DATA(lv_split_index) = CONV int8( 0 ).
          IF lv_needle_string IS INITIAL.
            WHILE lv_split_cursor < strlen( lv_text_string ).
              lv_string_result = lv_text_string+lv_split_cursor(1).
              lo_split_result->set_element(
                index = lv_split_index value = zcl_qjs_value=>new_string(
                  lv_string_result ) ).
              lv_split_cursor = lv_split_cursor + 1.
              lv_split_index = lv_split_index + 1.
            ENDWHILE.
          ELSE.
            WHILE lv_split_cursor <= strlen( lv_text_string ).
              DATA(lv_split_tail) = lv_text_string+lv_split_cursor.
              FIND FIRST OCCURRENCE OF lv_needle_string IN lv_split_tail
                MATCH OFFSET lv_string_offset.
              IF sy-subrc <> 0.
                lv_string_result = lv_text_string+lv_split_cursor.
                lo_split_result->set_element(
                  index = lv_split_index value = zcl_qjs_value=>new_string(
                    lv_string_result ) ).
                EXIT.
              ENDIF.
              lv_string_count = lv_string_offset.
              lv_string_result =
                lv_text_string+lv_split_cursor(lv_string_count).
              lo_split_result->set_element(
                index = lv_split_index value = zcl_qjs_value=>new_string(
                  lv_string_result ) ).
              lv_split_cursor = lv_split_cursor + lv_string_offset
                + strlen( lv_needle_string ).
              lv_split_index = lv_split_index + 1.
            ENDWHILE.
          ENDIF.
        ENDIF.
        result = zcl_qjs_value=>new_object( lo_split_result ).
      WHEN id_string_concat.
        lv_string_result = string_receiver( this_value ).
        LOOP AT arguments INTO ls_argument.
          lv_string_result = lv_string_result
            && string_value( ls_argument ).
        ENDLOOP.
        result = zcl_qjs_value=>new_string( lv_string_result ).
      WHEN id_string_repeat.
        lv_text_string = string_receiver( this_value ).
        READ TABLE arguments INDEX 1 INTO ls_argument.
        IF sy-subrc = 0.
          ls_string_integer = string_integer( ls_argument ).
        ELSE.
          CLEAR ls_string_integer.
        ENDIF.
        IF ls_string_integer-negative_infinity = abap_true
            OR ls_string_integer-positive_infinity = abap_true
            OR ls_string_integer-value < 0.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'RangeError: invalid string repeat count'.
        ENDIF.
        IF lv_text_string IS INITIAL.
          result = zcl_qjs_value=>new_string( '' ).
          RETURN.
        ENDIF.
        IF ls_string_integer-value > 1000000.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'RangeError: repeated string exceeds implementation limit'.
        ENDIF.
        CLEAR lv_string_result.
        lv_string_count = ls_string_integer-value.
        DO lv_string_count TIMES.
          lv_string_result = lv_string_result && lv_text_string.
        ENDDO.
        result = zcl_qjs_value=>new_string( lv_string_result ).
      WHEN id_string_to_lower.
        lv_text_string = string_receiver( this_value ).
        result = zcl_qjs_value=>new_string( to_lower( val = lv_text_string ) ).
      WHEN id_string_to_upper.
        lv_text_string = string_receiver( this_value ).
        result = zcl_qjs_value=>new_string( to_upper( val = lv_text_string ) ).
      WHEN id_string_trim OR id_string_trim_start OR id_string_trim_end.
        lv_text_string = string_receiver( this_value ).
        DATA(lv_trim_start) = xsdbool( mv_id <> id_string_trim_end ).
        DATA(lv_trim_end) = xsdbool( mv_id <> id_string_trim_start ).
        lv_string_result = string_trim_value(
          value = lv_text_string trim_start = lv_trim_start trim_end = lv_trim_end ).
        result = zcl_qjs_value=>new_string( lv_string_result ).
      WHEN id_reflect_apply.
        READ TABLE arguments INDEX 1 INTO DATA(ls_reflect_target).
        IF sy-subrc <> 0 OR is_callable( ls_reflect_target ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Reflect.apply target is not callable'.
        ENDIF.
        READ TABLE arguments INDEX 2 INTO DATA(ls_reflect_this).
        IF sy-subrc <> 0.
          ls_reflect_this = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        READ TABLE arguments INDEX 3 INTO DATA(ls_reflect_list).
        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Reflect.apply requires an argument list'.
        ENDIF.
        DATA(lt_reflect_arguments) = reflect_arguments( ls_reflect_list ).
        result = mo_runtime->invoke_callable(
          callable = ls_reflect_target this_value = ls_reflect_this
          arguments = lt_reflect_arguments ).
      WHEN id_reflect_construct.
        READ TABLE arguments INDEX 1 INTO ls_reflect_target.
        IF sy-subrc <> 0 OR is_constructable( ls_reflect_target ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Reflect.construct target is not constructable'.
        ENDIF.
        READ TABLE arguments INDEX 2 INTO ls_reflect_list.
        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Reflect.construct requires an argument list'.
        ENDIF.
        lt_reflect_arguments = reflect_arguments( ls_reflect_list ).
        READ TABLE arguments INDEX 3 INTO DATA(ls_reflect_new_target).
        IF sy-subrc <> 0.
          ls_reflect_new_target = ls_reflect_target.
        ELSEIF is_constructable( ls_reflect_new_target ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Reflect.construct newTarget is not constructable'.
        ENDIF.
        result = mo_runtime->construct_value(
          constructor = ls_reflect_target new_target = ls_reflect_new_target
          arguments = lt_reflect_arguments ).
      WHEN id_reflect_define_property.
        READ TABLE arguments INDEX 1 INTO ls_reflect_target.
        READ TABLE arguments INDEX 2 INTO DATA(ls_reflect_key).
        READ TABLE arguments INDEX 3 INTO DATA(ls_reflect_descriptor).
        DATA lo_reflect_define TYPE REF TO zcl_qjs_native_function.
        DATA lt_reflect_define_args TYPE zif_qjs_callable=>ty_arguments.
        CREATE OBJECT lo_reflect_define
          EXPORTING id = id_object_define_property runtime = mo_runtime.
        APPEND ls_reflect_target TO lt_reflect_define_args.
        APPEND ls_reflect_key TO lt_reflect_define_args.
        APPEND ls_reflect_descriptor TO lt_reflect_define_args.
        TRY.
            DATA(ls_reflect_ignored) = lo_reflect_define->zif_qjs_callable~call(
              this_value = zcl_qjs_value=>new_undefined( )
              arguments  = lt_reflect_define_args ).
            result = zcl_qjs_value=>new_boolean( abap_true ).
          CATCH zcx_qjs_throw.
            result = zcl_qjs_value=>new_boolean( abap_false ).
        ENDTRY.
      WHEN id_reflect_delete_property.
        READ TABLE arguments INDEX 1 INTO ls_reflect_target.
        IF sy-subrc <> 0 OR ls_reflect_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Reflect.deleteProperty target is not an object'.
        ENDIF.
        TRY.
            lo_object ?= ls_reflect_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Reflect.deleteProperty target must be ordinary'.
        ENDTRY.
        READ TABLE arguments INDEX 2 INTO ls_reflect_key.
        IF sy-subrc <> 0.
          ls_reflect_key = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        IF ls_reflect_key-tag = zcl_qjs_value=>tag_symbol.
          result = zcl_qjs_value=>new_boolean(
            lo_object->delete_symbol( ls_reflect_key-int_value ) ).
        ELSE.
          result = zcl_qjs_value=>new_boolean( lo_object->delete(
            string_value( ls_reflect_key ) ) ).
        ENDIF.
      WHEN id_reflect_get OR id_reflect_set.
        READ TABLE arguments INDEX 1 INTO ls_reflect_target.
        IF sy-subrc <> 0 OR ls_reflect_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Reflect property target is not an object'.
        ENDIF.
        TRY.
            lo_object ?= ls_reflect_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Reflect property target must be ordinary'.
        ENDTRY.
        READ TABLE arguments INDEX 2 INTO ls_reflect_key.
        IF sy-subrc <> 0.
          ls_reflect_key = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        IF mv_id = id_reflect_get.
          READ TABLE arguments INDEX 3 INTO DATA(ls_reflect_receiver).
          IF sy-subrc <> 0.
            ls_reflect_receiver = ls_reflect_target.
          ENDIF.
          IF ls_reflect_key-tag = zcl_qjs_value=>tag_symbol.
            result = lo_object->reflect_get_symbol(
              identity = ls_reflect_key-int_value receiver = ls_reflect_receiver ).
          ELSE.
            result = lo_object->reflect_get(
              name = string_value( ls_reflect_key ) receiver = ls_reflect_receiver ).
          ENDIF.
        ELSE.
          READ TABLE arguments INDEX 3 INTO DATA(ls_reflect_value).
          IF sy-subrc <> 0.
            ls_reflect_value = zcl_qjs_value=>new_undefined( ).
          ENDIF.
          READ TABLE arguments INDEX 4 INTO ls_reflect_receiver.
          IF sy-subrc <> 0.
            ls_reflect_receiver = ls_reflect_target.
          ENDIF.
          DATA(lv_reflect_set) = abap_false.
          IF ls_reflect_key-tag = zcl_qjs_value=>tag_symbol.
            lv_reflect_set = lo_object->reflect_set_symbol(
              identity = ls_reflect_key-int_value value = ls_reflect_value
              receiver = ls_reflect_receiver ).
          ELSE.
            lv_reflect_set = lo_object->reflect_set(
              name = string_value( ls_reflect_key ) value = ls_reflect_value
              receiver = ls_reflect_receiver ).
          ENDIF.
          result = zcl_qjs_value=>new_boolean( lv_reflect_set ).
        ENDIF.
      WHEN id_reflect_get_own_descriptor.
        READ TABLE arguments INDEX 1 INTO ls_reflect_target.
        READ TABLE arguments INDEX 2 INTO ls_reflect_key.
        DATA lo_reflect_descriptor TYPE REF TO zcl_qjs_native_function.
        DATA lt_reflect_descriptor_args TYPE zif_qjs_callable=>ty_arguments.
        CREATE OBJECT lo_reflect_descriptor
          EXPORTING id = id_object_get_own_descriptor runtime = mo_runtime.
        APPEND ls_reflect_target TO lt_reflect_descriptor_args.
        APPEND ls_reflect_key TO lt_reflect_descriptor_args.
        result = lo_reflect_descriptor->zif_qjs_callable~call(
          this_value = zcl_qjs_value=>new_undefined( )
          arguments  = lt_reflect_descriptor_args ).
      WHEN id_reflect_get_prototype.
        READ TABLE arguments INDEX 1 INTO ls_reflect_target.
        DATA lo_reflect_proto TYPE REF TO zcl_qjs_native_function.
        DATA lt_reflect_proto_args TYPE zif_qjs_callable=>ty_arguments.
        CREATE OBJECT lo_reflect_proto
          EXPORTING id = id_object_get_prototype runtime = mo_runtime.
        APPEND ls_reflect_target TO lt_reflect_proto_args.
        result = lo_reflect_proto->zif_qjs_callable~call(
          this_value = zcl_qjs_value=>new_undefined( )
          arguments  = lt_reflect_proto_args ).
      WHEN id_reflect_has.
        READ TABLE arguments INDEX 1 INTO ls_reflect_target.
        IF sy-subrc <> 0 OR ls_reflect_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Reflect.has target is not an object'.
        ENDIF.
        TRY.
            lo_object ?= ls_reflect_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Reflect.has target must be ordinary'.
        ENDTRY.
        READ TABLE arguments INDEX 2 INTO ls_reflect_key.
        IF sy-subrc <> 0.
          ls_reflect_key = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        IF ls_reflect_key-tag = zcl_qjs_value=>tag_symbol.
          result = zcl_qjs_value=>new_boolean(
            lo_object->has_symbol_property( ls_reflect_key-int_value ) ).
        ELSE.
          result = zcl_qjs_value=>new_boolean( lo_object->has_property(
            string_value( ls_reflect_key ) ) ).
        ENDIF.
      WHEN id_reflect_is_extensible OR id_reflect_prevent_extensions.
        READ TABLE arguments INDEX 1 INTO ls_reflect_target.
        IF sy-subrc <> 0 OR ls_reflect_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Reflect extensibility target is not an object'.
        ENDIF.
        TRY.
            lo_object ?= ls_reflect_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Reflect extensibility target must be ordinary'.
        ENDTRY.
        IF mv_id = id_reflect_is_extensible.
          result = zcl_qjs_value=>new_boolean( lo_object->is_extensible( ) ).
        ELSE.
          lo_object->prevent_extensions( ).
          result = zcl_qjs_value=>new_boolean( abap_true ).
        ENDIF.
      WHEN id_reflect_own_keys.
        READ TABLE arguments INDEX 1 INTO ls_reflect_target.
        IF sy-subrc <> 0 OR ls_reflect_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Reflect.ownKeys target is not an object'.
        ENDIF.
        TRY.
            lo_object ?= ls_reflect_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Reflect.ownKeys target must be ordinary'.
        ENDTRY.
        DATA(lo_reflect_keys) = mo_runtime->create_array( ).
        DATA(lv_reflect_index) = CONV int8( 0 ).
        DATA(lt_reflect_names) = lo_object->own_property_names( ).
        LOOP AT lt_reflect_names INTO DATA(lv_reflect_name).
          lo_reflect_keys->set_element(
            index = lv_reflect_index
            value = zcl_qjs_value=>new_string( lv_reflect_name ) ).
          lv_reflect_index = lv_reflect_index + 1.
        ENDLOOP.
        DATA(lt_reflect_symbols) = lo_object->own_property_symbols( ).
        LOOP AT lt_reflect_symbols INTO DATA(lv_reflect_symbol).
          lo_reflect_keys->set_element(
            index = lv_reflect_index
            value = zcl_qjs_value=>new_symbol( lv_reflect_symbol ) ).
          lv_reflect_index = lv_reflect_index + 1.
        ENDLOOP.
        result = zcl_qjs_value=>new_object( lo_reflect_keys ).
      WHEN id_reflect_set_prototype.
        READ TABLE arguments INDEX 1 INTO ls_reflect_target.
        READ TABLE arguments INDEX 2 INTO DATA(ls_reflect_proto_value).
        IF ls_reflect_target-tag <> zcl_qjs_value=>tag_object
            OR ( ls_reflect_proto_value-tag <> zcl_qjs_value=>tag_object
              AND ls_reflect_proto_value-tag <> zcl_qjs_value=>tag_null ).
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Reflect.setPrototypeOf arguments are invalid'.
        ENDIF.
        TRY.
            lo_object ?= ls_reflect_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Reflect.setPrototypeOf target must be ordinary'.
        ENDTRY.
        DATA lo_reflect_new_proto TYPE REF TO zcl_qjs_object.
        IF ls_reflect_proto_value-tag = zcl_qjs_value=>tag_object.
          TRY.
              lo_reflect_new_proto ?= ls_reflect_proto_value-object_ref.
            CATCH cx_sy_move_cast_error.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: Reflect.setPrototypeOf prototype must be ordinary'.
          ENDTRY.
        ENDIF.
        TRY.
            lo_object->set_prototype( lo_reflect_new_proto ).
            result = zcl_qjs_value=>new_boolean( abap_true ).
          CATCH zcx_qjs_throw.
            result = zcl_qjs_value=>new_boolean( abap_false ).
        ENDTRY.
      WHEN id_object_is_extensible OR id_object_prevent_extensions.
        IF sy-subrc <> 0 OR ls_argument-tag <> zcl_qjs_value=>tag_object.
          IF mv_id = id_object_is_extensible.
            result = zcl_qjs_value=>new_boolean( abap_false ).
          ELSEIF sy-subrc = 0.
            result = ls_argument.
          ELSE.
            result = zcl_qjs_value=>new_undefined( ).
          ENDIF.
          RETURN.
        ENDIF.
        TRY.
            lo_object ?= ls_argument-object_ref.
          CATCH cx_sy_move_cast_error.
            IF mv_id = id_object_is_extensible.
              result = zcl_qjs_value=>new_boolean( abap_true ).
            ELSE.
              result = ls_argument.
            ENDIF.
            RETURN.
        ENDTRY.
        IF mv_id = id_object_is_extensible.
          result = zcl_qjs_value=>new_boolean( lo_object->is_extensible( ) ).
        ELSE.
          lo_object->prevent_extensions( ).
          result = ls_argument.
        ENDIF.
      WHEN id_map_get OR id_map_set OR id_map_has OR id_map_delete
          OR id_map_clear OR id_map_size OR id_map_entries OR id_map_keys
          OR id_map_values OR id_map_for_each OR id_set_add OR id_set_has
          OR id_set_delete OR id_set_clear OR id_set_size OR id_set_entries
          OR id_set_values OR id_set_for_each.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: collection method receiver is incompatible'.
        ENDIF.
        DATA lo_collection TYPE REF TO zcl_qjs_object.
        TRY.
            lo_collection ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: collection method receiver is incompatible'.
        ENDTRY.
        DATA(lv_collection_kind) = zcl_qjs_object=>collection_map.
        IF mv_id = id_set_add OR mv_id = id_set_has OR mv_id = id_set_delete
            OR mv_id = id_set_clear OR mv_id = id_set_size
            OR mv_id = id_set_entries OR mv_id = id_set_values
            OR mv_id = id_set_for_each.
          lv_collection_kind = zcl_qjs_object=>collection_set.
        ENDIF.
        IF lo_collection->collection_kind( ) <> lv_collection_kind.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: collection method receiver is incompatible'.
        ENDIF.
        IF mv_id = id_map_get.
          DATA(ls_map_entry) = lo_collection->collection_get( ls_argument ).
          IF ls_map_entry-found = abap_true.
            result = ls_map_entry-value.
          ELSE.
            result = zcl_qjs_value=>new_undefined( ).
          ENDIF.
        ELSEIF mv_id = id_map_set.
          READ TABLE arguments INDEX 2 INTO DATA(ls_map_value).
          IF sy-subrc <> 0.
            ls_map_value = zcl_qjs_value=>new_undefined( ).
          ENDIF.
          lo_collection->collection_set_entry(
            key = ls_argument value = ls_map_value ).
          result = this_value.
        ELSEIF mv_id = id_set_add.
          lo_collection->collection_set_entry(
            key = ls_argument value = ls_argument ).
          result = this_value.
        ELSEIF mv_id = id_map_has OR mv_id = id_set_has.
          DATA(ls_has_entry) = lo_collection->collection_get( ls_argument ).
          result = zcl_qjs_value=>new_boolean( ls_has_entry-found ).
        ELSEIF mv_id = id_map_delete OR mv_id = id_set_delete.
          result = zcl_qjs_value=>new_boolean(
            lo_collection->collection_delete( ls_argument ) ).
        ELSEIF mv_id = id_map_clear OR mv_id = id_set_clear.
          lo_collection->collection_clear( ).
          result = zcl_qjs_value=>new_undefined( ).
        ELSEIF mv_id = id_map_size OR mv_id = id_set_size.
          result = zcl_qjs_value=>new_int( lo_collection->collection_size( ) ).
        ELSEIF mv_id = id_map_for_each OR mv_id = id_set_for_each.
          IF is_callable( ls_argument ) = abap_false.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: collection callback is not callable'.
          ENDIF.
          READ TABLE arguments INDEX 2 INTO DATA(ls_collection_this).
          IF sy-subrc <> 0.
            ls_collection_this = zcl_qjs_value=>new_undefined( ).
          ENDIF.
          DATA(lv_collection_index) = 1.
          WHILE lv_collection_index <= lo_collection->collection_slots( ).
            DATA(ls_each_entry) = lo_collection->collection_entry_at(
              lv_collection_index ).
            lv_collection_index = lv_collection_index + 1.
            IF ls_each_entry-deleted = abap_true.
              CONTINUE.
            ENDIF.
            DATA lt_each_arguments TYPE zif_qjs_callable=>ty_arguments.
            IF lv_collection_kind = zcl_qjs_object=>collection_map.
              APPEND ls_each_entry-value TO lt_each_arguments.
              APPEND ls_each_entry-key TO lt_each_arguments.
            ELSE.
              APPEND ls_each_entry-key TO lt_each_arguments.
              APPEND ls_each_entry-key TO lt_each_arguments.
            ENDIF.
            APPEND this_value TO lt_each_arguments.
            DATA(ls_each_ignored) = mo_runtime->invoke_callable(
              callable = ls_argument this_value = ls_collection_this
              arguments = lt_each_arguments ).
          ENDWHILE.
          result = zcl_qjs_value=>new_undefined( ).
        ELSE.
          DATA(lv_iterator_kind) = zcl_qjs_object=>iterator_values.
          IF mv_id = id_map_entries OR mv_id = id_set_entries.
            lv_iterator_kind = zcl_qjs_object=>iterator_entries.
          ELSEIF mv_id = id_map_keys.
            lv_iterator_kind = zcl_qjs_object=>iterator_keys.
          ENDIF.
          DATA lo_collection_iterator TYPE REF TO zcl_qjs_object.
          IF lv_collection_kind = zcl_qjs_object=>collection_map.
            lo_collection_iterator = mo_runtime->create_object(
              mo_runtime->get_map_iterator_proto( ) ).
          ELSE.
            lo_collection_iterator = mo_runtime->create_object(
              mo_runtime->get_set_iterator_proto( ) ).
          ENDIF.
          lo_collection_iterator->initialize_iterator(
            collection = lo_collection kind = lv_iterator_kind ).
          result = zcl_qjs_value=>new_object( lo_collection_iterator ).
        ENDIF.
      WHEN id_array_entries OR id_array_keys OR id_array_values.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: array iterator receiver is not an object'.
        ENDIF.
        DATA lo_array_iterator_source TYPE REF TO zcl_qjs_object.
        TRY.
            lo_array_iterator_source ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: array iterator receiver is unsupported'.
        ENDTRY.
        DATA(lv_array_iterator_kind) = zcl_qjs_object=>iterator_values.
        IF mv_id = id_array_entries.
          lv_array_iterator_kind = zcl_qjs_object=>iterator_entries.
        ELSEIF mv_id = id_array_keys.
          lv_array_iterator_kind = zcl_qjs_object=>iterator_keys.
        ENDIF.
        DATA(lo_sequence_iterator) = mo_runtime->create_object(
          mo_runtime->get_array_iterator_proto( ) ).
        lo_sequence_iterator->initialize_array_iterator(
          array = lo_array_iterator_source kind = lv_array_iterator_kind ).
        result = zcl_qjs_value=>new_object( lo_sequence_iterator ).
      WHEN id_string_iterator.
        DATA(lv_iterator_string) = string_receiver( this_value ).
        DATA(ls_iterator_string) = zcl_qjs_value=>new_string( lv_iterator_string ).
        DATA(lo_string_iterator) = mo_runtime->create_object(
          mo_runtime->get_string_iterator_proto( ) ).
        lo_string_iterator->initialize_string_iterator( ls_iterator_string ).
        result = zcl_qjs_value=>new_object( lo_string_iterator ).
      WHEN id_collection_next.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: iterator receiver is incompatible'.
        ENDIF.
        DATA lo_next_iterator TYPE REF TO zcl_qjs_object.
        TRY.
            lo_next_iterator ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: iterator receiver is incompatible'.
        ENDTRY.
        IF lo_next_iterator->iterator_kind( ) = 0.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: iterator receiver is incompatible'.
        ENDIF.
        DATA(ls_iterator_entry) = lo_next_iterator->iterator_next( ).
        DATA(lo_iterator_result) = mo_runtime->create_object( ).
        lo_iterator_result->define_property(
          name = 'done' value = zcl_qjs_value=>new_boolean(
            xsdbool( ls_iterator_entry-found = abap_false ) ) ).
        IF ls_iterator_entry-found = abap_false.
          lo_iterator_result->define_property(
            name = 'value' value = zcl_qjs_value=>new_undefined( ) ).
        ELSEIF lo_next_iterator->iterator_kind( )
            = zcl_qjs_object=>iterator_entries.
          DATA(lo_iterator_pair) = mo_runtime->create_array( ).
          lo_iterator_pair->set_element(
            index = 0 value = ls_iterator_entry-key ).
          lo_iterator_pair->set_element(
            index = 1 value = ls_iterator_entry-value ).
          lo_iterator_result->define_property(
            name = 'value' value = zcl_qjs_value=>new_object( lo_iterator_pair ) ).
        ELSEIF lo_next_iterator->iterator_kind( )
            = zcl_qjs_object=>iterator_keys.
          lo_iterator_result->define_property(
            name = 'value' value = ls_iterator_entry-key ).
        ELSE.
          lo_iterator_result->define_property(
            name = 'value' value = ls_iterator_entry-value ).
        ENDIF.
        result = zcl_qjs_value=>new_object( lo_iterator_result ).
      WHEN id_generator_next.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: generator receiver is incompatible'.
        ENDIF.
        DATA lo_generator TYPE REF TO zcl_qjs_object.
        TRY.
            lo_generator ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: generator receiver is incompatible'.
        ENDTRY.
        IF lo_generator->is_generator( ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: generator receiver is incompatible'.
        ENDIF.
        READ TABLE arguments INDEX 1 INTO DATA(ls_generator_input).
        IF sy-subrc <> 0.
          ls_generator_input = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        result = lo_generator->generator_next( ls_generator_input ).
      WHEN id_generator_throw.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: generator receiver is incompatible'.
        ENDIF.
        DATA lo_throw_generator TYPE REF TO zcl_qjs_object.
        TRY.
            lo_throw_generator ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: generator receiver is incompatible'.
        ENDTRY.
        IF lo_throw_generator->is_generator( ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: generator receiver is incompatible'.
        ENDIF.
        READ TABLE arguments INDEX 1 INTO DATA(ls_generator_throw_input).
        IF sy-subrc <> 0.
          ls_generator_throw_input = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        result = lo_throw_generator->generator_throw( ls_generator_throw_input ).
      WHEN id_generator_return.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: generator receiver is incompatible'.
        ENDIF.
        DATA lo_return_generator TYPE REF TO zcl_qjs_object.
        TRY.
            lo_return_generator ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: generator receiver is incompatible'.
        ENDTRY.
        IF lo_return_generator->is_generator( ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: generator receiver is incompatible'.
        ENDIF.
        READ TABLE arguments INDEX 1 INTO DATA(ls_generator_return_input).
        IF sy-subrc <> 0.
          ls_generator_return_input = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        result = lo_return_generator->generator_return( ls_generator_return_input ).
      WHEN id_iterator_self.
        result = this_value.
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
          IF sy-subrc = 0 AND ls_argument-tag = zcl_qjs_value=>tag_string.
            lo_object = mo_runtime->create_object(
              mo_runtime->get_string_prototype( ) ).
          ELSE.
            lo_object = mo_runtime->create_object( ).
          ENDIF.
          IF sy-subrc = 0 AND ls_argument-tag <> zcl_qjs_value=>tag_null
              AND ls_argument-tag <> zcl_qjs_value=>tag_undefined.
            IF ls_argument-tag = zcl_qjs_value=>tag_string.
              initialize_string_wrapper(
                object = lo_object primitive = ls_argument ).
            ELSE.
              lo_object->define_property(
                name = '[[PrimitiveValue]]' value = ls_argument
                writable = abap_false enumerable = abap_false configurable = abap_false ).
            ENDIF.
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
              ELSEIF lo_object->has_own( '[[ErrorData]]' ) = abap_true.
                lv_object_tag = 'Error'.
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
                ls_to_string_tag_symbol-int_value ).
              IF ls_custom_object_tag-tag = zcl_qjs_value=>tag_string.
                lv_object_tag = ls_custom_object_tag-string_ref->as_string( ).
              ENDIF.
            ELSEIF is_callable( this_value ) = abap_true.
              lv_object_tag = 'Function'.
              DATA lo_tag_closure TYPE REF TO zcl_qjs_closure.
              TRY.
                  lo_tag_closure ?= this_value-object_ref.
                CATCH cx_sy_move_cast_error.
              ENDTRY.
              IF lo_tag_closure IS BOUND.
                DATA(ls_closure_tag_symbol) = mo_runtime->well_known_symbol(
                  'toStringTag' ).
                DATA(ls_custom_closure_tag) =
                  lo_tag_closure->get_symbol_property(
                    ls_closure_tag_symbol-int_value ).
                IF ls_custom_closure_tag-tag = zcl_qjs_value=>tag_string.
                  lv_object_tag = ls_custom_closure_tag-string_ref->as_string( ).
                ENDIF.
              ENDIF.
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
      WHEN id_array_of.
        DATA(lv_array_of_length) = CONV int8( lines( arguments ) ).
        IF is_constructable( this_value ) = abap_true.
          DATA lt_array_of_construct_args TYPE zif_qjs_callable=>ty_arguments.
          APPEND array_length_value( lv_array_of_length )
            TO lt_array_of_construct_args.
          DATA(ls_array_of_result) = mo_runtime->construct_value(
            constructor = this_value arguments = lt_array_of_construct_args ).
        ELSE.
          DATA(lo_array_of_default) = mo_runtime->create_array( ).
          ls_array_of_result = zcl_qjs_value=>new_object( lo_array_of_default ).
        ENDIF.
        DATA lo_array_of_object TYPE REF TO zcl_qjs_object.
        DATA lo_array_of_closure TYPE REF TO zcl_qjs_closure.
        DATA lo_array_of_properties TYPE REF TO zif_qjs_property_container.
        TRY.
            lo_array_of_object ?= ls_array_of_result-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
        IF lo_array_of_object IS NOT BOUND.
          TRY.
              lo_array_of_closure ?= ls_array_of_result-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
        ENDIF.
        IF lo_array_of_object IS NOT BOUND AND lo_array_of_closure IS NOT BOUND.
          TRY.
              lo_array_of_properties ?= ls_array_of_result-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
        ENDIF.
        IF lo_array_of_object IS NOT BOUND AND lo_array_of_closure IS NOT BOUND
            AND lo_array_of_properties IS NOT BOUND.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array.of constructor returned a non-object'.
        ENDIF.
        mo_runtime->get_limits( )->consume( lv_array_of_length ).
        DATA(lv_array_of_index) = CONV int8( 0 ).
        LOOP AT arguments INTO DATA(ls_array_of_item).
          DATA(lv_array_of_name) = CONV string( lv_array_of_index ).
          CONDENSE lv_array_of_name NO-GAPS.
          IF lo_array_of_object IS BOUND.
            lo_array_of_object->set(
              name = lv_array_of_name value = ls_array_of_item ).
          ELSEIF lo_array_of_closure IS BOUND.
            lo_array_of_closure->set_property(
              name = lv_array_of_name value = ls_array_of_item ).
          ELSE.
            lo_array_of_properties->set_property(
              name = lv_array_of_name value = ls_array_of_item ).
          ENDIF.
          lv_array_of_index = lv_array_of_index + 1.
        ENDLOOP.
        DATA(ls_array_of_length_value) = array_length_value( lv_array_of_length ).
        IF lo_array_of_object IS BOUND.
          array_set_length(
            object = lo_array_of_object length = lv_array_of_length ).
        ELSEIF lo_array_of_closure IS BOUND.
          lo_array_of_closure->set_property(
            name = 'length' value = ls_array_of_length_value ).
        ELSE.
          lo_array_of_properties->set_property(
            name = 'length' value = ls_array_of_length_value ).
        ENDIF.
        result = ls_array_of_result.
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
      WHEN id_array_to_string.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array.prototype.toString receiver is not an object'.
        ENDIF.
        DATA lo_array_string_object TYPE REF TO zcl_qjs_object.
        DATA lo_array_string_closure TYPE REF TO zcl_qjs_closure.
        DATA lo_array_string_properties TYPE REF TO zif_qjs_property_container.
        TRY.
            lo_array_string_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
        IF lo_array_string_object IS BOUND.
          DATA(ls_array_string_join) = lo_array_string_object->get( 'join' ).
        ELSE.
          TRY.
              lo_array_string_closure ?= this_value-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_array_string_closure IS BOUND.
            ls_array_string_join = lo_array_string_closure->get_property( 'join' ).
          ELSE.
            TRY.
                lo_array_string_properties ?= this_value-object_ref.
              CATCH cx_sy_move_cast_error.
                RAISE EXCEPTION TYPE zcx_qjs_error
                  EXPORTING reason = 'TypeError: Array.prototype.toString requires an object'.
            ENDTRY.
            ls_array_string_join = lo_array_string_properties->get_property( 'join' ).
          ENDIF.
        ENDIF.
        IF is_callable( ls_array_string_join ) = abap_false.
          DATA lv_array_string_fallback TYPE string VALUE 'toString'.
          ls_array_string_join = mo_runtime->get_object_prototype( )->get(
            lv_array_string_fallback ).
        ENDIF.
        DATA lt_array_string_arguments TYPE zif_qjs_callable=>ty_arguments.
        result = mo_runtime->invoke_callable(
          callable   = ls_array_string_join
          this_value = this_value
          arguments  = lt_array_string_arguments ).
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
              AND ls_from_number-int_value = zcl_qjs_value=>number_finite.
            IF ls_from_number-float_value >= lv_search_max_safe_f.
              lv_search_past_end = abap_true.
            ELSEIF ls_from_number-float_value <= 0 - lv_search_max_safe_f.
              lv_search_index = 0 - lv_search_max_safe.
            ELSE.
              lv_search_index = trunc( ls_from_number-float_value ).
            ENDIF.
          ELSEIF ls_from_number-tag = zcl_qjs_value=>tag_number
              AND ls_from_number-int_value = zcl_qjs_value=>number_pos_inf.
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
      WHEN id_array_to_reversed OR id_array_with.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array copy receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array copy requires an ordinary object'.
        ENDTRY.
        DATA(lv_array_copy_length) = array_to_length( lo_object->get( 'length' ) ).
        DATA lv_array_copy_max TYPE int8.
        lv_array_copy_max = '4294967295'.
        IF lv_array_copy_length > lv_array_copy_max.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'RangeError: copied array is too large'.
        ENDIF.
        DATA(lv_array_with_index) = CONV int8( 0 ).
        DATA(ls_array_with_value) = zcl_qjs_value=>new_undefined( ).
        IF mv_id = id_array_with.
          READ TABLE arguments INDEX 1 INTO DATA(ls_array_with_index_value).
          IF sy-subrc <> 0.
            ls_array_with_index_value = zcl_qjs_value=>new_undefined( ).
          ENDIF.
          DATA(ls_array_with_number) = zcl_qjs_number=>to_number(
            ls_array_with_index_value ).
          DATA(lv_array_with_relative) = CONV int8( 0 ).
          DATA(lv_array_with_out) = abap_false.
          DATA lv_array_with_max_safe_f TYPE f.
          lv_array_with_max_safe_f = '9007199254740991'.
          IF ls_array_with_number-tag = zcl_qjs_value=>tag_int.
            lv_array_with_relative = ls_array_with_number-int_value.
          ELSEIF ls_array_with_number-tag = zcl_qjs_value=>tag_number
              AND ls_array_with_number-int_value = zcl_qjs_value=>number_finite.
            IF ls_array_with_number-float_value >= lv_array_with_max_safe_f
                OR ls_array_with_number-float_value < 0 - lv_array_with_max_safe_f.
              lv_array_with_out = abap_true.
            ELSE.
              lv_array_with_relative = trunc( ls_array_with_number-float_value ).
            ENDIF.
          ELSEIF ls_array_with_number-tag = zcl_qjs_value=>tag_number
              AND ( ls_array_with_number-int_value = zcl_qjs_value=>number_pos_inf
                OR ls_array_with_number-int_value = zcl_qjs_value=>number_neg_inf ).
            lv_array_with_out = abap_true.
          ENDIF.
          lv_array_with_index = lv_array_with_relative.
          IF lv_array_with_relative < 0.
            lv_array_with_index = lv_array_copy_length + lv_array_with_relative.
          ENDIF.
          IF lv_array_with_out = abap_true OR lv_array_with_index < 0
              OR lv_array_with_index >= lv_array_copy_length.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'RangeError: Array.prototype.with index is out of range'.
          ENDIF.
          READ TABLE arguments INDEX 2 INTO ls_array_with_value.
          IF sy-subrc <> 0.
            ls_array_with_value = zcl_qjs_value=>new_undefined( ).
          ENDIF.
        ENDIF.
        mo_runtime->get_limits( )->consume( lv_array_copy_length ).
        DATA(lo_array_copy_result) = mo_runtime->create_array( ).
        DATA(lv_array_copy_index) = CONV int8( 0 ).
        WHILE lv_array_copy_index < lv_array_copy_length.
          DATA(lv_array_copy_source) = lv_array_copy_index.
          IF mv_id = id_array_to_reversed.
            lv_array_copy_source = lv_array_copy_length - lv_array_copy_index - 1.
          ENDIF.
          DATA(lv_array_copy_source_name) = CONV string( lv_array_copy_source ).
          CONDENSE lv_array_copy_source_name NO-GAPS.
          IF mv_id = id_array_with
              AND lv_array_copy_index = lv_array_with_index.
            DATA(ls_array_copy_value) = ls_array_with_value.
          ELSE.
            ls_array_copy_value = lo_object->get( lv_array_copy_source_name ).
          ENDIF.
          lo_array_copy_result->set_element(
            index = lv_array_copy_index value = ls_array_copy_value ).
          lv_array_copy_index = lv_array_copy_index + 1.
        ENDWHILE.
        lo_array_copy_result->set_array_length( lv_array_copy_length ).
        result = zcl_qjs_value=>new_object( lo_array_copy_result ).
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
                AND ls_last_from_number-int_value = zcl_qjs_value=>number_finite.
              IF ls_last_from_number-float_value >= lv_last_max_safe_f.
                lv_last_positive_overflow = abap_true.
              ELSEIF ls_last_from_number-float_value <= 0 - lv_last_max_safe_f.
                lv_last_negative_overflow = abap_true.
              ELSE.
                lv_last_relative = trunc( ls_last_from_number-float_value ).
              ENDIF.
            ELSEIF ls_last_from_number-tag = zcl_qjs_value=>tag_number
                AND ls_last_from_number-int_value = zcl_qjs_value=>number_pos_inf.
              lv_last_positive_overflow = abap_true.
            ELSEIF ls_last_from_number-tag = zcl_qjs_value=>tag_number
                AND ls_last_from_number-int_value = zcl_qjs_value=>number_neg_inf.
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
            AND ls_at_number-int_value = zcl_qjs_value=>number_finite.
          IF abs( ls_at_number-float_value ) >= lv_at_max_safe_f.
            lv_at_out_of_range = abap_true.
          ELSE.
            lv_at_relative = trunc( ls_at_number-float_value ).
          ENDIF.
        ELSEIF ls_at_number-tag = zcl_qjs_value=>tag_number
            AND ( ls_at_number-int_value = zcl_qjs_value=>number_pos_inf
              OR ls_at_number-int_value = zcl_qjs_value=>number_neg_inf ).
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
      WHEN id_array_some OR id_array_every OR id_array_find OR id_array_find_index
          OR id_array_find_last OR id_array_find_last_index.
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
        DATA(lv_array_predicate_step) = CONV int8( 1 ).
        IF mv_id = id_array_find_last OR mv_id = id_array_find_last_index.
          lv_array_predicate_index = lv_array_predicate_length - 1.
          lv_array_predicate_step = -1.
        ENDIF.
        DATA(lv_array_predicate_matched) = abap_false.
        DATA ls_array_predicate_value TYPE zcl_qjs_value=>ty_value.
        DATA lt_array_predicate_args TYPE zif_qjs_callable=>ty_arguments.
        WHILE ( lv_array_predicate_step > 0
              AND lv_array_predicate_index < lv_array_predicate_length )
            OR ( lv_array_predicate_step < 0 AND lv_array_predicate_index >= 0 ).
          DATA(lv_array_predicate_name) = CONV string( lv_array_predicate_index ).
          CONDENSE lv_array_predicate_name NO-GAPS.
          DATA(lv_array_predicate_present) = lo_object->has_property(
            lv_array_predicate_name ).
          IF lv_array_predicate_present = abap_true
              OR mv_id = id_array_find OR mv_id = id_array_find_index
              OR mv_id = id_array_find_last OR mv_id = id_array_find_last_index.
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
                OR mv_id = id_array_find_index OR mv_id = id_array_find_last
                OR mv_id = id_array_find_last_index )
                AND lv_array_predicate_truth = abap_true.
              lv_array_predicate_matched = abap_true.
              EXIT.
            ELSEIF mv_id = id_array_every
                AND lv_array_predicate_truth = abap_false.
              lv_array_predicate_matched = abap_true.
              EXIT.
            ENDIF.
          ENDIF.
          lv_array_predicate_index = lv_array_predicate_index
            + lv_array_predicate_step.
        ENDWHILE.
        IF mv_id = id_array_some.
          result = zcl_qjs_value=>new_boolean( lv_array_predicate_matched ).
        ELSEIF mv_id = id_array_every.
          result = zcl_qjs_value=>new_boolean(
            xsdbool( lv_array_predicate_matched = abap_false ) ).
        ELSEIF mv_id = id_array_find OR mv_id = id_array_find_last.
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
      WHEN id_array_concat.
        DATA(lo_concat_result) = mo_runtime->create_array( ).
        DATA(lv_concat_target) = CONV int8( 0 ).
        DATA lv_concat_max_length TYPE int8.
        lv_concat_max_length = '4294967295'.
        DATA lt_concat_items TYPE zif_qjs_callable=>ty_arguments.
        APPEND this_value TO lt_concat_items.
        APPEND LINES OF arguments TO lt_concat_items.
        DATA(ls_concat_symbol) = mo_runtime->well_known_symbol(
          'isConcatSpreadable' ).
        LOOP AT lt_concat_items INTO DATA(ls_concat_item).
          DATA(lv_concat_spread) = abap_false.
          DATA lo_concat_object TYPE REF TO zcl_qjs_object.
          CLEAR lo_concat_object.
          IF ls_concat_item-tag = zcl_qjs_value=>tag_object.
            TRY.
                lo_concat_object ?= ls_concat_item-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
            IF lo_concat_object IS BOUND.
              DATA(ls_concat_override) = lo_concat_object->get_symbol(
                ls_concat_symbol-int_value ).
              IF ls_concat_override-tag = zcl_qjs_value=>tag_undefined.
                lv_concat_spread = lo_concat_object->is_array( ).
              ELSE.
                lv_concat_spread = zcl_qjs_value=>to_boolean( ls_concat_override ).
              ENDIF.
            ENDIF.
          ENDIF.
          IF lv_concat_spread = abap_true.
            DATA(lv_concat_length) = array_to_length(
              lo_concat_object->get( 'length' ) ).
            IF lv_concat_length > lv_concat_max_length - lv_concat_target.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'RangeError: concatenated array is too large'.
            ENDIF.
            mo_runtime->get_limits( )->consume( lv_concat_length ).
            DATA(lv_concat_source) = CONV int8( 0 ).
            WHILE lv_concat_source < lv_concat_length.
              DATA(lv_concat_source_name) = CONV string( lv_concat_source ).
              CONDENSE lv_concat_source_name NO-GAPS.
              IF lo_concat_object->has_property( lv_concat_source_name ) = abap_true.
                lo_concat_result->set_element(
                  index = lv_concat_target
                  value = lo_concat_object->get( lv_concat_source_name ) ).
              ENDIF.
              lv_concat_source = lv_concat_source + 1.
              lv_concat_target = lv_concat_target + 1.
            ENDWHILE.
          ELSE.
            IF lv_concat_target >= lv_concat_max_length.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'RangeError: concatenated array is too large'.
            ENDIF.
            mo_runtime->get_limits( )->consume( 1 ).
            lo_concat_result->set_element(
              index = lv_concat_target value = ls_concat_item ).
            lv_concat_target = lv_concat_target + 1.
          ENDIF.
        ENDLOOP.
        lo_concat_result->set_array_length( lv_concat_target ).
        result = zcl_qjs_value=>new_object( lo_concat_result ).
      WHEN id_array_splice.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array.prototype.splice receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array.prototype.splice requires an ordinary object'.
        ENDTRY.
        DATA(lv_splice_length) = array_to_length( lo_object->get( 'length' ) ).
        DATA(lv_splice_arg_count) = lines( arguments ).
        DATA(lv_splice_start) = CONV int8( 0 ).
        DATA(lv_splice_delete_count) = CONV int8( 0 ).
        IF lv_splice_arg_count > 0.
          READ TABLE arguments INDEX 1 INTO DATA(ls_splice_start_value).
          lv_splice_start = array_slice_index(
            value = ls_splice_start_value length = lv_splice_length ).
          IF lv_splice_arg_count = 1.
            lv_splice_delete_count = lv_splice_length - lv_splice_start.
          ELSE.
            READ TABLE arguments INDEX 2 INTO DATA(ls_splice_delete_value).
            lv_splice_delete_count = array_clamped_count(
              value   = ls_splice_delete_value
              maximum = lv_splice_length - lv_splice_start ).
          ENDIF.
        ENDIF.
        DATA(lv_splice_insert_count) = CONV int8( lv_splice_arg_count - 2 ).
        IF lv_splice_insert_count < 0.
          lv_splice_insert_count = 0.
        ENDIF.
        DATA(lv_splice_new_length) = lv_splice_length
          - lv_splice_delete_count + lv_splice_insert_count.
        DATA lv_splice_max_safe TYPE int8.
        lv_splice_max_safe = '9007199254740991'.
        IF lv_splice_new_length > lv_splice_max_safe.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: array-like length exceeds maximum safe integer'.
        ENDIF.
        DATA lv_splice_max_array TYPE int8.
        lv_splice_max_array = '4294967295'.
        IF lo_object->is_array( ) = abap_true
            AND lv_splice_new_length > lv_splice_max_array.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'RangeError: invalid array length'.
        ENDIF.
        mo_runtime->get_limits( )->consume(
          lv_splice_length + lv_splice_insert_count + lv_splice_delete_count ).
        DATA(lo_splice_deleted) = mo_runtime->create_array( ).
        DATA(lv_splice_index) = CONV int8( 0 ).
        WHILE lv_splice_index < lv_splice_delete_count.
          DATA(lv_splice_from) = lv_splice_start + lv_splice_index.
          DATA(lv_splice_from_name) = CONV string( lv_splice_from ).
          CONDENSE lv_splice_from_name NO-GAPS.
          IF lo_object->has_property( lv_splice_from_name ) = abap_true.
            lo_splice_deleted->set_element(
              index = lv_splice_index value = lo_object->get( lv_splice_from_name ) ).
          ENDIF.
          lv_splice_index = lv_splice_index + 1.
        ENDWHILE.
        lo_splice_deleted->set_array_length( lv_splice_delete_count ).
        IF lv_splice_insert_count < lv_splice_delete_count.
          lv_splice_index = lv_splice_start.
          WHILE lv_splice_index < lv_splice_length - lv_splice_delete_count.
            lv_splice_from = lv_splice_index + lv_splice_delete_count.
            DATA(lv_splice_to) = lv_splice_index + lv_splice_insert_count.
            lv_splice_from_name = CONV string( lv_splice_from ).
            DATA(lv_splice_to_name) = CONV string( lv_splice_to ).
            CONDENSE lv_splice_from_name NO-GAPS.
            CONDENSE lv_splice_to_name NO-GAPS.
            IF lo_object->has_property( lv_splice_from_name ) = abap_true.
              lo_object->set(
                name = lv_splice_to_name value = lo_object->get( lv_splice_from_name ) ).
            ELSEIF lo_object->delete( lv_splice_to_name ) = abap_false.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: spliced property is not configurable'.
            ENDIF.
            lv_splice_index = lv_splice_index + 1.
          ENDWHILE.
          lv_splice_index = lv_splice_length.
          WHILE lv_splice_index > lv_splice_new_length.
            lv_splice_index = lv_splice_index - 1.
            lv_splice_to_name = CONV string( lv_splice_index ).
            CONDENSE lv_splice_to_name NO-GAPS.
            IF lo_object->delete( lv_splice_to_name ) = abap_false.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: spliced property is not configurable'.
            ENDIF.
          ENDWHILE.
        ELSEIF lv_splice_insert_count > lv_splice_delete_count.
          lv_splice_index = lv_splice_length - lv_splice_delete_count.
          WHILE lv_splice_index > lv_splice_start.
            lv_splice_from = lv_splice_index + lv_splice_delete_count - 1.
            lv_splice_to = lv_splice_index + lv_splice_insert_count - 1.
            lv_splice_from_name = CONV string( lv_splice_from ).
            lv_splice_to_name = CONV string( lv_splice_to ).
            CONDENSE lv_splice_from_name NO-GAPS.
            CONDENSE lv_splice_to_name NO-GAPS.
            IF lo_object->has_property( lv_splice_from_name ) = abap_true.
              lo_object->set(
                name = lv_splice_to_name value = lo_object->get( lv_splice_from_name ) ).
            ELSEIF lo_object->delete( lv_splice_to_name ) = abap_false.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: spliced property is not configurable'.
            ENDIF.
            lv_splice_index = lv_splice_index - 1.
          ENDWHILE.
        ENDIF.
        lv_splice_index = 0.
        WHILE lv_splice_index < lv_splice_insert_count.
          READ TABLE arguments INDEX lv_splice_index + 3
            INTO DATA(ls_splice_insert_value).
          lv_splice_to = lv_splice_start + lv_splice_index.
          lv_splice_to_name = CONV string( lv_splice_to ).
          CONDENSE lv_splice_to_name NO-GAPS.
          lo_object->set(
            name = lv_splice_to_name value = ls_splice_insert_value ).
          lv_splice_index = lv_splice_index + 1.
        ENDWHILE.
        array_set_length( object = lo_object length = lv_splice_new_length ).
        result = zcl_qjs_value=>new_object( lo_splice_deleted ).
      WHEN id_array_to_spliced.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array.prototype.toSpliced receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array.prototype.toSpliced requires an ordinary object'.
        ENDTRY.
        DATA(lv_to_spliced_length) = array_to_length( lo_object->get( 'length' ) ).
        DATA(lv_to_spliced_arg_count) = lines( arguments ).
        DATA(lv_to_spliced_start) = CONV int8( 0 ).
        DATA(lv_to_spliced_skip) = CONV int8( 0 ).
        IF lv_to_spliced_arg_count > 0.
          READ TABLE arguments INDEX 1 INTO DATA(ls_to_spliced_start_value).
          lv_to_spliced_start = array_slice_index(
            value = ls_to_spliced_start_value length = lv_to_spliced_length ).
          IF lv_to_spliced_arg_count = 1.
            lv_to_spliced_skip = lv_to_spliced_length - lv_to_spliced_start.
          ELSE.
            READ TABLE arguments INDEX 2 INTO DATA(ls_to_spliced_skip_value).
            lv_to_spliced_skip = array_clamped_count(
              value   = ls_to_spliced_skip_value
              maximum = lv_to_spliced_length - lv_to_spliced_start ).
          ENDIF.
        ENDIF.
        DATA(lv_to_spliced_insert_count) = CONV int8( lv_to_spliced_arg_count - 2 ).
        IF lv_to_spliced_insert_count < 0.
          lv_to_spliced_insert_count = 0.
        ENDIF.
        DATA(lv_to_spliced_new_length) = lv_to_spliced_length
          - lv_to_spliced_skip + lv_to_spliced_insert_count.
        DATA lv_to_spliced_max_safe TYPE int8.
        lv_to_spliced_max_safe = '9007199254740991'.
        IF lv_to_spliced_new_length > lv_to_spliced_max_safe.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: array-like length exceeds maximum safe integer'.
        ENDIF.
        DATA lv_to_spliced_max_array TYPE int8.
        lv_to_spliced_max_array = '4294967295'.
        IF lv_to_spliced_new_length > lv_to_spliced_max_array.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'RangeError: copied array is too large'.
        ENDIF.
        mo_runtime->get_limits( )->consume( lv_to_spliced_new_length ).
        DATA(lo_to_spliced_result) = mo_runtime->create_array( ).
        DATA(lv_to_spliced_target) = CONV int8( 0 ).
        WHILE lv_to_spliced_target < lv_to_spliced_start.
          DATA(lv_to_spliced_source_name) = CONV string( lv_to_spliced_target ).
          CONDENSE lv_to_spliced_source_name NO-GAPS.
          lo_to_spliced_result->set_element(
            index = lv_to_spliced_target
            value = lo_object->get( lv_to_spliced_source_name ) ).
          lv_to_spliced_target = lv_to_spliced_target + 1.
        ENDWHILE.
        DATA(lv_to_spliced_argument_index) = 3.
        WHILE lv_to_spliced_argument_index <= lv_to_spliced_arg_count.
          READ TABLE arguments INDEX lv_to_spliced_argument_index
            INTO DATA(ls_to_spliced_insert_value).
          lo_to_spliced_result->set_element(
            index = lv_to_spliced_target value = ls_to_spliced_insert_value ).
          lv_to_spliced_target = lv_to_spliced_target + 1.
          lv_to_spliced_argument_index = lv_to_spliced_argument_index + 1.
        ENDWHILE.
        DATA(lv_to_spliced_source) = lv_to_spliced_start + lv_to_spliced_skip.
        WHILE lv_to_spliced_source < lv_to_spliced_length.
          lv_to_spliced_source_name = CONV string( lv_to_spliced_source ).
          CONDENSE lv_to_spliced_source_name NO-GAPS.
          lo_to_spliced_result->set_element(
            index = lv_to_spliced_target
            value = lo_object->get( lv_to_spliced_source_name ) ).
          lv_to_spliced_source = lv_to_spliced_source + 1.
          lv_to_spliced_target = lv_to_spliced_target + 1.
        ENDWHILE.
        lo_to_spliced_result->set_array_length( lv_to_spliced_new_length ).
        result = zcl_qjs_value=>new_object( lo_to_spliced_result ).
      WHEN id_array_sort.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array.prototype.sort receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array.prototype.sort requires an ordinary object'.
        ENDTRY.
        READ TABLE arguments INDEX 1 INTO DATA(ls_sort_comparator).
        IF sy-subrc <> 0.
          ls_sort_comparator = zcl_qjs_value=>new_undefined( ).
        ELSEIF ls_sort_comparator-tag <> zcl_qjs_value=>tag_undefined
            AND is_callable( ls_sort_comparator ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array.prototype.sort comparator is not callable'.
        ENDIF.
        DATA(lv_sort_length) = array_to_length( lo_object->get( 'length' ) ).
        mo_runtime->get_limits( )->consume( lv_sort_length ).
        DATA lt_sort_values TYPE STANDARD TABLE OF zcl_qjs_value=>ty_value
          WITH DEFAULT KEY.
        DATA(lv_sort_index) = CONV int8( 0 ).
        WHILE lv_sort_index < lv_sort_length.
          DATA(lv_sort_name) = CONV string( lv_sort_index ).
          CONDENSE lv_sort_name NO-GAPS.
          IF lo_object->has_property( lv_sort_name ) = abap_true.
            APPEND lo_object->get( lv_sort_name ) TO lt_sort_values.
          ENDIF.
          lv_sort_index = lv_sort_index + 1.
        ENDWHILE.
        DATA(lv_sort_outer) = 2.
        WHILE lv_sort_outer <= lines( lt_sort_values ).
          READ TABLE lt_sort_values INDEX lv_sort_outer INTO DATA(ls_sort_value).
          DATA(lv_sort_inner) = lv_sort_outer - 1.
          WHILE lv_sort_inner >= 1.
            READ TABLE lt_sort_values INDEX lv_sort_inner INTO DATA(ls_sort_previous).
            mo_runtime->get_limits( )->consume( 1 ).
            IF array_sort_compare(
                left = ls_sort_value right = ls_sort_previous
                comparator = ls_sort_comparator ) >= 0.
              EXIT.
            ENDIF.
            MODIFY lt_sort_values FROM ls_sort_previous INDEX lv_sort_inner + 1.
            lv_sort_inner = lv_sort_inner - 1.
          ENDWHILE.
          MODIFY lt_sort_values FROM ls_sort_value INDEX lv_sort_inner + 1.
          lv_sort_outer = lv_sort_outer + 1.
        ENDWHILE.
        lv_sort_index = 0.
        LOOP AT lt_sort_values INTO ls_sort_value.
          lv_sort_name = CONV string( lv_sort_index ).
          CONDENSE lv_sort_name NO-GAPS.
          lo_object->set( name = lv_sort_name value = ls_sort_value ).
          lv_sort_index = lv_sort_index + 1.
        ENDLOOP.
        WHILE lv_sort_index < lv_sort_length.
          lv_sort_name = CONV string( lv_sort_index ).
          CONDENSE lv_sort_name NO-GAPS.
          IF lo_object->delete( lv_sort_name ) = abap_false.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: sorted property is not configurable'.
          ENDIF.
          lv_sort_index = lv_sort_index + 1.
        ENDWHILE.
        result = this_value.
      WHEN id_array_to_sorted.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array.prototype.toSorted receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array.prototype.toSorted requires an ordinary object'.
        ENDTRY.
        READ TABLE arguments INDEX 1 INTO DATA(ls_to_sorted_comparator).
        IF sy-subrc <> 0.
          ls_to_sorted_comparator = zcl_qjs_value=>new_undefined( ).
        ELSEIF ls_to_sorted_comparator-tag <> zcl_qjs_value=>tag_undefined
            AND is_callable( ls_to_sorted_comparator ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array.prototype.toSorted comparator is not callable'.
        ENDIF.
        DATA(lv_to_sorted_length) = array_to_length( lo_object->get( 'length' ) ).
        DATA lv_to_sorted_max TYPE int8.
        lv_to_sorted_max = '4294967295'.
        IF lv_to_sorted_length > lv_to_sorted_max.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'RangeError: copied array is too large'.
        ENDIF.
        mo_runtime->get_limits( )->consume( lv_to_sorted_length ).
        DATA lt_to_sorted_values TYPE STANDARD TABLE OF zcl_qjs_value=>ty_value
          WITH DEFAULT KEY.
        DATA(lv_to_sorted_index) = CONV int8( 0 ).
        WHILE lv_to_sorted_index < lv_to_sorted_length.
          DATA(lv_to_sorted_name) = CONV string( lv_to_sorted_index ).
          CONDENSE lv_to_sorted_name NO-GAPS.
          APPEND lo_object->get( lv_to_sorted_name ) TO lt_to_sorted_values.
          lv_to_sorted_index = lv_to_sorted_index + 1.
        ENDWHILE.
        DATA(lv_to_sorted_outer) = 2.
        WHILE lv_to_sorted_outer <= lines( lt_to_sorted_values ).
          READ TABLE lt_to_sorted_values INDEX lv_to_sorted_outer
            INTO DATA(ls_to_sorted_value).
          DATA(lv_to_sorted_inner) = lv_to_sorted_outer - 1.
          WHILE lv_to_sorted_inner >= 1.
            READ TABLE lt_to_sorted_values INDEX lv_to_sorted_inner
              INTO DATA(ls_to_sorted_previous).
            mo_runtime->get_limits( )->consume( 1 ).
            IF array_sort_compare(
                left = ls_to_sorted_value right = ls_to_sorted_previous
                comparator = ls_to_sorted_comparator ) >= 0.
              EXIT.
            ENDIF.
            MODIFY lt_to_sorted_values FROM ls_to_sorted_previous
              INDEX lv_to_sorted_inner + 1.
            lv_to_sorted_inner = lv_to_sorted_inner - 1.
          ENDWHILE.
          MODIFY lt_to_sorted_values FROM ls_to_sorted_value
            INDEX lv_to_sorted_inner + 1.
          lv_to_sorted_outer = lv_to_sorted_outer + 1.
        ENDWHILE.
        DATA(lo_to_sorted_result) = mo_runtime->create_array( ).
        lv_to_sorted_index = 0.
        LOOP AT lt_to_sorted_values INTO ls_to_sorted_value.
          lo_to_sorted_result->set_element(
            index = lv_to_sorted_index value = ls_to_sorted_value ).
          lv_to_sorted_index = lv_to_sorted_index + 1.
        ENDLOOP.
        lo_to_sorted_result->set_array_length( lv_to_sorted_length ).
        result = zcl_qjs_value=>new_object( lo_to_sorted_result ).
      WHEN id_array_flat OR id_array_flat_map.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Array flatten receiver is not an object'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array flatten requires an ordinary object'.
        ENDTRY.
        DATA(lv_flat_length) = array_to_length( lo_object->get( 'length' ) ).
        DATA(lv_flat_depth) = CONV int8( 1 ).
        DATA(ls_flat_mapper) = zcl_qjs_value=>new_undefined( ).
        DATA(ls_flat_mapper_this) = zcl_qjs_value=>new_undefined( ).
        DATA(lv_flat_use_mapper) = abap_false.
        IF mv_id = id_array_flat.
          READ TABLE arguments INDEX 1 INTO DATA(ls_flat_depth_value).
          IF sy-subrc = 0
              AND ls_flat_depth_value-tag <> zcl_qjs_value=>tag_undefined.
            DATA lv_flat_max_depth TYPE int8.
            lv_flat_max_depth = '9007199254740991'.
            lv_flat_depth = array_clamped_count(
              value = ls_flat_depth_value maximum = lv_flat_max_depth ).
          ENDIF.
        ELSE.
          READ TABLE arguments INDEX 1 INTO ls_flat_mapper.
          IF sy-subrc <> 0 OR is_callable( ls_flat_mapper ) = abap_false.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Array.prototype.flatMap mapper is not callable'.
          ENDIF.
          READ TABLE arguments INDEX 2 INTO ls_flat_mapper_this.
          IF sy-subrc <> 0.
            ls_flat_mapper_this = zcl_qjs_value=>new_undefined( ).
          ENDIF.
          lv_flat_use_mapper = abap_true.
        ENDIF.
        DATA(lo_flat_result) = mo_runtime->create_array( ).
        DATA(lv_flat_target_index) = CONV int8( 0 ).
        array_flatten_into(
          EXPORTING source = lo_object target = lo_flat_result
            source_length = lv_flat_length depth = lv_flat_depth
            mapper = ls_flat_mapper mapper_this = ls_flat_mapper_this
            use_mapper = lv_flat_use_mapper
          CHANGING target_index = lv_flat_target_index ).
        lo_flat_result->set_array_length( lv_flat_target_index ).
        result = zcl_qjs_value=>new_object( lo_flat_result ).
      WHEN id_is_nan.
        IF sy-subrc <> 0.
          result = zcl_qjs_value=>new_boolean( abap_true ).
        ELSE.
          ls_argument = zcl_qjs_number=>to_number( ls_argument ).
          result = zcl_qjs_value=>new_boolean(
            xsdbool( ls_argument-tag = zcl_qjs_value=>tag_number
              AND ls_argument-int_value = zcl_qjs_value=>number_nan ) ).
        ENDIF.
      WHEN id_is_finite.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        result = zcl_qjs_value=>new_boolean(
          xsdbool( ls_number-tag = zcl_qjs_value=>tag_int
            OR ( ls_number-tag = zcl_qjs_value=>tag_number
              AND ls_number-int_value <> zcl_qjs_value=>number_nan
              AND ls_number-int_value <> zcl_qjs_value=>number_pos_inf
              AND ls_number-int_value <> zcl_qjs_value=>number_neg_inf ) ) ).
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
            AND ls_argument-int_value = zcl_qjs_value=>number_nan ) ).
      WHEN id_number_is_finite.
        result = zcl_qjs_value=>new_boolean(
          xsdbool( sy-subrc = 0
            AND ( ls_argument-tag = zcl_qjs_value=>tag_int
              OR ( ls_argument-tag = zcl_qjs_value=>tag_number
                AND ( ls_argument-int_value = zcl_qjs_value=>number_finite
                  OR ls_argument-int_value = zcl_qjs_value=>number_neg_zero ) ) ) ) ).
      WHEN id_number_is_integer OR id_number_is_safe_int.
        DATA(lv_is_integer) = abap_false.
        DATA(lv_integer_value) = CONV f( 0 ).
        IF sy-subrc = 0 AND ls_argument-tag = zcl_qjs_value=>tag_int.
          lv_is_integer = abap_true.
          lv_integer_value = ls_argument-int_value.
        ELSEIF sy-subrc = 0 AND ls_argument-tag = zcl_qjs_value=>tag_number.
          IF ls_argument-int_value = zcl_qjs_value=>number_neg_zero.
            lv_is_integer = abap_true.
          ELSEIF ls_argument-int_value = zcl_qjs_value=>number_finite
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
          IF ls_number-int_value = zcl_qjs_value=>number_neg_inf.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
          ELSEIF ls_number-int_value = zcl_qjs_value=>number_neg_zero.
            result = zcl_qjs_value=>new_finite( 0 ).
          ELSEIF ls_number-int_value = zcl_qjs_value=>number_finite
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
          IF ls_number-int_value <> zcl_qjs_value=>number_finite.
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
        IF ls_number-int_value <> zcl_qjs_value=>number_finite.
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
        IF ls_number-int_value <> zcl_qjs_value=>number_finite.
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
        IF ls_number-int_value = zcl_qjs_value=>number_nan
            OR ls_number-int_value = zcl_qjs_value=>number_neg_zero.
          result = ls_number.
        ELSEIF ls_number-int_value = zcl_qjs_value=>number_neg_inf
            OR ( ls_number-int_value = zcl_qjs_value=>number_finite
              AND ls_number-float_value < 0 ).
          result = zcl_qjs_value=>new_int( -1 ).
        ELSEIF ls_number-int_value = zcl_qjs_value=>number_pos_inf
            OR ( ls_number-int_value = zcl_qjs_value=>number_finite
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
        IF ls_number-int_value = zcl_qjs_value=>number_nan
            OR ls_number-int_value = zcl_qjs_value=>number_pos_inf
            OR ls_number-int_value = zcl_qjs_value=>number_neg_zero.
          result = ls_number.
        ELSEIF ls_number-int_value = zcl_qjs_value=>number_neg_inf
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
        IF ls_number-int_value = zcl_qjs_value=>number_nan
            OR ls_number-int_value = zcl_qjs_value=>number_pos_inf.
          result = ls_number.
        ELSEIF ls_number-int_value = zcl_qjs_value=>number_neg_inf
            OR ( ls_number-int_value = zcl_qjs_value=>number_finite
              AND ls_number-float_value < lv_exp_underflow ).
          result = zcl_qjs_value=>new_finite( 0 ).
        ELSEIF ls_number-int_value = zcl_qjs_value=>number_neg_zero.
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
        IF ls_number-int_value = zcl_qjs_value=>number_nan
            OR ls_number-int_value = zcl_qjs_value=>number_neg_inf
            OR ( ls_number-int_value = zcl_qjs_value=>number_finite
              AND ls_number-float_value < 0 ).
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
        ELSEIF ls_number-int_value = zcl_qjs_value=>number_pos_inf.
          result = ls_number.
        ELSEIF ls_number-int_value = zcl_qjs_value=>number_neg_zero
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
        IF ls_number-int_value = zcl_qjs_value=>number_nan
            OR ls_number-int_value = zcl_qjs_value=>number_pos_inf
            OR ls_number-int_value = zcl_qjs_value=>number_neg_inf.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
        ELSEIF mv_id <> id_math_cos
            AND ls_number-int_value = zcl_qjs_value=>number_neg_zero.
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
        IF ls_number-int_value <> zcl_qjs_value=>number_finite
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
        IF ls_number-int_value = zcl_qjs_value=>number_nan
            OR ls_number-int_value = zcl_qjs_value=>number_pos_inf
            OR ls_number-int_value = zcl_qjs_value=>number_neg_zero.
          result = ls_number.
        ELSEIF ls_number-int_value = zcl_qjs_value=>number_neg_inf.
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
        IF ls_number-int_value = zcl_qjs_value=>number_nan
            OR ls_number-int_value = zcl_qjs_value=>number_pos_inf
            OR ls_number-int_value = zcl_qjs_value=>number_neg_zero.
          result = ls_number.
        ELSEIF ls_number-int_value = zcl_qjs_value=>number_neg_inf
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
        IF ls_number-int_value = zcl_qjs_value=>number_nan
            OR ls_number-int_value = zcl_qjs_value=>number_neg_zero.
          result = ls_number.
        ELSEIF ls_number-int_value = zcl_qjs_value=>number_pos_inf.
          result = zcl_qjs_value=>new_finite( CONV f( '1.5707963267948966' ) ).
        ELSEIF ls_number-int_value = zcl_qjs_value=>number_neg_inf.
          result = zcl_qjs_value=>new_finite( CONV f( '-1.5707963267948966' ) ).
        ELSE.
          result = zcl_qjs_value=>new_finite( math_atan_f( ls_number-float_value ) ).
        ENDIF.
      WHEN id_math_asin OR id_math_acos.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        ls_number = zcl_qjs_number=>to_number( ls_argument ).
        IF ls_number-int_value = zcl_qjs_value=>number_nan
            OR ls_number-int_value = zcl_qjs_value=>number_pos_inf
            OR ls_number-int_value = zcl_qjs_value=>number_neg_inf
            OR abs( ls_number-float_value ) > 1.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
        ELSEIF mv_id = id_math_asin
            AND ls_number-int_value = zcl_qjs_value=>number_neg_zero.
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
        IF ls_number-int_value = zcl_qjs_value=>number_nan.
          result = ls_number.
        ELSEIF mv_id = id_math_cosh
            AND ( ls_number-int_value = zcl_qjs_value=>number_pos_inf
              OR ls_number-int_value = zcl_qjs_value=>number_neg_inf ).
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
        ELSEIF mv_id = id_math_tanh
            AND ls_number-int_value = zcl_qjs_value=>number_pos_inf.
          result = zcl_qjs_value=>new_finite( 1 ).
        ELSEIF mv_id = id_math_tanh
            AND ls_number-int_value = zcl_qjs_value=>number_neg_inf.
          result = zcl_qjs_value=>new_finite( -1 ).
        ELSEIF mv_id = id_math_cosh
            AND ls_number-int_value = zcl_qjs_value=>number_finite
            AND ls_number-float_value = 0.
          result = zcl_qjs_value=>new_finite( 1 ).
        ELSEIF mv_id <> id_math_cosh
            AND ( ls_number-int_value = zcl_qjs_value=>number_neg_zero
              OR ls_number-float_value = 0 ).
          result = ls_number.
        ELSEIF mv_id = id_math_sinh
            AND ( ls_number-int_value = zcl_qjs_value=>number_pos_inf
              OR ls_number-int_value = zcl_qjs_value=>number_neg_inf ).
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
        IF ls_number-int_value <> zcl_qjs_value=>number_finite
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
        IF ls_number-int_value = zcl_qjs_value=>number_pos_inf.
          result = ls_number.
        ELSEIF ls_number-int_value <> zcl_qjs_value=>number_finite
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
        IF ls_number-int_value = zcl_qjs_value=>number_nan
            OR ls_number-int_value = zcl_qjs_value=>number_neg_zero.
          result = ls_number.
        ELSEIF ls_number-int_value <> zcl_qjs_value=>number_finite
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
          IF ls_hypot_number-int_value = zcl_qjs_value=>number_nan.
            lv_hypot_nan = abap_true.
          ELSEIF ls_hypot_number-int_value = zcl_qjs_value=>number_pos_inf
              OR ls_hypot_number-int_value = zcl_qjs_value=>number_neg_inf.
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
        IF ls_number-int_value <> zcl_qjs_value=>number_finite
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
          IF ls_number-int_value = zcl_qjs_value=>number_nan.
            result = ls_number.
            RETURN.
          ENDIF.
          IF lv_first = abap_true.
            ls_best = ls_number.
            lv_first = abap_false.
          ELSEIF mv_id = id_math_max.
            IF zcl_qjs_number=>less_than( left = ls_best right = ls_number ) = abap_true
                OR ( zcl_qjs_number=>equal( left = ls_best right = ls_number ) = abap_true
                  AND ls_best-int_value = zcl_qjs_value=>number_neg_zero
                  AND ls_number-int_value = zcl_qjs_value=>number_finite ).
              ls_best = ls_number.
            ENDIF.
          ELSEIF zcl_qjs_number=>less_than(
              left = ls_number right = ls_best ) = abap_true
              OR ( zcl_qjs_number=>equal( left = ls_number right = ls_best ) = abap_true
                AND ls_number-int_value = zcl_qjs_value=>number_neg_zero ).
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
        result = call_object_define_property( arguments ).
      WHEN id_object_get_own_descriptor.
        READ TABLE arguments INDEX 1 INTO DATA(ls_own_target).
        IF sy-subrc <> 0 OR ls_own_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: descriptor target is not an object'.
        ENDIF.
        DATA lo_own_native TYPE REF TO zcl_qjs_native_function.
        DATA lo_own_closure TYPE REF TO zcl_qjs_closure.
        TRY.
            lo_object ?= ls_own_target-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
        IF lo_object IS NOT BOUND.
          TRY.
              lo_own_closure ?= ls_own_target-object_ref.
              lo_object = lo_own_closure->get_property_storage( ).
            CATCH cx_sy_move_cast_error.
          ENDTRY.
        ENDIF.
        IF lo_object IS NOT BOUND.
          TRY.
              lo_own_native ?= ls_own_target-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
        ENDIF.
        IF lo_object IS NOT BOUND AND lo_own_native IS NOT BOUND.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: descriptor target is unsupported'.
        ENDIF.
        READ TABLE arguments INDEX 2 INTO DATA(ls_own_key).
        IF sy-subrc <> 0.
          ls_own_key = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA lv_own_found TYPE abap_bool.
        DATA lv_own_writable TYPE abap_bool.
        DATA lv_own_enumerable TYPE abap_bool.
        DATA lv_own_configurable TYPE abap_bool.
        DATA lv_own_accessor TYPE abap_bool.
        DATA ls_own_value TYPE zcl_qjs_value=>ty_value.
        DATA ls_own_getter TYPE zcl_qjs_value=>ty_value.
        DATA ls_own_setter TYPE zcl_qjs_value=>ty_value.
        IF lo_object IS BOUND.
          DATA ls_own_property TYPE zcl_qjs_object=>ty_own_property.
          IF ls_own_key-tag = zcl_qjs_value=>tag_symbol.
            ls_own_property = lo_object->get_own_symbol_property(
              ls_own_key-int_value ).
          ELSE.
            DATA(lv_own_name) = zcl_qjs_value=>to_string( ls_own_key ).
            ls_own_property = lo_object->get_own_property( lv_own_name ).
          ENDIF.
          lv_own_found = ls_own_property-found.
          lv_own_writable = ls_own_property-writable.
          lv_own_enumerable = ls_own_property-enumerable.
          lv_own_configurable = ls_own_property-configurable.
          lv_own_accessor = ls_own_property-accessor.
          ls_own_value = ls_own_property-value.
          ls_own_getter = ls_own_property-getter.
          ls_own_setter = ls_own_property-setter.
        ELSE.
          IF ls_own_key-tag = zcl_qjs_value=>tag_symbol.
            DATA(ls_native_own_symbol) = lo_own_native->get_own_symbol_property(
              ls_own_key-int_value ).
            lv_own_found = ls_native_own_symbol-found.
            lv_own_writable = ls_native_own_symbol-writable.
            lv_own_enumerable = ls_native_own_symbol-enumerable.
            lv_own_configurable = ls_native_own_symbol-configurable.
            lv_own_accessor = ls_native_own_symbol-accessor.
            ls_own_value = ls_native_own_symbol-value.
            ls_own_getter = ls_native_own_symbol-getter.
            ls_own_setter = ls_native_own_symbol-setter.
          ELSE.
            DATA(ls_native_own_property) = lo_own_native->get_own_property(
              zcl_qjs_value=>to_string( ls_own_key ) ).
            lv_own_found = ls_native_own_property-found.
            lv_own_writable = ls_native_own_property-writable.
            lv_own_enumerable = ls_native_own_property-enumerable.
            lv_own_configurable = ls_native_own_property-configurable.
            ls_own_value = ls_native_own_property-value.
          ENDIF.
        ENDIF.
        IF lv_own_found = abap_false.
          result = zcl_qjs_value=>new_undefined( ).
        ELSE.
          DATA(lo_descriptor_result) = mo_runtime->create_object( ).
          IF lv_own_accessor = abap_true.
            lo_descriptor_result->set(
              name = 'get' value = ls_own_getter ).
            lo_descriptor_result->set(
              name = 'set' value = ls_own_setter ).
          ELSE.
            lo_descriptor_result->set(
              name = 'value' value = ls_own_value ).
            lo_descriptor_result->set(
              name = 'writable' value = zcl_qjs_value=>new_boolean(
                lv_own_writable ) ).
          ENDIF.
          lo_descriptor_result->set(
            name = 'enumerable' value = zcl_qjs_value=>new_boolean(
              lv_own_enumerable ) ).
          lo_descriptor_result->set(
            name = 'configurable' value = zcl_qjs_value=>new_boolean(
              lv_own_configurable ) ).
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
        DATA lo_current_proto TYPE REF TO zcl_qjs_object.
        TRY.
            lo_object ?= ls_proto_target-object_ref.
            lo_current_proto = lo_object->get_prototype( ).
          CATCH cx_sy_move_cast_error.
            DATA lo_proto_closure TYPE REF TO zcl_qjs_closure.
            TRY.
                lo_proto_closure ?= ls_proto_target-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
            IF lo_proto_closure IS BOUND.
              lo_current_proto = lo_proto_closure->get_property_storage(
                )->get_prototype( ).
            ELSE.
              DATA lo_proto_native TYPE REF TO zcl_qjs_native_function.
              TRY.
                  lo_proto_native ?= ls_proto_target-object_ref.
                CATCH cx_sy_move_cast_error.
              ENDTRY.
              IF lo_proto_native IS BOUND.
                DATA(ls_native_proto) = lo_proto_native->get_internal_prototype( ).
                IF ls_native_proto-tag <> 0.
                  result = ls_native_proto.
                  RETURN.
                ENDIF.
                lo_current_proto = mo_runtime->get_function_prototype( ).
              ELSEIF is_callable( ls_proto_target ) = abap_true.
                lo_current_proto = mo_runtime->get_function_prototype( ).
              ELSE.
                RAISE EXCEPTION TYPE zcx_qjs_error
                  EXPORTING reason = 'TypeError: prototype target is unsupported'.
              ENDIF.
            ENDIF.
        ENDTRY.
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
        DATA lo_set_proto_closure TYPE REF TO zcl_qjs_closure.
        DATA lo_set_proto_base TYPE REF TO zcl_qjs_closure.
        DATA(lv_set_proto_constructable_base) = abap_false.
        CLEAR lo_set_proto_closure.
        CLEAR lo_set_proto_base.
        TRY.
            lo_object ?= ls_set_proto_target-object_ref.
          CATCH cx_sy_move_cast_error.
            TRY.
                lo_set_proto_closure ?= ls_set_proto_target-object_ref.
                lo_object = lo_set_proto_closure->get_property_storage( ).
              CATCH cx_sy_move_cast_error.
            ENDTRY.
            IF lo_object IS NOT BOUND.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: prototype target must be ordinary'.
            ENDIF.
        ENDTRY.
        DATA lo_new_prototype TYPE REF TO zcl_qjs_object.
        IF ls_set_proto_value-tag = zcl_qjs_value=>tag_object.
          IF lo_set_proto_closure IS BOUND
              AND is_constructable( ls_set_proto_value ) = abap_true.
            lv_set_proto_constructable_base = abap_true.
          ENDIF.
          TRY.
              lo_new_prototype ?= ls_set_proto_value-object_ref.
            CATCH cx_sy_move_cast_error.
              TRY.
                  lo_set_proto_base ?= ls_set_proto_value-object_ref.
                  lo_new_prototype = lo_set_proto_base->get_property_storage( ).
                CATCH cx_sy_move_cast_error.
              ENDTRY.
              IF lo_new_prototype IS NOT BOUND.
                IF lv_set_proto_constructable_base = abap_true.
                  lo_new_prototype = mo_runtime->get_function_prototype( ).
                ELSE.
                  RAISE EXCEPTION TYPE zcx_qjs_error
                    EXPORTING reason = 'TypeError: prototype value must be ordinary'.
                ENDIF.
              ENDIF.
          ENDTRY.
        ENDIF.
        lo_object->set_prototype( lo_new_prototype ).
        IF lo_set_proto_closure IS BOUND
            AND lv_set_proto_constructable_base = abap_true.
          lo_set_proto_closure->set_base_constructor( ls_set_proto_value ).
        ENDIF.
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
      WHEN id_object_has_own OR id_object_has_own_property.
        DATA(lv_has_own_has_key) = abap_false.
        IF mv_id = id_object_has_own_property.
          DATA(ls_has_own_target) = this_value.
          READ TABLE arguments INDEX 1 INTO DATA(ls_has_own_key).
          lv_has_own_has_key = xsdbool( sy-subrc = 0 ).
        ELSE.
          READ TABLE arguments INDEX 1 INTO ls_has_own_target.
          IF sy-subrc = 0.
            READ TABLE arguments INDEX 2 INTO ls_has_own_key.
            lv_has_own_has_key = xsdbool( sy-subrc = 0 ).
          ENDIF.
        ENDIF.
        IF ls_has_own_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: own-property target is not an object'.
        ENDIF.
        DATA lo_has_own_native TYPE REF TO zcl_qjs_native_function.
        DATA lo_has_own_closure TYPE REF TO zcl_qjs_closure.
        TRY.
            lo_object ?= ls_has_own_target-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
        IF lo_object IS NOT BOUND.
          TRY.
              lo_has_own_closure ?= ls_has_own_target-object_ref.
              lo_object = lo_has_own_closure->get_property_storage( ).
            CATCH cx_sy_move_cast_error.
          ENDTRY.
        ENDIF.
        IF lo_object IS NOT BOUND.
          TRY.
              lo_has_own_native ?= ls_has_own_target-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
        ENDIF.
        IF lo_object IS NOT BOUND AND lo_has_own_native IS NOT BOUND.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Object.hasOwn target is unsupported'.
        ENDIF.
        IF lv_has_own_has_key = abap_false.
          ls_has_own_key = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        IF lo_has_own_native IS BOUND AND ls_has_own_key-tag = zcl_qjs_value=>tag_symbol.
          result = zcl_qjs_value=>new_boolean( abap_false ).
        ELSEIF lo_has_own_native IS BOUND.
          DATA(ls_has_own_native_property) = lo_has_own_native->get_own_property(
            zcl_qjs_value=>to_string( ls_has_own_key ) ).
          result = zcl_qjs_value=>new_boolean(
            ls_has_own_native_property-found ).
        ELSEIF ls_has_own_key-tag = zcl_qjs_value=>tag_symbol.
          result = zcl_qjs_value=>new_boolean(
            lo_object->has_own_symbol( ls_has_own_key-int_value ) ).
        ELSE.
          result = zcl_qjs_value=>new_boolean( lo_object->has_own(
            zcl_qjs_value=>to_string( ls_has_own_key ) ) ).
        ENDIF.
      WHEN id_object_value_of.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Object.prototype.valueOf receiver is null or undefined'.
        ENDIF.
        result = this_value.
      WHEN id_object_property_is_enum.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: propertyIsEnumerable receiver is not an object'.
        ENDIF.
        DATA lo_enum_native TYPE REF TO zcl_qjs_native_function.
        DATA lo_enum_closure TYPE REF TO zcl_qjs_closure.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
        IF lo_object IS NOT BOUND.
          TRY.
              lo_enum_closure ?= this_value-object_ref.
              lo_object = lo_enum_closure->get_property_storage( ).
            CATCH cx_sy_move_cast_error.
          ENDTRY.
        ENDIF.
        IF lo_object IS NOT BOUND.
          TRY.
              lo_enum_native ?= this_value-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
        ENDIF.
        IF lo_object IS NOT BOUND AND lo_enum_native IS NOT BOUND.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: propertyIsEnumerable receiver is unsupported'.
        ENDIF.
        READ TABLE arguments INDEX 1 INTO DATA(ls_property_is_enum_key).
        IF sy-subrc <> 0.
          ls_property_is_enum_key = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lv_property_is_enum) = abap_false.
        IF lo_enum_native IS BOUND
            AND ls_property_is_enum_key-tag = zcl_qjs_value=>tag_symbol.
          lv_property_is_enum = abap_false.
        ELSEIF lo_enum_native IS BOUND.
          DATA(ls_property_is_enum_native) = lo_enum_native->get_own_property(
            zcl_qjs_value=>to_string( ls_property_is_enum_key ) ).
          lv_property_is_enum = xsdbool(
            ls_property_is_enum_native-found = abap_true
            AND ls_property_is_enum_native-enumerable = abap_true ).
        ELSEIF ls_property_is_enum_key-tag = zcl_qjs_value=>tag_symbol.
          DATA(ls_property_is_enum_symbol) = lo_object->get_own_symbol_property(
            ls_property_is_enum_key-int_value ).
          lv_property_is_enum = xsdbool(
            ls_property_is_enum_symbol-found = abap_true
            AND ls_property_is_enum_symbol-enumerable = abap_true ).
        ELSE.
          DATA(ls_property_is_enum_string) = lo_object->get_own_property(
            zcl_qjs_value=>to_string( ls_property_is_enum_key ) ).
          lv_property_is_enum = xsdbool(
            ls_property_is_enum_string-found = abap_true
            AND ls_property_is_enum_string-enumerable = abap_true ).
        ENDIF.
        result = zcl_qjs_value=>new_boolean( lv_property_is_enum ).
      WHEN id_object_is_prototype_of.
        READ TABLE arguments INDEX 1 INTO DATA(ls_is_prototype_value).
        IF sy-subrc <> 0 OR ls_is_prototype_value-tag <> zcl_qjs_value=>tag_object.
          result = zcl_qjs_value=>new_boolean( abap_false ).
          RETURN.
        ENDIF.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: isPrototypeOf receiver is not an object'.
        ENDIF.
        DATA lo_is_prototype_target TYPE REF TO object.
        DATA lo_is_prototype_value TYPE REF TO zcl_qjs_object.
        lo_is_prototype_target = this_value-object_ref.
        TRY.
            lo_is_prototype_value ?= ls_is_prototype_value-object_ref.
          CATCH cx_sy_move_cast_error.
            CLEAR lo_is_prototype_value.
        ENDTRY.
        DATA lo_is_prototype_current TYPE REF TO zcl_qjs_object.
        IF lo_is_prototype_value IS BOUND.
          lo_is_prototype_current = lo_is_prototype_value->get_prototype( ).
        ELSEIF is_callable( ls_is_prototype_value ) = abap_true.
          lo_is_prototype_current = mo_runtime->get_function_prototype( ).
        ENDIF.
        DATA(lv_is_prototype) = abap_false.
        WHILE lo_is_prototype_current IS BOUND.
          IF lo_is_prototype_current = lo_is_prototype_target.
            lv_is_prototype = abap_true.
            EXIT.
          ENDIF.
          lo_is_prototype_current = lo_is_prototype_current->get_prototype( ).
        ENDWHILE.
        result = zcl_qjs_value=>new_boolean( lv_is_prototype ).
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
          IF ls_is_left-int_value = zcl_qjs_value=>number_nan
              AND ls_is_right-int_value = zcl_qjs_value=>number_nan.
            lv_same_value = abap_true.
          ELSE.
            DATA(lv_left_negative_zero) = xsdbool(
              ls_is_left-int_value = zcl_qjs_value=>number_neg_zero ).
            DATA(lv_right_negative_zero) = xsdbool(
              ls_is_right-int_value = zcl_qjs_value=>number_neg_zero ).
            DATA(lv_left_zero) = xsdbool( lv_left_negative_zero = abap_true
              OR ( ls_is_left-tag = zcl_qjs_value=>tag_int
                AND ls_is_left-int_value = 0 )
              OR ( ls_is_left-int_value = zcl_qjs_value=>number_finite
                AND ls_is_left-float_value = 0 ) ).
            DATA(lv_right_zero) = xsdbool( lv_right_negative_zero = abap_true
              OR ( ls_is_right-tag = zcl_qjs_value=>tag_int
                AND ls_is_right-int_value = 0 )
              OR ( ls_is_right-int_value = zcl_qjs_value=>number_finite
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
      WHEN id_aggregate_error.
        DATA lv_aggregate_message TYPE string.
        DATA lv_aggregate_has_message TYPE abap_bool.
        READ TABLE arguments INDEX 2 INTO DATA(ls_aggregate_message).
        IF sy-subrc = 0
            AND ls_aggregate_message-tag <> zcl_qjs_value=>tag_undefined.
          lv_aggregate_message = mo_runtime->to_string( ls_aggregate_message ).
          lv_aggregate_has_message = abap_true.
        ENDIF.
        READ TABLE arguments INDEX 3 INTO DATA(ls_aggregate_options).
        IF sy-subrc <> 0.
          ls_aggregate_options = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(ls_aggregate_cause) = get_error_cause( ls_aggregate_options ).
        DATA(lo_aggregate_errors) = mo_runtime->create_array( ).
        IF ls_argument-tag = 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(ls_aggregate_iterator) = mo_runtime->get_iterator( ls_argument ).
        DATA(lv_aggregate_index) = CONV int8( 0 ).
        WHILE abap_true = abap_true.
          DATA(ls_aggregate_step) = mo_runtime->iterator_next(
            ls_aggregate_iterator ).
          IF ls_aggregate_step-done = abap_true.
            EXIT.
          ENDIF.
          lo_aggregate_errors->set_element(
            index = lv_aggregate_index value = ls_aggregate_step-value ).
          lv_aggregate_index = lv_aggregate_index + 1.
        ENDWHILE.
        IF lv_aggregate_has_message = abap_true
            AND ls_aggregate_cause-found = abap_true.
          result = mo_runtime->create_aggregate_error(
            errors  = lo_aggregate_errors
            message = lv_aggregate_message
            cause   = ls_aggregate_cause-value ).
        ELSEIF lv_aggregate_has_message = abap_true.
          result = mo_runtime->create_aggregate_error(
            errors = lo_aggregate_errors message = lv_aggregate_message ).
        ELSEIF ls_aggregate_cause-found = abap_true.
          result = mo_runtime->create_aggregate_error(
            errors = lo_aggregate_errors cause = ls_aggregate_cause-value ).
        ELSE.
          result = mo_runtime->create_aggregate_error(
            errors = lo_aggregate_errors ).
        ENDIF.
      WHEN id_error OR id_type_error OR id_range_error OR id_syntax_error
          OR id_reference_error OR id_uri_error OR id_eval_error.
        lv_error_name = 'Error'.
        CASE mv_id.
          WHEN id_type_error. lv_error_name = 'TypeError'.
          WHEN id_range_error. lv_error_name = 'RangeError'.
          WHEN id_syntax_error. lv_error_name = 'SyntaxError'.
          WHEN id_reference_error. lv_error_name = 'ReferenceError'.
          WHEN id_uri_error. lv_error_name = 'URIError'.
          WHEN id_eval_error. lv_error_name = 'EvalError'.
        ENDCASE.
        CLEAR lv_error_message.
        DATA lv_error_has_message TYPE abap_bool.
        IF sy-subrc = 0 AND ls_argument-tag <> zcl_qjs_value=>tag_undefined.
          lv_error_message = mo_runtime->to_string( ls_argument ).
          lv_error_has_message = abap_true.
        ENDIF.
        READ TABLE arguments INDEX 2 INTO DATA(ls_error_options).
        IF sy-subrc <> 0.
          ls_error_options = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(ls_error_cause) = get_error_cause( ls_error_options ).
        IF lv_error_has_message = abap_true AND ls_error_cause-found = abap_true.
          result = mo_runtime->create_error(
            name = lv_error_name message = lv_error_message
            cause = ls_error_cause-value ).
        ELSEIF lv_error_has_message = abap_true.
          result = mo_runtime->create_error(
            name = lv_error_name message = lv_error_message ).
        ELSEIF ls_error_cause-found = abap_true.
          result = mo_runtime->create_error(
            name = lv_error_name cause = ls_error_cause-value ).
        ELSE.
          result = mo_runtime->create_error( name = lv_error_name ).
        ENDIF.
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
        DATA(ls_error_name_value) = lo_object->get( 'name' ).
        DATA(lv_to_string_name) = CONV string( 'Error' ).
        IF ls_error_name_value-tag <> zcl_qjs_value=>tag_undefined.
          lv_to_string_name = zcl_qjs_value=>to_string( ls_error_name_value ).
        ENDIF.
        DATA(ls_error_message_value) = lo_object->get( 'message' ).
        DATA(lv_to_string_message) = CONV string( '' ).
        IF ls_error_message_value-tag <> zcl_qjs_value=>tag_undefined.
          lv_to_string_message = zcl_qjs_value=>to_string(
            ls_error_message_value ).
        ENDIF.
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
      WHEN id_promise.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'TypeError: Promise constructor requires new'.
      WHEN id_promise_species_get.
        result = this_value.
      WHEN id_async_resume_fulfill OR id_async_resume_reject.
        DATA lo_async_task TYPE REF TO zcl_qjs_async_task.
        TRY.
            lo_async_task ?= ms_bound_target-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
        IF lo_async_task IS NOT BOUND.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: invalid async continuation'.
        ENDIF.
        READ TABLE arguments INDEX 1 INTO DATA(ls_async_value).
        IF sy-subrc <> 0.
          ls_async_value = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        lo_async_task->resume(
          value    = ls_async_value
          rejected = xsdbool( mv_id = id_async_resume_reject ) ).
        result = zcl_qjs_value=>new_undefined( ).
      WHEN id_async_from_sync_next OR id_async_from_sync_return
          OR id_async_from_sync_throw.
        DATA(lv_sync_resume_kind) = COND i(
          WHEN mv_id = id_async_from_sync_return THEN 1
          WHEN mv_id = id_async_from_sync_throw THEN 2
          ELSE 0 ).
        IF ls_argument-tag = 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        IF lv_sync_resume_kind = 0.
          DATA lt_sync_arguments TYPE zif_qjs_callable=>ty_arguments.
          APPEND ls_argument TO lt_sync_arguments.
          DATA(ls_sync_raw_step) = mo_runtime->invoke_callable(
            callable = ms_bound_this this_value = ms_bound_target
            arguments = lt_sync_arguments ).
          DATA(ls_sync_step_result) = mo_runtime->iterator_result(
            ls_sync_raw_step ).
          DATA(ls_sync_resume) = VALUE zcl_qjs_runtime=>ty_iterator_resume_result(
            found = abap_true done = ls_sync_step_result-done
            value = ls_sync_step_result-value ).
        ELSE.
          ls_sync_resume = mo_runtime->iterator_resume(
            iterator = ms_bound_target kind = lv_sync_resume_kind
            value = ls_argument pass_value = abap_true ).
        ENDIF.
        IF ls_sync_resume-found = abap_false.
          IF lv_sync_resume_kind = 2.
            mo_runtime->iterator_close( ms_bound_target ).
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: iterator has no throw method'.
          ENDIF.
          ls_sync_resume-found = abap_true.
          ls_sync_resume-done = abap_true.
          ls_sync_resume-value = ls_argument.
        ENDIF.
        DATA(lo_sync_value_promise) = mo_runtime->create_promise( ).
        lo_sync_value_promise->promise_settle(
          value = ls_sync_resume-value rejected = abap_false ).
        DATA(lo_sync_result_promise) = mo_runtime->create_promise( ).
        DATA(lo_sync_result_handler) = NEW zcl_qjs_native_function(
          id = id_async_from_sync_result runtime = mo_runtime
          bound_target = zcl_qjs_value=>new_boolean( ls_sync_resume-done ) ).
        DATA lo_sync_result_handler_ref TYPE REF TO object.
        lo_sync_result_handler_ref = lo_sync_result_handler.
        lo_sync_value_promise->promise_add_reaction(
          on_fulfilled = zcl_qjs_value=>new_object( lo_sync_result_handler_ref )
          on_rejected  = zcl_qjs_value=>new_undefined( )
          next_promise = lo_sync_result_promise ).
        result = zcl_qjs_value=>new_object( lo_sync_result_promise ).
      WHEN id_async_from_sync_result.
        IF ls_argument-tag = 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lo_async_sync_result) = mo_runtime->create_object( ).
        lo_async_sync_result->define_property( name = 'value' value = ls_argument ).
        lo_async_sync_result->define_property(
          name = 'done' value = zcl_qjs_value=>new_boolean(
            xsdbool( ms_bound_target-int_value <> 0 ) ) ).
        result = zcl_qjs_value=>new_object( lo_async_sync_result ).
      WHEN id_async_generator_next OR id_async_generator_throw
          OR id_async_generator_return.
        DATA lo_async_generator_object TYPE REF TO zcl_qjs_object.
        TRY.
            lo_async_generator_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
        IF lo_async_generator_object IS NOT BOUND
            OR lo_async_generator_object->is_async_generator( ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: async generator receiver is incompatible'.
        ENDIF.
        IF ls_argument-tag = 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        result = lo_async_generator_object->async_generator_enqueue(
          kind  = COND i(
            WHEN mv_id = id_async_generator_return THEN 1
            WHEN mv_id = id_async_generator_throw THEN 2
            ELSE 0 )
          input = ls_argument ).
      WHEN id_async_gen_await_fulfill OR id_async_gen_await_reject
          OR id_async_gen_result_fulfill OR id_async_gen_result_reject
          OR id_async_gen_delegate_fulfill
          OR id_async_gen_delegate_reject.
        DATA lo_async_generator TYPE REF TO zcl_qjs_async_generator.
        TRY.
            lo_async_generator ?= ms_bound_target-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
        IF lo_async_generator IS NOT BOUND.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: invalid async generator continuation'.
        ENDIF.
        IF ls_argument-tag = 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        IF mv_id = id_async_gen_delegate_fulfill
            OR mv_id = id_async_gen_delegate_reject.
          lo_async_generator->resume_delegate(
            value = ls_argument rejected = xsdbool(
              mv_id = id_async_gen_delegate_reject ) ).
        ELSEIF mv_id = id_async_gen_await_fulfill
            OR mv_id = id_async_gen_await_reject.
          lo_async_generator->resume_await(
            value = ls_argument rejected = xsdbool(
              mv_id = id_async_gen_await_reject ) ).
        ELSE.
          lo_async_generator->resume_result(
            value = ls_argument rejected = xsdbool(
              mv_id = id_async_gen_result_reject )
            done = xsdbool( ms_bound_this-int_value <> 0 ) ).
        ENDIF.
        result = zcl_qjs_value=>new_undefined( ).
      WHEN id_promise_capability_executor.
        DATA(ls_existing_capability_resolve) = get_own_property( '[[Resolve]]' ).
        DATA(ls_existing_capability_reject) = get_own_property( '[[Reject]]' ).
        IF ( ls_existing_capability_resolve-found = abap_true
              AND ls_existing_capability_resolve-value-tag
                <> zcl_qjs_value=>tag_undefined )
            OR ( ls_existing_capability_reject-found = abap_true
              AND ls_existing_capability_reject-value-tag
                <> zcl_qjs_value=>tag_undefined ).
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Promise capability executor called twice'.
        ENDIF.
        DATA ls_capability_resolve_arg TYPE zcl_qjs_value=>ty_value.
        DATA ls_capability_reject_arg TYPE zcl_qjs_value=>ty_value.
        READ TABLE arguments INDEX 1 INTO ls_capability_resolve_arg.
        IF sy-subrc <> 0.
          ls_capability_resolve_arg = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        READ TABLE arguments INDEX 2 INTO ls_capability_reject_arg.
        IF sy-subrc <> 0.
          ls_capability_reject_arg = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        define_property(
          name = '[[Resolve]]' value = ls_capability_resolve_arg
          writable = abap_false enumerable = abap_false configurable = abap_false ).
        define_property(
          name = '[[Reject]]' value = ls_capability_reject_arg
          writable = abap_false enumerable = abap_false configurable = abap_false ).
        result = zcl_qjs_value=>new_undefined( ).
      WHEN id_promise_catch.
        DATA(ls_catch_then) = get_callable_property(
          value = this_value name = 'then' ).
        DATA lt_catch_arguments TYPE zif_qjs_callable=>ty_arguments.
        APPEND zcl_qjs_value=>new_undefined( ) TO lt_catch_arguments.
        IF ls_argument-tag = 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        APPEND ls_argument TO lt_catch_arguments.
        result = mo_runtime->invoke_callable(
          callable = ls_catch_then this_value = this_value
          arguments = lt_catch_arguments ).
      WHEN id_promise_finally.
        DATA(ls_finally_then) = get_callable_property(
          value = this_value name = 'then' ).
        DATA(ls_finally_handler) = ls_argument.
        IF ls_finally_handler-tag = 0.
          ls_finally_handler = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA ls_finally_fulfilled TYPE zcl_qjs_value=>ty_value.
        DATA ls_finally_rejected TYPE zcl_qjs_value=>ty_value.
        IF mo_runtime->is_callable_value( ls_finally_handler ) = abap_true.
          DATA lo_finally_fulfilled TYPE REF TO zcl_qjs_native_function.
          DATA lo_finally_rejected TYPE REF TO zcl_qjs_native_function.
          CREATE OBJECT lo_finally_fulfilled
            EXPORTING id = id_promise_finalizer runtime = mo_runtime
              bound_target = ls_finally_handler
              bound_this = zcl_qjs_value=>new_boolean( abap_false ).
          CREATE OBJECT lo_finally_rejected
            EXPORTING id = id_promise_finalizer runtime = mo_runtime
              bound_target = ls_finally_handler
              bound_this = zcl_qjs_value=>new_boolean( abap_true ).
          DATA lo_finally_fulfilled_ref TYPE REF TO object.
          DATA lo_finally_rejected_ref TYPE REF TO object.
          lo_finally_fulfilled_ref = lo_finally_fulfilled.
          lo_finally_rejected_ref = lo_finally_rejected.
          ls_finally_fulfilled = zcl_qjs_value=>new_object( lo_finally_fulfilled_ref ).
          ls_finally_rejected = zcl_qjs_value=>new_object( lo_finally_rejected_ref ).
        ELSE.
          ls_finally_fulfilled = ls_finally_handler.
          ls_finally_rejected = ls_finally_handler.
        ENDIF.
        DATA lt_finally_arguments TYPE zif_qjs_callable=>ty_arguments.
        APPEND ls_finally_fulfilled TO lt_finally_arguments.
        APPEND ls_finally_rejected TO lt_finally_arguments.
        result = mo_runtime->invoke_callable(
          callable = ls_finally_then this_value = this_value
          arguments = lt_finally_arguments ).
      WHEN id_promise_then.
        DATA lo_promise TYPE REF TO zcl_qjs_object.
        TRY.
            lo_promise ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
        IF lo_promise IS NOT BOUND OR lo_promise->is_promise( ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Promise method receiver is not a Promise'.
        ENDIF.
        DATA(ls_species_constructor) = promise_species_constructor( lo_promise ).
        DATA(ls_then_capability) = new_promise_capability( ls_species_constructor ).
        DATA ls_on_fulfilled TYPE zcl_qjs_value=>ty_value.
        DATA ls_on_rejected TYPE zcl_qjs_value=>ty_value.
        READ TABLE arguments INDEX 1 INTO ls_on_fulfilled.
        READ TABLE arguments INDEX 2 INTO ls_on_rejected.
        IF ls_on_fulfilled-tag = 0.
          ls_on_fulfilled = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        IF ls_on_rejected-tag = 0.
          ls_on_rejected = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        lo_promise->promise_add_reaction(
          on_fulfilled = ls_on_fulfilled on_rejected = ls_on_rejected
          next_resolve = ls_then_capability-resolve
          next_reject = ls_then_capability-reject ).
        result = ls_then_capability-promise.
      WHEN id_promise_finalizer.
        IF ls_argument-tag = 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        IF mo_runtime->is_callable_value( ms_bound_target ) = abap_false.
          IF ms_bound_this-int_value <> 0.
            RAISE EXCEPTION TYPE zcx_qjs_throw EXPORTING value = ls_argument.
          ENDIF.
          result = ls_argument.
          RETURN.
        ENDIF.
        DATA(ls_cleanup_result) = mo_runtime->invoke_callable(
          callable = ms_bound_target this_value = zcl_qjs_value=>new_undefined( ) ).
        DATA(lo_cleanup_promise) = mo_runtime->create_promise( ).
        lo_cleanup_promise->promise_settle(
          value = ls_cleanup_result rejected = abap_false ).
        DATA(lo_finally_bridge) = mo_runtime->create_promise( ).
        DATA lo_finally_continue TYPE REF TO zcl_qjs_native_function.
        CREATE OBJECT lo_finally_continue
          EXPORTING id = id_promise_finally_continue runtime = mo_runtime
            bound_target = ls_argument bound_this = ms_bound_this.
        DATA lo_finally_continue_ref TYPE REF TO object.
        lo_finally_continue_ref = lo_finally_continue.
        DATA(ls_no_rejection_handler) = zcl_qjs_value=>new_undefined( ).
        lo_cleanup_promise->promise_add_reaction(
          on_fulfilled = zcl_qjs_value=>new_object( lo_finally_continue_ref )
          on_rejected = ls_no_rejection_handler next_promise = lo_finally_bridge ).
        result = zcl_qjs_value=>new_object( lo_finally_bridge ).
      WHEN id_promise_finally_continue.
        IF ms_bound_this-int_value <> 0.
          RAISE EXCEPTION TYPE zcx_qjs_throw EXPORTING value = ms_bound_target.
        ENDIF.
        result = ms_bound_target.
      WHEN id_promise_all OR id_promise_race OR id_promise_all_settled
          OR id_promise_any.
        DATA(ls_combinator_capability) = new_promise_capability( this_value ).
        DATA(ls_combinator_result) = ls_combinator_capability-promise.
        TRY.
            DATA(ls_combinator_resolve) = get_callable_property(
              value = this_value name = 'resolve' ).
            IF mo_runtime->is_callable_value( ls_combinator_resolve ) = abap_false.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: Promise resolve is not callable'.
            ENDIF.
            IF ls_argument-tag = 0.
              ls_argument = zcl_qjs_value=>new_undefined( ).
            ENDIF.
            DATA(ls_combinator_iterator) = mo_runtime->get_iterator( ls_argument ).
            DATA(lo_combinator_values) = mo_runtime->create_array( ).
            DATA(lo_combinator_state) = mo_runtime->create_object( ).
            lo_combinator_state->set(
              name = '[[Resolve]]' value = ls_combinator_capability-resolve ).
            lo_combinator_state->set(
              name = '[[Reject]]' value = ls_combinator_capability-reject ).
            lo_combinator_state->set(
              name  = '[[Values]]'
              value = zcl_qjs_value=>new_object( lo_combinator_values ) ).
            lo_combinator_state->set(
              name = '[[Remaining]]' value = zcl_qjs_value=>new_int( 0 ) ).
            DATA lv_combinator_index TYPE i.
            WHILE abap_true = abap_true.
              DATA(ls_combinator_step) = mo_runtime->iterator_next(
                ls_combinator_iterator ).
              IF ls_combinator_step-done = abap_true.
                EXIT.
              ENDIF.
              DATA lt_resolve_arguments TYPE zif_qjs_callable=>ty_arguments.
              APPEND ls_combinator_step-value TO lt_resolve_arguments.
              DATA(ls_resolved_input) = mo_runtime->invoke_callable(
                callable = ls_combinator_resolve this_value = this_value
                arguments = lt_resolve_arguments ).
              DATA(lo_input_promise) = mo_runtime->create_promise( ).
              lo_input_promise->promise_settle(
                value = ls_resolved_input rejected = abap_false ).
              DATA ls_combinator_fulfill TYPE zcl_qjs_value=>ty_value.
              IF mv_id = id_promise_all OR mv_id = id_promise_all_settled
                  OR mv_id = id_promise_any.
                lo_combinator_values->set_element(
                  index = CONV int8( lv_combinator_index )
                  value = zcl_qjs_value=>new_undefined( ) ).
                lo_combinator_state->set(
                  name  = '[[Remaining]]'
                  value = zcl_qjs_value=>new_int( lv_combinator_index + 1 ) ).
              ENDIF.
              IF mv_id = id_promise_all.
                DATA lo_all_fulfill TYPE REF TO zcl_qjs_native_function.
                CREATE OBJECT lo_all_fulfill
                  EXPORTING id = id_promise_all_fulfill runtime = mo_runtime
                    bound_target = zcl_qjs_value=>new_object( lo_combinator_state )
                    bound_this = zcl_qjs_value=>new_int( lv_combinator_index ).
                DATA lo_all_fulfill_ref TYPE REF TO object.
                lo_all_fulfill_ref = lo_all_fulfill.
                ls_combinator_fulfill = zcl_qjs_value=>new_object(
                  lo_all_fulfill_ref ).
              ELSEIF mv_id = id_promise_all_settled.
                DATA lo_settled_fulfill TYPE REF TO zcl_qjs_native_function.
                CREATE OBJECT lo_settled_fulfill
                  EXPORTING id = id_promise_all_settled_fulfill runtime = mo_runtime
                    bound_target = zcl_qjs_value=>new_object( lo_combinator_state )
                    bound_this = zcl_qjs_value=>new_int( lv_combinator_index ).
                DATA lo_settled_fulfill_ref TYPE REF TO object.
                lo_settled_fulfill_ref = lo_settled_fulfill.
                ls_combinator_fulfill = zcl_qjs_value=>new_object(
                  lo_settled_fulfill_ref ).
              ELSE.
                DATA lo_race_fulfill TYPE REF TO zcl_qjs_native_function.
                CREATE OBJECT lo_race_fulfill
                  EXPORTING id = id_promise_race_fulfill runtime = mo_runtime
                    bound_target = ls_combinator_result.
                DATA lo_race_fulfill_ref TYPE REF TO object.
                lo_race_fulfill_ref = lo_race_fulfill.
                ls_combinator_fulfill = zcl_qjs_value=>new_object(
                  lo_race_fulfill_ref ).
              ENDIF.
              DATA lv_combinator_reject_id TYPE i VALUE id_promise_combinator_reject.
              DATA ls_combinator_reject_target TYPE zcl_qjs_value=>ty_value.
              ls_combinator_reject_target = ls_combinator_capability-reject.
              IF mv_id = id_promise_all_settled.
                lv_combinator_reject_id = id_promise_all_settled_reject.
                ls_combinator_reject_target = zcl_qjs_value=>new_object(
                  lo_combinator_state ).
              ELSEIF mv_id = id_promise_any.
                lv_combinator_reject_id = id_promise_any_reject.
                ls_combinator_reject_target = zcl_qjs_value=>new_object(
                  lo_combinator_state ).
              ENDIF.
              IF mv_id = id_promise_race OR mv_id = id_promise_any.
                ls_combinator_fulfill = ls_combinator_capability-resolve.
              ENDIF.
              DATA lo_combinator_reject TYPE REF TO zcl_qjs_native_function.
              CREATE OBJECT lo_combinator_reject
                EXPORTING id = lv_combinator_reject_id runtime = mo_runtime
                  bound_target = ls_combinator_reject_target
                  bound_this = zcl_qjs_value=>new_int( lv_combinator_index ).
              DATA lo_combinator_reject_ref TYPE REF TO object.
              lo_combinator_reject_ref = lo_combinator_reject.
              DATA(lo_combinator_dummy) = mo_runtime->create_promise( ).
              lo_input_promise->promise_add_reaction(
                on_fulfilled = ls_combinator_fulfill
                on_rejected  = zcl_qjs_value=>new_object( lo_combinator_reject_ref )
                next_promise = lo_combinator_dummy ).
              lv_combinator_index = lv_combinator_index + 1.
            ENDWHILE.
            IF ( mv_id = id_promise_all OR mv_id = id_promise_all_settled )
                AND lv_combinator_index = 0.
              APPEND zcl_qjs_value=>new_object( lo_combinator_values )
                TO lt_empty_combinator_arguments.
              ls_empty_combinator_result = mo_runtime->invoke_callable(
                callable   = ls_combinator_capability-resolve
                this_value = zcl_qjs_value=>new_undefined( )
                arguments  = lt_empty_combinator_arguments ).
            ELSEIF mv_id = id_promise_any AND lv_combinator_index = 0.
              DATA(ls_empty_aggregate) = mo_runtime->create_aggregate_error(
                errors  = lo_combinator_values
                message = 'All promises were rejected' ).
              CLEAR lt_empty_combinator_arguments.
              APPEND ls_empty_aggregate TO lt_empty_combinator_arguments.
              ls_empty_combinator_result = mo_runtime->invoke_callable(
                callable   = ls_combinator_capability-reject
                this_value = zcl_qjs_value=>new_undefined( )
                arguments  = lt_empty_combinator_arguments ).
            ENDIF.
          CATCH zcx_qjs_throw INTO DATA(lx_combinator_throw).
            IF ls_combinator_iterator-tag = zcl_qjs_value=>tag_object.
              TRY.
                  mo_runtime->iterator_close( ls_combinator_iterator ).
                CATCH zcx_qjs_throw zcx_qjs_error.
              ENDTRY.
            ENDIF.
            APPEND lx_combinator_throw->value TO lt_combinator_error_arguments.
            ls_combinator_rejected = mo_runtime->invoke_callable(
              callable   = ls_combinator_capability-reject
              this_value = zcl_qjs_value=>new_undefined( )
              arguments  = lt_combinator_error_arguments ).
          CATCH zcx_qjs_error INTO DATA(lx_combinator_error).
            IF ls_combinator_iterator-tag = zcl_qjs_value=>tag_object.
              TRY.
                  mo_runtime->iterator_close( ls_combinator_iterator ).
                CATCH zcx_qjs_throw zcx_qjs_error.
              ENDTRY.
            ENDIF.
            DATA(ls_combinator_error_value) = mo_runtime->create_error_from_reason(
              lx_combinator_error->reason ).
            CLEAR lt_combinator_error_arguments.
            APPEND ls_combinator_error_value TO lt_combinator_error_arguments.
            ls_combinator_rejected = mo_runtime->invoke_callable(
              callable   = ls_combinator_capability-reject
              this_value = zcl_qjs_value=>new_undefined( )
              arguments  = lt_combinator_error_arguments ).
        ENDTRY.
        result = ls_combinator_result.
      WHEN id_promise_all_fulfill.
        DATA lo_all_state TYPE REF TO zcl_qjs_object.
        lo_all_state ?= ms_bound_target-object_ref.
        DATA lo_all_values TYPE REF TO zcl_qjs_object.
        DATA(ls_all_values) = lo_all_state->get( '[[Values]]' ).
        lo_all_values ?= ls_all_values-object_ref.
        lo_all_values->set_element(
          index = CONV int8( ms_bound_this-int_value ) value = ls_argument ).
        DATA(ls_all_remaining) = lo_all_state->get( '[[Remaining]]' ).
        DATA(lv_all_remaining) = ls_all_remaining-int_value - 1.
        lo_all_state->set(
          name  = '[[Remaining]]'
          value = zcl_qjs_value=>new_int( lv_all_remaining ) ).
        IF lv_all_remaining = 0.
          DATA(ls_all_resolve) = lo_all_state->get( '[[Resolve]]' ).
          DATA lt_all_resolve_arguments TYPE zif_qjs_callable=>ty_arguments.
          APPEND ls_all_values TO lt_all_resolve_arguments.
          DATA(ls_all_resolved) = mo_runtime->invoke_callable(
            callable   = ls_all_resolve
            this_value = zcl_qjs_value=>new_undefined( )
            arguments  = lt_all_resolve_arguments ).
        ENDIF.
        result = zcl_qjs_value=>new_undefined( ).
      WHEN id_promise_combinator_reject OR id_promise_race_fulfill.
        DATA lt_combinator_settle_arguments TYPE zif_qjs_callable=>ty_arguments.
        APPEND ls_argument TO lt_combinator_settle_arguments.
        DATA(ls_combinator_settled) = mo_runtime->invoke_callable(
          callable   = ms_bound_target
          this_value = zcl_qjs_value=>new_undefined( )
          arguments  = lt_combinator_settle_arguments ).
        result = zcl_qjs_value=>new_undefined( ).
      WHEN id_promise_all_settled_fulfill OR id_promise_all_settled_reject.
        DATA lo_settled_state TYPE REF TO zcl_qjs_object.
        lo_settled_state ?= ms_bound_target-object_ref.
        DATA lo_settled_values TYPE REF TO zcl_qjs_object.
        DATA(ls_settled_values) = lo_settled_state->get( '[[Values]]' ).
        lo_settled_values ?= ls_settled_values-object_ref.
        DATA(lo_settlement) = mo_runtime->create_object( ).
        IF mv_id = id_promise_all_settled_fulfill.
          lo_settlement->set(
            name = 'status' value = zcl_qjs_value=>new_string( 'fulfilled' ) ).
          lo_settlement->set( name = 'value' value = ls_argument ).
        ELSE.
          lo_settlement->set(
            name = 'status' value = zcl_qjs_value=>new_string( 'rejected' ) ).
          lo_settlement->set( name = 'reason' value = ls_argument ).
        ENDIF.
        lo_settled_values->set_element(
          index = CONV int8( ms_bound_this-int_value )
          value = zcl_qjs_value=>new_object( lo_settlement ) ).
        DATA(ls_settled_remaining) = lo_settled_state->get( '[[Remaining]]' ).
        DATA(lv_settled_remaining) = ls_settled_remaining-int_value - 1.
        lo_settled_state->set(
          name  = '[[Remaining]]'
          value = zcl_qjs_value=>new_int( lv_settled_remaining ) ).
        IF lv_settled_remaining = 0.
          DATA(ls_settled_resolve) = lo_settled_state->get( '[[Resolve]]' ).
          DATA lt_settled_resolve_arguments TYPE zif_qjs_callable=>ty_arguments.
          APPEND ls_settled_values TO lt_settled_resolve_arguments.
          DATA(ls_settled_resolved) = mo_runtime->invoke_callable(
            callable   = ls_settled_resolve
            this_value = zcl_qjs_value=>new_undefined( )
            arguments  = lt_settled_resolve_arguments ).
        ENDIF.
        result = zcl_qjs_value=>new_undefined( ).
      WHEN id_promise_any_reject.
        DATA lo_any_state TYPE REF TO zcl_qjs_object.
        lo_any_state ?= ms_bound_target-object_ref.
        DATA lo_any_errors TYPE REF TO zcl_qjs_object.
        DATA(ls_any_errors) = lo_any_state->get( '[[Values]]' ).
        lo_any_errors ?= ls_any_errors-object_ref.
        lo_any_errors->set_element(
          index = CONV int8( ms_bound_this-int_value ) value = ls_argument ).
        DATA(ls_any_remaining) = lo_any_state->get( '[[Remaining]]' ).
        DATA(lv_any_remaining) = ls_any_remaining-int_value - 1.
        lo_any_state->set(
          name = '[[Remaining]]' value = zcl_qjs_value=>new_int( lv_any_remaining ) ).
        IF lv_any_remaining = 0.
          DATA(ls_any_aggregate) = mo_runtime->create_aggregate_error(
            errors = lo_any_errors message = 'All promises were rejected' ).
          DATA(ls_any_reject) = lo_any_state->get( '[[Reject]]' ).
          DATA lt_any_reject_arguments TYPE zif_qjs_callable=>ty_arguments.
          APPEND ls_any_aggregate TO lt_any_reject_arguments.
          DATA(ls_any_rejected) = mo_runtime->invoke_callable(
            callable   = ls_any_reject
            this_value = zcl_qjs_value=>new_undefined( )
            arguments  = lt_any_reject_arguments ).
        ENDIF.
        result = zcl_qjs_value=>new_undefined( ).
      WHEN id_promise_resolve OR id_promise_reject.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Promise constructor receiver is not an object'.
        ENDIF.
        READ TABLE arguments INDEX 1 INTO DATA(ls_promise_static_value).
        IF sy-subrc <> 0.
          ls_promise_static_value = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        IF mv_id = id_promise_resolve
            AND ls_promise_static_value-tag = zcl_qjs_value=>tag_object.
          DATA lo_existing_promise TYPE REF TO zcl_qjs_object.
          TRY.
              lo_existing_promise ?= ls_promise_static_value-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_existing_promise IS BOUND
              AND lo_existing_promise->is_promise( ) = abap_true.
            DATA lv_promise_constructor_name TYPE string VALUE 'constructor'.
            DATA(ls_existing_constructor) = lo_existing_promise->get(
              lv_promise_constructor_name ).
            IF zcl_qjs_value=>strict_equal(
                left = ls_existing_constructor right = this_value ) = abap_true.
              result = ls_promise_static_value.
              RETURN.
            ENDIF.
          ENDIF.
        ENDIF.
        DATA(ls_static_capability) = new_promise_capability( this_value ).
        DATA lt_static_settle_arguments TYPE zif_qjs_callable=>ty_arguments.
        APPEND ls_promise_static_value TO lt_static_settle_arguments.
        IF mv_id = id_promise_reject.
          DATA(ls_static_settle_result) = mo_runtime->invoke_callable(
            callable   = ls_static_capability-reject
            this_value = zcl_qjs_value=>new_undefined( )
            arguments  = lt_static_settle_arguments ).
        ELSE.
          ls_static_settle_result = mo_runtime->invoke_callable(
            callable   = ls_static_capability-resolve
            this_value = zcl_qjs_value=>new_undefined( )
            arguments  = lt_static_settle_arguments ).
        ENDIF.
        result = ls_static_capability-promise.
      WHEN id_promise_fulfill OR id_promise_reject_fn.
        DATA lo_bound_promise TYPE REF TO zcl_qjs_object.
        TRY.
            lo_bound_promise ?= ms_bound_target-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
        IF lo_bound_promise IS NOT BOUND OR lo_bound_promise->is_promise( ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: invalid promise resolver'.
        ENDIF.
        IF ls_argument-tag = 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        lo_bound_promise->promise_settle(
          value    = ls_argument
          rejected = xsdbool( mv_id = id_promise_reject_fn ) ).
        result = zcl_qjs_value=>new_undefined( ).
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
          OR id_syntax_error OR id_reference_error OR id_uri_error OR id_eval_error
          OR id_function OR id_regexp.
        result = zif_qjs_callable~call(
          this_value = zcl_qjs_value=>new_undefined( ) arguments = arguments ).
      WHEN id_aggregate_error.
        result = zif_qjs_callable~call(
          this_value = zcl_qjs_value=>new_undefined( ) arguments = arguments ).
      WHEN id_promise.
        READ TABLE arguments INDEX 1 INTO DATA(ls_executor).
        IF runtime->is_callable_value( ls_executor ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Promise executor is not callable'.
        ENDIF.
        lo_object = runtime->create_promise( ).
        DATA(ls_promise_value) = zcl_qjs_value=>new_object( lo_object ).
        DATA lo_resolve TYPE REF TO zcl_qjs_native_function.
        DATA lo_reject TYPE REF TO zcl_qjs_native_function.
        CREATE OBJECT lo_resolve EXPORTING id = id_promise_fulfill runtime = runtime
          bound_target = ls_promise_value.
        CREATE OBJECT lo_reject EXPORTING id = id_promise_reject_fn runtime = runtime
          bound_target = ls_promise_value.
        DATA lo_resolve_ref TYPE REF TO object.
        DATA lo_reject_ref TYPE REF TO object.
        lo_resolve_ref = lo_resolve.
        lo_reject_ref = lo_reject.
        DATA lt_executor_arguments TYPE zif_qjs_callable=>ty_arguments.
        APPEND zcl_qjs_value=>new_object( lo_resolve_ref ) TO lt_executor_arguments.
        APPEND zcl_qjs_value=>new_object( lo_reject_ref ) TO lt_executor_arguments.
        TRY.
            DATA(ls_executor_result) = runtime->invoke_callable(
              callable = ls_executor this_value = zcl_qjs_value=>new_undefined( )
              arguments = lt_executor_arguments ).
          CATCH zcx_qjs_throw INTO DATA(lx_executor_throw).
            lo_object->promise_settle(
              value = lx_executor_throw->value rejected = abap_true ).
          CATCH zcx_qjs_error INTO DATA(lx_executor_error).
            lo_object->promise_settle(
              value    = runtime->create_error_from_reason( lx_executor_error->reason )
              rejected = abap_true ).
        ENDTRY.
        result = ls_promise_value.
      WHEN id_number OR id_string OR id_boolean.
        ls_primitive = zif_qjs_callable~call(
          this_value = zcl_qjs_value=>new_undefined( ) arguments = arguments ).
        IF mv_id = id_string.
          lo_object = runtime->create_object( runtime->get_string_prototype( ) ).
        ELSE.
          lo_object = runtime->create_object( ).
        ENDIF.
        IF mv_id = id_string.
          initialize_string_wrapper(
            object = lo_object primitive = ls_primitive ).
        ELSE.
          lo_object->define_property(
            name = '[[PrimitiveValue]]' value = ls_primitive
            writable = abap_false enumerable = abap_false configurable = abap_false ).
        ENDIF.
        result = zcl_qjs_value=>new_object( lo_object ).
      WHEN id_map OR id_set.
        IF mv_id = id_map.
          lo_object = runtime->create_object( runtime->get_map_prototype( ) ).
          lo_object->initialize_collection( zcl_qjs_object=>collection_map ).
        ELSE.
          lo_object = runtime->create_object( runtime->get_set_prototype( ) ).
          lo_object->initialize_collection( zcl_qjs_object=>collection_set ).
        ENDIF.
        READ TABLE arguments INDEX 1 INTO DATA(ls_collection_source).
        IF sy-subrc = 0
            AND ls_collection_source-tag <> zcl_qjs_value=>tag_undefined
            AND ls_collection_source-tag <> zcl_qjs_value=>tag_null.
          DATA(lv_adder_name) = COND string(
            WHEN mv_id = id_map THEN 'set' ELSE 'add' ).
          DATA(ls_collection_adder) = lo_object->get( lv_adder_name ).
          DATA(ls_source_iterator) = runtime->get_iterator( ls_collection_source ).
          WHILE abap_true = abap_true.
            DATA(ls_source_step) = runtime->iterator_next( ls_source_iterator ).
            IF ls_source_step-done = abap_true.
              EXIT.
            ENDIF.
            DATA lt_adder_arguments TYPE zif_qjs_callable=>ty_arguments.
            IF mv_id = id_map.
              IF ls_source_step-value-tag <> zcl_qjs_value=>tag_object.
                RAISE EXCEPTION TYPE zcx_qjs_error
                  EXPORTING reason = 'TypeError: Map entry is not an object'.
              ENDIF.
              DATA lo_source_pair TYPE REF TO zcl_qjs_object.
              TRY.
                  lo_source_pair ?= ls_source_step-value-object_ref.
                CATCH cx_sy_move_cast_error.
                  RAISE EXCEPTION TYPE zcx_qjs_error
                    EXPORTING reason = 'TypeError: Map entry is unsupported'.
              ENDTRY.
              APPEND lo_source_pair->get_element( 0 ) TO lt_adder_arguments.
              APPEND lo_source_pair->get_element( 1 ) TO lt_adder_arguments.
            ELSE.
              APPEND ls_source_step-value TO lt_adder_arguments.
            ENDIF.
            DATA(ls_adder_ignored) = runtime->invoke_callable(
              callable   = ls_collection_adder
              this_value = zcl_qjs_value=>new_object( lo_object )
              arguments  = lt_adder_arguments ).
          ENDWHILE.
        ENDIF.
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
          OR id_array_reduce_right OR id_array_fill OR id_array_copy_within
          OR id_array_concat OR id_array_splice OR id_array_sort
          OR id_array_find_last OR id_array_find_last_index
          OR id_array_flat OR id_array_flat_map OR id_array_of
          OR id_array_to_string OR id_array_to_reversed OR id_array_with
          OR id_array_to_sorted OR id_array_to_spliced
          OR id_object_has_own_property OR id_object_value_of
          OR id_object_property_is_enum OR id_object_is_prototype_of
          OR id_string_to_string OR id_string_value_of OR id_string_char_at
          OR id_string_char_code_at OR id_string_at OR id_string_index_of
          OR id_string_last_index_of OR id_string_includes
          OR id_string_starts_with OR id_string_ends_with OR id_string_slice
          OR id_string_substring OR id_string_concat OR id_string_repeat
          OR id_string_to_lower OR id_string_to_upper OR id_string_trim
          OR id_string_trim_start OR id_string_trim_end
          OR id_reflect_apply OR id_reflect_construct
          OR id_reflect_define_property OR id_reflect_delete_property
          OR id_reflect_get OR id_reflect_get_own_descriptor
          OR id_reflect_get_prototype OR id_reflect_has
          OR id_reflect_is_extensible OR id_reflect_own_keys
          OR id_reflect_prevent_extensions OR id_reflect_set
          OR id_reflect_set_prototype OR id_object_is_extensible
          OR id_object_prevent_extensions OR id_map_get OR id_map_set
          OR id_map_has OR id_map_delete OR id_map_clear OR id_map_size
          OR id_map_entries OR id_map_keys OR id_map_values OR id_map_for_each
          OR id_set_add OR id_set_has OR id_set_delete OR id_set_clear
          OR id_set_size OR id_set_entries OR id_set_values OR id_set_for_each
          OR id_collection_next OR id_iterator_self OR id_array_entries
          OR id_array_keys OR id_array_values OR id_string_iterator
          OR id_generator_next OR id_generator_throw OR id_generator_return
          OR id_promise_then OR id_promise_catch OR id_promise_resolve
          OR id_promise_reject OR id_promise_fulfill OR id_promise_reject_fn
          OR id_promise_finally OR id_promise_finalizer
          OR id_promise_finally_continue OR id_promise_all OR id_promise_race
          OR id_promise_all_fulfill OR id_promise_combinator_reject
          OR id_promise_race_fulfill OR id_promise_all_settled OR id_promise_any
          OR id_promise_all_settled_fulfill OR id_promise_all_settled_reject
          OR id_promise_any_reject OR id_promise_capability_executor
          OR id_async_resume_fulfill OR id_async_resume_reject
          OR id_async_from_sync_next OR id_async_from_sync_result
          OR id_async_from_sync_return OR id_async_from_sync_throw
          OR id_async_generator_next
          OR id_async_generator_throw OR id_async_generator_return
          OR id_async_gen_await_fulfill OR id_async_gen_await_reject
          OR id_async_gen_result_fulfill
          OR id_async_gen_result_reject
          OR id_async_gen_delegate_fulfill
          OR id_async_gen_delegate_reject.
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
