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
    DATA ls_native_value TYPE zcl_qjs_value=>ty_value.
    IF runtime IS NOT BOUND OR runtime->is_disposed( ) = abap_true.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Context requires an active JavaScript runtime'.
    ENDIF.
    mo_runtime = runtime.
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_number
      runtime = mo_runtime.
    lo_reference = lo_native.
    ls_native_value = zcl_qjs_value=>new_object( lo_reference ).
    ls_native_value-property_ref = lo_native.
    set_global( name = 'Number' value = ls_native_value ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_string
      runtime = mo_runtime.
    lo_reference = lo_native.
    ls_native_value = zcl_qjs_value=>new_object( lo_reference ).
    ls_native_value-property_ref = lo_native.
    set_global( name = 'String' value = ls_native_value ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_boolean
      runtime = mo_runtime.
    lo_reference = lo_native.
    ls_native_value = zcl_qjs_value=>new_object( lo_reference ).
    ls_native_value-property_ref = lo_native.
    set_global( name = 'Boolean' value = ls_native_value ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_object
      runtime = mo_runtime.
    lo_object_intrinsic = lo_native.
    lo_reference = lo_native.
    ls_native_value = zcl_qjs_value=>new_object( lo_reference ).
    ls_native_value-property_ref = lo_native.
    set_global( name = 'Object' value = ls_native_value ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_array
      runtime = mo_runtime.
    lo_array_intrinsic = lo_native.
    lo_reference = lo_native.
    ls_native_value = zcl_qjs_value=>new_object( lo_reference ).
    ls_native_value-property_ref = lo_native.
    set_global( name = 'Array' value = ls_native_value ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_is_nan
      runtime = mo_runtime.
    lo_reference = lo_native.
    ls_native_value = zcl_qjs_value=>new_object( lo_reference ).
    ls_native_value-property_ref = lo_native.
    set_global( name = 'isNaN' value = ls_native_value ).
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
        runtime = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'defineProperty' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_get_own_descriptor
        runtime = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'getOwnPropertyDescriptor'
      value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_create runtime = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'create' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_get_prototype
        runtime = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'getPrototypeOf' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_set_prototype
        runtime = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'setPrototypeOf' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_define_properties
        runtime = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'defineProperties' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native
      EXPORTING id = zcl_qjs_native_function=>id_object_get_own_names
        runtime = mo_runtime.
    lo_reference = lo_native.
    lo_object_intrinsic->set_property(
      name = 'getOwnPropertyNames' value = zcl_qjs_value=>new_object( lo_reference ) ).
    set_global(
      name = 'NaN'
      value = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ) ).
    set_global(
      name = 'Infinity'
      value = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ) ).
    lo_math = mo_runtime->create_object( ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_abs
      runtime = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'abs' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_floor
      runtime = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'floor' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_ceil
      runtime = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'ceil' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_max
      runtime = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'max' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_math_min
      runtime = mo_runtime.
    lo_reference = lo_native.
    lo_math->set( name = 'min' value = zcl_qjs_value=>new_object( lo_reference ) ).
    set_global( name = 'Math' value = zcl_qjs_value=>new_object( lo_math ) ).
    lo_json = mo_runtime->create_object( ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_json_parse
      runtime = mo_runtime.
    lo_reference = lo_native.
    lo_json->set(
      name = 'parse' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_json_stringify
      runtime = mo_runtime.
    lo_reference = lo_native.
    lo_json->set(
      name = 'stringify' value = zcl_qjs_value=>new_object( lo_reference ) ).
    set_global( name = 'JSON' value = zcl_qjs_value=>new_object( lo_json ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_error
      runtime = mo_runtime.
    lo_reference = lo_native.
    set_global( name = 'Error' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_type_error
      runtime = mo_runtime.
    lo_reference = lo_native.
    set_global( name = 'TypeError' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_range_error
      runtime = mo_runtime.
    lo_reference = lo_native.
    set_global( name = 'RangeError' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_syntax_error
      runtime = mo_runtime.
    lo_reference = lo_native.
    set_global( name = 'SyntaxError' value = zcl_qjs_value=>new_object( lo_reference ) ).
    CREATE OBJECT lo_native EXPORTING id = zcl_qjs_native_function=>id_reference_error
      runtime = mo_runtime.
    lo_reference = lo_native.
    set_global( name = 'ReferenceError' value = zcl_qjs_value=>new_object( lo_reference ) ).
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
