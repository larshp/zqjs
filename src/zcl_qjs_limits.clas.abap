CLASS zcl_qjs_limits DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        max_steps           TYPE int8 DEFAULT 100000
        max_operand_stack   TYPE i DEFAULT 4096
        max_frames          TYPE i DEFAULT 256
        max_parser_depth    TYPE i DEFAULT 256
        max_source_length   TYPE i DEFAULT 1048576
        max_bytecode_length TYPE i DEFAULT 1048576
        cancellation TYPE REF TO zif_qjs_cancellation OPTIONAL
      RAISING
        zcx_qjs_error.

    METHODS consume
      IMPORTING
        amount TYPE int8 DEFAULT 1
      RAISING
        zcx_qjs_error.

    METHODS reset.

    METHODS used_steps
      RETURNING
        VALUE(result) TYPE int8.

    METHODS remaining_steps
      RETURNING
        VALUE(result) TYPE int8.

    METHODS check_operand_stack IMPORTING current TYPE i RAISING zcx_qjs_error.
    METHODS check_frame_stack IMPORTING current TYPE i RAISING zcx_qjs_error.
    METHODS enter_nested_frame RAISING zcx_qjs_error.
    METHODS leave_nested_frame.
    METHODS check_parser_depth IMPORTING current TYPE i RAISING zcx_qjs_error.
    METHODS check_source_length IMPORTING current TYPE i RAISING zcx_qjs_error.
    METHODS check_bytecode_length IMPORTING current TYPE i RAISING zcx_qjs_error.

  PRIVATE SECTION.
    DATA mv_max_steps TYPE int8.
    DATA mv_used_steps TYPE int8.
    DATA mv_max_operand_stack TYPE i.
    DATA mv_max_frames TYPE i.
    DATA mv_nested_frames TYPE i.
    DATA mv_max_parser_depth TYPE i.
    DATA mv_max_source_length TYPE i.
    DATA mv_max_bytecode_length TYPE i.
    DATA mo_cancellation TYPE REF TO zif_qjs_cancellation.
ENDCLASS.

CLASS zcl_qjs_limits IMPLEMENTATION.
  METHOD constructor.
    IF max_steps <= 0 OR max_operand_stack <= 0 OR max_frames <= 0
        OR max_parser_depth <= 0 OR max_source_length <= 0
        OR max_bytecode_length <= 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING
          reason = 'JavaScript limits must be positive'.
    ENDIF.
    mv_max_steps = max_steps.
    mv_used_steps = 0.
    mv_max_operand_stack = max_operand_stack.
    mv_max_frames = max_frames.
    mv_max_parser_depth = max_parser_depth.
    mv_max_source_length = max_source_length.
    mv_max_bytecode_length = max_bytecode_length.
    mo_cancellation = cancellation.
  ENDMETHOD.

  METHOD consume.
    IF mo_cancellation IS BOUND
        AND mo_cancellation->is_cancelled( ) = abap_true.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'JavaScript execution cancelled'.
    ENDIF.
    IF amount < 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING
          reason = 'Consumed step count cannot be negative'.
    ENDIF.
    IF mv_used_steps > mv_max_steps - amount.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING
          reason = 'JavaScript instruction budget exhausted'.
    ENDIF.
    mv_used_steps = mv_used_steps + amount.
  ENDMETHOD.

  METHOD reset.
    mv_used_steps = 0.
    mv_nested_frames = 0.
  ENDMETHOD.

  METHOD used_steps.
    result = mv_used_steps.
  ENDMETHOD.

  METHOD remaining_steps.
    result = mv_max_steps - mv_used_steps.
  ENDMETHOD.

  METHOD check_operand_stack.
    IF current > mv_max_operand_stack.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'JavaScript operand stack budget exhausted'.
    ENDIF.
  ENDMETHOD.

  METHOD check_frame_stack.
    IF current + mv_nested_frames > mv_max_frames.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'JavaScript frame budget exhausted'.
    ENDIF.
  ENDMETHOD.

  METHOD enter_nested_frame.
    mv_nested_frames = mv_nested_frames + 1.
    IF mv_nested_frames >= mv_max_frames.
      mv_nested_frames = mv_nested_frames - 1.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'JavaScript frame budget exhausted'.
    ENDIF.
  ENDMETHOD.

  METHOD leave_nested_frame.
    IF mv_nested_frames > 0.
      mv_nested_frames = mv_nested_frames - 1.
    ENDIF.
  ENDMETHOD.

  METHOD check_parser_depth.
    IF current > mv_max_parser_depth.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'JavaScript parser depth budget exhausted'.
    ENDIF.
  ENDMETHOD.

  METHOD check_source_length.
    IF current > mv_max_source_length.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'JavaScript source size budget exhausted'.
    ENDIF.
  ENDMETHOD.

  METHOD check_bytecode_length.
    IF current > mv_max_bytecode_length.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'JavaScript bytecode size budget exhausted'.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
