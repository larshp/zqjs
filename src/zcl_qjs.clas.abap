CLASS zcl_qjs DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS eval
      IMPORTING
        source         TYPE string
        max_steps      TYPE int8 DEFAULT 100000
        max_objects    TYPE i DEFAULT 10000
        max_frames     TYPE i DEFAULT 256
        max_operand_stack TYPE i DEFAULT 4096
      RETURNING
        VALUE(result)  TYPE zcl_qjs_value=>ty_value
      RAISING
        zcx_qjs_error.

    CLASS-METHODS compile
      IMPORTING
        source         TYPE string
      RETURNING
        VALUE(result)  TYPE REF TO zcl_qjs_function
      RAISING
        zcx_qjs_error.
ENDCLASS.

CLASS zcl_qjs IMPLEMENTATION.
  METHOD compile.
    DATA lo_parser TYPE REF TO zcl_qjs_parser.
    CREATE OBJECT lo_parser
      EXPORTING
        source = source.
    result = lo_parser->compile( ).
  ENDMETHOD.

  METHOD eval.
    DATA lo_function TYPE REF TO zcl_qjs_function.
    DATA lo_limits TYPE REF TO zcl_qjs_limits.
    DATA lo_vm TYPE REF TO zcl_qjs_vm.
    DATA lo_parser TYPE REF TO zcl_qjs_parser.
    DATA lo_runtime TYPE REF TO zcl_qjs_runtime.
    DATA lo_context TYPE REF TO zcl_qjs_context.
    CREATE OBJECT lo_runtime
      EXPORTING
        max_steps = max_steps max_objects = max_objects max_frames = max_frames
        max_operand_stack = max_operand_stack.
    CREATE OBJECT lo_context EXPORTING runtime = lo_runtime.
    result = lo_context->eval( source ).
  ENDMETHOD.
ENDCLASS.
