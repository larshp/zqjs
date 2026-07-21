CLASS zcl_qjs_closure DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES ty_cells TYPE STANDARD TABLE OF REF TO zcl_qjs_cell WITH DEFAULT KEY.
    METHODS constructor
      IMPORTING function TYPE REF TO zcl_qjs_function captures TYPE ty_cells OPTIONAL
        properties TYPE REF TO zcl_qjs_object OPTIONAL
        prototype_object TYPE REF TO zcl_qjs_object OPTIONAL
        runtime TYPE REF TO zcl_qjs_runtime OPTIONAL.
    METHODS get_function RETURNING VALUE(result) TYPE REF TO zcl_qjs_function.
    METHODS get_captures RETURNING VALUE(result) TYPE ty_cells.
    METHODS get_property
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS set_property IMPORTING name TYPE string value TYPE zcl_qjs_value=>ty_value.
    METHODS delete_property
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS get_prototype_object RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS invoke
      IMPORTING this_value TYPE zcl_qjs_value=>ty_value
        arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
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
    mo_function = function.
    mt_captures = captures.
    mo_properties = properties.
    mo_prototype_object = prototype_object.
    mo_runtime = runtime.
    IF mo_properties IS BOUND AND mo_prototype_object IS BOUND.
      mo_properties->set(
        name = 'prototype' value = zcl_qjs_value=>new_object( mo_prototype_object ) ).
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
    IF name = 'prototype' AND value-tag = zcl_qjs_value=>tag_object.
      TRY.
          mo_prototype_object ?= value-object_ref.
        CATCH cx_sy_move_cast_error.
          CLEAR mo_prototype_object.
      ENDTRY.
    ENDIF.
  ENDMETHOD.
  METHOD delete_property.
    IF mo_properties IS BOUND.
      result = mo_properties->delete( name ).
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
ENDCLASS.
