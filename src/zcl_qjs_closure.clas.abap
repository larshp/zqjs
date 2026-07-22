CLASS zcl_qjs_closure DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES ty_cells TYPE STANDARD TABLE OF REF TO zcl_qjs_cell WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_instance_field,
      key TYPE zcl_qjs_value=>ty_value,
      initializer TYPE REF TO zcl_qjs_closure,
      private TYPE abap_bool,
      direct TYPE abap_bool,
      value TYPE zcl_qjs_value=>ty_value,
      accessor_kind TYPE i,
    END OF ty_instance_field.
    TYPES ty_instance_fields TYPE STANDARD TABLE OF ty_instance_field
      WITH DEFAULT KEY.
    METHODS constructor
      IMPORTING function TYPE REF TO zcl_qjs_function captures TYPE ty_cells OPTIONAL
        properties TYPE REF TO zcl_qjs_object OPTIONAL
        prototype_object TYPE REF TO zcl_qjs_object OPTIONAL
        runtime TYPE REF TO zcl_qjs_runtime OPTIONAL
      RAISING zcx_qjs_error.
    METHODS get_function RETURNING VALUE(result) TYPE REF TO zcl_qjs_function.
    METHODS get_captures RETURNING VALUE(result) TYPE ty_cells.
    METHODS get_property
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS set_property IMPORTING name TYPE string value TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS delete_property
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_property
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS get_symbol_property
      IMPORTING identity TYPE int8
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS set_symbol_property
      IMPORTING identity TYPE int8 value TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS delete_symbol_property
      IMPORTING identity TYPE int8
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_symbol_property
      IMPORTING identity TYPE int8
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS get_prototype_object RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS get_property_storage RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS register_instance_field
      IMPORTING key TYPE zcl_qjs_value=>ty_value
        initializer TYPE REF TO zcl_qjs_closure
        private TYPE abap_bool DEFAULT abap_false.
    METHODS register_private_method
      IMPORTING key TYPE zcl_qjs_value=>ty_value
        value TYPE zcl_qjs_value=>ty_value.
    METHODS register_private_accessor
      IMPORTING key TYPE zcl_qjs_value=>ty_value
        value TYPE zcl_qjs_value=>ty_value kind TYPE i.
    METHODS set_base_class IMPORTING base TYPE REF TO zcl_qjs_closure.
    METHODS invoke_default_derived
      IMPORTING receiver TYPE zcl_qjs_value=>ty_value
        arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
      RAISING zcx_qjs_error.
    METHODS initialize_instance_fields
      IMPORTING receiver TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS invoke
      IMPORTING this_value TYPE zcl_qjs_value=>ty_value
        arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
        class_call TYPE abap_bool DEFAULT abap_false
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS construct
      IMPORTING arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS construct_with_prototype
      IMPORTING arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
        prototype TYPE REF TO zcl_qjs_object OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
  PRIVATE SECTION.
    DATA mo_function TYPE REF TO zcl_qjs_function.
    DATA mt_captures TYPE ty_cells.
    DATA mo_properties TYPE REF TO zcl_qjs_object.
    DATA mo_prototype_object TYPE REF TO zcl_qjs_object.
    DATA mo_runtime TYPE REF TO zcl_qjs_runtime.
    DATA mt_instance_fields TYPE ty_instance_fields.
    DATA mo_base_class TYPE REF TO zcl_qjs_closure.
ENDCLASS.

CLASS zcl_qjs_closure IMPLEMENTATION.
  METHOD constructor.
    DATA lv_constructor_property TYPE string VALUE 'constructor'.
    mo_function = function.
    mt_captures = captures.
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
    result = mt_captures.
  ENDMETHOD.
  METHOD get_property.
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
    IF mo_properties IS BOUND.
      result = mo_properties->has_property( name ).
    ENDIF.
  ENDMETHOD.
  METHOD get_symbol_property.
    IF mo_properties IS BOUND.
      result = mo_properties->get_symbol( identity ).
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
    IF mo_properties IS BOUND.
      result = mo_properties->has_symbol_property( identity ).
    ENDIF.
  ENDMETHOD.
  METHOD get_prototype_object.
    result = mo_prototype_object.
  ENDMETHOD.
  METHOD get_property_storage.
    result = mo_properties.
  ENDMETHOD.
  METHOD register_instance_field.
    DATA ls_field TYPE ty_instance_field.
    ls_field-key = key.
    ls_field-initializer = initializer.
    ls_field-private = private.
    APPEND ls_field TO mt_instance_fields.
  ENDMETHOD.
  METHOD register_private_method.
    DATA ls_field TYPE ty_instance_field.
    ls_field-key = key.
    ls_field-private = abap_true.
    ls_field-direct = abap_true.
    ls_field-value = value.
    APPEND ls_field TO mt_instance_fields.
  ENDMETHOD.
  METHOD register_private_accessor.
    DATA ls_field TYPE ty_instance_field.
    ls_field-key = key.
    ls_field-private = abap_true.
    ls_field-direct = abap_true.
    ls_field-value = value.
    ls_field-accessor_kind = kind.
    APPEND ls_field TO mt_instance_fields.
  ENDMETHOD.
  METHOD set_base_class.
    mo_base_class = base.
  ENDMETHOD.
  METHOD invoke_default_derived.
    IF mo_base_class IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Derived class has no base constructor'.
    ENDIF.
    IF mo_base_class->get_function( )->is_default_derived_constructor( ) = abap_true.
      mo_base_class->invoke_default_derived(
        receiver = receiver arguments = arguments ).
    ELSE.
      IF mo_base_class->get_function( )->is_derived_class( ) = abap_false.
        mo_base_class->initialize_instance_fields( receiver = receiver ).
      ENDIF.
      mo_base_class->invoke(
        this_value = receiver arguments = arguments class_call = abap_true ).
    ENDIF.
    initialize_instance_fields( receiver = receiver ).
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
    LOOP AT mt_instance_fields INTO DATA(ls_field).
      DATA(ls_value) = ls_field-value.
      IF ls_field-direct = abap_false.
        ls_value = ls_field-initializer->invoke( this_value = receiver ).
      ENDIF.
      IF ls_field-private = abap_true.
        IF ls_field-accessor_kind = 1.
          lv_private_added = lo_receiver->add_private_accessor(
            identity = ls_field-key-symbol_id getter = ls_value
            setter = zcl_qjs_value=>new_undefined( ) ).
        ELSEIF ls_field-accessor_kind = 2.
          lv_private_added = lo_receiver->add_private_accessor(
            identity = ls_field-key-symbol_id
            getter = zcl_qjs_value=>new_undefined( ) setter = ls_value ).
        ELSE.
          lv_private_added = lo_receiver->add_private_field(
            identity = ls_field-key-symbol_id value = ls_value
            writable = xsdbool( ls_field-direct = abap_false ) ).
        ENDIF.
        IF lv_private_added = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: private field already exists'.
        ENDIF.
      ELSEIF ls_field-key-tag = zcl_qjs_value=>tag_symbol.
        lo_receiver->define_symbol_property(
          identity = ls_field-key-symbol_id value = ls_value writable = abap_true
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
          initial_arguments = arguments ).
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
    DATA(lo_object) = mo_runtime->create_object( prototype = prototype ).
    DATA(ls_this) = zcl_qjs_value=>new_object( lo_object ).
    DATA(ls_returned) = invoke(
      this_value = ls_this arguments = arguments class_call = abap_true ).
    IF ls_returned-tag = zcl_qjs_value=>tag_object.
      result = ls_returned.
    ELSE.
      result = ls_this.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
