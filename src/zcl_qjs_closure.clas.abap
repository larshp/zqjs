CLASS zcl_qjs_closure DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES ty_cells TYPE STANDARD TABLE OF REF TO zcl_qjs_cell WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_instance_field,
      key           TYPE zcl_qjs_value=>ty_value,
      initializer   TYPE REF TO zcl_qjs_closure,
      private       TYPE abap_bool,
      direct        TYPE abap_bool,
      value         TYPE zcl_qjs_value=>ty_value,
      accessor_kind TYPE i,
      END OF ty_instance_field.
    TYPES ty_instance_fields TYPE STANDARD TABLE OF ty_instance_field
      WITH DEFAULT KEY.
    METHODS constructor
      IMPORTING function TYPE REF TO zcl_qjs_function
        captures         TYPE REF TO ty_cells OPTIONAL
        properties       TYPE REF TO zcl_qjs_object OPTIONAL
        prototype_object TYPE REF TO zcl_qjs_object OPTIONAL
        runtime          TYPE REF TO zcl_qjs_runtime OPTIONAL
      RAISING zcx_qjs_error.
    METHODS get_function RETURNING VALUE(result) TYPE REF TO zcl_qjs_function.
    METHODS get_captures RETURNING VALUE(result) TYPE ty_cells.
    METHODS get_captures_reference RETURNING VALUE(result) TYPE REF TO ty_cells.
    METHODS get_property
      IMPORTING name          TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS set_property IMPORTING name TYPE string value TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS delete_property
      IMPORTING name          TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_property
      IMPORTING name          TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS get_symbol_property
      IMPORTING identity      TYPE i
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS get_symbol_with_receiver
      IMPORTING identity TYPE i receiver TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS set_symbol_property
      IMPORTING identity TYPE i value TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS delete_symbol_property
      IMPORTING identity      TYPE i
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_symbol_property
      IMPORTING identity      TYPE i
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS get_prototype_object RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS get_property_storage RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS register_instance_field
      IMPORTING key TYPE zcl_qjs_value=>ty_value
        initializer TYPE REF TO zcl_qjs_closure
        private     TYPE abap_bool DEFAULT abap_false.
    METHODS register_private_method
      IMPORTING key TYPE zcl_qjs_value=>ty_value
        value       TYPE zcl_qjs_value=>ty_value.
    METHODS register_private_accessor
      IMPORTING key TYPE zcl_qjs_value=>ty_value
        value TYPE zcl_qjs_value=>ty_value kind TYPE i.
    METHODS set_base_constructor
      IMPORTING base TYPE zcl_qjs_value=>ty_value.
    METHODS invoke_default_derived
      IMPORTING receiver      TYPE zcl_qjs_value=>ty_value
        arguments             TYPE zif_qjs_callable=>ty_arguments OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS initialize_instance_fields
      IMPORTING receiver TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS invoke
      IMPORTING this_value    TYPE zcl_qjs_value=>ty_value
        arguments             TYPE zif_qjs_callable=>ty_arguments OPTIONAL
        class_call            TYPE abap_bool DEFAULT abap_false
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS construct
      IMPORTING arguments     TYPE zif_qjs_callable=>ty_arguments OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS construct_with_prototype
      IMPORTING arguments     TYPE zif_qjs_callable=>ty_arguments OPTIONAL
        prototype             TYPE REF TO zcl_qjs_object OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
  PRIVATE SECTION.
    DATA mo_function TYPE REF TO zcl_qjs_function.
    DATA mr_captures TYPE REF TO ty_cells.
    DATA mo_properties TYPE REF TO zcl_qjs_object.
    DATA mo_prototype_object TYPE REF TO zcl_qjs_object.
    DATA mo_runtime TYPE REF TO zcl_qjs_runtime.
    DATA mt_instance_fields TYPE REF TO ty_instance_fields.
    DATA ms_base_constructor TYPE zcl_qjs_value=>ty_value.
ENDCLASS.

CLASS zcl_qjs_closure IMPLEMENTATION.
  METHOD constructor.
    DATA lv_constructor_property TYPE string VALUE 'constructor'.
    mo_function = function.
    IF captures IS BOUND.
      mr_captures = captures.
    ELSE.
      CREATE DATA mr_captures.
    ENDIF.
    mo_properties = properties.
    mo_prototype_object = prototype_object.
    mo_runtime = runtime.
    IF mo_properties IS BOUND.
      IF mo_prototype_object IS BOUND.
        mo_properties->define_property(
          name = 'prototype' value = zcl_qjs_value=>new_object( mo_prototype_object )
          writable = abap_true enumerable = abap_false configurable = abap_false ).
      ENDIF.
      mo_properties->define_property(
        name = 'length' value = zcl_qjs_value=>new_int(
          mo_function->get_function_length( ) )
        writable = abap_false enumerable = abap_false configurable = abap_true ).
      mo_properties->define_property(
        name = 'name' value = zcl_qjs_value=>new_string( mo_function->get_name( ) )
        writable = abap_false enumerable = abap_false configurable = abap_true ).
      IF mo_prototype_object IS BOUND
          AND mo_function->is_generator( ) = abap_false.
        mo_prototype_object->define_property(
          name = lv_constructor_property value = zcl_qjs_value=>new_object( me )
          writable = abap_true enumerable = abap_false configurable = abap_true ).
      ENDIF.
    ENDIF.
  ENDMETHOD.
  METHOD get_function.
    result = mo_function.
  ENDMETHOD.
  METHOD get_captures.
    result = mr_captures->*.
  ENDMETHOD.
  METHOD get_captures_reference.
    result = mr_captures.
  ENDMETHOD.
  METHOD get_property.
    IF mo_properties IS BOUND.
      DATA(ls_own_property) = mo_properties->get_own_property( name ).
      IF ls_own_property-found = abap_true.
        result = mo_properties->get( name ).
        RETURN.
      ENDIF.
    ENDIF.
    IF ms_base_constructor-tag = zcl_qjs_value=>tag_object.
      DATA lo_base_properties TYPE REF TO zif_qjs_property_container.
      TRY.
          lo_base_properties ?= ms_base_constructor-object_ref.
        CATCH cx_sy_move_cast_error.
      ENDTRY.
      IF lo_base_properties IS BOUND.
        result = lo_base_properties->get_property( name ).
        RETURN.
      ENDIF.
    ENDIF.
    IF mo_properties IS BOUND.
      result = mo_properties->get( name ).
    ELSE.
      result = zcl_qjs_value=>new_undefined( ).
    ENDIF.
  ENDMETHOD.
  METHOD set_property.
    IF mo_properties IS BOUND.
      mo_properties->set( name = name value = value ).
    ENDIF.
    IF name = 'prototype'.
      DATA(ls_stored_prototype) = mo_properties->get( name ).
      IF ls_stored_prototype-tag = zcl_qjs_value=>tag_object.
        TRY.
            mo_prototype_object ?= ls_stored_prototype-object_ref.
          CATCH cx_sy_move_cast_error.
            CLEAR mo_prototype_object.
        ENDTRY.
      ELSE.
        CLEAR mo_prototype_object.
      ENDIF.
    ENDIF.
  ENDMETHOD.
  METHOD delete_property.
    IF mo_properties IS BOUND.
      result = mo_properties->delete( name ).
      IF result = abap_true AND name = 'prototype'.
        CLEAR mo_prototype_object.
      ENDIF.
    ELSE.
      result = abap_true.
    ENDIF.
  ENDMETHOD.
  METHOD has_property.
    IF mo_properties IS BOUND AND mo_properties->has_property( name ) = abap_true.
      result = abap_true.
      RETURN.
    ENDIF.
    IF ms_base_constructor-tag = zcl_qjs_value=>tag_object.
      DATA lo_base_closure TYPE REF TO zcl_qjs_closure.
      DATA lo_base_native TYPE REF TO zcl_qjs_native_function.
      TRY.
          lo_base_closure ?= ms_base_constructor-object_ref.
        CATCH cx_sy_move_cast_error.
      ENDTRY.
      IF lo_base_closure IS BOUND.
        result = lo_base_closure->has_property( name ).
        RETURN.
      ENDIF.
      TRY.
          lo_base_native ?= ms_base_constructor-object_ref.
        CATCH cx_sy_move_cast_error.
      ENDTRY.
      IF lo_base_native IS BOUND.
        result = lo_base_native->has_property( name ).
      ENDIF.
    ENDIF.
  ENDMETHOD.
  METHOD get_symbol_property.
    result = get_symbol_with_receiver(
      identity = identity receiver = zcl_qjs_value=>new_object( me ) ).
  ENDMETHOD.
  METHOD get_symbol_with_receiver.
    IF mo_properties IS BOUND AND mo_properties->has_own_symbol( identity ) = abap_true.
      result = mo_properties->reflect_get_symbol(
        identity = identity receiver = receiver ).
      RETURN.
    ENDIF.
    IF ms_base_constructor-tag = zcl_qjs_value=>tag_object.
      DATA lo_symbol_base_closure TYPE REF TO zcl_qjs_closure.
      DATA lo_symbol_base_native TYPE REF TO zcl_qjs_native_function.
      TRY.
          lo_symbol_base_closure ?= ms_base_constructor-object_ref.
        CATCH cx_sy_move_cast_error.
      ENDTRY.
      IF lo_symbol_base_closure IS BOUND.
        result = lo_symbol_base_closure->get_symbol_with_receiver(
          identity = identity receiver = receiver ).
        RETURN.
      ENDIF.
      TRY.
          lo_symbol_base_native ?= ms_base_constructor-object_ref.
        CATCH cx_sy_move_cast_error.
      ENDTRY.
      IF lo_symbol_base_native IS BOUND.
        result = lo_symbol_base_native->get_symbol_with_receiver(
          identity = identity receiver = receiver ).
        RETURN.
      ENDIF.
    ENDIF.
    IF mo_properties IS BOUND.
      result = mo_properties->reflect_get_symbol(
        identity = identity receiver = receiver ).
    ELSE.
      result = zcl_qjs_value=>new_undefined( ).
    ENDIF.
  ENDMETHOD.
  METHOD set_symbol_property.
    IF mo_properties IS BOUND.
      mo_properties->set_symbol( identity = identity value = value ).
    ENDIF.
  ENDMETHOD.
  METHOD delete_symbol_property.
    IF mo_properties IS BOUND.
      result = mo_properties->delete_symbol( identity ).
    ELSE.
      result = abap_true.
    ENDIF.
  ENDMETHOD.
  METHOD has_symbol_property.
    IF mo_properties IS BOUND
        AND mo_properties->has_symbol_property( identity ) = abap_true.
      result = abap_true.
      RETURN.
    ENDIF.
    IF ms_base_constructor-tag = zcl_qjs_value=>tag_object.
      DATA lo_has_symbol_closure TYPE REF TO zcl_qjs_closure.
      DATA lo_has_symbol_native TYPE REF TO zcl_qjs_native_function.
      TRY.
          lo_has_symbol_closure ?= ms_base_constructor-object_ref.
        CATCH cx_sy_move_cast_error.
      ENDTRY.
      IF lo_has_symbol_closure IS BOUND.
        result = lo_has_symbol_closure->has_symbol_property( identity ).
        RETURN.
      ENDIF.
      TRY.
          lo_has_symbol_native ?= ms_base_constructor-object_ref.
        CATCH cx_sy_move_cast_error.
      ENDTRY.
      IF lo_has_symbol_native IS BOUND.
        result = lo_has_symbol_native->has_symbol_property( identity ).
      ENDIF.
    ENDIF.
  ENDMETHOD.
  METHOD get_prototype_object.
    result = mo_prototype_object.
  ENDMETHOD.
  METHOD get_property_storage.
    result = mo_properties.
  ENDMETHOD.
  METHOD register_instance_field.
    IF mt_instance_fields IS NOT BOUND.
      CREATE DATA mt_instance_fields.
    ENDIF.
    DATA ls_field TYPE ty_instance_field.
    ls_field-key = key.
    ls_field-initializer = initializer.
    ls_field-private = private.
    APPEND ls_field TO mt_instance_fields->*.
  ENDMETHOD.
  METHOD register_private_method.
    IF mt_instance_fields IS NOT BOUND.
      CREATE DATA mt_instance_fields.
    ENDIF.
    DATA ls_field TYPE ty_instance_field.
    ls_field-key = key.
    ls_field-private = abap_true.
    ls_field-direct = abap_true.
    ls_field-value = value.
    APPEND ls_field TO mt_instance_fields->*.
  ENDMETHOD.
  METHOD register_private_accessor.
    IF mt_instance_fields IS NOT BOUND.
      CREATE DATA mt_instance_fields.
    ENDIF.
    DATA ls_field TYPE ty_instance_field.
    ls_field-key = key.
    ls_field-private = abap_true.
    ls_field-direct = abap_true.
    ls_field-value = value.
    ls_field-accessor_kind = kind.
    APPEND ls_field TO mt_instance_fields->*.
  ENDMETHOD.
  METHOD set_base_constructor.
    ms_base_constructor = base.
  ENDMETHOD.
  METHOD invoke_default_derived.
    IF ms_base_constructor-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Derived class has no base constructor'.
    ENDIF.
    DATA lo_self_ref TYPE REF TO object.
    lo_self_ref = me.
    result = mo_runtime->construct_value(
      constructor = ms_base_constructor
      new_target  = zcl_qjs_value=>new_object( lo_self_ref )
      arguments   = arguments ).
    initialize_instance_fields( receiver = result ).
  ENDMETHOD.
  METHOD initialize_instance_fields.
    DATA lo_receiver TYPE REF TO zcl_qjs_object.
    DATA lv_private_added TYPE abap_bool.
    IF receiver-tag <> zcl_qjs_value=>tag_object.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Class field receiver is not an object'.
    ENDIF.
    TRY.
        lo_receiver ?= receiver-object_ref.
      CATCH cx_sy_move_cast_error.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Class field receiver is not ordinary'.
    ENDTRY.
    IF mt_instance_fields IS NOT BOUND.
      RETURN.
    ENDIF.
    LOOP AT mt_instance_fields->* INTO DATA(ls_field).
      DATA(ls_value) = ls_field-value.
      IF ls_field-direct = abap_false.
        ls_value = ls_field-initializer->invoke( this_value = receiver ).
      ENDIF.
      IF ls_field-private = abap_true.
        IF ls_field-accessor_kind = 1.
          lv_private_added = lo_receiver->add_private_accessor(
            identity = ls_field-key-int_value getter = ls_value
            setter = zcl_qjs_value=>new_undefined( ) ).
        ELSEIF ls_field-accessor_kind = 2.
          lv_private_added = lo_receiver->add_private_accessor(
            identity = ls_field-key-int_value
            getter = zcl_qjs_value=>new_undefined( ) setter = ls_value ).
        ELSE.
          lv_private_added = lo_receiver->add_private_field(
            identity = ls_field-key-int_value value = ls_value
            writable = xsdbool( ls_field-direct = abap_false ) ).
        ENDIF.
        IF lv_private_added = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: private field already exists'.
        ENDIF.
      ELSEIF ls_field-key-tag = zcl_qjs_value=>tag_symbol.
        lo_receiver->define_symbol_property(
          identity = ls_field-key-int_value value = ls_value writable = abap_true
          enumerable = abap_true configurable = abap_true ).
      ELSE.
        lo_receiver->define_property(
          name = zcl_qjs_value=>to_string( ls_field-key ) value = ls_value
          writable = abap_true enumerable = abap_true configurable = abap_true ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
  METHOD invoke.
    DATA lo_vm TYPE REF TO zcl_qjs_vm.
    DATA lo_limits TYPE REF TO zcl_qjs_limits.
    IF mo_function->is_class_constructor( ) = abap_true
        AND class_call = abap_false.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: class constructor cannot be called without new'.
    ENDIF.
    IF mo_runtime IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Closure has no active runtime'.
    ENDIF.
    IF mo_function->is_async( ) = abap_true
        AND mo_function->is_generator( ) = abap_true.
      result = zcl_qjs_value=>new_object(
        mo_runtime->create_async_generator(
          closure = me this_value = this_value arguments = arguments ) ).
      RETURN.
    ENDIF.
    IF mo_function->is_async( ) = abap_true.
      DATA(lo_async_task) = NEW zcl_qjs_async_task(
        runtime = mo_runtime closure = me this_value = this_value
        arguments = arguments ).
      result = lo_async_task->start( ).
      RETURN.
    ENDIF.
    IF mo_function->is_generator( ) = abap_true.
      result = zcl_qjs_value=>new_object(
        mo_runtime->create_generator(
          closure = me this_value = this_value arguments = arguments ) ).
      RETURN.
    ENDIF.
    lo_limits = mo_runtime->get_limits( ).
    lo_limits->enter_nested_frame( ).
    TRY.
        CREATE OBJECT lo_vm
          EXPORTING runtime = mo_runtime limits = lo_limits.
        result = lo_vm->execute(
          function = mo_function initial_closure = me initial_this = this_value
          initial_arguments = arguments initial_constructor = class_call ).
      CLEANUP.
        lo_limits->leave_nested_frame( ).
    ENDTRY.
    lo_limits->leave_nested_frame( ).
  ENDMETHOD.

  METHOD construct.
    result = construct_with_prototype(
      arguments = arguments prototype = mo_prototype_object ).
  ENDMETHOD.

  METHOD construct_with_prototype.
    IF mo_function->is_constructible( ) = abap_false.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: value is not constructable'.
    ENDIF.
    IF mo_function->is_default_derived_constructor( ) = abap_true.
      result = invoke_default_derived(
        receiver = zcl_qjs_value=>new_undefined( ) arguments = arguments ).
      IF result-tag = zcl_qjs_value=>tag_object.
        DATA lo_derived_object TYPE REF TO zcl_qjs_object.
        TRY.
            lo_derived_object ?= result-object_ref.
          CATCH cx_sy_move_cast_error.
        ENDTRY.
        IF lo_derived_object IS BOUND.
          lo_derived_object->set_prototype( prototype ).
        ENDIF.
      ENDIF.
      RETURN.
    ENDIF.
    DATA(lo_object) = mo_runtime->create_object( prototype = prototype ).
    DATA(ls_this) = zcl_qjs_value=>new_object( lo_object ).
    IF mo_function->is_class_constructor( ) = abap_true
        AND mo_function->is_derived_class( ) = abap_false.
      initialize_instance_fields( receiver = ls_this ).
    ENDIF.
    DATA(ls_returned) = invoke(
      this_value = ls_this arguments = arguments class_call = abap_true ).
    IF ls_returned-tag = zcl_qjs_value=>tag_object.
      result = ls_returned.
    ELSE.
      result = ls_this.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
