CLASS zcl_qjs_frame DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES ty_cells TYPE STANDARD TABLE OF REF TO zcl_qjs_cell WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_handler,
      target         TYPE i,
      finally_target TYPE i,
      stack_depth    TYPE i,
      END OF ty_handler.
    TYPES ty_handlers TYPE STANDARD TABLE OF ty_handler WITH DEFAULT KEY.
    TYPES ty_return_addresses TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    DATA function TYPE REF TO zcl_qjs_function.
    DATA code TYPE REF TO zcl_qjs_function=>ty_code.
    DATA pc TYPE i.
    DATA locals TYPE ty_cells.
    DATA captures TYPE REF TO zcl_qjs_closure=>ty_cells.
    DATA arguments TYPE zif_qjs_callable=>ty_arguments.
    DATA handlers TYPE REF TO ty_handlers.
    DATA stack_base TYPE i.
    DATA subroutine_returns TYPE REF TO ty_return_addresses.
    DATA is_constructor TYPE abap_bool.
    DATA constructor_this TYPE zcl_qjs_value=>ty_value.
    DATA closure TYPE REF TO zcl_qjs_closure.
    DATA after_return_fields TYPE REF TO zcl_qjs_closure.
    DATA after_return_receiver TYPE zcl_qjs_value=>ty_value.
    DATA abrupt_kind TYPE i.
    DATA abrupt_value TYPE zcl_qjs_value=>ty_value.
ENDCLASS.

CLASS zcl_qjs_frame IMPLEMENTATION.
ENDCLASS.
