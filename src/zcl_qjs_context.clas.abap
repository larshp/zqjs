CLASS zcl_qjs_context DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS constructor IMPORTING runtime TYPE REF TO zcl_qjs_runtime
      RAISING zcx_qjs_error.
    METHODS get_runtime RETURNING VALUE(result) TYPE REF TO zcl_qjs_runtime
      RAISING zcx_qjs_error.
    METHODS set_global
      IMPORTING name TYPE string value TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS register_function
      IMPORTING name TYPE string callable TYPE REF TO zif_qjs_callable
      RAISING zcx_qjs_error.
    METHODS register_constructor
      IMPORTING name TYPE string constructor TYPE REF TO zif_qjs_constructable
      RAISING zcx_qjs_error.
    METHODS get_global
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS get_global_object
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object
      RAISING zcx_qjs_error.
    METHODS eval
      IMPORTING source TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS call
      IMPORTING name TYPE string arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
        this_value TYPE zcl_qjs_value=>ty_value OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS dispose.
    METHODS is_disposed RETURNING VALUE(result) TYPE abap_bool.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_global,
      name TYPE string,
      cell TYPE REF TO zcl_qjs_cell,
    END OF ty_global.
    TYPES ty_globals TYPE SORTED TABLE OF ty_global WITH UNIQUE KEY name.
    DATA mo_runtime TYPE REF TO zcl_qjs_runtime.
    DATA mv_disposed TYPE abap_bool.
    DATA mt_globals TYPE ty_globals.
    DATA mo_global_object TYPE REF TO zcl_qjs_object.
    METHODS assert_active RAISING zcx_qjs_error.
    METHODS install_string_method
      IMPORTING prototype TYPE REF TO zcl_qjs_object name TYPE string
        id TYPE i length TYPE i
      RAISING zcx_qjs_error.
    METHODS install_reflect_method
      IMPORTING reflect_object TYPE REF TO zcl_qjs_object name TYPE string
        id TYPE i length TYPE i
      RAISING zcx_qjs_error.
    METHODS install_collection_method
      IMPORTING prototype TYPE REF TO zcl_qjs_object name TYPE string
        id TYPE i length TYPE i
      RAISING zcx_qjs_error.
ENDCLASS.

CLASS zcl_qjs_context IMPLEMENTATION.
  METHOD assert_active.
    IF mv_disposed = abap_true OR mo_runtime IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'JavaScript context is disposed'.
    ENDIF.
  ENDMETHOD.

  METHOD constructor.
    DATA lo_native TYPE REF TO zcl_qjs_native_function.
    DATA lo_math TYPE REF TO zcl_qjs_object.
    DATA lo_json TYPE REF TO zcl_qjs_object.
    DATA lo_reflect TYPE REF TO zcl_qjs_object.
    DATA lo_map_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_set_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_map_iterator_proto TYPE REF TO zcl_qjs_object.
    DATA lo_set_iterator_proto TYPE REF TO zcl_qjs_object.
    DATA lo_array_iterator_proto TYPE REF TO zcl_qjs_object.
    DATA lo_string_iterator_proto TYPE REF TO zcl_qjs_object.
    DATA lo_generator_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_generator_function_proto TYPE REF TO zcl_qjs_object.
    DATA lo_async_iterator_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_async_generator_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_async_gen_function_proto TYPE REF TO zcl_qjs_object.
    DATA lo_promise_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_regexp_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_reference TYPE REF TO object.
    DATA lo_object_intrinsic TYPE REF TO zcl_qjs_native_function.
    DATA lo_array_intrinsic TYPE REF TO zcl_qjs_native_function.
    DATA lo_symbol_intrinsic TYPE REF TO zcl_qjs_native_function.
    DATA lo_number_intrinsic TYPE REF TO zcl_qjs_native_function.
    DATA lo_string_intrinsic TYPE REF TO zcl_qjs_native_function.
    DATA lo_parse_int_intrinsic TYPE REF TO zcl_qjs_native_function.
    DATA lo_parse_float_intrinsic TYPE REF TO zcl_qjs_native_function.
    DATA lo_function_intrinsic TYPE REF TO zcl_qjs_native_function.
    DATA lo_promise_intrinsic TYPE REF TO zcl_qjs_native_function.
    DATA lo_regexp_intrinsic TYPE REF TO zcl_qjs_native_function.
    DATA lo_object_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_function_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_array_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_string_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_error_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_eval_error_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_type_error_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_range_error_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_syntax_error_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_reference_error_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_uri_error_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_aggregate_error_prototype TYPE REF TO zcl_qjs_object.
    DATA lv_constructor_property TYPE string VALUE 'constructor'.
    DATA lv_to_string_name TYPE string VALUE 'toString'.
    DATA lv_has_own_property_name TYPE string VALUE 'hasOwnProperty'.
    DATA lv_value_of_name TYPE string VALUE 'valueOf'.
    DATA lv_property_is_enum_name TYPE string VALUE 'propertyIsEnumerable'.
    DATA lv_is_prototype_of_name TYPE string VALUE 'isPrototypeOf'.
    DATA lv_error_name TYPE string VALUE 'Error'.
    DATA lv_eval_error_name TYPE string VALUE 'EvalError'.
    DATA lv_type_error_name TYPE string VALUE 'TypeError'.
    DATA lv_range_error_name TYPE string VALUE 'RangeError'.
    DATA lv_syntax_error_name TYPE string VALUE 'SyntaxError'.
    DATA lv_reference_error_name TYPE string VALUE 'ReferenceError'.
    DATA lv_uri_error_name TYPE string VALUE 'URIError'.
    DATA lv_aggregate_error_name TYPE string VALUE 'AggregateError'.
    DATA lv_error_to_string_name TYPE string VALUE 'toString'.
    DATA ls_native_value TYPE zcl_qjs_value=>ty_value.
    IF runtime IS NOT BOUND OR runtime->is_disposed( ) = abap_true.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Context requires an active JavaScript runtime'.
    ENDIF.
    mo_runtime = runtime.
    lo_object_prototype = mo_runtime->create_object( ).
    mo_runtime->set_object_prototype( lo_object_prototype ).
    mo_global_object = mo_runtime->create_object( lo_object_prototype ).
    set_global(
      name = 'globalThis' value = zcl_qjs_value=>new_object( mo_global_object ) ).
    lo_function_prototype = mo_runtime->create_object( ).
    mo_runtime->set_function_prototype( lo_function_prototype ).
    lo_string_prototype = mo_runtime->create_object( ).
    mo_runtime->set_string_prototype( lo_string_prototype ).
    lo_string_prototype->define_property(
      name = '[[PrimitiveValue]]' value = zcl_qjs_value=>new_string( '' )
      writable = abap_false enumerable = abap_false configurable = abap_false ).
    lo_string_prototype->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 )
      writable = abap_false enumerable = abap_false configurable = abap_false ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_function
      runtime                            = mo_runtime context = me.
    lo_function_intrinsic = lo_native.
    lo_function_intrinsic->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_function_intrinsic->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'Function' ) ).
    lo_reference = lo_native.
    ls_native_value = zcl_qjs_value=>new_object( lo_reference ).
    ls_native_value-property_ref = lo_native.
    lo_function_intrinsic->set_property(
      name = 'prototype' value = zcl_qjs_value=>new_object( lo_function_prototype ) ).
    set_global( name = 'Function' value = ls_native_value ).
    lo_function_prototype->define_property(
      name = lv_constructor_property value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_function_call
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'call' ) ).
    lo_reference = lo_native.
    lo_function_prototype->define_property(
      name = 'call' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_function_apply
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 2 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'apply' ) ).
    lo_reference = lo_native.
    lo_function_prototype->define_property(
      name = 'apply' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_function_bind
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'bind' ) ).
    lo_reference = lo_native.
    lo_function_prototype->define_property(
      name = 'bind' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_number
      runtime                            = mo_runtime.
    lo_number_intrinsic = lo_native.
    lo_reference = lo_native.
    ls_native_value = zcl_qjs_value=>new_object( lo_reference ).
    ls_native_value-property_ref = lo_native.
    set_global( name = 'Number' value = ls_native_value ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_string
      runtime                            = mo_runtime.
    lo_string_intrinsic = lo_native.
    lo_string_intrinsic->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_string_intrinsic->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'String' ) ).
    lo_reference = lo_native.
    ls_native_value = zcl_qjs_value=>new_object( lo_reference ).
    ls_native_value-property_ref = lo_native.
    lo_string_intrinsic->set_property(
      name = 'prototype' value = zcl_qjs_value=>new_object( lo_string_prototype ) ).
    set_global( name = 'String' value = ls_native_value ).
    lo_string_prototype->define_property(
      name = lv_constructor_property value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    install_string_method(
      prototype = lo_string_prototype name = lv_to_string_name
      id = zcl_qjs_native_function=>id_string_to_string length = 0 ).
    install_string_method(
      prototype = lo_string_prototype name = lv_value_of_name
      id = zcl_qjs_native_function=>id_string_value_of length = 0 ).
    install_string_method(
      prototype = lo_string_prototype name = 'charAt'
      id = zcl_qjs_native_function=>id_string_char_at length = 1 ).
    install_string_method(
      prototype = lo_string_prototype name = 'charCodeAt'
      id = zcl_qjs_native_function=>id_string_char_code_at length = 1 ).
    install_string_method(
      prototype = lo_string_prototype name = 'at'
      id = zcl_qjs_native_function=>id_string_at length = 1 ).
    install_string_method(
      prototype = lo_string_prototype name = 'indexOf'
      id = zcl_qjs_native_function=>id_string_index_of length = 1 ).
    install_string_method(
      prototype = lo_string_prototype name = 'lastIndexOf'
      id = zcl_qjs_native_function=>id_string_last_index_of length = 1 ).
    install_string_method(
      prototype = lo_string_prototype name = 'includes'
      id = zcl_qjs_native_function=>id_string_includes length = 1 ).
    install_string_method(
      prototype = lo_string_prototype name = 'startsWith'
      id = zcl_qjs_native_function=>id_string_starts_with length = 1 ).
    install_string_method(
      prototype = lo_string_prototype name = 'endsWith'
      id = zcl_qjs_native_function=>id_string_ends_with length = 1 ).
    install_string_method(
      prototype = lo_string_prototype name = 'slice'
      id = zcl_qjs_native_function=>id_string_slice length = 2 ).
    install_string_method(
      prototype = lo_string_prototype name = 'substring'
      id = zcl_qjs_native_function=>id_string_substring length = 2 ).
    install_string_method(
      prototype = lo_string_prototype name = 'concat'
      id = zcl_qjs_native_function=>id_string_concat length = 1 ).
    install_string_method(
      prototype = lo_string_prototype name = 'repeat'
      id = zcl_qjs_native_function=>id_string_repeat length = 1 ).
    install_string_method(
      prototype = lo_string_prototype name = 'toLowerCase'
      id = zcl_qjs_native_function=>id_string_to_lower length = 0 ).
    install_string_method(
      prototype = lo_string_prototype name = 'toUpperCase'
      id = zcl_qjs_native_function=>id_string_to_upper length = 0 ).
    install_string_method(
      prototype = lo_string_prototype name = 'trim'
      id = zcl_qjs_native_function=>id_string_trim length = 0 ).
    install_string_method(
      prototype = lo_string_prototype name = 'trimStart'
      id = zcl_qjs_native_function=>id_string_trim_start length = 0 ).
    install_string_method(
      prototype = lo_string_prototype name = 'trimEnd'
      id = zcl_qjs_native_function=>id_string_trim_end length = 0 ).
    install_string_method(
      prototype = lo_string_prototype name = 'replace'
      id = zcl_qjs_native_function=>id_string_replace length = 2 ).
    install_string_method(
      prototype = lo_string_prototype name = 'split'
      id = zcl_qjs_native_function=>id_string_split length = 2 ).
    install_string_method(
      prototype = lo_string_prototype name = 'substr'
      id = zcl_qjs_native_function=>id_string_substr length = 2 ).
    lo_regexp_prototype = mo_runtime->create_object( lo_object_prototype ).
    mo_runtime->set_regexp_prototype( lo_regexp_prototype ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_regexp runtime = mo_runtime.
    lo_regexp_intrinsic = lo_native.
    lo_regexp_intrinsic->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 2 ) ).
    lo_regexp_intrinsic->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'RegExp' ) ).
    lo_reference = lo_native.
    lo_regexp_intrinsic->set_property(
      name = 'prototype' value = zcl_qjs_value=>new_object( lo_regexp_prototype ) ).
    set_global(
      name = 'RegExp' value = zcl_qjs_value=>new_object( lo_reference ) ).
    lo_regexp_prototype->define_property(
      name = lv_constructor_property value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    install_string_method(
      prototype = lo_regexp_prototype name = 'exec'
      id = zcl_qjs_native_function=>id_regexp_exec length = 1 ).
    install_string_method(
      prototype = lo_regexp_prototype name = 'test'
      id = zcl_qjs_native_function=>id_regexp_test length = 1 ).
    install_string_method(
      prototype = lo_regexp_prototype name = lv_to_string_name
      id = zcl_qjs_native_function=>id_regexp_to_string length = 0 ).
    lo_reflect = mo_runtime->create_object( lo_object_prototype ).
    install_reflect_method(
      reflect_object = lo_reflect name = 'apply'
      id = zcl_qjs_native_function=>id_reflect_apply length = 3 ).
    install_reflect_method(
      reflect_object = lo_reflect name = 'construct'
      id = zcl_qjs_native_function=>id_reflect_construct length = 2 ).
    install_reflect_method(
      reflect_object = lo_reflect name = 'defineProperty'
      id = zcl_qjs_native_function=>id_reflect_define_property length = 3 ).
    install_reflect_method(
      reflect_object = lo_reflect name = 'deleteProperty'
      id = zcl_qjs_native_function=>id_reflect_delete_property length = 2 ).
    install_reflect_method(
      reflect_object = lo_reflect name = 'get'
      id = zcl_qjs_native_function=>id_reflect_get length = 2 ).
    install_reflect_method(
      reflect_object = lo_reflect name = 'getOwnPropertyDescriptor'
      id = zcl_qjs_native_function=>id_reflect_get_own_descriptor length = 2 ).
    install_reflect_method(
      reflect_object = lo_reflect name = 'getPrototypeOf'
      id = zcl_qjs_native_function=>id_reflect_get_prototype length = 1 ).
    install_reflect_method(
      reflect_object = lo_reflect name = 'has'
      id = zcl_qjs_native_function=>id_reflect_has length = 2 ).
    install_reflect_method(
      reflect_object = lo_reflect name = 'isExtensible'
      id = zcl_qjs_native_function=>id_reflect_is_extensible length = 1 ).
    install_reflect_method(
      reflect_object = lo_reflect name = 'ownKeys'
      id = zcl_qjs_native_function=>id_reflect_own_keys length = 1 ).
    install_reflect_method(
      reflect_object = lo_reflect name = 'preventExtensions'
      id = zcl_qjs_native_function=>id_reflect_prevent_extensions length = 1 ).
    install_reflect_method(
      reflect_object = lo_reflect name = 'set'
      id = zcl_qjs_native_function=>id_reflect_set length = 3 ).
    install_reflect_method(
      reflect_object = lo_reflect name = 'setPrototypeOf'
      id = zcl_qjs_native_function=>id_reflect_set_prototype length = 2 ).
    DATA(ls_reflect_tag) = mo_runtime->well_known_symbol( 'toStringTag' ).
    lo_reflect->define_symbol_property(
      identity = ls_reflect_tag-symbol_id
      value = zcl_qjs_value=>new_string( 'Reflect' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    set_global( name = 'Reflect' value = zcl_qjs_value=>new_object( lo_reflect ) ).
    lo_map_prototype = mo_runtime->create_object( lo_object_prototype ).
    lo_set_prototype = mo_runtime->create_object( lo_object_prototype ).
    lo_map_iterator_proto = mo_runtime->create_object( lo_object_prototype ).
    lo_set_iterator_proto = mo_runtime->create_object( lo_object_prototype ).
    lo_array_iterator_proto = mo_runtime->create_object( lo_object_prototype ).
    lo_string_iterator_proto = mo_runtime->create_object( lo_object_prototype ).
    lo_generator_prototype = mo_runtime->create_object( lo_object_prototype ).
    lo_generator_function_proto = mo_runtime->create_object( lo_function_prototype ).
    lo_async_iterator_prototype = mo_runtime->create_object( lo_object_prototype ).
    lo_async_generator_prototype = mo_runtime->create_object(
      lo_async_iterator_prototype ).
    lo_async_gen_function_proto = mo_runtime->create_object(
      lo_function_prototype ).
    lo_promise_prototype = mo_runtime->create_object( lo_object_prototype ).
    mo_runtime->set_map_prototype( lo_map_prototype ).
    mo_runtime->set_set_prototype( lo_set_prototype ).
    mo_runtime->set_map_iterator_proto( lo_map_iterator_proto ).
    mo_runtime->set_set_iterator_proto( lo_set_iterator_proto ).
    mo_runtime->set_array_iterator_proto( lo_array_iterator_proto ).
    mo_runtime->set_string_iterator_proto( lo_string_iterator_proto ).
    mo_runtime->set_generator_prototype( lo_generator_prototype ).
    mo_runtime->set_generator_function_proto( lo_generator_function_proto ).
    mo_runtime->set_async_generator_prototype( lo_async_generator_prototype ).
    mo_runtime->set_async_gen_function_proto( lo_async_gen_function_proto ).
    mo_runtime->set_promise_prototype( lo_promise_prototype ).
    lo_generator_function_proto->define_property(
      name = 'prototype' value = zcl_qjs_value=>new_object( lo_generator_prototype )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_generator_prototype->define_property(
      name = lv_constructor_property
      value = zcl_qjs_value=>new_object( lo_generator_function_proto )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    DATA(ls_to_string_tag) = mo_runtime->well_known_symbol( 'toStringTag' ).
    lo_generator_function_proto->define_symbol_property(
      identity = ls_to_string_tag-symbol_id
      value = zcl_qjs_value=>new_string( 'GeneratorFunction' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_generator_prototype->define_symbol_property(
      identity = ls_to_string_tag-symbol_id
      value = zcl_qjs_value=>new_string( 'Generator' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_async_gen_function_proto->define_property(
      name = 'prototype'
      value = zcl_qjs_value=>new_object( lo_async_generator_prototype )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_async_generator_prototype->define_property(
      name = lv_constructor_property
      value = zcl_qjs_value=>new_object( lo_async_gen_function_proto )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_async_gen_function_proto->define_symbol_property(
      identity = ls_to_string_tag-symbol_id
      value = zcl_qjs_value=>new_string( 'AsyncGeneratorFunction' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_async_generator_prototype->define_symbol_property(
      identity = ls_to_string_tag-symbol_id
      value = zcl_qjs_value=>new_string( 'AsyncGenerator' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).

    CREATE OBJECT lo_native EXPORTING id      = zcl_qjs_native_function=>id_promise
                                      runtime = mo_runtime.
    lo_promise_intrinsic = lo_native.
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'Promise' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'prototype' value = zcl_qjs_value=>new_object( lo_promise_prototype )
      writable = abap_false enumerable = abap_false configurable = abap_false ).
    lo_reference = lo_native.
    DATA(ls_promise_constructor) = zcl_qjs_value=>new_object( lo_reference ).
    set_global( name = 'Promise' value = ls_promise_constructor ).
    lo_promise_prototype->define_property(
      name = lv_constructor_property value = ls_promise_constructor
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    DATA(ls_promise_species_symbol) = mo_runtime->well_known_symbol( 'species' ).
    CREATE OBJECT lo_native
      EXPORTING id      = zcl_qjs_native_function=>id_promise_species_get
                runtime = mo_runtime.
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'get [Symbol.species]' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_reference = lo_native.
    lo_promise_intrinsic->define_symbol_accessor(
      identity = ls_promise_species_symbol-symbol_id
      getter = zcl_qjs_value=>new_object( lo_reference )
      setter = zcl_qjs_value=>new_undefined( )
      enumerable = abap_false configurable = abap_true ).
    lo_promise_prototype->define_symbol_property(
      identity = ls_to_string_tag-symbol_id
      value = zcl_qjs_value=>new_string( 'Promise' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    install_collection_method(
      prototype = lo_promise_prototype name = 'then'
      id = zcl_qjs_native_function=>id_promise_then length = 2 ).
    install_collection_method(
      prototype = lo_promise_prototype name = 'catch'
      id = zcl_qjs_native_function=>id_promise_catch length = 1 ).
    install_collection_method(
      prototype = lo_promise_prototype name = 'finally'
      id = zcl_qjs_native_function=>id_promise_finally length = 1 ).
    CREATE OBJECT lo_native EXPORTING id      = zcl_qjs_native_function=>id_promise_resolve
                                      runtime = mo_runtime.
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'resolve' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_reference = lo_native.
    lo_promise_intrinsic->define_property(
      name = 'resolve' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id      = zcl_qjs_native_function=>id_promise_reject
                                      runtime = mo_runtime.
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'reject' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_reference = lo_native.
    lo_promise_intrinsic->define_property(
      name = 'reject' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id      = zcl_qjs_native_function=>id_promise_all
                                      runtime = mo_runtime.
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'all' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_reference = lo_native.
    lo_promise_intrinsic->define_property(
      name = 'all' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id      = zcl_qjs_native_function=>id_promise_race
                                      runtime = mo_runtime.
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'race' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_reference = lo_native.
    lo_promise_intrinsic->define_property(
      name = 'race' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native
      EXPORTING id      = zcl_qjs_native_function=>id_promise_all_settled
                runtime = mo_runtime.
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'allSettled' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_reference = lo_native.
    lo_promise_intrinsic->define_property(
      name = 'allSettled' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id      = zcl_qjs_native_function=>id_promise_any
                                      runtime = mo_runtime.
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'any' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_reference = lo_native.
    lo_promise_intrinsic->define_property(
      name = 'any' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).

    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_map
      runtime                            = mo_runtime.
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'Map' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'prototype' value = zcl_qjs_value=>new_object( lo_map_prototype )
      writable = abap_false enumerable = abap_false configurable = abap_false ).
    lo_reference = lo_native.
    DATA(ls_map_constructor) = zcl_qjs_value=>new_object( lo_reference ).
    set_global( name = 'Map' value = ls_map_constructor ).
    lo_map_prototype->define_property(
      name = lv_constructor_property value = ls_map_constructor
      writable = abap_true enumerable = abap_false configurable = abap_true ).

    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_set
      runtime                            = mo_runtime.
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'Set' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'prototype' value = zcl_qjs_value=>new_object( lo_set_prototype )
      writable = abap_false enumerable = abap_false configurable = abap_false ).
    lo_reference = lo_native.
    DATA(ls_set_constructor) = zcl_qjs_value=>new_object( lo_reference ).
    set_global( name = 'Set' value = ls_set_constructor ).
    lo_set_prototype->define_property(
      name = lv_constructor_property value = ls_set_constructor
      writable = abap_true enumerable = abap_false configurable = abap_true ).

    install_collection_method(
      prototype = lo_map_prototype name = 'get'
      id = zcl_qjs_native_function=>id_map_get length = 1 ).
    install_collection_method(
      prototype = lo_map_prototype name = 'set'
      id = zcl_qjs_native_function=>id_map_set length = 2 ).
    install_collection_method(
      prototype = lo_map_prototype name = 'has'
      id = zcl_qjs_native_function=>id_map_has length = 1 ).
    install_collection_method(
      prototype = lo_map_prototype name = 'delete'
      id = zcl_qjs_native_function=>id_map_delete length = 1 ).
    install_collection_method(
      prototype = lo_map_prototype name = 'clear'
      id = zcl_qjs_native_function=>id_map_clear length = 0 ).
    install_collection_method(
      prototype = lo_map_prototype name = 'entries'
      id = zcl_qjs_native_function=>id_map_entries length = 0 ).
    install_collection_method(
      prototype = lo_map_prototype name = 'keys'
      id = zcl_qjs_native_function=>id_map_keys length = 0 ).
    install_collection_method(
      prototype = lo_map_prototype name = 'values'
      id = zcl_qjs_native_function=>id_map_values length = 0 ).
    install_collection_method(
      prototype = lo_map_prototype name = 'forEach'
      id = zcl_qjs_native_function=>id_map_for_each length = 1 ).

    install_collection_method(
      prototype = lo_set_prototype name = 'add'
      id = zcl_qjs_native_function=>id_set_add length = 1 ).
    install_collection_method(
      prototype = lo_set_prototype name = 'has'
      id = zcl_qjs_native_function=>id_set_has length = 1 ).
    install_collection_method(
      prototype = lo_set_prototype name = 'delete'
      id = zcl_qjs_native_function=>id_set_delete length = 1 ).
    install_collection_method(
      prototype = lo_set_prototype name = 'clear'
      id = zcl_qjs_native_function=>id_set_clear length = 0 ).
    install_collection_method(
      prototype = lo_set_prototype name = 'entries'
      id = zcl_qjs_native_function=>id_set_entries length = 0 ).
    install_collection_method(
      prototype = lo_set_prototype name = 'values'
      id = zcl_qjs_native_function=>id_set_values length = 0 ).
    DATA(ls_set_values) = lo_set_prototype->get_own_property( 'values' ).
    lo_set_prototype->define_property(
      name = 'keys' value = ls_set_values-value
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    install_collection_method(
      prototype = lo_set_prototype name = 'forEach'
      id = zcl_qjs_native_function=>id_set_for_each length = 1 ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_map_size
      runtime                            = mo_runtime.
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'get size' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_reference = lo_native.
    lo_map_prototype->define_accessor(
      name = 'size' getter = zcl_qjs_value=>new_object( lo_reference )
      setter = zcl_qjs_value=>new_undefined( ) configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_set_size
      runtime                            = mo_runtime.
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'get size' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_reference = lo_native.
    lo_set_prototype->define_accessor(
      name = 'size' getter = zcl_qjs_value=>new_object( lo_reference )
      setter = zcl_qjs_value=>new_undefined( ) configurable = abap_true ).

    install_collection_method(
      prototype = lo_map_iterator_proto name = 'next'
      id = zcl_qjs_native_function=>id_collection_next length = 0 ).
    install_collection_method(
      prototype = lo_set_iterator_proto name = 'next'
      id = zcl_qjs_native_function=>id_collection_next length = 0 ).
    install_collection_method(
      prototype = lo_array_iterator_proto name = 'next'
      id = zcl_qjs_native_function=>id_collection_next length = 0 ).
    install_collection_method(
      prototype = lo_string_iterator_proto name = 'next'
      id = zcl_qjs_native_function=>id_collection_next length = 0 ).
    install_collection_method(
      prototype = lo_generator_prototype name = 'next'
      id = zcl_qjs_native_function=>id_generator_next length = 1 ).
    install_collection_method(
      prototype = lo_generator_prototype name = 'throw'
      id = zcl_qjs_native_function=>id_generator_throw length = 1 ).
    install_collection_method(
      prototype = lo_generator_prototype name = 'return'
      id = zcl_qjs_native_function=>id_generator_return length = 1 ).
    install_collection_method(
      prototype = lo_async_generator_prototype name = 'next'
      id = zcl_qjs_native_function=>id_async_generator_next length = 1 ).
    install_collection_method(
      prototype = lo_async_generator_prototype name = 'throw'
      id = zcl_qjs_native_function=>id_async_generator_throw length = 1 ).
    install_collection_method(
      prototype = lo_async_generator_prototype name = 'return'
      id = zcl_qjs_native_function=>id_async_generator_return length = 1 ).
    DATA(ls_iterator_symbol) = mo_runtime->well_known_symbol( 'iterator' ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_iterator_self runtime = mo_runtime.
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( '[Symbol.iterator]' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_reference = lo_native.
    DATA(ls_iterator_self) = zcl_qjs_value=>new_object( lo_reference ).
    lo_map_iterator_proto->define_symbol_property(
      identity = ls_iterator_symbol-symbol_id value = ls_iterator_self
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_set_iterator_proto->define_symbol_property(
      identity = ls_iterator_symbol-symbol_id value = ls_iterator_self
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_array_iterator_proto->define_symbol_property(
      identity = ls_iterator_symbol-symbol_id value = ls_iterator_self
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_string_iterator_proto->define_symbol_property(
      identity = ls_iterator_symbol-symbol_id value = ls_iterator_self
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_generator_prototype->define_symbol_property(
      identity = ls_iterator_symbol-symbol_id value = ls_iterator_self
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    DATA(ls_async_iterator_symbol) = mo_runtime->well_known_symbol( 'asyncIterator' ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_iterator_self runtime = mo_runtime.
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( '[Symbol.asyncIterator]' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_reference = lo_native.
    lo_async_iterator_prototype->define_symbol_property(
      identity = ls_async_iterator_symbol-symbol_id
      value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    DATA(ls_map_entries) = lo_map_prototype->get_own_property( 'entries' ).
    lo_map_prototype->define_symbol_property(
      identity = ls_iterator_symbol-symbol_id value = ls_map_entries-value
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_set_prototype->define_symbol_property(
      identity = ls_iterator_symbol-symbol_id value = ls_set_values-value
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_string_iterator
        runtime    = mo_runtime.
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( '[Symbol.iterator]' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_reference = lo_native.
    lo_string_prototype->define_symbol_property(
      identity = ls_iterator_symbol-symbol_id
      value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).

    lo_map_prototype->define_symbol_property(
      identity = ls_reflect_tag-symbol_id value = zcl_qjs_value=>new_string( 'Map' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_set_prototype->define_symbol_property(
      identity = ls_reflect_tag-symbol_id value = zcl_qjs_value=>new_string( 'Set' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_map_iterator_proto->define_symbol_property(
      identity = ls_reflect_tag-symbol_id
      value = zcl_qjs_value=>new_string( 'Map Iterator' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_set_iterator_proto->define_symbol_property(
      identity = ls_reflect_tag-symbol_id
      value = zcl_qjs_value=>new_string( 'Set Iterator' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_array_iterator_proto->define_symbol_property(
      identity = ls_reflect_tag-symbol_id
      value = zcl_qjs_value=>new_string( 'Array Iterator' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_string_iterator_proto->define_symbol_property(
      identity = ls_reflect_tag-symbol_id
      value = zcl_qjs_value=>new_string( 'String Iterator' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_boolean
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    ls_native_value = zcl_qjs_value=>new_object( lo_reference ).
    ls_native_value-property_ref = lo_native.
    set_global( name = 'Boolean' value = ls_native_value ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_symbol
      runtime                            = mo_runtime.
    lo_symbol_intrinsic = lo_native.
    lo_reference = lo_native.
    ls_native_value = zcl_qjs_value=>new_object( lo_reference ).
    ls_native_value-property_ref = lo_native.
    set_global( name = 'Symbol' value = ls_native_value ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_symbol_for
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_symbol_intrinsic->set_property(
      name = 'for' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_symbol_key_for
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_symbol_intrinsic->set_property(
      name = 'keyFor' value = zcl_qjs_value=>new_object( lo_reference ) ).
    lo_symbol_intrinsic->set_property(
      name = 'asyncIterator' value = mo_runtime->well_known_symbol( 'asyncIterator' ) ).
    lo_symbol_intrinsic->set_property(
      name = 'asyncDispose' value = mo_runtime->well_known_symbol( 'asyncDispose' ) ).
    lo_symbol_intrinsic->set_property(
      name = 'dispose' value = mo_runtime->well_known_symbol( 'dispose' ) ).
    lo_symbol_intrinsic->set_property(
      name = 'hasInstance' value = mo_runtime->well_known_symbol( 'hasInstance' ) ).
    lo_symbol_intrinsic->set_property(
      name = 'isConcatSpreadable' value = mo_runtime->well_known_symbol(
        'isConcatSpreadable' ) ).
    lo_symbol_intrinsic->set_property(
      name = 'iterator' value = mo_runtime->well_known_symbol( 'iterator' ) ).
    lo_symbol_intrinsic->set_property(
      name = 'match' value = mo_runtime->well_known_symbol( 'match' ) ).
    lo_symbol_intrinsic->set_property(
      name = 'matchAll' value = mo_runtime->well_known_symbol( 'matchAll' ) ).
    lo_symbol_intrinsic->set_property(
      name = 'replace' value = mo_runtime->well_known_symbol( 'replace' ) ).
    lo_symbol_intrinsic->set_property(
      name = 'search' value = mo_runtime->well_known_symbol( 'search' ) ).
    lo_symbol_intrinsic->set_property(
      name = 'species' value = mo_runtime->well_known_symbol( 'species' ) ).
    lo_symbol_intrinsic->set_property(
      name = 'split' value = mo_runtime->well_known_symbol( 'split' ) ).
    lo_symbol_intrinsic->set_property(
      name = 'toPrimitive' value = mo_runtime->well_known_symbol( 'toPrimitive' ) ).
    lo_symbol_intrinsic->set_property(
      name = 'toStringTag' value = mo_runtime->well_known_symbol( 'toStringTag' ) ).
    lo_symbol_intrinsic->set_property(
      name = 'unscopables' value = mo_runtime->well_known_symbol( 'unscopables' ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_object
      runtime                            = mo_runtime.
    lo_object_intrinsic = lo_native.
    lo_reference = lo_native.
    ls_native_value = zcl_qjs_value=>new_object( lo_reference ).
    ls_native_value-property_ref = lo_native.
    set_global( name = 'Object' value = ls_native_value ).
    lo_object_intrinsic->set_property(
      name = 'prototype' value = zcl_qjs_value=>new_object( lo_object_prototype ) ).
    lo_reference = lo_object_intrinsic.
    lo_object_prototype->define_property(
      name = lv_constructor_property value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_to_string runtime = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_to_string_name ) ).
    lo_reference = lo_native.
    lo_object_prototype->define_property(
      name = lv_to_string_name value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_has_own_property
        runtime    = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_has_own_property_name ) ).
    lo_reference = lo_native.
    lo_object_prototype->define_property(
      name = lv_has_own_property_name value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_value_of runtime = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_value_of_name ) ).
    lo_reference = lo_native.
    lo_object_prototype->define_property(
      name = lv_value_of_name value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_property_is_enum
        runtime    = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_property_is_enum_name ) ).
    lo_reference = lo_native.
    lo_object_prototype->define_property(
      name = lv_property_is_enum_name value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_is_prototype_of
        runtime    = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_is_prototype_of_name ) ).
    lo_reference = lo_native.
    lo_object_prototype->define_property(
      name = lv_is_prototype_of_name value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_array_prototype = mo_runtime->create_array( ).
    lo_array_prototype->set_prototype( lo_object_prototype ).
    mo_runtime->set_array_prototype( lo_array_prototype ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array
      runtime                            = mo_runtime.
    lo_array_intrinsic = lo_native.
    lo_reference = lo_native.
    ls_native_value = zcl_qjs_value=>new_object( lo_reference ).
    ls_native_value-property_ref = lo_native.
    set_global( name = 'Array' value = ls_native_value ).
    lo_array_intrinsic->set_property(
      name = 'prototype' value = zcl_qjs_value=>new_object( lo_array_prototype ) ).
    lo_reference = lo_array_intrinsic.
    lo_array_prototype->define_property(
      name = lv_constructor_property value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    install_collection_method(
      prototype = lo_array_prototype name = 'entries'
      id = zcl_qjs_native_function=>id_array_entries length = 0 ).
    install_collection_method(
      prototype = lo_array_prototype name = 'keys'
      id = zcl_qjs_native_function=>id_array_keys length = 0 ).
    install_collection_method(
      prototype = lo_array_prototype name = 'values'
      id = zcl_qjs_native_function=>id_array_values length = 0 ).
    DATA(ls_array_values) = lo_array_prototype->get_own_property( 'values' ).
    lo_array_prototype->define_symbol_property(
      identity = ls_iterator_symbol-symbol_id value = ls_array_values-value
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_push
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'push' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'push' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_pop
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'pop' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'pop' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_join
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'join' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'join' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    DATA lv_array_to_string_name TYPE string VALUE 'toString'.
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_array_to_string runtime = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_array_to_string_name ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = lv_array_to_string_name value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_index_of
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'indexOf' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'indexOf' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_includes
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'includes' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'includes' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_shift
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'shift' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'shift' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_unshift
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'unshift' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'unshift' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_reverse
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'reverse' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'reverse' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_array_to_reversed runtime = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'toReversed' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'toReversed' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_with
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 2 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'with' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'with' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_to_sorted
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'toSorted' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'toSorted' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_to_spliced
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 2 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'toSpliced' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'toSpliced' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_array_last_index_of
        runtime    = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'lastIndexOf' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'lastIndexOf' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_at
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'at' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'at' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_slice
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 2 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'slice' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'slice' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_for_each
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'forEach' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'forEach' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_map
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'map' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'map' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_filter
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'filter' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'filter' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_some
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'some' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'some' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_every
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'every' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'every' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_find
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'find' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'find' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_array_find_index
        runtime    = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'findIndex' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'findIndex' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_array_find_last
        runtime    = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'findLast' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'findLast' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_array_find_last_index
        runtime    = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'findLastIndex' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'findLastIndex' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_reduce
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'reduce' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'reduce' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_array_reduce_right
        runtime    = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'reduceRight' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'reduceRight' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_fill
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'fill' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'fill' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_array_copy_within
        runtime    = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 2 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'copyWithin' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'copyWithin' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_concat
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'concat' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'concat' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_splice
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 2 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'splice' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'splice' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_sort
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'sort' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'sort' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_flat
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'flat' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'flat' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_flat_map
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'flatMap' ) ).
    lo_reference = lo_native.
    lo_array_prototype->define_property(
      name = 'flatMap' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_is_nan
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    ls_native_value = zcl_qjs_value=>new_object( lo_reference ).
    ls_native_value-property_ref = lo_native.
    set_global( name = 'isNaN' value = ls_native_value ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_is_finite
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    set_global( name = 'isFinite' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_parse_int
      runtime                            = mo_runtime.
    lo_parse_int_intrinsic = lo_native.
    lo_reference = lo_native.
    set_global( name = 'parseInt' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_parse_float
      runtime                            = mo_runtime.
    lo_parse_float_intrinsic = lo_native.
    lo_reference = lo_native.
    set_global( name = 'parseFloat' value = zcl_qjs_value=>new_object( lo_reference ) ).
    lo_reference = lo_parse_int_intrinsic.
    lo_number_intrinsic->set_property(
      name = 'parseInt' value = zcl_qjs_value=>new_object( lo_reference ) ).
    lo_reference = lo_parse_float_intrinsic.
    lo_number_intrinsic->set_property(
      name = 'parseFloat' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_number_is_nan
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_number_intrinsic->set_property(
      name = 'isNaN' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_number_is_finite
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_number_intrinsic->set_property(
      name = 'isFinite' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_number_is_integer
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_number_intrinsic->set_property(
      name = 'isInteger' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_number_is_safe_int
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_number_intrinsic->set_property(
      name = 'isSafeInteger' value = zcl_qjs_value=>new_object( lo_reference ) ).
    lo_number_intrinsic->set_property(
      name = 'NaN' value = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ) ).
    lo_number_intrinsic->set_property(
      name  = 'POSITIVE_INFINITY'
      value = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ) ).
    lo_number_intrinsic->set_property(
      name  = 'NEGATIVE_INFINITY'
      value = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_inf ) ).
    lo_number_intrinsic->set_property(
      name  = 'MAX_SAFE_INTEGER'
      value = zcl_qjs_number=>parse_literal( '9007199254740991' ) ).
    lo_number_intrinsic->set_property(
      name  = 'MIN_SAFE_INTEGER'
      value = zcl_qjs_number=>negate(
        zcl_qjs_number=>parse_literal( '9007199254740991' ) ) ).
    lo_number_intrinsic->set_property(
      name  = 'EPSILON'
      value = zcl_qjs_number=>parse_literal( '2.220446049250313e-16' ) ).
    lo_number_intrinsic->set_property(
      name  = 'MAX_VALUE'
      value = zcl_qjs_number=>parse_literal( '1.7976931348623157e308' ) ).
    lo_number_intrinsic->set_property(
      name  = 'MIN_VALUE'
      value = zcl_qjs_number=>parse_literal( '5e-324' ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_array_is_array runtime = mo_runtime.
    lo_reference = lo_native.
    lo_array_intrinsic->set_property(
      name = 'isArray' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array_of
      runtime                            = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'of' ) ).
    lo_reference = lo_native.
    lo_array_intrinsic->set_property(
      name = 'of' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_keys runtime = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'keys' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_define_property
        runtime    = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'defineProperty' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_get_own_descriptor
        runtime    = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name  = 'getOwnPropertyDescriptor'
      value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_create runtime = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'create' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_get_prototype
        runtime    = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'getPrototypeOf' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_set_prototype
        runtime    = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'setPrototypeOf' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_define_properties
        runtime    = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'defineProperties' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_get_own_names
        runtime    = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'getOwnPropertyNames' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_get_own_symbols
        runtime    = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name  = 'getOwnPropertySymbols'
      value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_assign runtime = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'assign' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_values runtime = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'values' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_entries runtime = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'entries' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_has_own runtime = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'hasOwn' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_is runtime = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'is' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_is_extensible
        runtime    = mo_runtime.
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'isExtensible' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_reference = lo_native.
    lo_object_intrinsic->define_property(
      name = 'isExtensible' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_prevent_extensions
        runtime    = mo_runtime.
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 1 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( 'preventExtensions' )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_reference = lo_native.
    lo_object_intrinsic->define_property(
      name = 'preventExtensions' value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    set_global(
      name  = 'NaN'
      value = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ) ).
    set_global(
      name  = 'Infinity'
      value = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_encode_uri
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    set_global( name = 'encodeURI' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_encode_uri_component runtime = mo_runtime.
    lo_reference = lo_native.
    set_global(
      name = 'encodeURIComponent' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_decode_uri
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    set_global( name = 'decodeURI' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_decode_uri_component runtime = mo_runtime.
    lo_reference = lo_native.
    set_global(
      name = 'decodeURIComponent' value = zcl_qjs_value=>new_object( lo_reference ) ).
    lo_math = mo_runtime->create_object( ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_abs
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'abs' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_floor
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'floor' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_ceil
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'ceil' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_max
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'max' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_min
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'min' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_trunc
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'trunc' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_round
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'round' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_sign
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'sign' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_sqrt
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'sqrt' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_exp
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'exp' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_log
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'log' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_log10
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'log10' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_log2
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'log2' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_sin
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'sin' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_cos
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'cos' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_tan
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'tan' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_pow
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'pow' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_cbrt
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'cbrt' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_expm1
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'expm1' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_log1p
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'log1p' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_atan
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'atan' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_asin
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'asin' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_acos
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'acos' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_atan2
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'atan2' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_sinh
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'sinh' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_cosh
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'cosh' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_tanh
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'tanh' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_asinh
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'asinh' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_acosh
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'acosh' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_atanh
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'atanh' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_clz32
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'clz32' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_imul
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'imul' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_hypot
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'hypot' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_fround
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'fround' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_f16round
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'f16round' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_random
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'random' value = zcl_qjs_value=>new_object( lo_reference ) ).
    lo_math->define_property(
      name = 'E' value = zcl_qjs_number=>parse_literal( '2.718281828459045' )
      writable = abap_false enumerable = abap_false configurable = abap_false ).
    lo_math->define_property(
      name = 'LN10' value = zcl_qjs_number=>parse_literal( '2.302585092994046' )
      writable = abap_false enumerable = abap_false configurable = abap_false ).
    lo_math->define_property(
      name = 'LN2' value = zcl_qjs_number=>parse_literal( '0.6931471805599453' )
      writable = abap_false enumerable = abap_false configurable = abap_false ).
    lo_math->define_property(
      name = 'LOG10E' value = zcl_qjs_number=>parse_literal( '0.4342944819032518' )
      writable = abap_false enumerable = abap_false configurable = abap_false ).
    lo_math->define_property(
      name = 'LOG2E' value = zcl_qjs_number=>parse_literal( '1.4426950408889634' )
      writable = abap_false enumerable = abap_false configurable = abap_false ).
    lo_math->define_property(
      name = 'PI' value = zcl_qjs_number=>parse_literal( '3.141592653589793' )
      writable = abap_false enumerable = abap_false configurable = abap_false ).
    lo_math->define_property(
      name = 'SQRT1_2' value = zcl_qjs_number=>parse_literal( '0.7071067811865476' )
      writable = abap_false enumerable = abap_false configurable = abap_false ).
    lo_math->define_property(
      name = 'SQRT2' value = zcl_qjs_number=>parse_literal( '1.4142135623730951' )
      writable = abap_false enumerable = abap_false configurable = abap_false ).
    set_global( name = 'Math' value = zcl_qjs_value=>new_object( lo_math ) ).
    lo_json = mo_runtime->create_object( ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_json_parse
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_json->set(
      name = 'parse' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_json_stringify
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    lo_json->set(
      name = 'stringify' value = zcl_qjs_value=>new_object( lo_reference ) ).
    set_global( name = 'JSON' value = zcl_qjs_value=>new_object( lo_json ) ).
    lo_error_prototype = mo_runtime->create_object( ).
    lo_eval_error_prototype = mo_runtime->create_object(
      prototype = lo_error_prototype ).
    lo_type_error_prototype = mo_runtime->create_object(
      prototype = lo_error_prototype ).
    lo_range_error_prototype = mo_runtime->create_object(
      prototype = lo_error_prototype ).
    lo_syntax_error_prototype = mo_runtime->create_object(
      prototype = lo_error_prototype ).
    lo_reference_error_prototype = mo_runtime->create_object(
      prototype = lo_error_prototype ).
    lo_uri_error_prototype = mo_runtime->create_object(
      prototype = lo_error_prototype ).
    lo_aggregate_error_prototype = mo_runtime->create_object(
      prototype = lo_error_prototype ).
    mo_runtime->set_error_prototype(
      name = lv_error_name prototype = lo_error_prototype ).
    mo_runtime->set_error_prototype(
      name = lv_eval_error_name prototype = lo_eval_error_prototype ).
    mo_runtime->set_error_prototype(
      name = lv_type_error_name prototype = lo_type_error_prototype ).
    mo_runtime->set_error_prototype(
      name = lv_range_error_name prototype = lo_range_error_prototype ).
    mo_runtime->set_error_prototype(
      name = lv_syntax_error_name prototype = lo_syntax_error_prototype ).
    mo_runtime->set_error_prototype(
      name = lv_reference_error_name prototype = lo_reference_error_prototype ).
    mo_runtime->set_error_prototype(
      name = lv_uri_error_name prototype = lo_uri_error_prototype ).
    mo_runtime->set_error_prototype(
      name = lv_aggregate_error_name prototype = lo_aggregate_error_prototype ).

    lo_error_prototype->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_error_name )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_error_prototype->define_property(
      name = 'message' value = zcl_qjs_value=>new_string( CONV string( '' ) )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_error_to_string runtime = mo_runtime.
    lo_native->set_property(
      name = 'length' value = zcl_qjs_value=>new_int( 0 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_error_to_string_name ) ).
    lo_reference = lo_native.
    lo_error_prototype->define_property(
      name = lv_error_to_string_name value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).

    lo_type_error_prototype->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_type_error_name )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_type_error_prototype->define_property(
      name = 'message' value = zcl_qjs_value=>new_string( CONV string( '' ) )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_eval_error_prototype->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_eval_error_name )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_eval_error_prototype->define_property(
      name = 'message' value = zcl_qjs_value=>new_string( CONV string( '' ) )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_range_error_prototype->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_range_error_name )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_range_error_prototype->define_property(
      name = 'message' value = zcl_qjs_value=>new_string( CONV string( '' ) )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_syntax_error_prototype->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_syntax_error_name )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_syntax_error_prototype->define_property(
      name = 'message' value = zcl_qjs_value=>new_string( CONV string( '' ) )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_reference_error_prototype->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_reference_error_name )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_reference_error_prototype->define_property(
      name = 'message' value = zcl_qjs_value=>new_string( CONV string( '' ) )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_uri_error_prototype->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_uri_error_name )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_uri_error_prototype->define_property(
      name = 'message' value = zcl_qjs_value=>new_string( CONV string( '' ) )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_aggregate_error_prototype->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_aggregate_error_name )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_aggregate_error_prototype->define_property(
      name = 'message' value = zcl_qjs_value=>new_string( CONV string( '' ) )
      writable = abap_true enumerable = abap_false configurable = abap_true ).

    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_error
      runtime                            = mo_runtime.
    lo_native->set_property( name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_error_name ) ).
    lo_native->set_property(
      name = 'prototype' value = zcl_qjs_value=>new_object( lo_error_prototype ) ).
    lo_reference = lo_native.
    DATA(ls_error_constructor) = zcl_qjs_value=>new_object( lo_reference ).
    set_global( name = lv_error_name value = ls_error_constructor ).
    lo_error_prototype->define_property(
      name = lv_constructor_property value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).

    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_eval_error
      runtime                            = mo_runtime.
    lo_native->set_internal_prototype( ls_error_constructor ).
    lo_native->set_property( name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_eval_error_name ) ).
    lo_native->set_property(
      name = 'prototype' value = zcl_qjs_value=>new_object( lo_eval_error_prototype ) ).
    lo_reference = lo_native.
    set_global(
      name = lv_eval_error_name value = zcl_qjs_value=>new_object( lo_reference ) ).
    lo_eval_error_prototype->define_property(
      name = lv_constructor_property value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).

    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_type_error
      runtime                            = mo_runtime.
    lo_native->set_internal_prototype( ls_error_constructor ).
    lo_native->set_property( name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_type_error_name ) ).
    lo_native->set_property(
      name = 'prototype' value = zcl_qjs_value=>new_object( lo_type_error_prototype ) ).
    lo_reference = lo_native.
    set_global(
      name = lv_type_error_name value = zcl_qjs_value=>new_object( lo_reference ) ).
    lo_type_error_prototype->define_property(
      name = lv_constructor_property value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).

    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_range_error
      runtime                            = mo_runtime.
    lo_native->set_internal_prototype( ls_error_constructor ).
    lo_native->set_property( name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_range_error_name ) ).
    lo_native->set_property(
      name = 'prototype' value = zcl_qjs_value=>new_object( lo_range_error_prototype ) ).
    lo_reference = lo_native.
    set_global(
      name = lv_range_error_name value = zcl_qjs_value=>new_object( lo_reference ) ).
    lo_range_error_prototype->define_property(
      name = lv_constructor_property value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).

    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_syntax_error
      runtime                            = mo_runtime.
    lo_native->set_internal_prototype( ls_error_constructor ).
    lo_native->set_property( name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_syntax_error_name ) ).
    lo_native->set_property(
      name = 'prototype' value = zcl_qjs_value=>new_object( lo_syntax_error_prototype ) ).
    lo_reference = lo_native.
    set_global(
      name = lv_syntax_error_name value = zcl_qjs_value=>new_object( lo_reference ) ).
    lo_syntax_error_prototype->define_property(
      name = lv_constructor_property value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).

    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_reference_error runtime = mo_runtime.
    lo_native->set_internal_prototype( ls_error_constructor ).
    lo_native->set_property( name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_reference_error_name ) ).
    lo_native->set_property(
      name = 'prototype' value = zcl_qjs_value=>new_object(
        lo_reference_error_prototype ) ).
    lo_reference = lo_native.
    set_global(
      name = lv_reference_error_name value = zcl_qjs_value=>new_object( lo_reference ) ).
    lo_reference_error_prototype->define_property(
      name = lv_constructor_property value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).

    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_uri_error
      runtime                            = mo_runtime.
    lo_native->set_internal_prototype( ls_error_constructor ).
    lo_native->set_property( name = 'length' value = zcl_qjs_value=>new_int( 1 ) ).
    lo_native->set_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_uri_error_name ) ).
    lo_native->set_property(
      name = 'prototype' value = zcl_qjs_value=>new_object( lo_uri_error_prototype ) ).
    lo_reference = lo_native.
    set_global(
      name = lv_uri_error_name value = zcl_qjs_value=>new_object( lo_reference ) ).
    lo_uri_error_prototype->define_property(
      name = lv_constructor_property value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_native EXPORTING id      = zcl_qjs_native_function=>id_aggregate_error
                                      runtime = mo_runtime.
    lo_native->set_internal_prototype( ls_error_constructor ).
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( 2 )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( lv_aggregate_error_name )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'prototype' value = zcl_qjs_value=>new_object(
        lo_aggregate_error_prototype )
      writable = abap_false enumerable = abap_false configurable = abap_false ).
    lo_reference = lo_native.
    DATA(ls_aggregate_error_constructor) = zcl_qjs_value=>new_object( lo_reference ).
    set_global(
      name = lv_aggregate_error_name value = ls_aggregate_error_constructor ).
    lo_aggregate_error_prototype->define_property(
      name = lv_constructor_property value = ls_aggregate_error_constructor
      writable = abap_true enumerable = abap_false configurable = abap_true ).
  ENDMETHOD.

  METHOD install_string_method.
    DATA lo_native TYPE REF TO zcl_qjs_native_function.
    DATA lo_reference TYPE REF TO object.
    CREATE OBJECT lo_native EXPORTING id = id runtime = mo_runtime.
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( length )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( name )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_reference = lo_native.
    prototype->define_property(
      name = name value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
  ENDMETHOD.

  METHOD install_reflect_method.
    DATA lo_native TYPE REF TO zcl_qjs_native_function.
    DATA lo_reference TYPE REF TO object.
    CREATE OBJECT lo_native EXPORTING id = id runtime = mo_runtime.
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( length )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( name )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_reference = lo_native.
    reflect_object->define_property(
      name = name value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
  ENDMETHOD.

  METHOD install_collection_method.
    DATA lo_native TYPE REF TO zcl_qjs_native_function.
    DATA lo_reference TYPE REF TO object.
    CREATE OBJECT lo_native EXPORTING id = id runtime = mo_runtime.
    lo_native->define_property(
      name = 'length' value = zcl_qjs_value=>new_int( length )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_native->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( name )
      writable = abap_false enumerable = abap_false configurable = abap_true ).
    lo_reference = lo_native.
    prototype->define_property(
      name = name value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
  ENDMETHOD.

  METHOD get_runtime.
    assert_active( ).
    result = mo_runtime.
  ENDMETHOD.

  METHOD set_global.
    DATA ls_global TYPE ty_global.
    DATA ls_existing TYPE ty_global.
    assert_active( ).
    IF name IS INITIAL.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Global name must not be empty'.
    ENDIF.
    READ TABLE mt_globals WITH TABLE KEY name = name INTO ls_existing.
    IF sy-subrc = 0.
      ls_existing-cell->set( value ).
      RETURN.
    ENDIF.
    ls_global-name = name.
    CREATE OBJECT ls_global-cell EXPORTING value = value runtime = mo_runtime.
    INSERT ls_global INTO TABLE mt_globals.
    IF mo_global_object IS BOUND.
      mo_global_object->define_cell_property(
        name = name cell = ls_global-cell writable = abap_true
        enumerable = abap_false configurable = abap_true ).
    ENDIF.
  ENDMETHOD.

  METHOD register_function.
    DATA lo_reference TYPE REF TO object.
    IF callable IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Host callable must be bound'.
    ENDIF.
    lo_reference ?= callable.
    set_global( name = name value = zcl_qjs_value=>new_object( lo_reference ) ).
  ENDMETHOD.

  METHOD register_constructor.
    DATA lo_reference TYPE REF TO object.
    IF constructor IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Host constructor must be bound'.
    ENDIF.
    lo_reference ?= constructor.
    set_global( name = name value = zcl_qjs_value=>new_object( lo_reference ) ).
  ENDMETHOD.

  METHOD get_global.
    DATA ls_global TYPE ty_global.
    assert_active( ).
    READ TABLE mt_globals WITH TABLE KEY name = name INTO ls_global.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Unknown JavaScript global'.
    ENDIF.
    result = ls_global-cell->get( ).
  ENDMETHOD.

  METHOD get_global_object.
    assert_active( ).
    result = mo_global_object.
  ENDMETHOD.

  METHOD eval.
    DATA lo_parser TYPE REF TO zcl_qjs_parser.
    DATA lo_vm TYPE REF TO zcl_qjs_vm.
    DATA lo_function TYPE REF TO zcl_qjs_function.
    DATA lt_names TYPE zcl_qjs_parser=>ty_global_names.
    DATA lt_cells TYPE zcl_qjs_vm=>ty_cells.
    DATA ls_global TYPE ty_global.
    DATA lt_bindings TYPE zcl_qjs_parser=>ty_global_bindings.
    DATA ls_binding TYPE zcl_qjs_parser=>ty_global_binding.
    DATA lo_cell TYPE REF TO zcl_qjs_cell.
    DATA ls_spec TYPE zcl_qjs_function=>ty_local_spec.
    DATA ls_undefined TYPE zcl_qjs_value=>ty_value.
    assert_active( ).
    LOOP AT mt_globals INTO ls_global.
      APPEND ls_global-name TO lt_names.
    ENDLOOP.
    CREATE OBJECT lo_parser
      EXPORTING source = source limits = mo_runtime->get_limits( )
        global_names = lt_names.
    lo_function = lo_parser->compile( ).
    lt_bindings = lo_parser->get_global_bindings( ).
    LOOP AT lt_bindings INTO ls_binding.
      READ TABLE mt_globals WITH TABLE KEY name = ls_binding-name INTO ls_global.
      IF sy-subrc = 0.
        lo_cell = ls_global-cell.
      ELSE.
        ls_spec = lo_function->get_local_spec( ls_binding-index ).
        ls_undefined = zcl_qjs_value=>new_undefined( ).
        CREATE OBJECT lo_cell
          EXPORTING value = ls_undefined initialized = ls_spec-initialized
            mutable = ls_spec-mutable runtime = mo_runtime.
        ls_global-name = ls_binding-name.
        ls_global-cell = lo_cell.
        INSERT ls_global INTO TABLE mt_globals.
        IF ls_binding-lexical = abap_false.
          mo_global_object->define_cell_property(
            name = ls_binding-name cell = lo_cell writable = ls_spec-mutable
            enumerable = abap_true configurable = abap_true ).
        ENDIF.
      ENDIF.
      APPEND lo_cell TO lt_cells.
    ENDLOOP.
    CREATE OBJECT lo_vm
      EXPORTING runtime = mo_runtime limits = mo_runtime->get_limits( ).
    result = lo_vm->execute( function = lo_function initial_cells = lt_cells ).
    mo_runtime->drain_jobs( ).
  ENDMETHOD.

  METHOD call.
    DATA lo_emitter TYPE REF TO zcl_qjs_emitter.
    DATA lo_vm TYPE REF TO zcl_qjs_vm.
    DATA lo_function TYPE REF TO zcl_qjs_function.
    DATA ls_callable TYPE zcl_qjs_value=>ty_value.
    DATA ls_argument TYPE zcl_qjs_value=>ty_value.
    assert_active( ).
    ls_callable = get_global( name ).
    CREATE OBJECT lo_emitter EXPORTING limits = mo_runtime->get_limits( ).
    IF this_value-tag <> 0.
      lo_emitter->emit_constant( this_value ).
    ENDIF.
    lo_emitter->emit_constant( ls_callable ).
    LOOP AT arguments INTO ls_argument.
      lo_emitter->emit_constant( ls_argument ).
    ENDLOOP.
    IF this_value-tag = 0.
      lo_emitter->emit(
        opcode = zif_qjs_opcodes=>call operand = lines( arguments ) ).
    ELSE.
      lo_emitter->emit(
        opcode = zif_qjs_opcodes=>call_method operand = lines( arguments ) ).
    ENDIF.
    lo_emitter->emit( zif_qjs_opcodes=>return ).
    lo_function = lo_emitter->to_function( ).
    CREATE OBJECT lo_vm
      EXPORTING runtime = mo_runtime limits = mo_runtime->get_limits( ).
    result = lo_vm->execute( lo_function ).
    mo_runtime->drain_jobs( ).
  ENDMETHOD.

  METHOD dispose.
    CLEAR mt_globals.
    CLEAR mo_global_object.
    CLEAR mo_runtime.
    mv_disposed = abap_true.
  ENDMETHOD.

  METHOD is_disposed.
    result = mv_disposed.
  ENDMETHOD.
ENDCLASS.
