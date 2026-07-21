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
    METHODS assert_active RAISING zcx_qjs_error.
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
    DATA lo_reference TYPE REF TO object.
    DATA lo_object_intrinsic TYPE REF TO zcl_qjs_native_function.
    DATA lo_array_intrinsic TYPE REF TO zcl_qjs_native_function.
    DATA lo_symbol_intrinsic TYPE REF TO zcl_qjs_native_function.
    DATA lo_number_intrinsic TYPE REF TO zcl_qjs_native_function.
    DATA lo_parse_int_intrinsic TYPE REF TO zcl_qjs_native_function.
    DATA lo_parse_float_intrinsic TYPE REF TO zcl_qjs_native_function.
    DATA lo_function_intrinsic TYPE REF TO zcl_qjs_native_function.
    DATA lo_object_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_function_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_array_prototype TYPE REF TO zcl_qjs_object.
    DATA lv_constructor_property TYPE string VALUE 'constructor'.
    DATA lv_to_string_name TYPE string VALUE 'toString'.
    DATA ls_native_value TYPE zcl_qjs_value=>ty_value.
    IF runtime IS NOT BOUND OR runtime->is_disposed( ) = abap_true.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Context requires an active JavaScript runtime'.
    ENDIF.
    mo_runtime = runtime.
    lo_object_prototype = mo_runtime->create_object( ).
    mo_runtime->set_object_prototype( lo_object_prototype ).
    lo_function_prototype = mo_runtime->create_object( ).
    mo_runtime->set_function_prototype( lo_function_prototype ).
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
    lo_reference = lo_native.
    ls_native_value = zcl_qjs_value=>new_object( lo_reference ).
    ls_native_value-property_ref = lo_native.
    set_global( name = 'String' value = ls_native_value ).
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
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_error
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    set_global( name = 'Error' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_type_error
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    set_global( name = 'TypeError' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_range_error
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    set_global( name = 'RangeError' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_syntax_error
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    set_global( name = 'SyntaxError' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_reference_error
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    set_global( name = 'ReferenceError' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_uri_error
      runtime                            = mo_runtime.
    lo_reference = lo_native.
    set_global( name = 'URIError' value = zcl_qjs_value=>new_object( lo_reference ) ).
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
      ENDIF.
      APPEND lo_cell TO lt_cells.
    ENDLOOP.
    CREATE OBJECT lo_vm
      EXPORTING runtime = mo_runtime limits = mo_runtime->get_limits( ).
    result = lo_vm->execute( function = lo_function initial_cells = lt_cells ).
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
  ENDMETHOD.

  METHOD dispose.
    CLEAR mt_globals.
    CLEAR mo_runtime.
    mv_disposed = abap_true.
  ENDMETHOD.

  METHOD is_disposed.
    result = mv_disposed.
  ENDMETHOD.
ENDCLASS.
