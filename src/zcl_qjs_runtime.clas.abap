CLASS zcl_qjs_runtime DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_symbol_key,
        found TYPE abap_bool,
        key TYPE string,
      END OF ty_symbol_key.
    TYPES:
      BEGIN OF ty_iterator_result,
        done TYPE abap_bool,
        value TYPE zcl_qjs_value=>ty_value,
      END OF ty_iterator_result.
    TYPES:
      BEGIN OF ty_iterator_resume_result,
        found TYPE abap_bool,
        done TYPE abap_bool,
        value TYPE zcl_qjs_value=>ty_value,
      END OF ty_iterator_resume_result.
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
    METHODS create_generator
      IMPORTING closure TYPE REF TO zcl_qjs_closure
        this_value TYPE zcl_qjs_value=>ty_value
        arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object
      RAISING zcx_qjs_error.
    METHODS invoke_callable
      IMPORTING callable TYPE zcl_qjs_value=>ty_value
        this_value TYPE zcl_qjs_value=>ty_value
        arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS get_iterator
      IMPORTING value TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS iterator_next
      IMPORTING iterator TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE ty_iterator_result
      RAISING zcx_qjs_error.
    METHODS iterator_resume
      IMPORTING iterator TYPE zcl_qjs_value=>ty_value
        kind TYPE i
        value TYPE zcl_qjs_value=>ty_value OPTIONAL
        pass_value TYPE abap_bool DEFAULT abap_true
      RETURNING VALUE(result) TYPE ty_iterator_resume_result
      RAISING zcx_qjs_error.
    METHODS iterator_close
      IMPORTING iterator TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS to_primitive
      IMPORTING value TYPE zcl_qjs_value=>ty_value
        prefer_string TYPE abap_bool DEFAULT abap_false
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS to_string
      IMPORTING value TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE string
      RAISING zcx_qjs_error.
    METHODS construct_value
      IMPORTING constructor TYPE zcl_qjs_value=>ty_value
        new_target TYPE zcl_qjs_value=>ty_value OPTIONAL
        arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS set_function_prototype
      IMPORTING prototype TYPE REF TO zcl_qjs_object.
    METHODS get_function_prototype
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS set_generator_function_proto
      IMPORTING prototype TYPE REF TO zcl_qjs_object.
    METHODS get_generator_function_proto
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS set_object_prototype
      IMPORTING prototype TYPE REF TO zcl_qjs_object.
    METHODS get_object_prototype
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS set_array_prototype
      IMPORTING prototype TYPE REF TO zcl_qjs_object.
    METHODS get_array_prototype
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS set_string_prototype
      IMPORTING prototype TYPE REF TO zcl_qjs_object.
    METHODS get_string_prototype
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS set_map_prototype
      IMPORTING prototype TYPE REF TO zcl_qjs_object.
    METHODS get_map_prototype
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS set_set_prototype
      IMPORTING prototype TYPE REF TO zcl_qjs_object.
    METHODS get_set_prototype
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS set_map_iterator_proto
      IMPORTING prototype TYPE REF TO zcl_qjs_object.
    METHODS get_map_iterator_proto
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS set_set_iterator_proto
      IMPORTING prototype TYPE REF TO zcl_qjs_object.
    METHODS get_set_iterator_proto
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS set_array_iterator_proto
      IMPORTING prototype TYPE REF TO zcl_qjs_object.
    METHODS get_array_iterator_proto
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS set_string_iterator_proto
      IMPORTING prototype TYPE REF TO zcl_qjs_object.
    METHODS get_string_iterator_proto
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS set_generator_prototype
      IMPORTING prototype TYPE REF TO zcl_qjs_object.
    METHODS get_generator_prototype
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS set_error_prototype
      IMPORTING name TYPE string prototype TYPE REF TO zcl_qjs_object.
    METHODS get_error_prototype
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS create_function_properties
      IMPORTING generator TYPE abap_bool DEFAULT abap_false
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
    TYPES:
      BEGIN OF ty_error_prototype,
        name TYPE string,
        prototype TYPE REF TO zcl_qjs_object,
      END OF ty_error_prototype.
    TYPES ty_error_prototypes TYPE HASHED TABLE OF ty_error_prototype
      WITH UNIQUE KEY name.
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
    DATA mo_generator_function_proto TYPE REF TO zcl_qjs_object.
    DATA mo_array_prototype TYPE REF TO zcl_qjs_object.
    DATA mo_string_prototype TYPE REF TO zcl_qjs_object.
    DATA mo_map_prototype TYPE REF TO zcl_qjs_object.
    DATA mo_set_prototype TYPE REF TO zcl_qjs_object.
    DATA mo_map_iterator_proto TYPE REF TO zcl_qjs_object.
    DATA mo_set_iterator_proto TYPE REF TO zcl_qjs_object.
    DATA mo_array_iterator_proto TYPE REF TO zcl_qjs_object.
    DATA mo_string_iterator_proto TYPE REF TO zcl_qjs_object.
    DATA mo_generator_prototype TYPE REF TO zcl_qjs_object.
    DATA mt_error_prototypes TYPE ty_error_prototypes.
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

  METHOD create_generator.
    DATA(lo_prototype) = closure->get_prototype_object( ).
    IF lo_prototype IS NOT BOUND.
      lo_prototype = mo_generator_prototype.
    ENDIF.
    result = create_object( prototype = lo_prototype ).
    result->initialize_generator(
      function = closure->get_function( ) closure = closure
      this_value = this_value arguments = arguments ).
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

  METHOD get_iterator.
    DATA(ls_iterator_symbol) = well_known_symbol( 'iterator' ).
    DATA ls_method TYPE zcl_qjs_value=>ty_value.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    DATA lo_properties TYPE REF TO zif_qjs_property_container.
    IF value-tag = zcl_qjs_value=>tag_string.
      IF mo_string_prototype IS BOUND.
        ls_method = mo_string_prototype->get_symbol(
          ls_iterator_symbol-symbol_id ).
      ENDIF.
    ELSEIF value-tag = zcl_qjs_value=>tag_object.
      TRY.
          lo_object ?= value-object_ref.
        CATCH cx_sy_move_cast_error.
      ENDTRY.
      IF lo_object IS BOUND.
        ls_method = lo_object->get_symbol( ls_iterator_symbol-symbol_id ).
      ELSE.
        lo_properties = value-property_ref.
        IF lo_properties IS NOT BOUND.
          TRY.
              lo_properties ?= value-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
        ENDIF.
        IF lo_properties IS BOUND.
          ls_method = lo_properties->get_symbol_property(
            ls_iterator_symbol-symbol_id ).
        ENDIF.
      ENDIF.
    ENDIF.
    IF ls_method-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: value is not iterable'.
    ENDIF.
    result = invoke_callable( callable = ls_method this_value = value ).
    IF result-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: iterator method did not return an object'.
    ENDIF.
  ENDMETHOD.

  METHOD iterator_next.
    DATA ls_next_method TYPE zcl_qjs_value=>ty_value.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    DATA lo_properties TYPE REF TO zif_qjs_property_container.
    IF iterator-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: iterator is not an object'.
    ENDIF.
    TRY.
        lo_object ?= iterator-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_object IS BOUND.
      ls_next_method = lo_object->get( 'next' ).
    ELSE.
      lo_properties = iterator-property_ref.
      IF lo_properties IS NOT BOUND.
        TRY.
            lo_properties ?= iterator-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
      ENDIF.
      IF lo_properties IS BOUND.
        ls_next_method = lo_properties->get_property( 'next' ).
      ENDIF.
    ENDIF.
    DATA(ls_step) = invoke_callable(
      callable = ls_next_method this_value = iterator ).
    IF ls_step-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: iterator result is not an object'.
    ENDIF.
    CLEAR lo_object.
    CLEAR lo_properties.
    TRY.
        lo_object ?= ls_step-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    DATA ls_done TYPE zcl_qjs_value=>ty_value.
    IF lo_object IS BOUND.
      ls_done = lo_object->get( 'done' ).
      result-value = lo_object->get( 'value' ).
    ELSE.
      lo_properties = ls_step-property_ref.
      IF lo_properties IS NOT BOUND.
        TRY.
            lo_properties ?= ls_step-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
      ENDIF.
      IF lo_properties IS NOT BOUND.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'TypeError: iterator result is unsupported'.
      ENDIF.
      ls_done = lo_properties->get_property( 'done' ).
      result-value = lo_properties->get_property( 'value' ).
    ENDIF.
    result-done = zcl_qjs_value=>to_boolean( ls_done ).
  ENDMETHOD.

  METHOD iterator_resume.
    DATA lv_method_name TYPE string.
    DATA ls_method TYPE zcl_qjs_value=>ty_value.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    DATA lo_properties TYPE REF TO zif_qjs_property_container.
    DATA lt_arguments TYPE zif_qjs_callable=>ty_arguments.
    CASE kind.
      WHEN 0.
        lv_method_name = 'next'.
      WHEN 1.
        lv_method_name = 'return'.
      WHEN 2.
        lv_method_name = 'throw'.
      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Invalid iterator resume kind'.
    ENDCASE.
    IF iterator-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: iterator is not an object'.
    ENDIF.
    TRY.
        lo_object ?= iterator-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_object IS BOUND.
      ls_method = lo_object->get( lv_method_name ).
    ELSE.
      lo_properties = iterator-property_ref.
      IF lo_properties IS NOT BOUND.
        TRY.
            lo_properties ?= iterator-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
      ENDIF.
      IF lo_properties IS BOUND.
        ls_method = lo_properties->get_property( lv_method_name ).
      ENDIF.
    ENDIF.
    IF ls_method-tag = zcl_qjs_value=>tag_undefined
        OR ls_method-tag = zcl_qjs_value=>tag_null.
      RETURN.
    ENDIF.
    result-found = abap_true.
    IF pass_value = abap_true.
      APPEND value TO lt_arguments.
    ENDIF.
    DATA(ls_step) = invoke_callable(
      callable = ls_method this_value = iterator arguments = lt_arguments ).
    IF ls_step-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: iterator result is not an object'.
    ENDIF.
    CLEAR lo_object.
    CLEAR lo_properties.
    TRY.
        lo_object ?= ls_step-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    DATA ls_done TYPE zcl_qjs_value=>ty_value.
    IF lo_object IS BOUND.
      ls_done = lo_object->get( 'done' ).
      result-value = lo_object->get( 'value' ).
    ELSE.
      lo_properties = ls_step-property_ref.
      IF lo_properties IS NOT BOUND.
        TRY.
            lo_properties ?= ls_step-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
      ENDIF.
      IF lo_properties IS NOT BOUND.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'TypeError: iterator result is unsupported'.
      ENDIF.
      ls_done = lo_properties->get_property( 'done' ).
      result-value = lo_properties->get_property( 'value' ).
    ENDIF.
    result-done = zcl_qjs_value=>to_boolean( ls_done ).
  ENDMETHOD.

  METHOD iterator_close.
    DATA ls_return_method TYPE zcl_qjs_value=>ty_value.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    DATA lo_properties TYPE REF TO zif_qjs_property_container.
    IF iterator-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: iterator is not an object'.
    ENDIF.
    TRY.
        lo_object ?= iterator-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_object IS BOUND.
      ls_return_method = lo_object->get( 'return' ).
    ELSE.
      lo_properties = iterator-property_ref.
      IF lo_properties IS NOT BOUND.
        TRY.
            lo_properties ?= iterator-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
      ENDIF.
      IF lo_properties IS BOUND.
        ls_return_method = lo_properties->get_property( 'return' ).
      ENDIF.
    ENDIF.
    IF ls_return_method-tag = zcl_qjs_value=>tag_undefined
        OR ls_return_method-tag = zcl_qjs_value=>tag_null.
      RETURN.
    ENDIF.
    DATA(ls_result) = invoke_callable(
      callable = ls_return_method this_value = iterator ).
    IF ls_result-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: iterator return result is not an object'.
    ENDIF.
  ENDMETHOD.

  METHOD to_primitive.
    IF value-tag <> zcl_qjs_value=>tag_object.
      result = value.
      RETURN.
    ENDIF.
    DATA lo_closure TYPE REF TO zcl_qjs_closure.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    DATA lo_properties TYPE REF TO zif_qjs_property_container.
    TRY.
        lo_closure ?= value-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_closure IS NOT BOUND.
      TRY.
          lo_object ?= value-object_ref.
        CATCH cx_sy_move_cast_error.
      ENDTRY.
    ENDIF.
    IF lo_closure IS NOT BOUND AND lo_object IS NOT BOUND.
      lo_properties = value-property_ref.
      IF lo_properties IS NOT BOUND.
        TRY.
            lo_properties ?= value-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
      ENDIF.
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
    DATA lv_method_name TYPE string.
    DO 2 TIMES.
      IF sy-index = 1.
        lv_method_name = lv_first_name.
      ELSE.
        lv_method_name = lv_second_name.
      ENDIF.
      DATA ls_method TYPE zcl_qjs_value=>ty_value.
      IF lo_closure IS BOUND.
        ls_method = lo_closure->get_property( lv_method_name ).
      ELSEIF lo_object IS BOUND.
        ls_method = lo_object->get( lv_method_name ).
      ELSEIF lo_properties IS BOUND.
        ls_method = lo_properties->get_property( lv_method_name ).
      ELSE.
        CONTINUE.
      ENDIF.
      DATA lo_callable TYPE REF TO zif_qjs_callable.
      DATA lo_method_closure TYPE REF TO zcl_qjs_closure.
      IF ls_method-tag = zcl_qjs_value=>tag_object.
        TRY.
            lo_method_closure ?= ls_method-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
        TRY.
            lo_callable ?= ls_method-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
      ENDIF.
      IF lo_method_closure IS BOUND OR lo_callable IS BOUND.
        result = invoke_callable( callable = ls_method this_value = value ).
        IF result-tag <> zcl_qjs_value=>tag_object.
          RETURN.
        ENDIF.
      ENDIF.
      CLEAR lo_callable.
      CLEAR lo_method_closure.
    ENDDO.
    RAISE EXCEPTION TYPE zcx_qjs_error
      EXPORTING reason = 'TypeError: runtime conversion cannot produce a primitive'.
  ENDMETHOD.

  METHOD to_string.
    result = zcl_qjs_value=>to_string(
      to_primitive( value = value prefer_string = abap_true ) ).
  ENDMETHOD.

  METHOD construct_value.
    DATA lo_closure TYPE REF TO zcl_qjs_closure.
    DATA lo_constructor TYPE REF TO zif_qjs_constructable.
    DATA lo_new_target_closure TYPE REF TO zcl_qjs_closure.
    DATA lo_new_target_properties TYPE REF TO zif_qjs_property_container.
    DATA lo_construct_prototype TYPE REF TO zcl_qjs_object.
    DATA ls_prototype_value TYPE zcl_qjs_value=>ty_value.
    IF constructor-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: value is not constructable'.
    ENDIF.
    TRY.
        lo_closure ?= constructor-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF new_target-tag <> 0.
      TRY.
          lo_new_target_closure ?= new_target-object_ref.
        CATCH cx_sy_move_cast_error.
      ENDTRY.
      IF lo_new_target_closure IS BOUND.
        ls_prototype_value = lo_new_target_closure->get_property( 'prototype' ).
      ELSE.
        lo_new_target_properties = new_target-property_ref.
        IF lo_new_target_properties IS NOT BOUND.
          TRY.
              lo_new_target_properties ?= new_target-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
        ENDIF.
        IF lo_new_target_properties IS BOUND.
          ls_prototype_value = lo_new_target_properties->get_property( 'prototype' ).
        ENDIF.
      ENDIF.
      IF ls_prototype_value-tag = zcl_qjs_value=>tag_object.
        TRY.
            lo_construct_prototype ?= ls_prototype_value-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
      ENDIF.
      IF lo_construct_prototype IS NOT BOUND.
        lo_construct_prototype = mo_object_prototype.
      ENDIF.
    ENDIF.
    IF lo_closure IS BOUND.
      IF new_target-tag <> 0.
        result = lo_closure->construct_with_prototype(
          arguments = arguments prototype = lo_construct_prototype ).
      ELSE.
        result = lo_closure->construct( arguments ).
      ENDIF.
      RETURN.
    ENDIF.
    TRY.
        lo_constructor ?= constructor-object_ref.
      CATCH cx_sy_move_cast_error.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'TypeError: object is not constructable'.
    ENDTRY.
    result = lo_constructor->construct( runtime = me arguments = arguments ).
    IF new_target-tag <> 0 AND result-tag = zcl_qjs_value=>tag_object.
      DATA lo_result_object TYPE REF TO zcl_qjs_object.
      TRY.
          lo_result_object ?= result-object_ref.
        CATCH cx_sy_move_cast_error.
      ENDTRY.
      IF lo_result_object IS BOUND.
        lo_result_object->set_prototype( lo_construct_prototype ).
      ENDIF.
    ENDIF.
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

  METHOD set_generator_function_proto.
    mo_generator_function_proto = prototype.
  ENDMETHOD.

  METHOD get_generator_function_proto.
    result = mo_generator_function_proto.
  ENDMETHOD.

  METHOD set_array_prototype.
    mo_array_prototype = prototype.
  ENDMETHOD.

  METHOD get_array_prototype.
    result = mo_array_prototype.
  ENDMETHOD.

  METHOD set_string_prototype.
    mo_string_prototype = prototype.
  ENDMETHOD.

  METHOD get_string_prototype.
    result = mo_string_prototype.
  ENDMETHOD.

  METHOD set_map_prototype.
    mo_map_prototype = prototype.
  ENDMETHOD.

  METHOD get_map_prototype.
    result = mo_map_prototype.
  ENDMETHOD.

  METHOD set_set_prototype.
    mo_set_prototype = prototype.
  ENDMETHOD.

  METHOD get_set_prototype.
    result = mo_set_prototype.
  ENDMETHOD.

  METHOD set_map_iterator_proto.
    mo_map_iterator_proto = prototype.
  ENDMETHOD.

  METHOD get_map_iterator_proto.
    result = mo_map_iterator_proto.
  ENDMETHOD.

  METHOD set_set_iterator_proto.
    mo_set_iterator_proto = prototype.
  ENDMETHOD.

  METHOD get_set_iterator_proto.
    result = mo_set_iterator_proto.
  ENDMETHOD.

  METHOD set_array_iterator_proto.
    mo_array_iterator_proto = prototype.
  ENDMETHOD.

  METHOD get_array_iterator_proto.
    result = mo_array_iterator_proto.
  ENDMETHOD.

  METHOD set_string_iterator_proto.
    mo_string_iterator_proto = prototype.
  ENDMETHOD.

  METHOD get_string_iterator_proto.
    result = mo_string_iterator_proto.
  ENDMETHOD.

  METHOD set_generator_prototype.
    mo_generator_prototype = prototype.
  ENDMETHOD.

  METHOD get_generator_prototype.
    result = mo_generator_prototype.
  ENDMETHOD.

  METHOD set_error_prototype.
    DELETE TABLE mt_error_prototypes WITH TABLE KEY name = name.
    INSERT VALUE #( name = name prototype = prototype )
      INTO TABLE mt_error_prototypes.
  ENDMETHOD.

  METHOD get_error_prototype.
    READ TABLE mt_error_prototypes WITH TABLE KEY name = name
      INTO DATA(ls_error_prototype).
    IF sy-subrc = 0.
      result = ls_error_prototype-prototype.
    ENDIF.
  ENDMETHOD.

  METHOD create_function_properties.
    IF generator = abap_true AND mo_generator_function_proto IS BOUND.
      result = create_object( prototype = mo_generator_function_proto ).
    ELSE.
      result = create_object( prototype = mo_function_prototype ).
    ENDIF.
  ENDMETHOD.

  METHOD create_error.
    DATA lo_error TYPE REF TO zcl_qjs_object.
    DATA lo_to_string TYPE REF TO zcl_qjs_native_function.
    DATA lo_reference TYPE REF TO object.
    DATA lv_to_string_property TYPE string VALUE 'toString'.
    DATA(lo_error_prototype) = get_error_prototype( name ).
    IF lo_error_prototype IS BOUND.
      lo_error = create_object( prototype = lo_error_prototype ).
    ELSE.
      lo_error = create_object( ).
      lo_error->define_property(
        name = 'name' value = zcl_qjs_value=>new_string( name )
        writable = abap_true enumerable = abap_false configurable = abap_true ).
      CREATE OBJECT lo_to_string
        EXPORTING id = zcl_qjs_native_function=>id_error_to_string runtime = me.
      lo_reference = lo_to_string.
      lo_error->define_property(
        name = lv_to_string_property value = zcl_qjs_value=>new_object( lo_reference )
        writable = abap_true enumerable = abap_false configurable = abap_true ).
    ENDIF.
    IF message IS SUPPLIED.
      lo_error->define_property(
        name = 'message' value = zcl_qjs_value=>new_string( message )
        writable = abap_true enumerable = abap_false configurable = abap_true ).
    ENDIF.
    lo_error->define_property(
      name = '[[ErrorData]]' value = zcl_qjs_value=>new_undefined( )
      writable = abap_false enumerable = abap_false configurable = abap_false ).
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
    CLEAR mo_generator_function_proto.
    CLEAR mo_array_prototype.
    CLEAR mo_string_prototype.
    CLEAR mo_map_prototype.
    CLEAR mo_set_prototype.
    CLEAR mo_map_iterator_proto.
    CLEAR mo_set_iterator_proto.
    CLEAR mo_array_iterator_proto.
    CLEAR mo_string_iterator_proto.
    CLEAR mo_generator_prototype.
    CLEAR mo_empty_shape.
    mv_object_count = 0.
    mv_disposed = abap_true.
  ENDMETHOD.

  METHOD is_disposed.
    result = mv_disposed.
  ENDMETHOD.
ENDCLASS.
