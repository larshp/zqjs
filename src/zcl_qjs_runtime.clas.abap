CLASS zcl_qjs_runtime DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_symbol_key,
        found TYPE abap_bool,
        key TYPE string,
      END OF ty_symbol_key.
    METHODS constructor
      IMPORTING
        max_steps TYPE int8 DEFAULT 100000
        max_atoms TYPE i DEFAULT 4096
        max_objects TYPE i DEFAULT 10000
        cancellation TYPE REF TO zif_qjs_cancellation OPTIONAL
      RAISING zcx_qjs_error.

    METHODS get_limits RETURNING VALUE(result) TYPE REF TO zcl_qjs_limits
      RAISING zcx_qjs_error.
    METHODS get_atoms RETURNING VALUE(result) TYPE REF TO zcl_qjs_atoms
      RAISING zcx_qjs_error.
    METHODS new_symbol
      IMPORTING description TYPE string OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS symbol_description
      IMPORTING symbol TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE string
      RAISING zcx_qjs_error.
    METHODS symbol_for
      IMPORTING key TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS symbol_key_for
      IMPORTING symbol TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE ty_symbol_key
      RAISING zcx_qjs_error.
    METHODS well_known_symbol
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS create_object
      IMPORTING prototype TYPE REF TO zcl_qjs_object OPTIONAL
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object
      RAISING zcx_qjs_error.
    METHODS create_array
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object
      RAISING zcx_qjs_error.
    METHODS invoke_callable
      IMPORTING callable TYPE zcl_qjs_value=>ty_value
        this_value TYPE zcl_qjs_value=>ty_value
        arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS construct_value
      IMPORTING constructor TYPE zcl_qjs_value=>ty_value
        arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS set_function_prototype
      IMPORTING prototype TYPE REF TO zcl_qjs_object.
    METHODS get_function_prototype
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS set_object_prototype
      IMPORTING prototype TYPE REF TO zcl_qjs_object.
    METHODS get_object_prototype
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS set_array_prototype
      IMPORTING prototype TYPE REF TO zcl_qjs_object.
    METHODS get_array_prototype
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS create_function_properties
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object
      RAISING zcx_qjs_error.
    METHODS create_error
      IMPORTING name TYPE string message TYPE string OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS create_error_from_reason
      IMPORTING reason TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS allocated_object_count RETURNING VALUE(result) TYPE i.
    METHODS register_resource
      IMPORTING resource TYPE REF TO zif_qjs_disposable
      RAISING zcx_qjs_error.
    METHODS dispose.
    METHODS is_disposed RETURNING VALUE(result) TYPE abap_bool.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_symbol,
      identity TYPE int8,
      description TYPE string,
    END OF ty_symbol.
    TYPES ty_symbols TYPE HASHED TABLE OF ty_symbol WITH UNIQUE KEY identity.
    TYPES:
      BEGIN OF ty_symbol_registry,
        key TYPE string,
        identity TYPE int8,
      END OF ty_symbol_registry.
    TYPES ty_symbol_registry_tab TYPE SORTED TABLE OF ty_symbol_registry
      WITH UNIQUE KEY key.
    TYPES ty_well_known_symbols TYPE SORTED TABLE OF ty_symbol_registry
      WITH UNIQUE KEY key.
    DATA mo_limits TYPE REF TO zcl_qjs_limits.
    DATA mo_atoms TYPE REF TO zcl_qjs_atoms.
    DATA mt_symbols TYPE ty_symbols.
    DATA mt_symbol_registry TYPE ty_symbol_registry_tab.
    DATA mt_well_known_symbols TYPE ty_well_known_symbols.
    DATA mv_next_symbol TYPE int8 VALUE 1.
    DATA mv_disposed TYPE abap_bool.
    DATA mv_max_objects TYPE i.
    DATA mv_object_count TYPE i.
    DATA mo_empty_shape TYPE REF TO zcl_qjs_shape.
    DATA mo_object_prototype TYPE REF TO zcl_qjs_object.
    DATA mo_function_prototype TYPE REF TO zcl_qjs_object.
    DATA mo_array_prototype TYPE REF TO zcl_qjs_object.
    DATA mt_resources TYPE STANDARD TABLE OF REF TO zif_qjs_disposable
      WITH DEFAULT KEY.
    METHODS assert_active RAISING zcx_qjs_error.
ENDCLASS.

CLASS zcl_qjs_runtime IMPLEMENTATION.
  METHOD constructor.
    IF max_objects <= 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Object limit must be positive'.
    ENDIF.
    CREATE OBJECT mo_limits
      EXPORTING max_steps = max_steps cancellation = cancellation.
    CREATE OBJECT mo_atoms EXPORTING max_atoms = max_atoms.
    CREATE OBJECT mo_empty_shape.
    mv_max_objects = max_objects.
  ENDMETHOD.

  METHOD assert_active.
    IF mv_disposed = abap_true.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'JavaScript runtime is disposed'.
    ENDIF.
  ENDMETHOD.

  METHOD get_limits.
    assert_active( ).
    result = mo_limits.
  ENDMETHOD.

  METHOD get_atoms.
    assert_active( ).
    result = mo_atoms.
  ENDMETHOD.

  METHOD new_symbol.
    DATA ls_symbol TYPE ty_symbol.
    assert_active( ).
    ls_symbol-identity = mv_next_symbol.
    ls_symbol-description = description.
    INSERT ls_symbol INTO TABLE mt_symbols.
    result = zcl_qjs_value=>new_symbol( mv_next_symbol ).
    mv_next_symbol = mv_next_symbol + 1.
  ENDMETHOD.

  METHOD symbol_description.
    DATA ls_symbol TYPE ty_symbol.
    assert_active( ).
    IF symbol-tag <> zcl_qjs_value=>tag_symbol.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Value is not a Symbol'.
    ENDIF.
    READ TABLE mt_symbols WITH TABLE KEY identity = symbol-symbol_id INTO ls_symbol.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Symbol belongs to another runtime'.
    ENDIF.
    result = ls_symbol-description.
  ENDMETHOD.

  METHOD symbol_for.
    DATA ls_registry TYPE ty_symbol_registry.
    assert_active( ).
    READ TABLE mt_symbol_registry WITH TABLE KEY key = key INTO ls_registry.
    IF sy-subrc = 0.
      result = zcl_qjs_value=>new_symbol( ls_registry-identity ).
      RETURN.
    ENDIF.
    result = new_symbol( description = key ).
    ls_registry-key = key.
    ls_registry-identity = result-symbol_id.
    INSERT ls_registry INTO TABLE mt_symbol_registry.
  ENDMETHOD.

  METHOD symbol_key_for.
    assert_active( ).
    DATA(lv_description) = symbol_description( symbol ).
    LOOP AT mt_symbol_registry INTO DATA(ls_registry)
        WHERE identity = symbol-symbol_id.
      result-found = abap_true.
      result-key = ls_registry-key.
      RETURN.
    ENDLOOP.
    result-found = abap_false.
  ENDMETHOD.

  METHOD well_known_symbol.
    assert_active( ).
    READ TABLE mt_well_known_symbols WITH TABLE KEY key = name
      INTO DATA(ls_symbol).
    IF sy-subrc = 0.
      result = zcl_qjs_value=>new_symbol( ls_symbol-identity ).
      RETURN.
    ENDIF.
    result = new_symbol( description = 'Symbol.' && name ).
    ls_symbol-key = name.
    ls_symbol-identity = result-symbol_id.
    INSERT ls_symbol INTO TABLE mt_well_known_symbols.
  ENDMETHOD.

  METHOD create_object.
    assert_active( ).
    IF mv_object_count >= mv_max_objects.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'JavaScript object budget exhausted'.
    ENDIF.
    IF prototype IS SUPPLIED.
      CREATE OBJECT result
        EXPORTING prototype = prototype shape = mo_empty_shape runtime = me.
    ELSE.
      CREATE OBJECT result
        EXPORTING prototype = mo_object_prototype shape = mo_empty_shape runtime = me.
    ENDIF.
    mv_object_count = mv_object_count + 1.
  ENDMETHOD.

  METHOD create_array.
    assert_active( ).
    IF mv_object_count >= mv_max_objects.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'JavaScript object budget exhausted'.
    ENDIF.
    CREATE OBJECT result
      EXPORTING is_array = abap_true prototype = mo_array_prototype
        shape = mo_empty_shape runtime = me.
    mv_object_count = mv_object_count + 1.
  ENDMETHOD.

  METHOD invoke_callable.
    DATA lo_closure TYPE REF TO zcl_qjs_closure.
    DATA lo_callable TYPE REF TO zif_qjs_callable.
    IF callable-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: value is not callable'.
    ENDIF.
    TRY.
        lo_closure ?= callable-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_closure IS BOUND.
      result = lo_closure->invoke(
        this_value = this_value arguments = arguments ).
      RETURN.
    ENDIF.
    TRY.
        lo_callable ?= callable-object_ref.
      CATCH cx_sy_move_cast_error.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'TypeError: object is not callable'.
    ENDTRY.
    result = lo_callable->call(
      this_value = this_value arguments = arguments ).
  ENDMETHOD.

  METHOD construct_value.
    DATA lo_closure TYPE REF TO zcl_qjs_closure.
    DATA lo_constructor TYPE REF TO zif_qjs_constructable.
    IF constructor-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: value is not constructable'.
    ENDIF.
    TRY.
        lo_closure ?= constructor-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_closure IS BOUND.
      result = lo_closure->construct( arguments ).
      RETURN.
    ENDIF.
    TRY.
        lo_constructor ?= constructor-object_ref.
      CATCH cx_sy_move_cast_error.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'TypeError: object is not constructable'.
    ENDTRY.
    result = lo_constructor->construct( runtime = me arguments = arguments ).
  ENDMETHOD.

  METHOD set_function_prototype.
    mo_function_prototype = prototype.
  ENDMETHOD.

  METHOD set_object_prototype.
    mo_object_prototype = prototype.
  ENDMETHOD.

  METHOD get_object_prototype.
    result = mo_object_prototype.
  ENDMETHOD.

  METHOD get_function_prototype.
    result = mo_function_prototype.
  ENDMETHOD.

  METHOD set_array_prototype.
    mo_array_prototype = prototype.
  ENDMETHOD.

  METHOD get_array_prototype.
    result = mo_array_prototype.
  ENDMETHOD.

  METHOD create_function_properties.
    result = create_object( prototype = mo_function_prototype ).
  ENDMETHOD.

  METHOD create_error.
    DATA lo_error TYPE REF TO zcl_qjs_object.
    DATA lo_to_string TYPE REF TO zcl_qjs_native_function.
    DATA lo_reference TYPE REF TO object.
    DATA lv_to_string_property TYPE string VALUE 'toString'.
    lo_error = create_object( ).
    lo_error->define_property(
      name = 'name' value = zcl_qjs_value=>new_string( name )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    lo_error->define_property(
      name = 'message' value = zcl_qjs_value=>new_string( message )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    CREATE OBJECT lo_to_string
      EXPORTING id = zcl_qjs_native_function=>id_error_to_string runtime = me.
    lo_reference = lo_to_string.
    lo_error->define_property(
      name = lv_to_string_property value = zcl_qjs_value=>new_object( lo_reference )
      writable = abap_true enumerable = abap_false configurable = abap_true ).
    result = zcl_qjs_value=>new_object( lo_error ).
  ENDMETHOD.

  METHOD create_error_from_reason.
    DATA lv_name TYPE string VALUE 'Error'.
    DATA lv_message TYPE string.
    DATA lv_offset TYPE i.
    lv_message = reason.
    FIND FIRST OCCURRENCE OF ': ' IN reason MATCH OFFSET lv_offset.
    IF sy-subrc = 0 AND lv_offset > 0.
      lv_name = reason+0(lv_offset).
      DATA(lv_message_offset) = lv_offset + 2.
      lv_message = reason+lv_message_offset.
    ENDIF.
    result = create_error( name = lv_name message = lv_message ).
  ENDMETHOD.

  METHOD allocated_object_count.
    result = mv_object_count.
  ENDMETHOD.

  METHOD register_resource.
    assert_active( ).
    IF resource IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Host resource must be bound'.
    ENDIF.
    APPEND resource TO mt_resources.
  ENDMETHOD.

  METHOD dispose.
    IF mv_disposed = abap_true.
      RETURN.
    ENDIF.
    LOOP AT mt_resources INTO DATA(lo_resource).
      lo_resource->dispose( ).
    ENDLOOP.
    CLEAR mt_resources.
    IF mo_atoms IS BOUND.
      mo_atoms->clear_dynamic( ).
    ENDIF.
    CLEAR mt_symbols.
    CLEAR mt_symbol_registry.
    CLEAR mt_well_known_symbols.
    CLEAR mo_object_prototype.
    CLEAR mo_function_prototype.
    CLEAR mo_array_prototype.
    CLEAR mo_empty_shape.
    mv_object_count = 0.
    mv_disposed = abap_true.
  ENDMETHOD.

  METHOD is_disposed.
    result = mv_disposed.
  ENDMETHOD.
ENDCLASS.
