CLASS zcl_qjs_limits DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_step_state,
      maximum TYPE int8,
      used TYPE int8,
    END OF ty_step_state.
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
    METHODS step_state_reference
      RETURNING VALUE(result) TYPE REF TO ty_step_state.
    METHODS has_cancellation RETURNING VALUE(result) TYPE abap_bool.

    METHODS check_operand_stack IMPORTING current TYPE i RAISING zcx_qjs_error.
    METHODS check_frame_stack IMPORTING current TYPE i RAISING zcx_qjs_error.
    METHODS enter_nested_frame RAISING zcx_qjs_error.
    METHODS leave_nested_frame.
    METHODS check_parser_depth IMPORTING current TYPE i RAISING zcx_qjs_error.
    METHODS check_source_length IMPORTING current TYPE i RAISING zcx_qjs_error.
    METHODS check_bytecode_length IMPORTING current TYPE i RAISING zcx_qjs_error.

  PRIVATE SECTION.
    DATA ms_step_state TYPE ty_step_state.
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
    ms_step_state-maximum = max_steps.
    ms_step_state-used = 0.
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
    IF ms_step_state-used > ms_step_state-maximum - amount.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING
          reason = 'JavaScript instruction budget exhausted'.
    ENDIF.
    ms_step_state-used = ms_step_state-used + amount.
  ENDMETHOD.

  METHOD reset.
    ms_step_state-used = 0.
    mv_nested_frames = 0.
  ENDMETHOD.

  METHOD used_steps.
    result = ms_step_state-used.
  ENDMETHOD.

  METHOD remaining_steps.
    result = ms_step_state-maximum - ms_step_state-used.
  ENDMETHOD.

  METHOD step_state_reference.
    GET REFERENCE OF ms_step_state INTO result.
  ENDMETHOD.

  METHOD has_cancellation.
    result = xsdbool( mo_cancellation IS BOUND ).
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
