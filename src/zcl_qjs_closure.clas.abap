CLASS zcl_qjs_closure DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES ty_cells TYPE STANDARD TABLE OF REF TO zcl_qjs_cell WITH DEFAULT KEY.
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
    METHODS get_prototype_object RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS invoke
      IMPORTING this_value TYPE zcl_qjs_value=>ty_value
        arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS construct
      IMPORTING arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
  PRIVATE SECTION.
    DATA mo_function TYPE REF TO zcl_qjs_function.
    DATA mt_captures TYPE ty_cells.
    DATA mo_properties TYPE REF TO zcl_qjs_object.
    DATA mo_prototype_object TYPE REF TO zcl_qjs_object.
    DATA mo_runtime TYPE REF TO zcl_qjs_runtime.
ENDCLASS.

CLASS zcl_qjs_closure IMPLEMENTATION.
  METHOD constructor.
    DATA lv_constructor_property TYPE string VALUE 'constructor'.
    mo_function = function.
    mt_captures = captures.
    mo_properties = properties.
    mo_prototype_object = prototype_object.
    mo_runtime = runtime.
    IF mo_properties IS BOUND AND mo_prototype_object IS BOUND.
      mo_properties->define_property(
        name = 'prototype' value = zcl_qjs_value=>new_object( mo_prototype_object )
        writable = abap_true enumerable = abap_false configurable = abap_false ).
      mo_properties->define_property(
        name = 'length' value = zcl_qjs_value=>new_int(
          mo_function->get_parameter_count( ) )
        writable = abap_false enumerable = abap_false configurable = abap_true ).
      mo_properties->define_property(
        name = 'name' value = zcl_qjs_value=>new_string( mo_function->get_name( ) )
        writable = abap_false enumerable = abap_false configurable = abap_true ).
      mo_prototype_object->define_property(
        name = lv_constructor_property value = zcl_qjs_value=>new_object( me )
        writable = abap_true enumerable = abap_false configurable = abap_true ).
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
      IF value-tag = zcl_qjs_value=>tag_object.
        TRY.
            mo_prototype_object ?= value-object_ref.
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
    ELSE.
      result = abap_true.
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
  METHOD get_prototype_object.
    result = mo_prototype_object.
  ENDMETHOD.
  METHOD invoke.
    DATA lo_vm TYPE REF TO zcl_qjs_vm.
    DATA lo_limits TYPE REF TO zcl_qjs_limits.
    IF mo_runtime IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Closure has no active runtime'.
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
    DATA(lo_object) = mo_runtime->create_object( prototype = mo_prototype_object ).
    DATA(ls_this) = zcl_qjs_value=>new_object( lo_object ).
    DATA(ls_returned) = invoke(
      this_value = ls_this arguments = arguments ).
    IF ls_returned-tag = zcl_qjs_value=>tag_object.
      result = ls_returned.
    ELSE.
      result = ls_this.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
