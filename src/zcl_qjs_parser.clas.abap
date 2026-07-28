CLASS zcl_qjs_parser DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES ty_global_names TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_global_binding,
      name    TYPE string,
      index   TYPE i,
      lexical TYPE abap_bool,
      END OF ty_global_binding.
    TYPES ty_global_bindings TYPE STANDARD TABLE OF ty_global_binding WITH DEFAULT KEY.
    METHODS constructor
      IMPORTING
        source       TYPE string
        limits       TYPE REF TO zcl_qjs_limits OPTIONAL
        global_names TYPE ty_global_names OPTIONAL
      RAISING
        zcx_qjs_error.

    METHODS compile
      RETURNING
        VALUE(result) TYPE REF TO zcl_qjs_function
      RAISING
        zcx_qjs_error.
    METHODS get_global_bindings RETURNING VALUE(result) TYPE ty_global_bindings.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_local,
      name           TYPE string,
      function_depth TYPE i,
      index          TYPE i,
      kind           TYPE i,
      lexical        TYPE abap_bool,
      constant       TYPE abap_bool,
      END OF ty_local.
    TYPES ty_locals TYPE HASHED TABLE OF ty_local WITH UNIQUE KEY name.
    TYPES ty_function_locals TYPE HASHED TABLE OF ty_local
      WITH UNIQUE KEY name function_depth.
    TYPES ty_jump_indices TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_loop,
      continue_target   TYPE i,
      has_iterator      TYPE abap_bool,
      exception_handler TYPE abap_bool,
      async_iterator    TYPE abap_bool,
      iterator_local    TYPE i,
      break_jumps       TYPE ty_jump_indices,
      continue_jumps    TYPE ty_jump_indices,
      END OF ty_loop.
    TYPES ty_loops TYPE STANDARD TABLE OF ty_loop WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_finally,
      calls          TYPE ty_jump_indices,
      suppress_throw TYPE abap_bool,
      loop_depth     TYPE i,
      END OF ty_finally.
    TYPES ty_finally_stack TYPE STANDARD TABLE OF ty_finally WITH DEFAULT KEY.
    TYPES ty_scopes TYPE STANDARD TABLE OF ty_locals WITH DEFAULT KEY.
    TYPES ty_capture_names TYPE HASHED TABLE OF string WITH UNIQUE KEY table_line.
    TYPES: BEGIN OF ty_hoist,
      name             TYPE string,
      make_instruction TYPE i,
      put_instruction  TYPE i,
      END OF ty_hoist.
    TYPES ty_hoists TYPE HASHED TABLE OF ty_hoist WITH UNIQUE KEY name.
    TYPES: BEGIN OF ty_class_method,
      name            TYPE string,
      local_index     TYPE i,
      constructor     TYPE abap_bool,
      static          TYPE abap_bool,
      accessor_kind   TYPE i,
      computed        TYPE abap_bool,
      key_local_index TYPE i,
      field           TYPE abap_bool,
      static_block    TYPE abap_bool,
      private         TYPE abap_bool,
      generator       TYPE abap_bool,
      async           TYPE abap_bool,
      initializer     TYPE REF TO zcl_qjs_function,
      END OF ty_class_method.
    TYPES ty_class_methods TYPE STANDARD TABLE OF ty_class_method WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_private_declaration,
      name   TYPE string,
      static TYPE abap_bool,
      kind   TYPE i,
      END OF ty_private_declaration.
    TYPES ty_private_declarations TYPE HASHED TABLE OF ty_private_declaration
      WITH UNIQUE KEY name.
    DATA mo_lexer TYPE REF TO zcl_qjs_lexer.
    DATA mo_emitter TYPE REF TO zcl_qjs_emitter.
    DATA ms_token TYPE zcl_qjs_lexer=>ty_token.
    DATA mo_limits TYPE REF TO zcl_qjs_limits.
    DATA mv_parser_depth TYPE i.
    DATA mv_checked_parser_depth TYPE i.
    DATA mt_locals TYPE ty_function_locals.
    DATA mt_parent_locals TYPE ty_locals.
    DATA mr_outer_parent_locals TYPE REF TO ty_locals.
    DATA mr_outer_scopes TYPE REF TO ty_scopes.
    DATA mv_function_depth TYPE i.
    DATA mt_loops TYPE ty_loops.
    DATA mv_in_function TYPE abap_bool.
    DATA mv_source TYPE string.
    DATA mt_finally TYPE ty_finally_stack.
    DATA mt_scopes TYPE ty_scopes.
    DATA mt_capture_names TYPE ty_capture_names.
    DATA mv_capture_filter_ready TYPE abap_bool.
    DATA mt_hoists TYPE ty_hoists.
    DATA ms_super_binding TYPE ty_local.
    DATA mv_has_super TYPE abap_bool.
    DATA mv_super_static TYPE abap_bool.
    DATA mv_super_object_method TYPE abap_bool.
    DATA mv_super_call_allowed TYPE abap_bool.
    DATA mv_factor_method_call TYPE abap_bool.
    DATA mv_factor_super_call TYPE abap_bool.
    DATA mv_parsing_class_method TYPE abap_bool.
    DATA mv_parsing_class_constructor TYPE abap_bool.
    DATA mv_parsing_generator_method TYPE abap_bool.
    DATA mv_parsing_async_function TYPE abap_bool.
    DATA mv_in_generator TYPE abap_bool.
    DATA mv_in_async TYPE abap_bool.
    DATA mo_last_function TYPE REF TO zcl_qjs_function.

    METHODS advance
      RAISING
        zcx_qjs_error.

    METHODS parse_expression
      RAISING
        zcx_qjs_error.
    METHODS parse_assignment RAISING zcx_qjs_error.
    METHODS parse_yield RAISING zcx_qjs_error.
    METHODS is_arrow_function_start RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS parse_arrow_function RAISING zcx_qjs_error.
    METHODS is_async_function_start RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS is_pattern_assignment
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS parse_pattern_assignment RAISING zcx_qjs_error.
    METHODS parse_conditional RAISING zcx_qjs_error.

    METHODS parse_logical_or RAISING zcx_qjs_error.
    METHODS parse_logical_and RAISING zcx_qjs_error.
    METHODS parse_bitwise_or RAISING zcx_qjs_error.
    METHODS parse_bitwise_xor RAISING zcx_qjs_error.
    METHODS parse_bitwise_and RAISING zcx_qjs_error.
    METHODS parse_equality RAISING zcx_qjs_error.
    METHODS parse_comparison RAISING zcx_qjs_error.

    METHODS parse_additive RAISING zcx_qjs_error.
    METHODS parse_shift RAISING zcx_qjs_error.

    METHODS parse_term
      RAISING
        zcx_qjs_error.
    METHODS parse_postfix RAISING zcx_qjs_error.

    METHODS parse_factor
      RAISING
        zcx_qjs_error.
    METHODS parse_template_literal RAISING zcx_qjs_error.
    METHODS parse_tagged_template
      IMPORTING method_call TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS array_literal_has_spread
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS call_has_spread
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS parse_spread_arguments RAISING zcx_qjs_error.
    METHODS parse_spread_array RAISING zcx_qjs_error.
    METHODS pattern_end_offset
      IMPORTING start_offset  TYPE i
      RETURNING VALUE(result) TYPE i
      RAISING zcx_qjs_error.
    METHODS parse_pattern_declaration
      IMPORTING lexical TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS parse_pattern_parameter
      IMPORTING argument_index     TYPE i
      RETURNING VALUE(has_default) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS parse_binding_pattern
      IMPORTING lexical TYPE abap_bool
        assignment      TYPE abap_bool DEFAULT abap_false
      RAISING zcx_qjs_error.
    METHODS parse_array_binding
      IMPORTING lexical TYPE abap_bool
        assignment      TYPE abap_bool DEFAULT abap_false
      RAISING zcx_qjs_error.
    METHODS parse_object_binding
      IMPORTING lexical TYPE abap_bool
        assignment      TYPE abap_bool DEFAULT abap_false
      RAISING zcx_qjs_error.
    METHODS parse_member_binding
      IMPORTING binding TYPE ty_local
      RAISING zcx_qjs_error.
    METHODS emit_binding_default RAISING zcx_qjs_error.
    METHODS is_compound_assignment
      IMPORTING kind          TYPE i
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS is_identifier_name
      IMPORTING kind          TYPE i
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS emit_compound_operator IMPORTING kind TYPE i RAISING zcx_qjs_error.
    METHODS emit_binding_get IMPORTING binding TYPE ty_local RAISING zcx_qjs_error.
    METHODS emit_binding_set IMPORTING binding TYPE ty_local RAISING zcx_qjs_error.
    METHODS emit_binding_put IMPORTING binding TYPE ty_local RAISING zcx_qjs_error.
    METHODS parse_prefix_update IMPORTING opcode TYPE i RAISING zcx_qjs_error.

    METHODS parse_statement RAISING zcx_qjs_error.
    METHODS parse_block RAISING zcx_qjs_error.
    METHODS parse_if RAISING zcx_qjs_error.
    METHODS parse_var RAISING zcx_qjs_error.
    METHODS parse_while RAISING zcx_qjs_error.
    METHODS parse_for RAISING zcx_qjs_error.
    METHODS parse_for_in RAISING zcx_qjs_error.
    METHODS parse_for_of
      IMPORTING async TYPE abap_bool DEFAULT abap_false
      RAISING zcx_qjs_error.
    METHODS parse_for_pattern
      IMPORTING declaration_kind TYPE i
        is_for_of                TYPE abap_bool
        async                    TYPE abap_bool DEFAULT abap_false
      RAISING zcx_qjs_error.
    METHODS is_for_in_head
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS is_for_of_head
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS parse_loop_jump IMPORTING is_continue TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS finish_loop
      IMPORTING exit_target TYPE i
      RAISING zcx_qjs_error.
    METHODS parse_function_declaration RAISING zcx_qjs_error.
    METHODS parse_function_expression RAISING zcx_qjs_error.
    METHODS parse_class_declaration RAISING zcx_qjs_error.
    METHODS parse_class_expression
      IMPORTING inferred_name TYPE string OPTIONAL
      RAISING zcx_qjs_error.
    METHODS parse_class
      IMPORTING declaration TYPE abap_bool
        inferred_name       TYPE string OPTIONAL
      RAISING zcx_qjs_error.
    METHODS parse_class_field_initializer
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_function
      RAISING zcx_qjs_error.
    METHODS parse_class_static_block
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_function
      RAISING zcx_qjs_error.
    METHODS parse_return RAISING zcx_qjs_error.
    METHODS parse_throw RAISING zcx_qjs_error.
    METHODS parse_try RAISING zcx_qjs_error.
    METHODS predeclare_scope
      IMPORTING start_offset TYPE i
        stop_at_brace        TYPE abap_bool DEFAULT abap_false
      RAISING zcx_qjs_error.
    METHODS scan_binding_pattern
      IMPORTING scanner  TYPE REF TO zcl_qjs_lexer
        opening_kind     TYPE i
        declaration_kind TYPE i
      RAISING zcx_qjs_error.
    METHODS scan_binding_target
      IMPORTING scanner  TYPE REF TO zcl_qjs_lexer
        first            TYPE zcl_qjs_lexer=>ty_token
        declaration_kind TYPE i
      RAISING zcx_qjs_error.
    METHODS skip_binding_default
      IMPORTING scanner TYPE REF TO zcl_qjs_lexer
        closing_kind    TYPE i
      RAISING zcx_qjs_error.
    METHODS declare_scan_binding
      IMPORTING name     TYPE string
        declaration_kind TYPE i
      RAISING zcx_qjs_error.
    METHODS declare_name IMPORTING name TYPE string RAISING zcx_qjs_error.
    METHODS emit_finally_calls
      IMPORTING for_throw TYPE abap_bool DEFAULT abap_false
        for_loop_jump     TYPE abap_bool DEFAULT abap_false
      RAISING zcx_qjs_error.
    METHODS emit_iterator_closes
      IMPORTING for_throw TYPE abap_bool DEFAULT abap_false
      RAISING zcx_qjs_error.
    METHODS emit_iterator_close
      IMPORTING async TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS declare_lexical
      IMPORTING name TYPE string
        constant     TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS parse_lexical IMPORTING constant TYPE abap_bool RAISING zcx_qjs_error.
    METHODS reserve_function IMPORTING name TYPE string RAISING zcx_qjs_error.
    METHODS find_binding
      IMPORTING name          TYPE string
      RETURNING VALUE(result) TYPE ty_local
      RAISING zcx_qjs_error.
    METHODS has_binding
      IMPORTING name          TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS ensure_parent_binding
      IMPORTING name          TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS capture_parent_bindings.
ENDCLASS.

CLASS zcl_qjs_parser IMPLEMENTATION.
  METHOD constructor.
    DATA lt_root_scope TYPE ty_locals.
    DATA lv_global_name TYPE string.
    mv_source = source.
    IF limits IS BOUND.
      mo_limits = limits.
    ELSE.
      CREATE OBJECT mo_limits.
    ENDIF.
    mo_limits->check_source_length( strlen( source ) ).
    CREATE OBJECT mo_lexer
      EXPORTING
        source = source.
    CREATE OBJECT mo_emitter
      EXPORTING limits = mo_limits.
    APPEND lt_root_scope TO mt_scopes.
    LOOP AT global_names INTO lv_global_name.
      declare_name( lv_global_name ).
    ENDLOOP.
    mo_lexer->prepare( ).
    advance( ).
    predeclare_scope( start_offset = 0 ).
  ENDMETHOD.

  METHOD declare_name.
    DATA ls_local TYPE ty_local.
    READ TABLE mt_locals WITH TABLE KEY name = name
      function_depth = mv_function_depth TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      ls_local-name = name.
      ls_local-function_depth = mv_function_depth.
      ls_local-index = mo_emitter->allocate_local( ).
      ls_local-kind = zcl_qjs_function=>capture_local.
      INSERT ls_local INTO TABLE mt_locals.
    ENDIF.
  ENDMETHOD.

  METHOD declare_lexical.
    DATA ls_local TYPE ty_local.
    DATA lv_scope_index TYPE i.
    FIELD-SYMBOLS <scope> TYPE ty_locals.
    lv_scope_index = lines( mt_scopes ).
    READ TABLE mt_scopes INDEX lv_scope_index ASSIGNING <scope>.
    READ TABLE <scope> WITH TABLE KEY name = name TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Duplicate lexical declaration'.
    ENDIF.
    ls_local-name = name.
    ls_local-index = mo_emitter->allocate_local(
      initialized = abap_false mutable = xsdbool( constant = abap_false ) ).
    ls_local-kind = zcl_qjs_function=>capture_local.
    ls_local-lexical = abap_true.
    ls_local-constant = constant.
    INSERT ls_local INTO TABLE <scope>.
  ENDMETHOD.

  METHOD reserve_function.
    DATA ls_hoist TYPE ty_hoist.
    READ TABLE mt_hoists WITH TABLE KEY name = name TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      RETURN.
    ENDIF.
    ls_hoist-name = name.
    ls_hoist-make_instruction = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>invalid ).
    ls_hoist-put_instruction = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>invalid ).
    INSERT ls_hoist INTO TABLE mt_hoists.
  ENDMETHOD.

  METHOD emit_finally_calls.
    DATA lv_index TYPE i.
    DATA lv_call TYPE i.
    FIELD-SYMBOLS <finally> TYPE ty_finally.
    lv_index = lines( mt_finally ).
    WHILE lv_index > 0.
      READ TABLE mt_finally INDEX lv_index ASSIGNING <finally>.
      IF NOT ( for_throw = abap_true AND <finally>-suppress_throw = abap_true )
          AND NOT ( for_loop_jump = abap_true
            AND <finally>-loop_depth < lines( mt_loops ) ).
        lv_call = mo_emitter->position( ).
        APPEND lv_call TO <finally>-calls.
        mo_emitter->emit( zif_qjs_opcodes=>gosub ).
      ENDIF.
      lv_index = lv_index - 1.
    ENDWHILE.
  ENDMETHOD.

  METHOD emit_iterator_closes.
    DATA lv_index TYPE i.
    DATA lv_finally_index TYPE i.
    DATA lv_catch_loop_depth TYPE i.
    DATA ls_loop TYPE ty_loop.
    DATA ls_finally TYPE ty_finally.
    IF for_throw = abap_true.
      lv_finally_index = lines( mt_finally ).
      WHILE lv_finally_index > 0.
        READ TABLE mt_finally INDEX lv_finally_index INTO ls_finally.
        IF ls_finally-suppress_throw = abap_true.
          lv_catch_loop_depth = ls_finally-loop_depth.
          EXIT.
        ENDIF.
        lv_finally_index = lv_finally_index - 1.
      ENDWHILE.
    ENDIF.
    lv_index = lines( mt_loops ).
    WHILE lv_index > lv_catch_loop_depth.
      READ TABLE mt_loops INDEX lv_index INTO ls_loop.
      IF ls_loop-has_iterator = abap_true
          AND NOT ( for_throw = abap_true
            AND ls_loop-exception_handler = abap_true ).
        IF ls_loop-exception_handler = abap_true.
          mo_emitter->emit( zif_qjs_opcodes=>leave_catch ).
          mo_emitter->emit(  opcode = zif_qjs_opcodes=>get_local
                            operand = ls_loop-iterator_local ).
          emit_iterator_close( ls_loop-async_iterator ).
        ELSE.
          mo_emitter->emit( zif_qjs_opcodes=>swap ).
          emit_iterator_close( ls_loop-async_iterator ).
        ENDIF.
      ENDIF.
      lv_index = lv_index - 1.
    ENDWHILE.
  ENDMETHOD.

  METHOD emit_iterator_close.
    IF async = abap_true.
      mo_emitter->emit( zif_qjs_opcodes=>iterator_call ).
      mo_emitter->emit( zif_qjs_opcodes=>await ).
      mo_emitter->emit( zif_qjs_opcodes=>iterator_check_object ).
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
    ELSE.
      mo_emitter->emit( zif_qjs_opcodes=>iterator_close ).
    ENDIF.
  ENDMETHOD.

  METHOD declare_scan_binding.
    IF declaration_kind = 1.
      declare_name( name ).
    ELSE.
      declare_lexical(
        name = name constant = xsdbool( declaration_kind = 3 ) ).
    ENDIF.
  ENDMETHOD.

  METHOD scan_binding_target.
    CASE first-kind.
      WHEN zcl_qjs_lexer=>token_identifier.
        declare_scan_binding(
          name = first-text declaration_kind = declaration_kind ).
      WHEN zcl_qjs_lexer=>token_lbracket
          OR zcl_qjs_lexer=>token_lbrace.
        scan_binding_pattern(
          scanner = scanner opening_kind = first-kind
          declaration_kind = declaration_kind ).
      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected destructuring binding target'.
    ENDCASE.
  ENDMETHOD.

  METHOD skip_binding_default.
    DATA ls_scan TYPE zcl_qjs_lexer=>ty_token.
    DATA lv_offset TYPE i.
    DATA lv_parentheses TYPE i.
    DATA lv_brackets TYPE i.
    DATA lv_braces TYPE i.
    WHILE abap_true = abap_true.
      lv_offset = scanner->get_offset( ).
      scanner->next_into( CHANGING token = ls_scan ).
      IF ls_scan-kind = zcl_qjs_lexer=>token_eof.
        RETURN.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_comma
          AND lv_parentheses = 0 AND lv_brackets = 0 AND lv_braces = 0.
        scanner->set_offset( lv_offset ).
        RETURN.
      ELSEIF ls_scan-kind = closing_kind
          AND lv_parentheses = 0 AND lv_brackets = 0 AND lv_braces = 0.
        scanner->set_offset( lv_offset ).
        RETURN.
      ENDIF.
      CASE ls_scan-kind.
        WHEN zcl_qjs_lexer=>token_lparen.
          lv_parentheses = lv_parentheses + 1.
        WHEN zcl_qjs_lexer=>token_rparen.
          lv_parentheses = lv_parentheses - 1.
        WHEN zcl_qjs_lexer=>token_lbracket.
          lv_brackets = lv_brackets + 1.
        WHEN zcl_qjs_lexer=>token_rbracket.
          lv_brackets = lv_brackets - 1.
        WHEN zcl_qjs_lexer=>token_lbrace.
          lv_braces = lv_braces + 1.
        WHEN zcl_qjs_lexer=>token_rbrace.
          lv_braces = lv_braces - 1.
      ENDCASE.
    ENDWHILE.
  ENDMETHOD.

  METHOD scan_binding_pattern.
    DATA ls_scan TYPE zcl_qjs_lexer=>ty_token.
    DATA ls_next TYPE zcl_qjs_lexer=>ty_token.
    DATA lv_offset TYPE i.
    DATA lv_depth TYPE i.
    DATA lv_closing_kind TYPE i.
    IF opening_kind = zcl_qjs_lexer=>token_lbracket.
      lv_closing_kind = zcl_qjs_lexer=>token_rbracket.
    ELSE.
      lv_closing_kind = zcl_qjs_lexer=>token_rbrace.
    ENDIF.
    WHILE abap_true = abap_true.
      scanner->next_into( CHANGING token = ls_scan ).
      IF ls_scan-kind = zcl_qjs_lexer=>token_eof
          OR ls_scan-kind = lv_closing_kind.
        RETURN.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_comma.
        CONTINUE.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_ellipsis.
        scanner->next_into( CHANGING token = ls_scan ).
        scan_binding_target(
          scanner = scanner first = ls_scan
          declaration_kind = declaration_kind ).
      ELSEIF opening_kind = zcl_qjs_lexer=>token_lbrace.
        IF ls_scan-kind = zcl_qjs_lexer=>token_lbracket.
          lv_depth = 1.
          WHILE lv_depth > 0.
            scanner->next_into( CHANGING token = ls_next ).
            IF ls_next-kind = zcl_qjs_lexer=>token_lbracket.
              lv_depth = lv_depth + 1.
            ELSEIF ls_next-kind = zcl_qjs_lexer=>token_rbracket.
              lv_depth = lv_depth - 1.
            ELSEIF ls_next-kind = zcl_qjs_lexer=>token_eof.
              RETURN.
            ENDIF.
          ENDWHILE.
          scanner->next_into( CHANGING token = ls_next ).
          IF ls_next-kind <> zcl_qjs_lexer=>token_colon.
            RETURN.
          ENDIF.
          scanner->next_into( CHANGING token = ls_next ).
          scan_binding_target(
            scanner = scanner first = ls_next
            declaration_kind = declaration_kind ).
        ELSE.
          lv_offset = scanner->get_offset( ).
          scanner->next_into( CHANGING token = ls_next ).
          IF ls_next-kind = zcl_qjs_lexer=>token_colon.
            scanner->next_into( CHANGING token = ls_next ).
            scan_binding_target(
              scanner = scanner first = ls_next
              declaration_kind = declaration_kind ).
          ELSE.
            IF ls_scan-kind = zcl_qjs_lexer=>token_identifier.
              declare_scan_binding(
                name = ls_scan-text declaration_kind = declaration_kind ).
            ENDIF.
            scanner->set_offset( lv_offset ).
          ENDIF.
        ENDIF.
      ELSE.
        scan_binding_target(
          scanner = scanner first = ls_scan
          declaration_kind = declaration_kind ).
      ENDIF.
      lv_offset = scanner->get_offset( ).
      scanner->next_into( CHANGING token = ls_next ).
      IF ls_next-kind = zcl_qjs_lexer=>token_assign.
        skip_binding_default(
          scanner = scanner closing_kind = lv_closing_kind ).
      ELSE.
        scanner->set_offset( lv_offset ).
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD predeclare_scope.
    DATA lo_scanner TYPE REF TO zcl_qjs_lexer.
    DATA ls_scan TYPE zcl_qjs_lexer=>ty_token.
    DATA ls_name TYPE zcl_qjs_lexer=>ty_token.
    DATA lv_depth TYPE i.
    DATA lv_function_depth TYPE i.
    DATA lv_declaration_kind TYPE i.
    DATA lv_declaration_depth TYPE i.
    DATA lv_expect_declaration_name TYPE abap_bool.
    DATA lv_parenthesis_depth TYPE i.
    DATA lv_for_parenthesis_depth TYPE i.
    DATA lv_for_pending TYPE abap_bool.
    DEFINE qjs_note_capture.
      IF ensure_parent_binding( &1 ) = abap_true.
        INSERT &1 INTO TABLE mt_capture_names.
      ENDIF.
    END-OF-DEFINITION.
    CLEAR mt_capture_names.
    mv_capture_filter_ready = abap_true.
    CREATE OBJECT lo_scanner EXPORTING cache = mo_lexer.
    lo_scanner->set_offset( start_offset ).
    WHILE abap_true = abap_true.
      lo_scanner->next_into( CHANGING token = ls_scan ).
      IF ls_scan-kind = zcl_qjs_lexer=>token_eof.
        RETURN.
      ENDIF.
      IF ls_scan-kind = zcl_qjs_lexer=>token_identifier.
        IF ls_scan-text = 'arguments'.
          mo_emitter->mark_arguments_used( ).
        ENDIF.
        qjs_note_capture ls_scan-text.
      ENDIF.
      IF lv_declaration_kind > 0.
        IF lv_expect_declaration_name = abap_true.
          IF ls_scan-kind = zcl_qjs_lexer=>token_identifier.
            IF lv_declaration_kind = 1.
              declare_name( ls_scan-text ).
            ELSE.
              declare_lexical(
                name = ls_scan-text constant = xsdbool( lv_declaration_kind = 3 ) ).
            ENDIF.
            lv_expect_declaration_name = abap_false.
            CONTINUE.
          ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_lbracket
              OR ls_scan-kind = zcl_qjs_lexer=>token_lbrace.
            scan_binding_pattern(
              scanner = lo_scanner opening_kind = ls_scan-kind
              declaration_kind = lv_declaration_kind ).
            lv_expect_declaration_name = abap_false.
            CONTINUE.
          ENDIF.
          RETURN.
        ENDIF.
        IF ls_scan-kind = zcl_qjs_lexer=>token_lparen
            OR ls_scan-kind = zcl_qjs_lexer=>token_lbracket
            OR ls_scan-kind = zcl_qjs_lexer=>token_lbrace.
          lv_declaration_depth = lv_declaration_depth + 1.
          CONTINUE.
        ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_rparen
            OR ls_scan-kind = zcl_qjs_lexer=>token_rbracket
            OR ls_scan-kind = zcl_qjs_lexer=>token_rbrace.
          IF lv_declaration_depth > 0.
            lv_declaration_depth = lv_declaration_depth - 1.
            CONTINUE.
          ENDIF.
          IF ls_scan-kind = zcl_qjs_lexer=>token_rparen.
            IF lv_parenthesis_depth = lv_for_parenthesis_depth.
              CLEAR lv_for_parenthesis_depth.
            ENDIF.
            lv_parenthesis_depth = lv_parenthesis_depth - 1.
          ENDIF.
          CLEAR lv_declaration_kind.
        ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_comma
            AND lv_declaration_depth = 0.
          lv_expect_declaration_name = abap_true.
          CONTINUE.
        ELSEIF lv_declaration_depth = 0
            AND ( ls_scan-kind = zcl_qjs_lexer=>token_in
              OR ( ls_scan-kind = zcl_qjs_lexer=>token_identifier
                AND ls_scan-text = 'of' ) ).
          CLEAR lv_declaration_kind.
          CONTINUE.
        ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_var
            AND lv_declaration_depth = 0.
          lv_declaration_kind = 1.
          lv_expect_declaration_name = abap_true.
          CONTINUE.
        ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_semicolon
            AND lv_declaration_depth = 0.
          CLEAR lv_declaration_kind.
          CONTINUE.
        ELSE.
          CONTINUE.
        ENDIF.
      ENDIF.
      IF ls_scan-kind = zcl_qjs_lexer=>token_rbrace.
        IF lv_depth = 0 AND stop_at_brace = abap_true.
          RETURN.
        ENDIF.
        lv_depth = lv_depth - 1.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_lbrace.
        lv_depth = lv_depth + 1.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_for.
        lv_for_pending = abap_true.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_lparen.
        lv_parenthesis_depth = lv_parenthesis_depth + 1.
        IF lv_for_pending = abap_true.
          lv_for_parenthesis_depth = lv_parenthesis_depth.
          CLEAR lv_for_pending.
        ENDIF.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_rparen.
        IF lv_parenthesis_depth = lv_for_parenthesis_depth.
          CLEAR lv_for_parenthesis_depth.
        ENDIF.
        lv_parenthesis_depth = lv_parenthesis_depth - 1.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_var.
        lv_declaration_kind = 1.
        lv_expect_declaration_name = abap_true.
      ELSEIF ( ls_scan-kind = zcl_qjs_lexer=>token_let
          OR ls_scan-kind = zcl_qjs_lexer=>token_const )
          AND lv_depth = 0 AND lv_for_parenthesis_depth = 0.
        lv_declaration_kind = 2.
        IF ls_scan-kind = zcl_qjs_lexer=>token_const.
          lv_declaration_kind = 3.
        ENDIF.
        lv_expect_declaration_name = abap_true.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_function.
        lo_scanner->next_into( CHANGING token = ls_name ).
        IF ls_name-kind = zcl_qjs_lexer=>token_star.
          lo_scanner->next_into( CHANGING token = ls_name ).
        ENDIF.
        IF ls_name-kind = zcl_qjs_lexer=>token_identifier.
          declare_name( ls_name-text ).
          reserve_function( ls_name-text ).
        ENDIF.
        lv_function_depth = 0.
        WHILE abap_true = abap_true.
          lo_scanner->next_into( CHANGING token = ls_scan ).
          IF ls_scan-kind = zcl_qjs_lexer=>token_identifier.
            qjs_note_capture ls_scan-text.
          ENDIF.
          IF ls_scan-kind = zcl_qjs_lexer=>token_eof.
            RETURN.
          ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_lbrace.
            lv_function_depth = 1.
            EXIT.
          ENDIF.
        ENDWHILE.
        WHILE lv_function_depth > 0.
          lo_scanner->next_into( CHANGING token = ls_scan ).
          IF ls_scan-kind = zcl_qjs_lexer=>token_identifier.
            qjs_note_capture ls_scan-text.
          ENDIF.
          IF ls_scan-kind = zcl_qjs_lexer=>token_lbrace.
            lv_function_depth = lv_function_depth + 1.
          ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_rbrace.
            lv_function_depth = lv_function_depth - 1.
          ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_eof.
            RETURN.
          ENDIF.
        ENDWHILE.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_class AND lv_depth = 0.
        lo_scanner->next_into( CHANGING token = ls_name ).
        IF ls_name-kind = zcl_qjs_lexer=>token_identifier.
          declare_lexical( name = ls_name-text constant = abap_true ).
        ENDIF.
        lv_function_depth = 0.
        WHILE abap_true = abap_true.
          lo_scanner->next_into( CHANGING token = ls_scan ).
          IF ls_scan-kind = zcl_qjs_lexer=>token_identifier.
            qjs_note_capture ls_scan-text.
          ENDIF.
          IF ls_scan-kind = zcl_qjs_lexer=>token_eof.
            RETURN.
          ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_lbrace.
            lv_function_depth = 1.
            EXIT.
          ENDIF.
        ENDWHILE.
        WHILE lv_function_depth > 0.
          lo_scanner->next_into( CHANGING token = ls_scan ).
          IF ls_scan-kind = zcl_qjs_lexer=>token_identifier.
            qjs_note_capture ls_scan-text.
          ENDIF.
          IF ls_scan-kind = zcl_qjs_lexer=>token_lbrace.
            lv_function_depth = lv_function_depth + 1.
          ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_rbrace.
            lv_function_depth = lv_function_depth - 1.
          ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_eof.
            RETURN.
          ENDIF.
        ENDWHILE.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD advance.
    mo_lexer->next_into( CHANGING token = ms_token ).
  ENDMETHOD.

  METHOD is_async_function_start.
    IF ms_token-kind <> zcl_qjs_lexer=>token_identifier
        OR ms_token-text <> 'async'.
      RETURN.
    ENDIF.
    DATA(lo_scanner) = NEW zcl_qjs_lexer( cache = mo_lexer ).
    lo_scanner->set_offset( mo_lexer->get_offset( ) ).
    DATA(ls_next) = lo_scanner->next( ).
    result = xsdbool(
      ls_next-kind = zcl_qjs_lexer=>token_function
        AND ls_next-line_terminator_before = abap_false ).
  ENDMETHOD.

  METHOD compile.
    IF ms_token-kind = zcl_qjs_lexer=>token_eof.
      mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
    ELSE.
      parse_statement( ).
      WHILE ms_token-kind <> zcl_qjs_lexer=>token_eof.
        mo_emitter->emit( zif_qjs_opcodes=>drop ).
        parse_statement( ).
      ENDWHILE.
    ENDIF.
    mo_emitter->emit( zif_qjs_opcodes=>return ).
    result = mo_emitter->to_function( ).
  ENDMETHOD.

  METHOD get_global_bindings.
    DATA ls_local TYPE ty_local.
    DATA ls_binding TYPE ty_global_binding.
    DATA lt_root_scope TYPE ty_locals.
    LOOP AT mt_locals INTO ls_local WHERE function_depth = 0.
      ls_binding-name = ls_local-name.
      ls_binding-index = ls_local-index.
      ls_binding-lexical = ls_local-lexical.
      APPEND ls_binding TO result.
    ENDLOOP.
    READ TABLE mt_scopes INDEX 1 INTO lt_root_scope.
    LOOP AT lt_root_scope INTO ls_local.
      ls_binding-name = ls_local-name.
      ls_binding-index = ls_local-index.
      ls_binding-lexical = ls_local-lexical.
      APPEND ls_binding TO result.
    ENDLOOP.
    SORT result BY index.
  ENDMETHOD.

  METHOD parse_statement.
    IF is_async_function_start( ) = abap_true.
      mv_parsing_async_function = abap_true.
      advance( ).
      parse_function_declaration( ).
      RETURN.
    ENDIF.
    CASE ms_token-kind.
      WHEN zcl_qjs_lexer=>token_if.
        parse_if( ).
      WHEN zcl_qjs_lexer=>token_var.
        parse_var( ).
      WHEN zcl_qjs_lexer=>token_let.
        parse_lexical( abap_false ).
      WHEN zcl_qjs_lexer=>token_const.
        parse_lexical( abap_true ).
      WHEN zcl_qjs_lexer=>token_while.
        parse_while( ).
      WHEN zcl_qjs_lexer=>token_for.
        parse_for( ).
      WHEN zcl_qjs_lexer=>token_break.
        parse_loop_jump( abap_false ).
      WHEN zcl_qjs_lexer=>token_continue.
        parse_loop_jump( abap_true ).
      WHEN zcl_qjs_lexer=>token_function.
        parse_function_declaration( ).
      WHEN zcl_qjs_lexer=>token_class.
        parse_class_declaration( ).
      WHEN zcl_qjs_lexer=>token_return.
        parse_return( ).
      WHEN zcl_qjs_lexer=>token_throw.
        parse_throw( ).
      WHEN zcl_qjs_lexer=>token_try.
        parse_try( ).
      WHEN zcl_qjs_lexer=>token_lbrace.
        parse_block( ).
      WHEN zcl_qjs_lexer=>token_semicolon.
        advance( ).
        mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
      WHEN OTHERS.
        parse_expression( ).
        IF ms_token-kind = zcl_qjs_lexer=>token_semicolon.
          advance( ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD parse_lexical.
    DATA lv_scope_index TYPE i.
    DATA ls_local TYPE ty_local.
    DATA lv_binding_name TYPE string.
    FIELD-SYMBOLS <scope> TYPE ty_locals.
    advance( ).
    lv_scope_index = lines( mt_scopes ).
    READ TABLE mt_scopes INDEX lv_scope_index ASSIGNING <scope>.
    WHILE abap_true = abap_true.
      IF ms_token-kind = zcl_qjs_lexer=>token_lbracket
          OR ms_token-kind = zcl_qjs_lexer=>token_lbrace.
        parse_pattern_declaration( abap_true ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_comma.
          EXIT.
        ENDIF.
        advance( ).
        CONTINUE.
      ENDIF.
      IF ms_token-kind <> zcl_qjs_lexer=>token_identifier.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected lexical binding name'.
      ENDIF.
      READ TABLE <scope> WITH TABLE KEY name = ms_token-text INTO ls_local.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Lexical declaration was not predeclared'.
      ENDIF.
      lv_binding_name = ms_token-text.
      advance( ).
      IF ms_token-kind = zcl_qjs_lexer=>token_assign.
        advance( ).
        IF ms_token-kind = zcl_qjs_lexer=>token_class.
          parse_class_expression( inferred_name = lv_binding_name ).
        ELSE.
          parse_assignment( ).
        ENDIF.
      ELSEIF constant = abap_true.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Constant declaration requires an initializer'.
      ELSE.
        mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
      ENDIF.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>initialize_lexical operand = ls_local-index ).
      IF ms_token-kind <> zcl_qjs_lexer=>token_comma.
        EXIT.
      ENDIF.
      advance( ).
    ENDWHILE.
    mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
    IF ms_token-kind = zcl_qjs_lexer=>token_semicolon.
      advance( ).
    ENDIF.
  ENDMETHOD.

  METHOD parse_return.
    DATA lv_has_value TYPE abap_bool.
    IF mv_in_function = abap_false.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Return statement outside a function'.
    ENDIF.
    advance( ).
    IF ms_token-line_terminator_before = abap_true
        OR ms_token-kind = zcl_qjs_lexer=>token_semicolon
        OR ms_token-kind = zcl_qjs_lexer=>token_rbrace.
      mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
    ELSE.
      parse_expression( ).
      lv_has_value = abap_true.
    ENDIF.
    IF lv_has_value = abap_true
        AND mv_in_generator = abap_true AND mv_in_async = abap_true.
      mo_emitter->emit( zif_qjs_opcodes=>await ).
    ENDIF.
    emit_finally_calls( ).
    emit_iterator_closes( ).
    mo_emitter->emit( zif_qjs_opcodes=>return ).
    mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
    IF ms_token-kind = zcl_qjs_lexer=>token_semicolon.
      advance( ).
    ENDIF.
  ENDMETHOD.

  METHOD parse_throw.
    advance( ).
    IF ms_token-line_terminator_before = abap_true
        OR ms_token-kind = zcl_qjs_lexer=>token_semicolon
        OR ms_token-kind = zcl_qjs_lexer=>token_eof.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected expression after throw'.
    ENDIF.
    parse_expression( ).
    emit_finally_calls( for_throw = abap_true ).
    emit_iterator_closes( for_throw = abap_true ).
    mo_emitter->emit( zif_qjs_opcodes=>throw ).
    mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
    IF ms_token-kind = zcl_qjs_lexer=>token_semicolon.
      advance( ).
    ENDIF.
  ENDMETHOD.

  METHOD parse_try.
    DATA lv_catch_instruction TYPE i.
    DATA lv_normal_jump TYPE i.
    DATA lv_end_jump TYPE i.
    DATA lv_catch_name TYPE string.
    DATA ls_catch_local TYPE ty_local.
    DATA ls_outer_local TYPE ty_local.
    DATA lv_had_outer TYPE abap_bool.
    DATA lv_has_catch TYPE abap_bool.
    DATA lv_has_finally TYPE abap_bool.
    DATA lv_finally_index TYPE i.
    DATA lv_catch_guard_instruction TYPE i.
    DATA lv_call TYPE i.
    DATA lv_jump TYPE i.
    DATA ls_finally TYPE ty_finally.
    FIELD-SYMBOLS <finally> TYPE ty_finally.

    advance( ).
    IF ms_token-kind <> zcl_qjs_lexer=>token_lbrace.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected block after try'.
    ENDIF.
    ls_finally-suppress_throw = abap_true.
    ls_finally-loop_depth = lines( mt_loops ).
    APPEND ls_finally TO mt_finally.
    lv_finally_index = lines( mt_finally ).
    lv_catch_instruction = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>catch ).
    parse_block( ).
    mo_emitter->emit( zif_qjs_opcodes=>leave_catch ).
    lv_normal_jump = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>goto ).
    mo_emitter->patch(
      instruction = lv_catch_instruction target = mo_emitter->position( ) ).

    READ TABLE mt_finally INDEX lv_finally_index ASSIGNING <finally>.
    <finally>-suppress_throw = abap_false.
    IF ms_token-kind = zcl_qjs_lexer=>token_catch.
      lv_has_catch = abap_true.
      advance( ).
      IF ms_token-kind <> zcl_qjs_lexer=>token_lparen.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected catch binding'.
      ENDIF.
      advance( ).
      DATA(lv_pattern_catch) = xsdbool(
        ms_token-kind = zcl_qjs_lexer=>token_lbracket
          OR ms_token-kind = zcl_qjs_lexer=>token_lbrace ).
      DATA lv_catch_scope_index TYPE i.
      IF lv_pattern_catch = abap_true.
        DATA lt_catch_scope TYPE ty_locals.
        DATA lt_catch_bindings TYPE ty_locals.
        DATA ls_catch_binding TYPE ty_local.
        APPEND lt_catch_scope TO mt_scopes.
        lv_catch_scope_index = lines( mt_scopes ).
        DATA lo_catch_scanner TYPE REF TO zcl_qjs_lexer.
        CREATE OBJECT lo_catch_scanner EXPORTING cache = mo_lexer.
        lo_catch_scanner->set_offset( ms_token-offset ).
        DATA(ls_catch_opening) = lo_catch_scanner->next( ).
        scan_binding_pattern(
          scanner = lo_catch_scanner opening_kind = ls_catch_opening-kind
          declaration_kind = 2 ).
        READ TABLE mt_scopes INDEX lv_catch_scope_index
          INTO lt_catch_bindings.
        LOOP AT lt_catch_bindings INTO ls_catch_binding.
          mo_emitter->emit(
            opcode  = zif_qjs_opcodes=>reset_lexical
            operand = ls_catch_binding-index ).
        ENDLOOP.
        parse_binding_pattern( abap_true ).
      ELSE.
        IF ms_token-kind <> zcl_qjs_lexer=>token_identifier.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected catch identifier'.
        ENDIF.
        lv_catch_name = ms_token-text.
        READ TABLE mt_locals WITH TABLE KEY name = lv_catch_name
          function_depth = mv_function_depth
          INTO ls_outer_local.
        IF sy-subrc = 0.
          lv_had_outer = abap_true.
          DELETE TABLE mt_locals WITH TABLE KEY name = lv_catch_name
            function_depth = mv_function_depth.
        ENDIF.
        ls_catch_local-name = lv_catch_name.
        ls_catch_local-function_depth = mv_function_depth.
        ls_catch_local-index = mo_emitter->allocate_local( ).
        ls_catch_local-kind = zcl_qjs_function=>capture_local.
        INSERT ls_catch_local INTO TABLE mt_locals.
        advance( ).
      ENDIF.
      IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected closing catch parenthesis'.
      ENDIF.
      advance( ).
      IF ms_token-kind <> zcl_qjs_lexer=>token_lbrace.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected catch block'.
      ENDIF.
      IF lv_pattern_catch = abap_false.
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>put_local operand = ls_catch_local-index ).
      ENDIF.
      lv_catch_guard_instruction = mo_emitter->position( ).
      mo_emitter->emit( opcode = zif_qjs_opcodes=>catch operand = 0 ).
      parse_block( ).
      mo_emitter->emit( zif_qjs_opcodes=>leave_catch ).
      IF lv_pattern_catch = abap_true.
        DELETE mt_scopes INDEX lv_catch_scope_index.
      ELSE.
        DELETE TABLE mt_locals WITH TABLE KEY name = lv_catch_name
          function_depth = mv_function_depth.
        IF lv_had_outer = abap_true.
          INSERT ls_outer_local INTO TABLE mt_locals.
        ENDIF.
      ENDIF.
    ELSE.
      IF ms_token-kind <> zcl_qjs_lexer=>token_finally.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected catch or finally after try block'.
      ENDIF.
      emit_finally_calls( for_throw = abap_true ).
      mo_emitter->emit( zif_qjs_opcodes=>throw ).
      mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
    ENDIF.

    mo_emitter->patch(
      instruction = lv_normal_jump target = mo_emitter->position( ) ).
    lv_call = mo_emitter->position( ).
    READ TABLE mt_finally INDEX lv_finally_index ASSIGNING <finally>.
    APPEND lv_call TO <finally>-calls.
    mo_emitter->emit( zif_qjs_opcodes=>gosub ).
    lv_end_jump = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>goto ).

    IF ms_token-kind = zcl_qjs_lexer=>token_finally.
      lv_has_finally = abap_true.
      advance( ).
    ENDIF.
    READ TABLE mt_finally INDEX lv_finally_index INTO ls_finally.
    LOOP AT ls_finally-calls INTO lv_jump.
      mo_emitter->patch(
        instruction = lv_jump target = mo_emitter->position( ) ).
    ENDLOOP.
    DELETE mt_finally INDEX lv_finally_index.
    IF lv_has_finally = abap_true.
      mo_emitter->patch_second(
        instruction = lv_catch_instruction target = mo_emitter->position( ) ).
      IF lv_catch_guard_instruction > 0.
        mo_emitter->patch_second(
          instruction = lv_catch_guard_instruction
          target      = mo_emitter->position( ) ).
      ENDIF.
      IF ms_token-kind <> zcl_qjs_lexer=>token_lbrace.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected finally block'.
      ENDIF.
      parse_block( ).
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
    ENDIF.
    mo_emitter->emit( zif_qjs_opcodes=>ret ).
    mo_emitter->patch(
      instruction = lv_end_jump target = mo_emitter->position( ) ).
  ENDMETHOD.

  METHOD parse_function_declaration.
    DATA lo_outer_emitter TYPE REF TO zcl_qjs_emitter.
    DATA lr_previous_outer_parent TYPE REF TO ty_locals.
    DATA lr_previous_outer_scopes TYPE REF TO ty_scopes.
    DATA lt_outer_loops TYPE ty_loops.
    DATA lt_outer_parent_locals TYPE ty_locals.
    DATA lt_outer_finally TYPE ty_finally_stack.
    DATA lt_outer_scopes TYPE ty_scopes.
    DATA lt_root_scope TYPE ty_locals.
    DATA lt_outer_hoists TYPE ty_hoists.
    DATA ls_hoist TYPE ty_hoist.
    DATA lv_constant_index TYPE i.
    DATA lv_outer_in_function TYPE abap_bool.
    DATA ls_outer_local TYPE ty_local.
    DATA ls_local TYPE ty_local.
    DATA lv_name TYPE string.
    DATA lv_parameter_count TYPE i.
    DATA lv_function_length TYPE i.
    DATA lv_seen_default TYPE abap_bool.
    DATA lv_default_jump TYPE i.
    DATA lo_function TYPE REF TO zcl_qjs_function.
    DATA ls_function_value TYPE zcl_qjs_value=>ty_value.
    DATA lv_generator TYPE abap_bool.
    DATA lv_outer_in_generator TYPE abap_bool.
    DATA lv_async TYPE abap_bool.
    DATA lv_outer_in_async TYPE abap_bool.

    lv_async = mv_parsing_async_function.
    CLEAR mv_parsing_async_function.
    advance( ).
    IF ms_token-kind = zcl_qjs_lexer=>token_star.
      lv_generator = abap_true.
      advance( ).
    ENDIF.
    IF ms_token-kind <> zcl_qjs_lexer=>token_identifier.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected function name'.
    ENDIF.
    lv_name = ms_token-text.
    READ TABLE mt_locals WITH TABLE KEY name = lv_name
      function_depth = mv_function_depth INTO ls_outer_local.
    IF sy-subrc <> 0.
      ls_outer_local-name = lv_name.
      ls_outer_local-function_depth = mv_function_depth.
      ls_outer_local-index = mo_emitter->allocate_local( ).
      ls_outer_local-kind = zcl_qjs_function=>capture_local.
      INSERT ls_outer_local INTO TABLE mt_locals.
    ENDIF.
    advance( ).
    IF ms_token-kind <> zcl_qjs_lexer=>token_lparen.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected function parameter list'.
    ENDIF.
    advance( ).

    lo_outer_emitter = mo_emitter.
    lt_outer_parent_locals = mt_parent_locals.
    lt_outer_finally = mt_finally.
    lt_outer_scopes = mt_scopes.
    lt_outer_hoists = mt_hoists.
    lt_outer_loops = mt_loops.
    lv_outer_in_function = mv_in_function.
    lv_outer_in_generator = mv_in_generator.
    lv_outer_in_async = mv_in_async.
    lr_previous_outer_parent = mr_outer_parent_locals.
    lr_previous_outer_scopes = mr_outer_scopes.
    GET REFERENCE OF lt_outer_parent_locals INTO mr_outer_parent_locals.
    GET REFERENCE OF lt_outer_scopes INTO mr_outer_scopes.
    CREATE OBJECT mo_emitter EXPORTING limits = mo_limits.
    CLEAR mt_parent_locals.
    mv_function_depth = mv_function_depth + 1.
    CLEAR mt_loops.
    CLEAR mt_finally.
    CLEAR mt_scopes.
    CLEAR mt_hoists.
    APPEND lt_root_scope TO mt_scopes.
    mv_in_function = abap_true.
    mv_in_generator = lv_generator.
    mv_in_async = lv_async.

    ls_local-name = lv_name.
    ls_local-function_depth = mv_function_depth.
    ls_local-index = mo_emitter->allocate_local( ).
    ls_local-kind = zcl_qjs_function=>capture_local.
    INSERT ls_local INTO TABLE mt_locals.
    CLEAR ls_local.
    ls_local-name = 'this'.
    ls_local-function_depth = mv_function_depth.
    ls_local-index = mo_emitter->allocate_local( ).
    ls_local-kind = zcl_qjs_function=>capture_local.
    INSERT ls_local INTO TABLE mt_locals.
    CLEAR ls_local.
    ls_local-name = 'arguments'.
    ls_local-function_depth = mv_function_depth.
    ls_local-index = mo_emitter->allocate_local( ).
    ls_local-kind = zcl_qjs_function=>capture_local.
    INSERT ls_local INTO TABLE mt_locals.
    WHILE ms_token-kind <> zcl_qjs_lexer=>token_rparen.
      IF ms_token-kind = zcl_qjs_lexer=>token_ellipsis.
        advance( ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_identifier.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected rest parameter name'.
        ENDIF.
        CLEAR ls_local.
        ls_local-name = ms_token-text.
        ls_local-function_depth = mv_function_depth.
        ls_local-index = mo_emitter->allocate_local( ).
        ls_local-kind = zcl_qjs_function=>capture_local.
        INSERT ls_local INTO TABLE mt_locals.
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>rest operand = lv_parameter_count ).
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>put_local operand = ls_local-index ).
        advance( ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Rest parameter must be last'.
        ENDIF.
        CONTINUE.
      ENDIF.
      IF ms_token-kind = zcl_qjs_lexer=>token_lbracket
          OR ms_token-kind = zcl_qjs_lexer=>token_lbrace.
        DATA(lv_pattern_default) = parse_pattern_parameter(
          lv_parameter_count ).
        lv_parameter_count = lv_parameter_count + 1.
        IF lv_pattern_default = abap_true.
          lv_seen_default = abap_true.
        ELSEIF lv_seen_default = abap_false.
          lv_function_length = lv_function_length + 1.
        ENDIF.
        IF ms_token-kind = zcl_qjs_lexer=>token_comma.
          advance( ).
        ELSEIF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected comma after pattern parameter'.
        ENDIF.
        CONTINUE.
      ENDIF.
      IF ms_token-kind <> zcl_qjs_lexer=>token_identifier.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected function parameter'.
      ENDIF.
      CLEAR ls_local.
      ls_local-name = ms_token-text.
      ls_local-function_depth = mv_function_depth.
      ls_local-index = mo_emitter->allocate_local( ).
      ls_local-kind = zcl_qjs_function=>capture_local.
      INSERT ls_local INTO TABLE mt_locals.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>get_arg operand = lv_parameter_count ).
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>put_local operand = ls_local-index ).
      lv_parameter_count = lv_parameter_count + 1.
      advance( ).
      IF ms_token-kind = zcl_qjs_lexer=>token_assign.
        lv_seen_default = abap_true.
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>get_local operand = ls_local-index ).
        mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
        mo_emitter->emit( zif_qjs_opcodes=>strict_equal ).
        lv_default_jump = mo_emitter->position( ).
        mo_emitter->emit( zif_qjs_opcodes=>if_false ).
        advance( ).
        parse_assignment( ).
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>put_local operand = ls_local-index ).
        mo_emitter->patch(
          instruction = lv_default_jump target = mo_emitter->position( ) ).
      ELSEIF lv_seen_default = abap_false.
        lv_function_length = lv_function_length + 1.
      ENDIF.
      IF ms_token-kind = zcl_qjs_lexer=>token_comma.
        advance( ).
      ELSEIF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected comma in function parameter list'.
      ENDIF.
    ENDWHILE.
    advance( ).
    IF lv_generator = abap_true AND lv_async = abap_true.
      mo_emitter->emit( zif_qjs_opcodes=>initial_yield ).
    ENDIF.
    IF ms_token-kind <> zcl_qjs_lexer=>token_lbrace.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected function body'.
    ENDIF.
    predeclare_scope(
      start_offset = mo_lexer->get_offset( ) stop_at_brace = abap_true ).
    capture_parent_bindings( ).
    advance( ).
    mo_emitter->set_signature(
      parameter_count = lv_parameter_count function_length = lv_function_length
      has_self = abap_true has_this = abap_true
      has_arguments = abap_true name = lv_name generator = lv_generator
      async = lv_async
      constructible = xsdbool( lv_generator = abap_false AND lv_async = abap_false ) ).
    WHILE ms_token-kind <> zcl_qjs_lexer=>token_rbrace.
      IF ms_token-kind = zcl_qjs_lexer=>token_eof.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected closing function brace'.
      ENDIF.
      parse_statement( ).
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
    ENDWHILE.
    advance( ).
    mo_emitter->emit( zif_qjs_opcodes=>return_undefined ).
    lo_function = mo_emitter->to_function( ).
    mo_last_function = lo_function.

    mo_emitter = lo_outer_emitter.
    DELETE mt_locals WHERE function_depth = mv_function_depth.
    mv_function_depth = mv_function_depth - 1.
    mt_parent_locals = lt_outer_parent_locals.
    mt_loops = lt_outer_loops.
    mt_finally = lt_outer_finally.
    mt_scopes = lt_outer_scopes.
    mt_hoists = lt_outer_hoists.
    mr_outer_parent_locals = lr_previous_outer_parent.
    mr_outer_scopes = lr_previous_outer_scopes.
    mv_in_function = lv_outer_in_function.
    mv_in_generator = lv_outer_in_generator.
    mv_in_async = lv_outer_in_async.
    ls_function_value = zcl_qjs_value=>new_object( lo_function ).
    READ TABLE mt_hoists WITH TABLE KEY name = lv_name INTO ls_hoist.
    IF sy-subrc = 0.
      lv_constant_index = mo_emitter->add_constant( ls_function_value ).
      mo_emitter->replace(
        instruction = ls_hoist-make_instruction
        opcode      = zif_qjs_opcodes=>make_closure
        operand     = lv_constant_index ).
      mo_emitter->replace(
        instruction = ls_hoist-put_instruction
        opcode      = zif_qjs_opcodes=>put_local
        operand     = ls_outer_local-index ).
    ELSE.
      mo_emitter->emit_closure( ls_function_value ).
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>put_local operand = ls_outer_local-index ).
    ENDIF.
    mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
  ENDMETHOD.

  METHOD parse_function_expression.
    DATA lo_outer_emitter TYPE REF TO zcl_qjs_emitter.
    DATA lr_previous_outer_parent TYPE REF TO ty_locals.
    DATA lr_previous_outer_scopes TYPE REF TO ty_scopes.
    DATA lt_outer_loops TYPE ty_loops.
    DATA lt_outer_parent_locals TYPE ty_locals.
    DATA lt_outer_finally TYPE ty_finally_stack.
    DATA lt_outer_scopes TYPE ty_scopes.
    DATA lt_root_scope TYPE ty_locals.
    DATA lt_outer_hoists TYPE ty_hoists.
    DATA lv_outer_in_function TYPE abap_bool.
    DATA ls_local TYPE ty_local.
    DATA lv_name TYPE string.
    DATA lv_parameter_count TYPE i.
    DATA lv_function_length TYPE i.
    DATA lv_seen_default TYPE abap_bool.
    DATA lv_default_jump TYPE i.
    DATA lo_function TYPE REF TO zcl_qjs_function.
    DATA lv_class_method TYPE abap_bool.
    DATA lv_class_constructor TYPE abap_bool.
    DATA lv_generator TYPE abap_bool.
    DATA lv_outer_in_generator TYPE abap_bool.
    DATA lv_async TYPE abap_bool.
    DATA lv_outer_in_async TYPE abap_bool.

    lv_async = mv_parsing_async_function.
    CLEAR mv_parsing_async_function.
    lv_class_method = mv_parsing_class_method.
    lv_class_constructor = mv_parsing_class_constructor.
    lv_generator = mv_parsing_generator_method.
    CLEAR mv_parsing_class_method.
    CLEAR mv_parsing_class_constructor.
    CLEAR mv_parsing_generator_method.
    advance( ).
    IF ms_token-kind = zcl_qjs_lexer=>token_star.
      lv_generator = abap_true.
      advance( ).
    ENDIF.
    IF ms_token-kind = zcl_qjs_lexer=>token_identifier.
      lv_name = ms_token-text.
      advance( ).
    ENDIF.
    IF ms_token-kind <> zcl_qjs_lexer=>token_lparen.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected function expression parameter list'.
    ENDIF.
    advance( ).

    lo_outer_emitter = mo_emitter.
    lt_outer_parent_locals = mt_parent_locals.
    lt_outer_finally = mt_finally.
    lt_outer_scopes = mt_scopes.
    lt_outer_hoists = mt_hoists.
    lt_outer_loops = mt_loops.
    lv_outer_in_function = mv_in_function.
    lv_outer_in_generator = mv_in_generator.
    lv_outer_in_async = mv_in_async.
    lr_previous_outer_parent = mr_outer_parent_locals.
    lr_previous_outer_scopes = mr_outer_scopes.
    GET REFERENCE OF lt_outer_parent_locals INTO mr_outer_parent_locals.
    GET REFERENCE OF lt_outer_scopes INTO mr_outer_scopes.
    CREATE OBJECT mo_emitter EXPORTING limits = mo_limits.
    CLEAR mt_parent_locals.
    mv_function_depth = mv_function_depth + 1.
    CLEAR mt_loops.
    CLEAR mt_finally.
    CLEAR mt_scopes.
    CLEAR mt_hoists.
    APPEND lt_root_scope TO mt_scopes.
    mv_in_function = abap_true.
    mv_in_generator = lv_generator.
    mv_in_async = lv_async.

    ls_local-index = mo_emitter->allocate_local( ).
    ls_local-kind = zcl_qjs_function=>capture_local.
    IF lv_name IS NOT INITIAL.
      ls_local-name = lv_name.
      ls_local-function_depth = mv_function_depth.
      INSERT ls_local INTO TABLE mt_locals.
    ENDIF.
    CLEAR ls_local.
    ls_local-name = 'this'.
    ls_local-function_depth = mv_function_depth.
    ls_local-index = mo_emitter->allocate_local( ).
    ls_local-kind = zcl_qjs_function=>capture_local.
    INSERT ls_local INTO TABLE mt_locals.
    CLEAR ls_local.
    ls_local-name = 'arguments'.
    ls_local-function_depth = mv_function_depth.
    ls_local-index = mo_emitter->allocate_local( ).
    ls_local-kind = zcl_qjs_function=>capture_local.
    INSERT ls_local INTO TABLE mt_locals.
    WHILE ms_token-kind <> zcl_qjs_lexer=>token_rparen.
      IF ms_token-kind = zcl_qjs_lexer=>token_ellipsis.
        advance( ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_identifier.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected function rest parameter name'.
        ENDIF.
        CLEAR ls_local.
        ls_local-name = ms_token-text.
        ls_local-function_depth = mv_function_depth.
        ls_local-index = mo_emitter->allocate_local( ).
        ls_local-kind = zcl_qjs_function=>capture_local.
        INSERT ls_local INTO TABLE mt_locals.
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>rest operand = lv_parameter_count ).
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>put_local operand = ls_local-index ).
        advance( ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Function rest parameter must be last'.
        ENDIF.
        CONTINUE.
      ENDIF.
      IF ms_token-kind = zcl_qjs_lexer=>token_lbracket
          OR ms_token-kind = zcl_qjs_lexer=>token_lbrace.
        DATA(lv_expr_pattern_default) = parse_pattern_parameter(
          lv_parameter_count ).
        lv_parameter_count = lv_parameter_count + 1.
        IF lv_expr_pattern_default = abap_true.
          lv_seen_default = abap_true.
        ELSEIF lv_seen_default = abap_false.
          lv_function_length = lv_function_length + 1.
        ENDIF.
        IF ms_token-kind = zcl_qjs_lexer=>token_comma.
          advance( ).
        ELSEIF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected comma after function pattern parameter'.
        ENDIF.
        CONTINUE.
      ENDIF.
      IF ms_token-kind <> zcl_qjs_lexer=>token_identifier.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected function expression parameter'.
      ENDIF.
      CLEAR ls_local.
      ls_local-name = ms_token-text.
      ls_local-function_depth = mv_function_depth.
      ls_local-index = mo_emitter->allocate_local( ).
      ls_local-kind = zcl_qjs_function=>capture_local.
      INSERT ls_local INTO TABLE mt_locals.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>get_arg operand = lv_parameter_count ).
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>put_local operand = ls_local-index ).
      lv_parameter_count = lv_parameter_count + 1.
      advance( ).
      IF ms_token-kind = zcl_qjs_lexer=>token_assign.
        lv_seen_default = abap_true.
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>get_local operand = ls_local-index ).
        mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
        mo_emitter->emit( zif_qjs_opcodes=>strict_equal ).
        lv_default_jump = mo_emitter->position( ).
        mo_emitter->emit( zif_qjs_opcodes=>if_false ).
        advance( ).
        parse_assignment( ).
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>put_local operand = ls_local-index ).
        mo_emitter->patch(
          instruction = lv_default_jump target = mo_emitter->position( ) ).
      ELSEIF lv_seen_default = abap_false.
        lv_function_length = lv_function_length + 1.
      ENDIF.
      IF ms_token-kind = zcl_qjs_lexer=>token_comma.
        advance( ).
      ELSEIF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected comma in function expression parameters'.
      ENDIF.
    ENDWHILE.
    advance( ).
    IF lv_generator = abap_true AND lv_async = abap_true.
      mo_emitter->emit( zif_qjs_opcodes=>initial_yield ).
    ENDIF.
    IF ms_token-kind <> zcl_qjs_lexer=>token_lbrace.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected function expression body'.
    ENDIF.
    predeclare_scope(
      start_offset = mo_lexer->get_offset( ) stop_at_brace = abap_true ).
    capture_parent_bindings( ).
    advance( ).
    mo_emitter->set_signature(
      parameter_count = lv_parameter_count function_length = lv_function_length
      has_self = abap_true has_this = abap_true
      has_arguments = abap_true name = lv_name
      constructible = xsdbool(
        lv_generator = abap_false AND lv_async = abap_false
          AND ( lv_class_method = abap_false OR lv_class_constructor = abap_true ) )
      class_constructor = lv_class_constructor generator = lv_generator
      async = lv_async ).
    WHILE ms_token-kind <> zcl_qjs_lexer=>token_rbrace.
      IF ms_token-kind = zcl_qjs_lexer=>token_eof.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected closing function expression brace'.
      ENDIF.
      parse_statement( ).
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
    ENDWHILE.
    advance( ).
    mo_emitter->emit( zif_qjs_opcodes=>return_undefined ).
    lo_function = mo_emitter->to_function( ).

    mo_emitter = lo_outer_emitter.
    DELETE mt_locals WHERE function_depth = mv_function_depth.
    mv_function_depth = mv_function_depth - 1.
    mt_parent_locals = lt_outer_parent_locals.
    mt_loops = lt_outer_loops.
    mt_finally = lt_outer_finally.
    mt_scopes = lt_outer_scopes.
    mt_hoists = lt_outer_hoists.
    mr_outer_parent_locals = lr_previous_outer_parent.
    mr_outer_scopes = lr_previous_outer_scopes.
    mv_in_function = lv_outer_in_function.
    mv_in_generator = lv_outer_in_generator.
    mv_in_async = lv_outer_in_async.
    mo_last_function = lo_function.
    mo_emitter->emit_closure( zcl_qjs_value=>new_object( lo_function ) ).
  ENDMETHOD.

  METHOD parse_class_declaration.
    parse_class( abap_true ).
  ENDMETHOD.

  METHOD parse_class_field_initializer.
    DATA lo_outer_emitter TYPE REF TO zcl_qjs_emitter.
    DATA lt_outer_locals TYPE ty_function_locals.
    DATA lt_outer_parent_locals TYPE ty_locals.
    DATA lt_outer_loops TYPE ty_loops.
    DATA lt_outer_finally TYPE ty_finally_stack.
    DATA lt_outer_scopes TYPE ty_scopes.
    DATA lt_outer_hoists TYPE ty_hoists.
    DATA lt_root_scope TYPE ty_locals.
    DATA lt_visible_scope TYPE ty_locals.
    DATA ls_visible_binding TYPE ty_local.
    DATA ls_parent_binding TYPE ty_local.
    DATA ls_local TYPE ty_local.
    DATA lv_outer_in_function TYPE abap_bool.

    lo_outer_emitter = mo_emitter.
    lt_outer_locals = mt_locals.
    lt_outer_parent_locals = mt_parent_locals.
    lt_outer_loops = mt_loops.
    lt_outer_finally = mt_finally.
    lt_outer_scopes = mt_scopes.
    lt_outer_hoists = mt_hoists.
    lv_outer_in_function = mv_in_function.

    CREATE OBJECT mo_emitter EXPORTING limits = mo_limits.
    CLEAR mt_parent_locals.
    LOOP AT mt_locals INTO ls_parent_binding
        WHERE function_depth = mv_function_depth.
      INSERT ls_parent_binding INTO TABLE mt_parent_locals.
    ENDLOOP.
    LOOP AT mt_scopes INTO lt_visible_scope.
      LOOP AT lt_visible_scope INTO ls_visible_binding.
        DELETE TABLE mt_parent_locals WITH TABLE KEY name = ls_visible_binding-name.
        INSERT ls_visible_binding INTO TABLE mt_parent_locals.
      ENDLOOP.
    ENDLOOP.
    CLEAR mt_locals.
    CLEAR mt_loops.
    CLEAR mt_finally.
    CLEAR mt_scopes.
    CLEAR mt_hoists.
    APPEND lt_root_scope TO mt_scopes.
    mv_function_depth = mv_function_depth + 1.
    mv_in_function = abap_true.

    ls_local-name = 'this'.
    ls_local-function_depth = mv_function_depth.
    ls_local-index = mo_emitter->allocate_local( ).
    ls_local-kind = zcl_qjs_function=>capture_local.
    INSERT ls_local INTO TABLE mt_locals.
    capture_parent_bindings( ).
    mo_emitter->set_signature(
      parameter_count = 0 function_length = 0 has_this = abap_true
      constructible = abap_false ).
    IF ms_token-kind = zcl_qjs_lexer=>token_assign.
      advance( ).
      parse_assignment( ).
    ELSE.
      mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
    ENDIF.
    mo_emitter->emit( zif_qjs_opcodes=>return ).
    result = mo_emitter->to_function( ).

    mo_emitter = lo_outer_emitter.
    mt_locals = lt_outer_locals.
    mv_function_depth = mv_function_depth - 1.
    mt_parent_locals = lt_outer_parent_locals.
    mt_loops = lt_outer_loops.
    mt_finally = lt_outer_finally.
    mt_scopes = lt_outer_scopes.
    mt_hoists = lt_outer_hoists.
    mv_in_function = lv_outer_in_function.
  ENDMETHOD.

  METHOD parse_class_static_block.
    DATA lo_outer_emitter TYPE REF TO zcl_qjs_emitter.
    DATA lt_outer_locals TYPE ty_function_locals.
    DATA lt_outer_parent_locals TYPE ty_locals.
    DATA lt_outer_loops TYPE ty_loops.
    DATA lt_outer_finally TYPE ty_finally_stack.
    DATA lt_outer_scopes TYPE ty_scopes.
    DATA lt_outer_hoists TYPE ty_hoists.
    DATA lt_root_scope TYPE ty_locals.
    DATA lt_visible_scope TYPE ty_locals.
    DATA ls_visible_binding TYPE ty_local.
    DATA ls_parent_binding TYPE ty_local.
    DATA ls_local TYPE ty_local.
    DATA lv_outer_in_function TYPE abap_bool.

    lo_outer_emitter = mo_emitter.
    lt_outer_locals = mt_locals.
    lt_outer_parent_locals = mt_parent_locals.
    lt_outer_loops = mt_loops.
    lt_outer_finally = mt_finally.
    lt_outer_scopes = mt_scopes.
    lt_outer_hoists = mt_hoists.
    lv_outer_in_function = mv_in_function.

    CREATE OBJECT mo_emitter EXPORTING limits = mo_limits.
    CLEAR mt_parent_locals.
    LOOP AT mt_locals INTO ls_parent_binding
        WHERE function_depth = mv_function_depth.
      INSERT ls_parent_binding INTO TABLE mt_parent_locals.
    ENDLOOP.
    LOOP AT mt_scopes INTO lt_visible_scope.
      LOOP AT lt_visible_scope INTO ls_visible_binding.
        DELETE TABLE mt_parent_locals WITH TABLE KEY name = ls_visible_binding-name.
        INSERT ls_visible_binding INTO TABLE mt_parent_locals.
      ENDLOOP.
    ENDLOOP.
    CLEAR mt_locals.
    CLEAR mt_loops.
    CLEAR mt_finally.
    CLEAR mt_scopes.
    CLEAR mt_hoists.
    APPEND lt_root_scope TO mt_scopes.
    mv_function_depth = mv_function_depth + 1.
    mv_in_function = abap_true.

    ls_local-name = 'this'.
    ls_local-function_depth = mv_function_depth.
    ls_local-index = mo_emitter->allocate_local( ).
    ls_local-kind = zcl_qjs_function=>capture_local.
    INSERT ls_local INTO TABLE mt_locals.
    capture_parent_bindings( ).
    mo_emitter->set_signature(
      parameter_count = 0 function_length = 0 has_this = abap_true
      constructible = abap_false ).
    IF ms_token-kind <> zcl_qjs_lexer=>token_lbrace.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected static initialization block'.
    ENDIF.
    predeclare_scope(
      start_offset = mo_lexer->get_offset( ) stop_at_brace = abap_true ).
    advance( ).
    WHILE ms_token-kind <> zcl_qjs_lexer=>token_rbrace.
      IF ms_token-kind = zcl_qjs_lexer=>token_eof.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected closing static block brace'.
      ENDIF.
      parse_statement( ).
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
    ENDWHILE.
    advance( ).
    mo_emitter->emit( zif_qjs_opcodes=>return_undefined ).
    result = mo_emitter->to_function( ).

    mo_emitter = lo_outer_emitter.
    mt_locals = lt_outer_locals.
    mv_function_depth = mv_function_depth - 1.
    mt_parent_locals = lt_outer_parent_locals.
    mt_loops = lt_outer_loops.
    mt_finally = lt_outer_finally.
    mt_scopes = lt_outer_scopes.
    mt_hoists = lt_outer_hoists.
    mv_in_function = lv_outer_in_function.
  ENDMETHOD.

  METHOD parse_class_expression.
    parse_class( declaration = abap_false inferred_name = inferred_name ).
  ENDMETHOD.

  METHOD parse_class.
    DATA lt_methods TYPE ty_class_methods.
    DATA ls_method TYPE ty_class_method.
    DATA ls_binding TYPE ty_local.
    DATA lt_class_scope TYPE ty_locals.
    DATA lv_class_name TYPE string.
    DATA lv_method_name TYPE string.
    DATA lv_constructor_index TYPE i VALUE -1.
    DATA lv_is_constructor TYPE abap_bool.
    DATA ls_base_binding TYPE ty_local.
    DATA ls_old_super_binding TYPE ty_local.
    DATA lv_old_has_super TYPE abap_bool.
    DATA lv_old_super_static TYPE abap_bool.
    DATA lv_old_super_call_allowed TYPE abap_bool.
    DATA lv_has_base TYPE abap_bool.
    DATA lv_has_class_binding TYPE abap_bool.
    DATA lv_has_class_scope TYPE abap_bool.
    DATA lo_class_scanner TYPE REF TO zcl_qjs_lexer.
    DATA ls_class_lookahead TYPE zcl_qjs_lexer=>ty_token.
    DATA lo_constructor_function TYPE REF TO zcl_qjs_function.
    DATA lv_default_constructor TYPE abap_bool.
    DATA lt_private_names TYPE ty_global_names.
    DATA lt_private_scope TYPE ty_locals.
    DATA ls_private_token TYPE zcl_qjs_lexer=>ty_token.
    DATA lv_private_depth TYPE i.
    DATA lv_private_binding_name TYPE string.
    DATA lv_has_private_scope TYPE abap_bool.
    DATA lt_private_declarations TYPE ty_private_declarations.
    DATA ls_private_declaration TYPE ty_private_declaration.
    DATA lv_private_kind TYPE i.
    DATA lv_private_mode TYPE i.

    advance( ).
    IF declaration = abap_true
        AND ms_token-kind <> zcl_qjs_lexer=>token_identifier.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected class name'.
    ENDIF.
    IF ms_token-kind = zcl_qjs_lexer=>token_identifier.
      lv_class_name = ms_token-text.
      IF declaration = abap_true.
        ls_binding = find_binding( lv_class_name ).
      ELSE.
        APPEND lt_class_scope TO mt_scopes.
        lv_has_class_scope = abap_true.
        declare_lexical( name = lv_class_name constant = abap_true ).
        ls_binding = find_binding( lv_class_name ).
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>reset_lexical operand = ls_binding-index ).
      ENDIF.
      lv_has_class_binding = abap_true.
      advance( ).
    ELSEIF inferred_name IS NOT INITIAL.
      lv_class_name = inferred_name.
    ENDIF.
    IF ms_token-kind = zcl_qjs_lexer=>token_extends.
      advance( ).
      IF ms_token-kind <> zcl_qjs_lexer=>token_identifier.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected base class name'.
      ENDIF.
      ls_base_binding = find_binding( ms_token-text ).
      lv_has_base = abap_true.
      advance( ).
    ENDIF.
    IF ms_token-kind <> zcl_qjs_lexer=>token_lbrace.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected class body'.
    ENDIF.
    ls_old_super_binding = ms_super_binding.
    lv_old_has_super = mv_has_super.
    lv_old_super_static = mv_super_static.
    lv_old_super_call_allowed = mv_super_call_allowed.
    ms_super_binding = ls_base_binding.
    mv_has_super = lv_has_base.
    CREATE OBJECT lo_class_scanner EXPORTING cache = mo_lexer.
    lo_class_scanner->set_offset( mo_lexer->get_offset( ) ).
    WHILE abap_true = abap_true.
      lo_class_scanner->next_into( CHANGING token = ls_private_token ).
      IF ls_private_token-kind = zcl_qjs_lexer=>token_lbrace.
        lv_private_depth = lv_private_depth + 1.
      ELSEIF ls_private_token-kind = zcl_qjs_lexer=>token_rbrace.
        IF lv_private_depth = 0.
          EXIT.
        ENDIF.
        lv_private_depth = lv_private_depth - 1.
      ELSEIF ls_private_token-kind = zcl_qjs_lexer=>token_private_identifier
          AND lv_private_depth = 0.
        READ TABLE lt_private_names WITH KEY table_line = ls_private_token-text
          TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          APPEND ls_private_token-text TO lt_private_names.
        ENDIF.
      ELSEIF ls_private_token-kind = zcl_qjs_lexer=>token_eof.
        EXIT.
      ENDIF.
    ENDWHILE.
    IF lines( lt_private_names ) > 0.
      APPEND lt_private_scope TO mt_scopes.
      lv_has_private_scope = abap_true.
      LOOP AT lt_private_names INTO DATA(lv_private_name).
        lv_private_binding_name = '#' && lv_private_name.
        declare_lexical( name = lv_private_binding_name constant = abap_true ).
        DATA(ls_private_binding) = find_binding( lv_private_binding_name ).
        mo_emitter->emit(
          opcode  = zif_qjs_opcodes=>private_symbol
          operand = mo_emitter->intern_atom( lv_private_name ) ).
        mo_emitter->emit(
          opcode  = zif_qjs_opcodes=>initialize_lexical
          operand = ls_private_binding-index ).
      ENDLOOP.
    ENDIF.
    advance( ).
    WHILE ms_token-kind <> zcl_qjs_lexer=>token_rbrace.
      IF ms_token-kind = zcl_qjs_lexer=>token_semicolon.
        advance( ).
        CONTINUE.
      ENDIF.
      CLEAR ls_method.
      IF ms_token-kind = zcl_qjs_lexer=>token_identifier
          AND ms_token-text = 'static'.
        CREATE OBJECT lo_class_scanner EXPORTING cache = mo_lexer.
        lo_class_scanner->set_offset( mo_lexer->get_offset( ) ).
        lo_class_scanner->next_into( CHANGING token = ls_class_lookahead ).
        IF ls_class_lookahead-kind <> zcl_qjs_lexer=>token_lparen
            AND ls_class_lookahead-kind <> zcl_qjs_lexer=>token_assign
            AND ls_class_lookahead-kind <> zcl_qjs_lexer=>token_semicolon
            AND ls_class_lookahead-kind <> zcl_qjs_lexer=>token_rbrace.
          ls_method-static = abap_true.
          advance( ).
        ENDIF.
      ENDIF.
      IF ls_method-static = abap_true
          AND ms_token-kind = zcl_qjs_lexer=>token_lbrace.
        ls_method-static_block = abap_true.
        mv_super_static = abap_true.
        mv_super_call_allowed = abap_false.
        ls_method-initializer = parse_class_static_block( ).
        APPEND ls_method TO lt_methods.
        CONTINUE.
      ENDIF.
      IF ms_token-kind = zcl_qjs_lexer=>token_identifier
          AND ms_token-text = 'async'.
        CREATE OBJECT lo_class_scanner EXPORTING cache = mo_lexer.
        lo_class_scanner->set_offset( mo_lexer->get_offset( ) ).
        lo_class_scanner->next_into( CHANGING token = ls_class_lookahead ).
        IF ls_class_lookahead-line_terminator_before = abap_false
            AND ls_class_lookahead-kind <> zcl_qjs_lexer=>token_lparen
            AND ls_class_lookahead-kind <> zcl_qjs_lexer=>token_assign
            AND ls_class_lookahead-kind <> zcl_qjs_lexer=>token_semicolon
            AND ls_class_lookahead-kind <> zcl_qjs_lexer=>token_rbrace.
          ls_method-async = abap_true.
          advance( ).
        ENDIF.
      ENDIF.
      IF ms_token-kind = zcl_qjs_lexer=>token_star.
        ls_method-generator = abap_true.
        advance( ).
      ENDIF.
      IF ms_token-kind = zcl_qjs_lexer=>token_identifier
          AND ( ms_token-text = 'get' OR ms_token-text = 'set' ).
        CREATE OBJECT lo_class_scanner EXPORTING cache = mo_lexer.
        lo_class_scanner->set_offset( mo_lexer->get_offset( ) ).
        lo_class_scanner->next_into( CHANGING token = ls_class_lookahead ).
        IF ls_class_lookahead-kind <> zcl_qjs_lexer=>token_lparen.
          IF ms_token-text = 'get'.
            ls_method-accessor_kind = 1.
          ELSE.
            ls_method-accessor_kind = 2.
          ENDIF.
          advance( ).
        ENDIF.
      ENDIF.
      IF ms_token-kind = zcl_qjs_lexer=>token_lbracket.
        ls_method-computed = abap_true.
        advance( ).
        parse_expression( ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected closing computed class method bracket'.
        ENDIF.
        ls_method-key_local_index = mo_emitter->allocate_local( ).
        mo_emitter->emit(
          opcode  = zif_qjs_opcodes=>put_local
          operand = ls_method-key_local_index ).
        CLEAR lv_method_name.
      ELSE.
        IF ms_token-kind = zcl_qjs_lexer=>token_private_identifier.
          ls_method-private = abap_true.
          lv_method_name = ms_token-text.
        ELSEIF is_identifier_name( ms_token-kind ) = abap_false
            AND ms_token-kind <> zcl_qjs_lexer=>token_string
            AND ms_token-kind <> zcl_qjs_lexer=>token_number.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected class method name'.
        ELSE.
          lv_method_name = ms_token-text.
          IF ms_token-kind = zcl_qjs_lexer=>token_number.
            lv_method_name = zcl_qjs_value=>to_string(
              zcl_qjs_number=>parse_literal( ms_token-text ) ).
          ENDIF.
        ENDIF.
      ENDIF.
      ls_method-name = lv_method_name.
      IF ls_method-accessor_kind = 0.
        CREATE OBJECT lo_class_scanner EXPORTING cache = mo_lexer.
        lo_class_scanner->set_offset( mo_lexer->get_offset( ) ).
        lo_class_scanner->next_into( CHANGING token = ls_class_lookahead ).
        IF ls_class_lookahead-kind = zcl_qjs_lexer=>token_assign
            OR ls_class_lookahead-kind = zcl_qjs_lexer=>token_semicolon
            OR ls_class_lookahead-kind = zcl_qjs_lexer=>token_rbrace
            OR ls_class_lookahead-line_terminator_before = abap_true
            OR ( ls_method-private = abap_true
              AND ls_class_lookahead-kind <> zcl_qjs_lexer=>token_lparen ).
          IF ls_method-computed = abap_false AND ls_method-private = abap_false
              AND ( lv_method_name = `constructor`
                OR ( ls_method-static = abap_true
                  AND lv_method_name = `prototype` ) ).
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Invalid class field name'.
          ENDIF.
          ls_method-field = abap_true.
          advance( ).
          mv_super_static = ls_method-static.
          mv_super_call_allowed = abap_false.
          ls_method-initializer = parse_class_field_initializer( ).
          APPEND ls_method TO lt_methods.
          IF ms_token-kind = zcl_qjs_lexer=>token_semicolon.
            advance( ).
          ENDIF.
          CONTINUE.
        ENDIF.
      ENDIF.
      lv_is_constructor = abap_false.
      IF lv_method_name = `constructor` AND ls_method-accessor_kind = 0.
        IF ls_method-async = abap_true.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Class constructor cannot be async'.
        ENDIF.
        IF ls_method-generator = abap_true.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Class constructor cannot be a generator'.
        ENDIF.
        IF ls_method-static = abap_false.
          lv_is_constructor = abap_true.
        ENDIF.
      ENDIF.
      ls_method-constructor = lv_is_constructor.
      mv_parsing_class_method = abap_true.
      mv_parsing_class_constructor = lv_is_constructor.
      mv_parsing_generator_method = ls_method-generator.
      mv_parsing_async_function = ls_method-async.
      mv_super_static = ls_method-static.
      mv_super_call_allowed = lv_is_constructor.
      ms_token-kind = zcl_qjs_lexer=>token_function.
      parse_function_expression( ).
      ls_method-local_index = mo_emitter->allocate_local( ).
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>put_local operand = ls_method-local_index ).
      IF lv_is_constructor = abap_true.
        IF lv_constructor_index >= 0.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Duplicate class constructor'.
        ENDIF.
        lv_constructor_index = ls_method-local_index.
        lo_constructor_function = mo_last_function.
      ENDIF.
      APPEND ls_method TO lt_methods.
    ENDWHILE.

    LOOP AT lt_methods INTO ls_method WHERE private = abap_true.
      IF ls_method-name = `constructor`.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Invalid private name: #constructor'.
      ENDIF.
      IF ls_method-field = abap_true.
        lv_private_kind = 1.
      ELSEIF ls_method-accessor_kind = 1.
        lv_private_kind = 2.
      ELSEIF ls_method-accessor_kind = 2.
        lv_private_kind = 3.
      ELSE.
        lv_private_kind = 4.
      ENDIF.
      READ TABLE lt_private_declarations
        WITH TABLE KEY name = ls_method-name INTO ls_private_declaration.
      IF sy-subrc = 0.
        IF ls_private_declaration-static <> ls_method-static
            OR NOT ( ( ls_private_declaration-kind = 2 AND lv_private_kind = 3 )
              OR ( ls_private_declaration-kind = 3 AND lv_private_kind = 2 ) ).
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Duplicate private class element: #'
              && ls_method-name.
        ENDIF.
        ls_private_declaration-kind = 5.
        DELETE TABLE lt_private_declarations
          WITH TABLE KEY name = ls_method-name.
        INSERT ls_private_declaration INTO TABLE lt_private_declarations.
      ELSE.
        CLEAR ls_private_declaration.
        ls_private_declaration-name = ls_method-name.
        ls_private_declaration-static = ls_method-static.
        ls_private_declaration-kind = lv_private_kind.
        INSERT ls_private_declaration INTO TABLE lt_private_declarations.
      ENDIF.
    ENDLOOP.
    LOOP AT lt_private_names INTO lv_private_name.
      READ TABLE lt_private_declarations WITH TABLE KEY name = lv_private_name
        TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Undeclared private name: #' && lv_private_name.
      ENDIF.
    ENDLOOP.
    advance( ).
    ms_super_binding = ls_old_super_binding.
    mv_has_super = lv_old_has_super.
    mv_super_static = lv_old_super_static.
    mv_super_call_allowed = lv_old_super_call_allowed.

    IF lv_constructor_index < 0.
      lv_default_constructor = abap_true.
      DATA(lo_default_emitter) = NEW zcl_qjs_emitter( limits = mo_limits ).
      lo_default_emitter->set_signature(
        parameter_count = 0 function_length = 0 name = lv_class_name
        class_constructor = abap_true ).
      lo_default_emitter->emit( zif_qjs_opcodes=>return_undefined ).
      lo_constructor_function = lo_default_emitter->to_function( ).
      mo_emitter->emit_closure(
        zcl_qjs_value=>new_object( lo_constructor_function ) ).
      lv_constructor_index = mo_emitter->allocate_local( ).
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>put_local operand = lv_constructor_index ).
    ENDIF.

    lo_constructor_function->set_class_field_metadata(
      derived         = lv_has_base
      default_derived = xsdbool(
        lv_default_constructor = abap_true AND lv_has_base = abap_true ) ).
    lo_constructor_function->set_name( lv_class_name ).

    mo_emitter->emit(
      opcode = zif_qjs_opcodes=>get_local operand = lv_constructor_index ).
    IF lv_has_class_binding = abap_true.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>initialize_lexical operand = ls_binding-index ).
    ELSE.
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
    ENDIF.
    IF lv_has_base = abap_true.
      DATA(ls_object_binding) = find_binding( 'Object' ).
      DATA(lv_set_prototype_atom) = mo_emitter->intern_atom( 'setPrototypeOf' ).
      emit_binding_get( ls_object_binding ).
      mo_emitter->emit(
        opcode  = zif_qjs_opcodes=>get_field_for_call
        operand = lv_set_prototype_atom ).
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>get_local operand = lv_constructor_index ).
      emit_binding_get( ls_base_binding ).
      mo_emitter->emit( opcode = zif_qjs_opcodes=>call_method operand = 2 ).
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
      emit_binding_get( ls_object_binding ).
      mo_emitter->emit(
        opcode  = zif_qjs_opcodes=>get_field_for_call
        operand = lv_set_prototype_atom ).
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>get_local operand = lv_constructor_index ).
      mo_emitter->emit(
        opcode  = zif_qjs_opcodes=>get_field
        operand = mo_emitter->intern_atom( 'prototype' ) ).
      emit_binding_get( ls_base_binding ).
      mo_emitter->emit(
        opcode  = zif_qjs_opcodes=>get_field
        operand = mo_emitter->intern_atom( 'prototype' ) ).
      mo_emitter->emit( opcode = zif_qjs_opcodes=>call_method operand = 2 ).
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
    ENDIF.
    LOOP AT lt_methods INTO ls_method WHERE constructor = abap_false.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>get_local operand = lv_constructor_index ).
      IF ls_method-static_block = abap_true.
        mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
        mo_emitter->emit_closure(
          zcl_qjs_value=>new_object( ls_method-initializer ) ).
        mo_emitter->emit( opcode = zif_qjs_opcodes=>call_method operand = 0 ).
        mo_emitter->emit( zif_qjs_opcodes=>drop ).
        mo_emitter->emit( zif_qjs_opcodes=>drop ).
        CONTINUE.
      ENDIF.
      IF ls_method-field = abap_true.
        IF ls_method-static = abap_false.
          IF ls_method-private = abap_true.
            emit_binding_get( find_binding( '#' && ls_method-name ) ).
          ELSEIF ls_method-computed = abap_true.
            mo_emitter->emit(
              opcode  = zif_qjs_opcodes=>get_local
              operand = ls_method-key_local_index ).
          ELSE.
            mo_emitter->emit_constant(
              zcl_qjs_value=>new_string( ls_method-name ) ).
          ENDIF.
          mo_emitter->emit_closure(
            zcl_qjs_value=>new_object( ls_method-initializer ) ).
          mo_emitter->emit(
            opcode   = zif_qjs_opcodes=>define_field
            operand2 = COND i(
              WHEN ls_method-private = abap_true THEN 3 ELSE 1 ) ).
        ELSE.
          mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
          mo_emitter->emit_closure(
            zcl_qjs_value=>new_object( ls_method-initializer ) ).
          mo_emitter->emit( opcode = zif_qjs_opcodes=>call_method operand = 0 ).
          IF ls_method-private = abap_true.
            emit_binding_get( find_binding( '#' && ls_method-name ) ).
            mo_emitter->emit( zif_qjs_opcodes=>swap ).
            mo_emitter->emit( zif_qjs_opcodes=>define_private_field ).
          ELSEIF ls_method-computed = abap_true.
            mo_emitter->emit(
              opcode  = zif_qjs_opcodes=>get_local
              operand = ls_method-key_local_index ).
            mo_emitter->emit( zif_qjs_opcodes=>swap ).
            mo_emitter->emit(
              opcode = zif_qjs_opcodes=>define_field operand2 = 2 ).
          ELSE.
            mo_emitter->emit(
              opcode  = zif_qjs_opcodes=>define_field
              operand = mo_emitter->intern_atom( ls_method-name ) ).
          ENDIF.
        ENDIF.
        mo_emitter->emit( zif_qjs_opcodes=>drop ).
        CONTINUE.
      ENDIF.
      IF ls_method-private = abap_true.
        emit_binding_get( find_binding( '#' && ls_method-name ) ).
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>get_local operand = ls_method-local_index ).
        IF ls_method-accessor_kind = 1.
          lv_private_mode = COND i(
            WHEN ls_method-static = abap_true THEN 8 ELSE 6 ).
        ELSEIF ls_method-accessor_kind = 2.
          lv_private_mode = COND i(
            WHEN ls_method-static = abap_true THEN 9 ELSE 7 ).
        ELSE.
          lv_private_mode = COND i(
            WHEN ls_method-static = abap_true THEN 5 ELSE 4 ).
        ENDIF.
        mo_emitter->emit(
          opcode   = zif_qjs_opcodes=>define_field
          operand2 = lv_private_mode ).
        mo_emitter->emit( zif_qjs_opcodes=>drop ).
        CONTINUE.
      ENDIF.
      IF ls_method-static = abap_false.
        mo_emitter->emit(
          opcode  = zif_qjs_opcodes=>get_field
          operand = mo_emitter->intern_atom( 'prototype' ) ).
      ENDIF.
      IF ls_method-computed = abap_true.
        mo_emitter->emit(
          opcode  = zif_qjs_opcodes=>get_local
          operand = ls_method-key_local_index ).
      ENDIF.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>get_local operand = ls_method-local_index ).
      IF ls_method-computed = abap_true.
        mo_emitter->emit(
          opcode  = zif_qjs_opcodes=>define_method_computed
          operand = ls_method-accessor_kind ).
      ELSE.
        mo_emitter->emit(
          opcode   = zif_qjs_opcodes=>define_method
          operand  = mo_emitter->intern_atom( ls_method-name )
          operand2 = ls_method-accessor_kind ).
      ENDIF.
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
    ENDLOOP.
    IF declaration = abap_true.
      mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
    ELSE.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>get_local operand = lv_constructor_index ).
    ENDIF.
    IF lv_has_private_scope = abap_true.
      DELETE mt_scopes INDEX lines( mt_scopes ).
    ENDIF.
    IF lv_has_class_scope = abap_true.
      DELETE mt_scopes INDEX lines( mt_scopes ).
    ENDIF.
  ENDMETHOD.

  METHOD ensure_parent_binding.
    READ TABLE mt_parent_locals WITH TABLE KEY name = name
      TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      result = abap_true.
      RETURN.
    ENDIF.
    DATA ls_parent TYPE ty_local.
    IF mr_outer_scopes IS BOUND.
      DATA(lv_scope_index) = lines( mr_outer_scopes->* ).
      WHILE lv_scope_index > 0.
        READ TABLE mr_outer_scopes->* INDEX lv_scope_index
          ASSIGNING FIELD-SYMBOL(<lt_outer_scope>).
        READ TABLE <lt_outer_scope> WITH TABLE KEY name = name
          INTO ls_parent.
        IF sy-subrc = 0.
          INSERT ls_parent INTO TABLE mt_parent_locals.
          result = abap_true.
          RETURN.
        ENDIF.
        lv_scope_index = lv_scope_index - 1.
      ENDWHILE.
    ENDIF.
    IF mv_function_depth > 0.
      READ TABLE mt_locals WITH TABLE KEY name = name
        function_depth = mv_function_depth - 1 INTO ls_parent.
      IF sy-subrc = 0.
        INSERT ls_parent INTO TABLE mt_parent_locals.
        result = abap_true.
        RETURN.
      ENDIF.
    ENDIF.
    IF mr_outer_parent_locals IS BOUND.
      READ TABLE mr_outer_parent_locals->* WITH TABLE KEY name = name
        INTO ls_parent.
      IF sy-subrc = 0.
        INSERT ls_parent INTO TABLE mt_parent_locals.
        result = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD find_binding.
    DATA ls_local TYPE ty_local.
    DATA lv_scope_index TYPE i.
    lv_scope_index = lines( mt_scopes ).
    WHILE lv_scope_index > 0.
      READ TABLE mt_scopes INDEX lv_scope_index ASSIGNING FIELD-SYMBOL(<lt_scope>).
      READ TABLE <lt_scope> WITH TABLE KEY name = name INTO ls_local.
      IF sy-subrc = 0.
        result = ls_local.
        RETURN.
      ENDIF.
      lv_scope_index = lv_scope_index - 1.
    ENDWHILE.
    READ TABLE mt_locals WITH TABLE KEY name = name
      function_depth = mv_function_depth INTO ls_local.
    IF sy-subrc = 0.
      IF name = 'arguments'.
        mo_emitter->mark_arguments_used( ).
      ENDIF.
      result = ls_local.
      RETURN.
    ENDIF.
    ensure_parent_binding( name ).
    READ TABLE mt_parent_locals WITH TABLE KEY name = name INTO ls_local.
    IF sy-subrc = 0.
      result-name = name.
      IF ls_local-kind = zcl_qjs_function=>capture_parent.
        result-index = mo_emitter->allocate_capture(
          source_kind  = zcl_qjs_function=>capture_parent
          source_index = ls_local-index ).
      ELSE.
        result-index = mo_emitter->allocate_capture(
          source_kind  = zcl_qjs_function=>capture_local
          source_index = ls_local-index ).
      ENDIF.
      result-kind = zcl_qjs_function=>capture_parent.
      result-function_depth = mv_function_depth.
      INSERT result INTO TABLE mt_locals.
      RETURN.
    ENDIF.
    RAISE EXCEPTION TYPE zcx_qjs_error
      EXPORTING reason = 'Unknown JavaScript identifier: ' && name.
  ENDMETHOD.

  METHOD has_binding.
    DATA lv_scope_index TYPE i.
    lv_scope_index = lines( mt_scopes ).
    WHILE lv_scope_index > 0.
      READ TABLE mt_scopes INDEX lv_scope_index ASSIGNING FIELD-SYMBOL(<lt_scope>).
      READ TABLE <lt_scope> WITH TABLE KEY name = name TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        result = abap_true.
        RETURN.
      ENDIF.
      lv_scope_index = lv_scope_index - 1.
    ENDWHILE.
    READ TABLE mt_locals WITH TABLE KEY name = name
      function_depth = mv_function_depth TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      result = abap_true.
      RETURN.
    ENDIF.
    ensure_parent_binding( name ).
    READ TABLE mt_parent_locals WITH TABLE KEY name = name TRANSPORTING NO FIELDS.
    result = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.

  METHOD capture_parent_bindings.
    DATA ls_local TYPE ty_local.
    DATA ls_parent_binding TYPE ty_local.
    DEFINE qjs_capture_binding.
      READ TABLE mt_locals WITH TABLE KEY name = ls_parent_binding-name
        function_depth = mv_function_depth
        TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        CLEAR ls_local.
        ls_local-name = ls_parent_binding-name.
        ls_local-function_depth = mv_function_depth.
        IF ls_parent_binding-kind = zcl_qjs_function=>capture_parent.
          ls_local-index = mo_emitter->append_capture(
            source_kind  = zcl_qjs_function=>capture_parent
            source_index = ls_parent_binding-index ).
        ELSE.
          ls_local-index = mo_emitter->append_capture(
            source_kind  = zcl_qjs_function=>capture_local
            source_index = ls_parent_binding-index ).
        ENDIF.
        ls_local-kind = zcl_qjs_function=>capture_parent.
        INSERT ls_local INTO TABLE mt_locals.
      ENDIF.
    END-OF-DEFINITION.
    IF mv_capture_filter_ready = abap_true.
      LOOP AT mt_capture_names INTO DATA(lv_capture_name).
        READ TABLE mt_parent_locals WITH TABLE KEY name = lv_capture_name
          INTO ls_parent_binding.
        IF sy-subrc = 0. qjs_capture_binding. ENDIF.
      ENDLOOP.
    ELSE.
      LOOP AT mt_parent_locals INTO ls_parent_binding.
        qjs_capture_binding.
      ENDLOOP.
    ENDIF.
    CLEAR mv_capture_filter_ready.
    CLEAR mt_capture_names.
  ENDMETHOD.

  METHOD pattern_end_offset.
    DATA lo_scanner TYPE REF TO zcl_qjs_lexer.
    DATA ls_scan TYPE zcl_qjs_lexer=>ty_token.
    DATA lv_brackets TYPE i.
    DATA lv_braces TYPE i.
    CREATE OBJECT lo_scanner EXPORTING cache = mo_lexer.
    lo_scanner->set_offset( start_offset ).
    WHILE abap_true = abap_true.
      lo_scanner->next_into( CHANGING token = ls_scan ).
      IF ls_scan-kind = zcl_qjs_lexer=>token_eof.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Unterminated destructuring pattern'.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_lbracket.
        lv_brackets = lv_brackets + 1.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_rbracket.
        lv_brackets = lv_brackets - 1.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_lbrace.
        lv_braces = lv_braces + 1.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_rbrace.
        lv_braces = lv_braces - 1.
      ENDIF.
      IF lv_brackets = 0 AND lv_braces = 0.
        result = lo_scanner->get_offset( ).
        RETURN.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD emit_binding_default.
    DATA lv_use_value_jump TYPE i.
    IF ms_token-kind <> zcl_qjs_lexer=>token_assign.
      RETURN.
    ENDIF.
    mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
    mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
    mo_emitter->emit( zif_qjs_opcodes=>strict_equal ).
    lv_use_value_jump = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>if_false ).
    mo_emitter->emit( zif_qjs_opcodes=>drop ).
    advance( ).
    parse_assignment( ).
    mo_emitter->patch(
      instruction = lv_use_value_jump target = mo_emitter->position( ) ).
  ENDMETHOD.

  METHOD parse_binding_pattern.
    DATA ls_binding TYPE ty_local.
    DATA lv_name TYPE string.
    CASE ms_token-kind.
      WHEN zcl_qjs_lexer=>token_identifier.
        lv_name = ms_token-text.
        ls_binding = find_binding( lv_name ).
        advance( ).
        IF assignment = abap_true
            AND ( ms_token-kind = zcl_qjs_lexer=>token_dot
              OR ms_token-kind = zcl_qjs_lexer=>token_lbracket ).
          parse_member_binding( ls_binding ).
        ELSE.
          emit_binding_default( ).
        IF lexical = abap_true.
          mo_emitter->emit(
            opcode  = zif_qjs_opcodes=>initialize_lexical
            operand = ls_binding-index ).
        ELSE.
          emit_binding_put( ls_binding ).
        ENDIF.
        ENDIF.
      WHEN zcl_qjs_lexer=>token_lbracket.
        parse_array_binding( lexical = lexical assignment = assignment ).
      WHEN zcl_qjs_lexer=>token_lbrace.
        parse_object_binding( lexical = lexical assignment = assignment ).
      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected destructuring binding target'.
    ENDCASE.
  ENDMETHOD.

  METHOD parse_member_binding.
    emit_binding_get( binding ).
    WHILE ms_token-kind = zcl_qjs_lexer=>token_dot
        OR ms_token-kind = zcl_qjs_lexer=>token_lbracket.
      IF ms_token-kind = zcl_qjs_lexer=>token_dot.
        advance( ).
        IF is_identifier_name( ms_token-kind ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected destructuring member property'.
        ENDIF.
        DATA(lv_member_atom) = mo_emitter->intern_atom( ms_token-text ).
        advance( ).
        IF ms_token-kind = zcl_qjs_lexer=>token_dot
            OR ms_token-kind = zcl_qjs_lexer=>token_lbracket.
          mo_emitter->emit(
            opcode = zif_qjs_opcodes=>get_field operand = lv_member_atom ).
        ELSE.
          mo_emitter->emit( zif_qjs_opcodes=>swap ).
          emit_binding_default( ).
          mo_emitter->emit(
            opcode = zif_qjs_opcodes=>put_field operand = lv_member_atom ).
          RETURN.
        ENDIF.
      ELSE.
        advance( ).
        parse_expression( ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected destructuring member bracket'.
        ENDIF.
        advance( ).
        IF ms_token-kind = zcl_qjs_lexer=>token_dot
            OR ms_token-kind = zcl_qjs_lexer=>token_lbracket.
          mo_emitter->emit( zif_qjs_opcodes=>get_element ).
        ELSE.
          mo_emitter->emit( zif_qjs_opcodes=>permute_three ).
          mo_emitter->emit( zif_qjs_opcodes=>swap ).
          emit_binding_default( ).
          mo_emitter->emit( zif_qjs_opcodes=>put_element ).
          RETURN.
        ENDIF.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD parse_array_binding.
    DATA lv_done_jump TYPE i.
    DATA lv_has_element TYPE abap_bool.
    advance( ).
    mo_emitter->emit( zif_qjs_opcodes=>for_of_start ).
    WHILE ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
      IF ms_token-kind = zcl_qjs_lexer=>token_comma.
        mo_emitter->emit( zif_qjs_opcodes=>for_of_next ).
        mo_emitter->emit( zif_qjs_opcodes=>drop ).
        mo_emitter->emit( zif_qjs_opcodes=>drop ).
        lv_has_element = abap_true.
        advance( ).
        CONTINUE.
      ELSEIF ms_token-kind = zcl_qjs_lexer=>token_ellipsis.
        advance( ).
        mo_emitter->emit( zif_qjs_opcodes=>new_array ).
        mo_emitter->emit( opcode = zif_qjs_opcodes=>push_i32 operand = 0 ).
        mo_emitter->emit( zif_qjs_opcodes=>permute_three ).
        mo_emitter->emit( zif_qjs_opcodes=>swap ).
        mo_emitter->emit( zif_qjs_opcodes=>append ).
        mo_emitter->emit( zif_qjs_opcodes=>drop ).
        parse_binding_pattern( lexical = lexical assignment = assignment ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Array rest binding must be last'.
        ENDIF.
        advance( ).
        RETURN.
      ENDIF.
      mo_emitter->emit( zif_qjs_opcodes=>for_of_next ).
      mo_emitter->emit( zif_qjs_opcodes=>swap ).
      parse_binding_pattern( lexical = lexical assignment = assignment ).
      lv_has_element = abap_true.
      IF ms_token-kind = zcl_qjs_lexer=>token_comma.
        advance( ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
          mo_emitter->emit( zif_qjs_opcodes=>drop ).
          CONTINUE.
        ENDIF.
      ELSEIF ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected comma in array binding pattern'.
      ENDIF.
      EXIT.
    ENDWHILE.
    advance( ).
    IF lv_has_element = abap_true.
      lv_done_jump = mo_emitter->position( ).
      mo_emitter->emit( zif_qjs_opcodes=>if_true ).
      mo_emitter->emit( zif_qjs_opcodes=>iterator_close ).
      mo_emitter->patch(
        instruction = lv_done_jump target = mo_emitter->position( ) ).
    ELSE.
      mo_emitter->emit( zif_qjs_opcodes=>iterator_close ).
    ENDIF.
  ENDMETHOD.

  METHOD parse_object_binding.
    DATA lv_source_local TYPE i.
    DATA lv_exclude_local TYPE i.
    DATA lv_key_local TYPE i.
    DATA lv_atom TYPE i.
    DATA lv_name TYPE string.
    DATA lv_computed TYPE abap_bool.
    lv_source_local = mo_emitter->allocate_local( ).
    lv_exclude_local = mo_emitter->allocate_local( ).
    mo_emitter->emit( zif_qjs_opcodes=>to_object ).
    mo_emitter->emit(
      opcode = zif_qjs_opcodes=>put_local operand = lv_source_local ).
    mo_emitter->emit( zif_qjs_opcodes=>new_object ).
    mo_emitter->emit(
      opcode = zif_qjs_opcodes=>put_local operand = lv_exclude_local ).
    advance( ).
    WHILE ms_token-kind <> zcl_qjs_lexer=>token_rbrace.
      IF ms_token-kind = zcl_qjs_lexer=>token_ellipsis.
        advance( ).
        mo_emitter->emit( zif_qjs_opcodes=>new_object ).
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>get_local operand = lv_source_local ).
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>get_local operand = lv_exclude_local ).
        mo_emitter->emit( zif_qjs_opcodes=>copy_data_properties ).
        mo_emitter->emit( zif_qjs_opcodes=>drop ).
        mo_emitter->emit( zif_qjs_opcodes=>drop ).
        parse_binding_pattern( lexical = lexical assignment = assignment ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_rbrace.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Object rest binding must be last'.
        ENDIF.
        advance( ).
        RETURN.
      ENDIF.
      CLEAR lv_computed.
      IF ms_token-kind = zcl_qjs_lexer=>token_lbracket.
        lv_computed = abap_true.
        lv_key_local = mo_emitter->allocate_local( ).
        advance( ).
        parse_expression( ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected closing computed binding bracket'.
        ENDIF.
        advance( ).
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>put_local operand = lv_key_local ).
      ELSE.
        IF is_identifier_name( ms_token-kind ) = abap_false
            AND ms_token-kind <> zcl_qjs_lexer=>token_string
            AND ms_token-kind <> zcl_qjs_lexer=>token_number.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected object binding property name'.
        ENDIF.
        lv_name = ms_token-text.
        IF ms_token-kind = zcl_qjs_lexer=>token_number.
          lv_name = zcl_qjs_value=>to_string(
            zcl_qjs_number=>parse_literal( ms_token-text ) ).
        ENDIF.
        lv_atom = mo_emitter->intern_atom( lv_name ).
        advance( ).
      ENDIF.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>get_local operand = lv_exclude_local ).
      IF lv_computed = abap_true.
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>get_local operand = lv_key_local ).
        mo_emitter->emit( zif_qjs_opcodes=>push_true ).
        mo_emitter->emit( zif_qjs_opcodes=>put_element ).
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>get_local operand = lv_source_local ).
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>get_local operand = lv_key_local ).
        mo_emitter->emit( zif_qjs_opcodes=>get_element ).
      ELSE.
        mo_emitter->emit( zif_qjs_opcodes=>push_true ).
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>put_field operand = lv_atom ).
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>get_local operand = lv_source_local ).
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>get_field operand = lv_atom ).
      ENDIF.
      IF ms_token-kind = zcl_qjs_lexer=>token_colon.
        advance( ).
        parse_binding_pattern( lexical = lexical assignment = assignment ).
      ELSEIF lv_computed = abap_false.
        mo_lexer->set_offset( ms_token-offset ).
        ms_token-kind = zcl_qjs_lexer=>token_identifier.
        ms_token-text = lv_name.
        parse_binding_pattern( lexical = lexical assignment = assignment ).
      ELSE.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Computed binding property requires a target'.
      ENDIF.
      IF ms_token-kind = zcl_qjs_lexer=>token_comma.
        advance( ).
      ELSEIF ms_token-kind <> zcl_qjs_lexer=>token_rbrace.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected comma in object binding pattern'.
      ENDIF.
    ENDWHILE.
    advance( ).
  ENDMETHOD.

  METHOD parse_pattern_declaration.
    DATA lv_start_offset TYPE i.
    DATA lv_end_offset TYPE i.
    DATA lv_resume_offset TYPE i.
    DATA ls_resume_token TYPE zcl_qjs_lexer=>ty_token.
    lv_start_offset = ms_token-offset.
    lv_end_offset = pattern_end_offset( lv_start_offset ).
    mo_lexer->set_offset( lv_end_offset ).
    advance( ).
    IF ms_token-kind <> zcl_qjs_lexer=>token_assign.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Destructuring declaration requires an initializer'.
    ENDIF.
    advance( ).
    parse_assignment( ).
    ls_resume_token = ms_token.
    lv_resume_offset = mo_lexer->get_offset( ).
    mo_lexer->set_offset( lv_start_offset ).
    advance( ).
    parse_binding_pattern( lexical ).
    mo_lexer->set_offset( lv_resume_offset ).
    ms_token = ls_resume_token.
  ENDMETHOD.

  METHOD parse_pattern_parameter.
    DATA lo_scanner TYPE REF TO zcl_qjs_lexer.
    DATA ls_opening TYPE zcl_qjs_lexer=>ty_token.
    DATA ls_resume_token TYPE zcl_qjs_lexer=>ty_token.
    DATA lv_start_offset TYPE i.
    DATA lv_end_offset TYPE i.
    DATA lv_resume_offset TYPE i.
    lv_start_offset = ms_token-offset.
    lv_end_offset = pattern_end_offset( lv_start_offset ).
    CREATE OBJECT lo_scanner EXPORTING cache = mo_lexer.
    lo_scanner->set_offset( lv_start_offset ).
    lo_scanner->next_into( CHANGING token = ls_opening ).
    scan_binding_pattern(
      scanner = lo_scanner opening_kind = ls_opening-kind
      declaration_kind = 1 ).
    mo_emitter->emit(
      opcode = zif_qjs_opcodes=>get_arg operand = argument_index ).
    mo_lexer->set_offset( lv_end_offset ).
    advance( ).
    IF ms_token-kind = zcl_qjs_lexer=>token_assign.
      has_default = abap_true.
      emit_binding_default( ).
    ENDIF.
    ls_resume_token = ms_token.
    lv_resume_offset = mo_lexer->get_offset( ).
    mo_lexer->set_offset( lv_start_offset ).
    advance( ).
    parse_binding_pattern( abap_false ).
    mo_lexer->set_offset( lv_resume_offset ).
    ms_token = ls_resume_token.
  ENDMETHOD.

  METHOD parse_var.
    DATA ls_local TYPE ty_local.
    DATA lv_binding_name TYPE string.
    advance( ).
    WHILE abap_true = abap_true.
      IF ms_token-kind = zcl_qjs_lexer=>token_lbracket
          OR ms_token-kind = zcl_qjs_lexer=>token_lbrace.
        parse_pattern_declaration( abap_false ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_comma.
          EXIT.
        ENDIF.
        advance( ).
        CONTINUE.
      ENDIF.
      IF ms_token-kind <> zcl_qjs_lexer=>token_identifier.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected identifier after var'.
      ENDIF.
      READ TABLE mt_locals WITH TABLE KEY name = ms_token-text
        function_depth = mv_function_depth INTO ls_local.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Variable declaration was not predeclared: '
            && ms_token-text.
      ENDIF.
      lv_binding_name = ms_token-text.
      advance( ).
      IF ms_token-kind = zcl_qjs_lexer=>token_assign.
        advance( ).
        IF ms_token-kind = zcl_qjs_lexer=>token_class.
          parse_class_expression( inferred_name = lv_binding_name ).
        ELSE.
          parse_assignment( ).
        ENDIF.
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>put_local operand = ls_local-index ).
      ENDIF.
      IF ms_token-kind <> zcl_qjs_lexer=>token_comma.
        EXIT.
      ENDIF.
      advance( ).
    ENDWHILE.
    IF ms_token-kind = zcl_qjs_lexer=>token_semicolon.
      advance( ).
    ENDIF.
    mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
  ENDMETHOD.

  METHOD parse_while.
    DATA lv_loop_start TYPE i.
    DATA lv_exit_jump TYPE i.
    advance( ).
    IF ms_token-kind <> zcl_qjs_lexer=>token_lparen.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected opening parenthesis after while'.
    ENDIF.
    advance( ).
    lv_loop_start = mo_emitter->position( ).
    parse_expression( ).
    IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected closing parenthesis after while condition'.
    ENDIF.
    advance( ).
    lv_exit_jump = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>if_false ).
    DATA ls_loop TYPE ty_loop.
    ls_loop-continue_target = lv_loop_start.
    APPEND ls_loop TO mt_loops.
    parse_statement( ).
    mo_emitter->emit( zif_qjs_opcodes=>drop ).
    mo_emitter->emit( opcode = zif_qjs_opcodes=>goto operand = lv_loop_start ).
    mo_emitter->patch(
      instruction = lv_exit_jump target = mo_emitter->position( ) ).
    finish_loop( mo_emitter->position( ) ).
    mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
  ENDMETHOD.

  METHOD parse_loop_jump.
    DATA lv_loop_index TYPE i.
    DATA lv_jump TYPE i.
    FIELD-SYMBOLS <loop> TYPE ty_loop.
    lv_loop_index = lines( mt_loops ).
    IF lv_loop_index = 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Loop control statement outside a loop'.
    ENDIF.
    READ TABLE mt_loops INDEX lv_loop_index ASSIGNING <loop>.
    emit_finally_calls( for_loop_jump = abap_true ).
    IF <loop>-exception_handler = abap_true.
      mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
      mo_emitter->emit( zif_qjs_opcodes=>leave_catch ).
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
    ENDIF.
    IF is_continue = abap_false AND <loop>-has_iterator = abap_true.
      IF <loop>-exception_handler = abap_true.
        mo_emitter->emit(  opcode = zif_qjs_opcodes=>get_local
                          operand = <loop>-iterator_local ).
      ENDIF.
      emit_iterator_close( <loop>-async_iterator ).
    ENDIF.
    lv_jump = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>goto ).
    IF is_continue = abap_true.
      APPEND lv_jump TO <loop>-continue_jumps.
    ELSE.
      APPEND lv_jump TO <loop>-break_jumps.
    ENDIF.
    advance( ).
    IF ms_token-kind = zcl_qjs_lexer=>token_semicolon.
      advance( ).
    ENDIF.
    mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
  ENDMETHOD.

  METHOD finish_loop.
    DATA lv_loop_index TYPE i.
    DATA ls_loop TYPE ty_loop.
    DATA lv_jump TYPE i.
    lv_loop_index = lines( mt_loops ).
    READ TABLE mt_loops INDEX lv_loop_index INTO ls_loop.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Internal loop patch stack underflow'.
    ENDIF.
    LOOP AT ls_loop-break_jumps INTO lv_jump.
      mo_emitter->patch( instruction = lv_jump target = exit_target ).
    ENDLOOP.
    LOOP AT ls_loop-continue_jumps INTO lv_jump.
      mo_emitter->patch(
        instruction = lv_jump target = ls_loop-continue_target ).
    ENDLOOP.
    DELETE mt_loops INDEX lv_loop_index.
  ENDMETHOD.

  METHOD parse_for.
    DATA lv_condition_start TYPE i.
    DATA lv_exit_jump TYPE i.
    DATA lv_body_jump TYPE i.
    DATA lv_continue_target TYPE i.
    DATA ls_loop TYPE ty_loop.
    DATA lv_async TYPE abap_bool.
    DATA lv_for_lexical_scope TYPE abap_bool.
    advance( ).
    IF ms_token-kind = zcl_qjs_lexer=>token_identifier
        AND ms_token-text = 'await'.
      IF mv_in_async = abap_false.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'for await is only valid in async functions'.
      ENDIF.
      lv_async = abap_true.
      advance( ).
    ENDIF.
    IF ms_token-kind <> zcl_qjs_lexer=>token_lparen.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected opening parenthesis after for'.
    ENDIF.
    advance( ).
    IF is_for_in_head( ) = abap_true.
      IF lv_async = abap_true.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'for await loop requires of'.
      ENDIF.
      parse_for_in( ).
      RETURN.
    ENDIF.
    IF is_for_of_head( ) = abap_true.
      parse_for_of( lv_async ).
      RETURN.
    ENDIF.
    IF lv_async = abap_true.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'for await loop requires of'.
    ENDIF.
    IF ms_token-kind = zcl_qjs_lexer=>token_var.
      parse_var( ).
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
    ELSEIF ms_token-kind = zcl_qjs_lexer=>token_let
        OR ms_token-kind = zcl_qjs_lexer=>token_const.
      DATA(lv_for_constant) = xsdbool(
        ms_token-kind = zcl_qjs_lexer=>token_const ).
      DATA lt_for_scope TYPE ty_locals.
      APPEND lt_for_scope TO mt_scopes.
      lv_for_lexical_scope = abap_true.
      DATA(lo_for_scanner) = NEW zcl_qjs_lexer( cache = mo_lexer ).
      lo_for_scanner->set_offset( mo_lexer->get_offset( ) ).
      DATA(ls_for_name) = lo_for_scanner->next( ).
      IF ls_for_name-kind <> zcl_qjs_lexer=>token_identifier.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected lexical for binding name'.
      ENDIF.
      declare_lexical(
        name = ls_for_name-text constant = lv_for_constant ).
      parse_lexical( lv_for_constant ).
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
    ELSEIF ms_token-kind = zcl_qjs_lexer=>token_semicolon.
      advance( ).
    ELSE.
      parse_expression( ).
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
      IF ms_token-kind <> zcl_qjs_lexer=>token_semicolon.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected semicolon after for initializer'.
      ENDIF.
      advance( ).
    ENDIF.

    lv_condition_start = mo_emitter->position( ).
    IF ms_token-kind = zcl_qjs_lexer=>token_semicolon.
      mo_emitter->emit( zif_qjs_opcodes=>push_true ).
    ELSE.
      parse_expression( ).
    ENDIF.
    IF ms_token-kind <> zcl_qjs_lexer=>token_semicolon.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected semicolon after for condition'.
    ENDIF.
    advance( ).
    lv_exit_jump = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>if_false ).
    lv_body_jump = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>goto ).

    lv_continue_target = mo_emitter->position( ).
    IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
      parse_expression( ).
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
    ENDIF.
    IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected closing parenthesis after for update'.
    ENDIF.
    advance( ).
    mo_emitter->emit( opcode = zif_qjs_opcodes=>goto operand = lv_condition_start ).
    mo_emitter->patch(
      instruction = lv_body_jump target = mo_emitter->position( ) ).

    ls_loop-continue_target = lv_continue_target.
    APPEND ls_loop TO mt_loops.
    parse_statement( ).
    mo_emitter->emit( zif_qjs_opcodes=>drop ).
    mo_emitter->emit( opcode = zif_qjs_opcodes=>goto operand = lv_continue_target ).
    mo_emitter->patch(
      instruction = lv_exit_jump target = mo_emitter->position( ) ).
    finish_loop( mo_emitter->position( ) ).
    IF lv_for_lexical_scope = abap_true.
      DELETE mt_scopes INDEX lines( mt_scopes ).
    ENDIF.
    mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
  ENDMETHOD.

  METHOD is_for_in_head.
    DATA ls_saved_token TYPE zcl_qjs_lexer=>ty_token.
    DATA lv_saved_offset TYPE i.
    ls_saved_token = ms_token.
    lv_saved_offset = mo_lexer->get_offset( ).
    IF ms_token-kind = zcl_qjs_lexer=>token_var
        OR ms_token-kind = zcl_qjs_lexer=>token_let
        OR ms_token-kind = zcl_qjs_lexer=>token_const.
      advance( ).
    ENDIF.
    IF ms_token-kind = zcl_qjs_lexer=>token_lbracket
        OR ms_token-kind = zcl_qjs_lexer=>token_lbrace.
      DATA(lv_pattern_end) = pattern_end_offset( ms_token-offset ).
      mo_lexer->set_offset( lv_pattern_end ).
      advance( ).
      result = xsdbool( ms_token-kind = zcl_qjs_lexer=>token_in ).
    ELSEIF ms_token-kind = zcl_qjs_lexer=>token_identifier.
      advance( ).
      result = xsdbool( ms_token-kind = zcl_qjs_lexer=>token_in ).
    ENDIF.
    mo_lexer->set_offset( lv_saved_offset ).
    ms_token = ls_saved_token.
  ENDMETHOD.

  METHOD is_for_of_head.
    DATA ls_saved_token TYPE zcl_qjs_lexer=>ty_token.
    DATA lv_saved_offset TYPE i.
    ls_saved_token = ms_token.
    lv_saved_offset = mo_lexer->get_offset( ).
    IF ms_token-kind = zcl_qjs_lexer=>token_var
        OR ms_token-kind = zcl_qjs_lexer=>token_let
        OR ms_token-kind = zcl_qjs_lexer=>token_const.
      advance( ).
    ENDIF.
    IF ms_token-kind = zcl_qjs_lexer=>token_lbracket
        OR ms_token-kind = zcl_qjs_lexer=>token_lbrace.
      DATA(lv_pattern_end) = pattern_end_offset( ms_token-offset ).
      mo_lexer->set_offset( lv_pattern_end ).
      advance( ).
      result = xsdbool( ms_token-kind = zcl_qjs_lexer=>token_identifier
        AND ms_token-text = 'of' ).
    ELSEIF ms_token-kind = zcl_qjs_lexer=>token_identifier.
      advance( ).
      result = xsdbool( ms_token-kind = zcl_qjs_lexer=>token_identifier
        AND ms_token-text = 'of' ).
    ENDIF.
    mo_lexer->set_offset( lv_saved_offset ).
    ms_token = ls_saved_token.
  ENDMETHOD.

  METHOD parse_for_pattern.
    DATA lo_scanner TYPE REF TO zcl_qjs_lexer.
    DATA ls_opening TYPE zcl_qjs_lexer=>ty_token.
    DATA ls_body_token TYPE zcl_qjs_lexer=>ty_token.
    DATA ls_loop TYPE ty_loop.
    DATA ls_pattern_binding TYPE ty_local.
    DATA lt_scope TYPE ty_locals.
    DATA lt_pattern_scope TYPE ty_locals.
    DATA lv_start_offset TYPE i.
    DATA lv_end_offset TYPE i.
    DATA lv_body_offset TYPE i.
    DATA lv_scope_index TYPE i.
    DATA lv_next_target TYPE i.
    DATA lv_done_jump TYPE i.
    DATA lv_break_target TYPE i.
    DATA lv_iterator_local TYPE i.
    DATA lv_value_local TYPE i.
    DATA lv_catch_instruction TYPE i.
    DATA lv_normal_jump TYPE i.
    DATA lv_lexical TYPE abap_bool.
    lv_start_offset = ms_token-offset.
    lv_end_offset = pattern_end_offset( lv_start_offset ).
    IF declaration_kind = zcl_qjs_lexer=>token_let
        OR declaration_kind = zcl_qjs_lexer=>token_const.
      lv_lexical = abap_true.
      APPEND lt_scope TO mt_scopes.
      lv_scope_index = lines( mt_scopes ).
      CREATE OBJECT lo_scanner EXPORTING cache = mo_lexer.
      lo_scanner->set_offset( lv_start_offset ).
      lo_scanner->next_into( CHANGING token = ls_opening ).
      scan_binding_pattern(
        scanner = lo_scanner opening_kind = ls_opening-kind
        declaration_kind = COND i(
          WHEN declaration_kind = zcl_qjs_lexer=>token_const THEN 3 ELSE 2 ) ).
      READ TABLE mt_scopes INDEX lv_scope_index INTO lt_pattern_scope.
      LOOP AT lt_pattern_scope INTO ls_pattern_binding.
        mo_emitter->emit(
          opcode  = zif_qjs_opcodes=>reset_lexical
          operand = ls_pattern_binding-index ).
      ENDLOOP.
    ENDIF.
    mo_lexer->set_offset( lv_end_offset ).
    advance( ).
    IF ( is_for_of = abap_true
          AND ( ms_token-kind <> zcl_qjs_lexer=>token_identifier
            OR ms_token-text <> 'of' ) )
        OR ( is_for_of = abap_false
          AND ms_token-kind <> zcl_qjs_lexer=>token_in ).
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected destructuring loop separator'.
    ENDIF.
    advance( ).
    parse_expression( ).
    IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected closing destructuring loop parenthesis'.
    ENDIF.
    advance( ).
    ls_body_token = ms_token.
    lv_body_offset = mo_lexer->get_offset( ).
    IF is_for_of = abap_true.
      IF async = abap_true.
        mo_emitter->emit( zif_qjs_opcodes=>for_await_of_start ).
      ELSE.
        mo_emitter->emit( zif_qjs_opcodes=>for_of_start ).
      ENDIF.
      lv_iterator_local = mo_emitter->allocate_local( ).
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>put_local operand = lv_iterator_local ).
      lv_value_local = mo_emitter->allocate_local( ).
    ELSE.
      mo_emitter->emit( zif_qjs_opcodes=>for_in_start ).
    ENDIF.
    lv_next_target = mo_emitter->position( ).
    IF is_for_of = abap_true.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>get_local operand = lv_iterator_local ).
      IF async = abap_true.
        mo_emitter->emit( zif_qjs_opcodes=>for_await_of_next ).
        mo_emitter->emit( zif_qjs_opcodes=>await ).
        mo_emitter->emit( zif_qjs_opcodes=>iterator_get_value_done ).
      ELSE.
        mo_emitter->emit( zif_qjs_opcodes=>for_of_next ).
      ENDIF.
    ELSE.
      mo_emitter->emit( zif_qjs_opcodes=>for_in_next ).
    ENDIF.
    lv_done_jump = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>if_true ).
    IF is_for_of = abap_true.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>put_local operand = lv_value_local ).
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
      lv_catch_instruction = mo_emitter->position( ).
      mo_emitter->emit( zif_qjs_opcodes=>catch ).
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>get_local operand = lv_value_local ).
    ENDIF.
    IF lv_lexical = abap_true.
      LOOP AT lt_pattern_scope INTO ls_pattern_binding.
        mo_emitter->emit(
          opcode  = zif_qjs_opcodes=>reset_lexical
          operand = ls_pattern_binding-index ).
      ENDLOOP.
    ENDIF.
    mo_lexer->set_offset( lv_start_offset ).
    advance( ).
    parse_binding_pattern(
      lexical = lv_lexical assignment = xsdbool( declaration_kind = 0 ) ).
    mo_lexer->set_offset( lv_body_offset ).
    ms_token = ls_body_token.

    ls_loop-continue_target = lv_next_target.
    ls_loop-has_iterator = is_for_of.
    ls_loop-exception_handler = is_for_of.
    ls_loop-async_iterator = async.
    ls_loop-iterator_local = lv_iterator_local.
    APPEND ls_loop TO mt_loops.
    parse_statement( ).
    IF is_for_of = abap_true.
      mo_emitter->emit( zif_qjs_opcodes=>leave_catch ).
    ENDIF.
    mo_emitter->emit( zif_qjs_opcodes=>drop ).
    mo_emitter->emit( opcode = zif_qjs_opcodes=>goto operand = lv_next_target ).
    mo_emitter->patch(
      instruction = lv_done_jump target = mo_emitter->position( ) ).
    mo_emitter->emit( zif_qjs_opcodes=>drop ).
    IF is_for_of = abap_true.
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
      lv_break_target = mo_emitter->position( ).
      finish_loop( lv_break_target ).
      lv_normal_jump = mo_emitter->position( ).
      mo_emitter->emit( zif_qjs_opcodes=>goto ).
      mo_emitter->patch(
        instruction = lv_catch_instruction target = mo_emitter->position( ) ).
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>get_local operand = lv_iterator_local ).
      emit_iterator_close( async ).
      mo_emitter->emit( zif_qjs_opcodes=>throw ).
      mo_emitter->patch(
        instruction = lv_normal_jump target = mo_emitter->position( ) ).
    ELSE.
      lv_break_target = mo_emitter->position( ).
      finish_loop( lv_break_target ).
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
    ENDIF.
    mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
    IF lv_scope_index > 0.
      DELETE mt_scopes INDEX lv_scope_index.
    ENDIF.
  ENDMETHOD.

  METHOD parse_for_in.
    DATA ls_binding TYPE ty_local.
    DATA ls_loop TYPE ty_loop.
    DATA lt_scope TYPE ty_locals.
    DATA lv_declaration_kind TYPE i.
    DATA lv_lexical TYPE abap_bool.
    DATA lv_done_jump TYPE i.
    DATA lv_next_target TYPE i.
    DATA lv_break_target TYPE i.
    DATA lv_scope_index TYPE i.
    DATA lv_name TYPE string.

    lv_declaration_kind = ms_token-kind.
    IF lv_declaration_kind = zcl_qjs_lexer=>token_var
        OR lv_declaration_kind = zcl_qjs_lexer=>token_let
        OR lv_declaration_kind = zcl_qjs_lexer=>token_const.
      advance( ).
    ELSE.
      CLEAR lv_declaration_kind.
    ENDIF.
    IF ms_token-kind = zcl_qjs_lexer=>token_lbracket
        OR ms_token-kind = zcl_qjs_lexer=>token_lbrace.
      parse_for_pattern(
        declaration_kind = lv_declaration_kind is_for_of = abap_false ).
      RETURN.
    ENDIF.
    IF ms_token-kind <> zcl_qjs_lexer=>token_identifier.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected identifier in for-in loop'.
    ENDIF.
    lv_name = ms_token-text.

    IF lv_declaration_kind = zcl_qjs_lexer=>token_let
        OR lv_declaration_kind = zcl_qjs_lexer=>token_const.
      APPEND lt_scope TO mt_scopes.
      lv_scope_index = lines( mt_scopes ).
      declare_lexical(
        name = lv_name constant = xsdbool(
          lv_declaration_kind = zcl_qjs_lexer=>token_const ) ).
      ls_binding = find_binding( lv_name ).
      lv_lexical = abap_true.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>reset_lexical operand = ls_binding-index ).
    ELSE.
      ls_binding = find_binding( lv_name ).
    ENDIF.

    advance( ).
    IF ms_token-kind <> zcl_qjs_lexer=>token_in.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected in in for-in loop'.
    ENDIF.
    advance( ).
    parse_expression( ).
    IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected closing parenthesis after for-in expression'.
    ENDIF.
    advance( ).

    mo_emitter->emit( zif_qjs_opcodes=>for_in_start ).
    lv_next_target = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>for_in_next ).
    lv_done_jump = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>if_true ).
    IF lv_lexical = abap_true.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>reset_lexical operand = ls_binding-index ).
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>initialize_lexical operand = ls_binding-index ).
    ELSE.
      emit_binding_put( ls_binding ).
    ENDIF.

    ls_loop-continue_target = lv_next_target.
    APPEND ls_loop TO mt_loops.
    parse_statement( ).
    mo_emitter->emit( zif_qjs_opcodes=>drop ).
    mo_emitter->emit( opcode = zif_qjs_opcodes=>goto operand = lv_next_target ).

    mo_emitter->patch(
      instruction = lv_done_jump target = mo_emitter->position( ) ).
    mo_emitter->emit( zif_qjs_opcodes=>drop ).
    lv_break_target = mo_emitter->position( ).
    finish_loop( lv_break_target ).
    mo_emitter->emit( zif_qjs_opcodes=>drop ).
    mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
    IF lv_scope_index > 0.
      DELETE mt_scopes INDEX lv_scope_index.
    ENDIF.
  ENDMETHOD.

  METHOD parse_for_of.
    DATA ls_binding TYPE ty_local.
    DATA ls_loop TYPE ty_loop.
    DATA lt_scope TYPE ty_locals.
    DATA lv_declaration_kind TYPE i.
    DATA lv_lexical TYPE abap_bool.
    DATA lv_done_jump TYPE i.
    DATA lv_next_target TYPE i.
    DATA lv_break_target TYPE i.
    DATA lv_iterator_local TYPE i.
    DATA lv_value_local TYPE i.
    DATA lv_catch_instruction TYPE i.
    DATA lv_normal_jump TYPE i.
    DATA lv_scope_index TYPE i.
    DATA lv_name TYPE string.

    lv_declaration_kind = ms_token-kind.
    IF lv_declaration_kind = zcl_qjs_lexer=>token_var
        OR lv_declaration_kind = zcl_qjs_lexer=>token_let
        OR lv_declaration_kind = zcl_qjs_lexer=>token_const.
      advance( ).
    ELSE.
      CLEAR lv_declaration_kind.
    ENDIF.
    IF ms_token-kind = zcl_qjs_lexer=>token_lbracket
        OR ms_token-kind = zcl_qjs_lexer=>token_lbrace.
      parse_for_pattern(
        declaration_kind = lv_declaration_kind is_for_of = abap_true
        async = async ).
      RETURN.
    ENDIF.
    IF ms_token-kind <> zcl_qjs_lexer=>token_identifier.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected identifier in for-of loop'.
    ENDIF.
    lv_name = ms_token-text.

    IF lv_declaration_kind = zcl_qjs_lexer=>token_let
        OR lv_declaration_kind = zcl_qjs_lexer=>token_const.
      APPEND lt_scope TO mt_scopes.
      lv_scope_index = lines( mt_scopes ).
      declare_lexical(
        name = lv_name constant = xsdbool(
          lv_declaration_kind = zcl_qjs_lexer=>token_const ) ).
      ls_binding = find_binding( lv_name ).
      lv_lexical = abap_true.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>reset_lexical operand = ls_binding-index ).
    ELSE.
      ls_binding = find_binding( lv_name ).
    ENDIF.

    advance( ).
    IF ms_token-kind <> zcl_qjs_lexer=>token_identifier OR ms_token-text <> 'of'.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected of in for-of loop'.
    ENDIF.
    advance( ).
    parse_expression( ).
    IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected closing parenthesis after for-of expression'.
    ENDIF.
    advance( ).

    IF async = abap_true.
      mo_emitter->emit( zif_qjs_opcodes=>for_await_of_start ).
    ELSE.
      mo_emitter->emit( zif_qjs_opcodes=>for_of_start ).
    ENDIF.
    lv_iterator_local = mo_emitter->allocate_local( ).
    mo_emitter->emit(
      opcode = zif_qjs_opcodes=>put_local operand = lv_iterator_local ).
    lv_value_local = mo_emitter->allocate_local( ).
    lv_next_target = mo_emitter->position( ).
    mo_emitter->emit(
      opcode = zif_qjs_opcodes=>get_local operand = lv_iterator_local ).
    IF async = abap_true.
      mo_emitter->emit( zif_qjs_opcodes=>for_await_of_next ).
      mo_emitter->emit( zif_qjs_opcodes=>await ).
      mo_emitter->emit( zif_qjs_opcodes=>iterator_get_value_done ).
    ELSE.
      mo_emitter->emit( zif_qjs_opcodes=>for_of_next ).
    ENDIF.
    lv_done_jump = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>if_true ).
    mo_emitter->emit(
      opcode = zif_qjs_opcodes=>put_local operand = lv_value_local ).
    mo_emitter->emit( zif_qjs_opcodes=>drop ).
    lv_catch_instruction = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>catch ).
    mo_emitter->emit(
      opcode = zif_qjs_opcodes=>get_local operand = lv_value_local ).
    IF lv_lexical = abap_true.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>reset_lexical operand = ls_binding-index ).
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>initialize_lexical operand = ls_binding-index ).
    ELSE.
      emit_binding_put( ls_binding ).
    ENDIF.

    ls_loop-continue_target = lv_next_target.
    ls_loop-has_iterator = abap_true.
    ls_loop-exception_handler = abap_true.
    ls_loop-async_iterator = async.
    ls_loop-iterator_local = lv_iterator_local.
    APPEND ls_loop TO mt_loops.
    parse_statement( ).
    mo_emitter->emit( zif_qjs_opcodes=>leave_catch ).
    mo_emitter->emit( zif_qjs_opcodes=>drop ).
    mo_emitter->emit( opcode = zif_qjs_opcodes=>goto operand = lv_next_target ).

    mo_emitter->patch(
      instruction = lv_done_jump target = mo_emitter->position( ) ).
    mo_emitter->emit( zif_qjs_opcodes=>drop ).
    mo_emitter->emit( zif_qjs_opcodes=>drop ).
    lv_break_target = mo_emitter->position( ).
    finish_loop( lv_break_target ).
    lv_normal_jump = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>goto ).
    mo_emitter->patch(
      instruction = lv_catch_instruction target = mo_emitter->position( ) ).
    mo_emitter->emit(
      opcode = zif_qjs_opcodes=>get_local operand = lv_iterator_local ).
    emit_iterator_close( async ).
    mo_emitter->emit( zif_qjs_opcodes=>throw ).
    mo_emitter->patch(
      instruction = lv_normal_jump target = mo_emitter->position( ) ).
    mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
    IF lv_scope_index > 0.
      DELETE mt_scopes INDEX lv_scope_index.
    ENDIF.
  ENDMETHOD.

  METHOD parse_block.
    DATA lt_scope TYPE ty_locals.
    DATA lt_current_scope TYPE ty_locals.
    DATA ls_binding TYPE ty_local.
    APPEND lt_scope TO mt_scopes.
    predeclare_scope(
      start_offset = mo_lexer->get_offset( ) stop_at_brace = abap_true ).
    READ TABLE mt_scopes INDEX lines( mt_scopes ) INTO lt_current_scope.
    LOOP AT lt_current_scope INTO ls_binding.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>reset_lexical operand = ls_binding-index ).
    ENDLOOP.
    advance( ).
    IF ms_token-kind = zcl_qjs_lexer=>token_rbrace.
      mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
    ELSE.
      parse_statement( ).
      WHILE ms_token-kind <> zcl_qjs_lexer=>token_rbrace.
        IF ms_token-kind = zcl_qjs_lexer=>token_eof.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected closing brace'.
        ENDIF.
        mo_emitter->emit( zif_qjs_opcodes=>drop ).
        parse_statement( ).
      ENDWHILE.
    ENDIF.
    advance( ).
    DELETE mt_scopes INDEX lines( mt_scopes ).
  ENDMETHOD.

  METHOD parse_if.
    DATA lv_false_jump TYPE i.
    DATA lv_end_jump TYPE i.
    advance( ).
    IF ms_token-kind <> zcl_qjs_lexer=>token_lparen.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected opening parenthesis after if'.
    ENDIF.
    advance( ).
    parse_expression( ).
    IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected closing parenthesis after if condition'.
    ENDIF.
    advance( ).
    lv_false_jump = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>if_false ).
    parse_statement( ).
    lv_end_jump = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>goto ).
    mo_emitter->patch(
      instruction = lv_false_jump target = mo_emitter->position( ) ).
    IF ms_token-kind = zcl_qjs_lexer=>token_else.
      advance( ).
      parse_statement( ).
    ELSE.
      mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
    ENDIF.
    mo_emitter->patch(
      instruction = lv_end_jump target = mo_emitter->position( ) ).
  ENDMETHOD.

  METHOD parse_expression.
    parse_assignment( ).
    WHILE ms_token-kind = zcl_qjs_lexer=>token_comma.
      advance( ).
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
      parse_assignment( ).
    ENDWHILE.
  ENDMETHOD.

  METHOD parse_assignment.
    IF ms_token-kind = zcl_qjs_lexer=>token_yield.
      parse_yield( ).
      RETURN.
    ENDIF.
    IF is_arrow_function_start( ) = abap_true.
      parse_arrow_function( ).
      RETURN.
    ENDIF.
    IF is_pattern_assignment( ) = abap_true.
      parse_pattern_assignment( ).
      RETURN.
    ENDIF.
    parse_conditional( ).
  ENDMETHOD.

  METHOD is_arrow_function_start.
    DATA lo_scanner TYPE REF TO zcl_qjs_lexer.
    DATA ls_scan TYPE zcl_qjs_lexer=>ty_token.
    DATA lv_depth TYPE i.

    IF ms_token-kind = zcl_qjs_lexer=>token_identifier.
      CREATE OBJECT lo_scanner EXPORTING cache = mo_lexer.
      lo_scanner->set_offset( mo_lexer->get_offset( ) ).
      lo_scanner->next_into( CHANGING token = ls_scan ).
      IF ls_scan-kind = zcl_qjs_lexer=>token_arrow.
        result = xsdbool( ls_scan-line_terminator_before = abap_false ).
        RETURN.
      ENDIF.
      IF ms_token-text <> 'async'
          OR ls_scan-line_terminator_before = abap_true.
        RETURN.
      ENDIF.
      IF ls_scan-kind = zcl_qjs_lexer=>token_identifier.
        lo_scanner->next_into( CHANGING token = ls_scan ).
        result = xsdbool( ls_scan-kind = zcl_qjs_lexer=>token_arrow
          AND ls_scan-line_terminator_before = abap_false ).
        RETURN.
      ELSEIF ls_scan-kind <> zcl_qjs_lexer=>token_lparen.
        RETURN.
      ENDIF.
    ELSEIF ms_token-kind = zcl_qjs_lexer=>token_lparen.
      CREATE OBJECT lo_scanner EXPORTING cache = mo_lexer.
      lo_scanner->set_offset( mo_lexer->get_offset( ) ).
    ELSE.
      RETURN.
    ENDIF.

    lv_depth = 1.
    WHILE lv_depth > 0.
      lo_scanner->next_into( CHANGING token = ls_scan ).
      IF ls_scan-kind = zcl_qjs_lexer=>token_lparen.
        lv_depth = lv_depth + 1.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_rparen.
        lv_depth = lv_depth - 1.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_eof.
        RETURN.
      ENDIF.
    ENDWHILE.
    lo_scanner->next_into( CHANGING token = ls_scan ).
    result = xsdbool( ls_scan-kind = zcl_qjs_lexer=>token_arrow
      AND ls_scan-line_terminator_before = abap_false ).
  ENDMETHOD.

  METHOD parse_arrow_function.
    DATA lo_outer_emitter TYPE REF TO zcl_qjs_emitter.
    DATA lr_previous_outer_parent TYPE REF TO ty_locals.
    DATA lr_previous_outer_scopes TYPE REF TO ty_scopes.
    DATA lt_outer_loops TYPE ty_loops.
    DATA lt_outer_parent_locals TYPE ty_locals.
    DATA lt_outer_finally TYPE ty_finally_stack.
    DATA lt_outer_scopes TYPE ty_scopes.
    DATA lt_outer_hoists TYPE ty_hoists.
    DATA lt_root_scope TYPE ty_locals.
    DATA ls_local TYPE ty_local.
    DATA ls_global_this TYPE ty_local.
    DATA lv_outer_in_function TYPE abap_bool.
    DATA lv_outer_in_generator TYPE abap_bool.
    DATA lv_outer_in_async TYPE abap_bool.
    DATA lv_async TYPE abap_bool.
    DATA lv_parenthesized TYPE abap_bool.
    DATA lv_parameter_count TYPE i.
    DATA lv_function_length TYPE i.
    DATA lv_seen_default TYPE abap_bool.
    DATA lv_default_jump TYPE i.
    DATA lo_function TYPE REF TO zcl_qjs_function.

    IF ms_token-kind = zcl_qjs_lexer=>token_identifier
        AND ms_token-text = 'async'.
      DATA(lo_async_scanner) = NEW zcl_qjs_lexer( cache = mo_lexer ).
      lo_async_scanner->set_offset( mo_lexer->get_offset( ) ).
      DATA(ls_after_async) = lo_async_scanner->next( ).
      IF ls_after_async-kind <> zcl_qjs_lexer=>token_arrow
          AND ls_after_async-line_terminator_before = abap_false.
        lv_async = abap_true.
        advance( ).
      ENDIF.
    ENDIF.
    IF ms_token-kind = zcl_qjs_lexer=>token_lparen.
      lv_parenthesized = abap_true.
      advance( ).
    ENDIF.

    lo_outer_emitter = mo_emitter.
    lt_outer_parent_locals = mt_parent_locals.
    lt_outer_finally = mt_finally.
    lt_outer_scopes = mt_scopes.
    lt_outer_hoists = mt_hoists.
    lt_outer_loops = mt_loops.
    lv_outer_in_function = mv_in_function.
    lv_outer_in_generator = mv_in_generator.
    lv_outer_in_async = mv_in_async.
    lr_previous_outer_parent = mr_outer_parent_locals.
    lr_previous_outer_scopes = mr_outer_scopes.
    GET REFERENCE OF lt_outer_parent_locals INTO mr_outer_parent_locals.
    GET REFERENCE OF lt_outer_scopes INTO mr_outer_scopes.
    CREATE OBJECT mo_emitter EXPORTING limits = mo_limits.
    CLEAR mt_parent_locals.
    mv_function_depth = mv_function_depth + 1.
    IF lv_outer_in_function = abap_false.
      ensure_parent_binding( 'globalThis' ).
      READ TABLE mt_parent_locals WITH TABLE KEY name = 'globalThis'
        INTO ls_global_this.
      IF sy-subrc = 0.
        DELETE TABLE mt_parent_locals WITH TABLE KEY name = 'this'.
        ls_global_this-name = 'this'.
        INSERT ls_global_this INTO TABLE mt_parent_locals.
      ENDIF.
    ENDIF.
    CLEAR mt_loops.
    CLEAR mt_finally.
    CLEAR mt_scopes.
    CLEAR mt_hoists.
    APPEND lt_root_scope TO mt_scopes.
    mv_in_function = abap_true.
    mv_in_generator = abap_false.
    mv_in_async = lv_async.

    WHILE ( lv_parenthesized = abap_true
          AND ms_token-kind <> zcl_qjs_lexer=>token_rparen )
        OR ( lv_parenthesized = abap_false AND lv_parameter_count = 0 ).
      IF ms_token-kind = zcl_qjs_lexer=>token_ellipsis.
        advance( ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_identifier.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected arrow rest parameter name'.
        ENDIF.
        ls_local-name = ms_token-text.
        ls_local-function_depth = mv_function_depth.
        ls_local-index = mo_emitter->allocate_local( ).
        ls_local-kind = zcl_qjs_function=>capture_local.
        INSERT ls_local INTO TABLE mt_locals.
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>rest operand = lv_parameter_count ).
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>put_local operand = ls_local-index ).
        advance( ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Arrow rest parameter must be last'.
        ENDIF.
        CONTINUE.
      ENDIF.
      IF ms_token-kind = zcl_qjs_lexer=>token_lbracket
          OR ms_token-kind = zcl_qjs_lexer=>token_lbrace.
        DATA(lv_arrow_pattern_default) = parse_pattern_parameter(
          lv_parameter_count ).
        lv_parameter_count = lv_parameter_count + 1.
        IF lv_arrow_pattern_default = abap_true.
          lv_seen_default = abap_true.
        ELSEIF lv_seen_default = abap_false.
          lv_function_length = lv_function_length + 1.
        ENDIF.
      ELSE.
        IF ms_token-kind <> zcl_qjs_lexer=>token_identifier.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected arrow parameter'.
        ENDIF.
        CLEAR ls_local.
        ls_local-name = ms_token-text.
        ls_local-function_depth = mv_function_depth.
        ls_local-index = mo_emitter->allocate_local( ).
        ls_local-kind = zcl_qjs_function=>capture_local.
        INSERT ls_local INTO TABLE mt_locals.
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>get_arg operand = lv_parameter_count ).
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>put_local operand = ls_local-index ).
        lv_parameter_count = lv_parameter_count + 1.
        advance( ).
        IF ms_token-kind = zcl_qjs_lexer=>token_assign.
          lv_seen_default = abap_true.
          mo_emitter->emit(
            opcode = zif_qjs_opcodes=>get_local operand = ls_local-index ).
          mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
          mo_emitter->emit( zif_qjs_opcodes=>strict_equal ).
          lv_default_jump = mo_emitter->position( ).
          mo_emitter->emit( zif_qjs_opcodes=>if_false ).
          advance( ).
          parse_assignment( ).
          mo_emitter->emit(
            opcode = zif_qjs_opcodes=>put_local operand = ls_local-index ).
          mo_emitter->patch(
            instruction = lv_default_jump target = mo_emitter->position( ) ).
        ELSEIF lv_seen_default = abap_false.
          lv_function_length = lv_function_length + 1.
        ENDIF.
      ENDIF.
      IF lv_parenthesized = abap_false.
        EXIT.
      ELSEIF ms_token-kind = zcl_qjs_lexer=>token_comma.
        advance( ).
      ELSEIF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected comma in arrow parameters'.
      ENDIF.
    ENDWHILE.
    IF lv_parenthesized = abap_true.
      IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected closing arrow parameter parenthesis'.
      ENDIF.
      advance( ).
    ENDIF.
    IF ms_token-kind <> zcl_qjs_lexer=>token_arrow
        OR ms_token-line_terminator_before = abap_true.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected arrow token'.
    ENDIF.
    advance( ).
    IF ms_token-kind = zcl_qjs_lexer=>token_lbrace.
      predeclare_scope(
        start_offset = mo_lexer->get_offset( ) stop_at_brace = abap_true ).
    ENDIF.
    capture_parent_bindings( ).
    mo_emitter->set_signature(
      parameter_count = lv_parameter_count function_length = lv_function_length
      constructible = abap_false async = lv_async ).
    IF ms_token-kind = zcl_qjs_lexer=>token_lbrace.
      advance( ).
      WHILE ms_token-kind <> zcl_qjs_lexer=>token_rbrace.
        IF ms_token-kind = zcl_qjs_lexer=>token_eof.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected closing arrow function brace'.
        ENDIF.
        parse_statement( ).
        mo_emitter->emit( zif_qjs_opcodes=>drop ).
      ENDWHILE.
      advance( ).
      mo_emitter->emit( zif_qjs_opcodes=>return_undefined ).
    ELSE.
      parse_assignment( ).
      mo_emitter->emit( zif_qjs_opcodes=>return ).
    ENDIF.
    lo_function = mo_emitter->to_function( ).

    mo_emitter = lo_outer_emitter.
    DELETE mt_locals WHERE function_depth = mv_function_depth.
    mv_function_depth = mv_function_depth - 1.
    mt_parent_locals = lt_outer_parent_locals.
    mt_loops = lt_outer_loops.
    mt_finally = lt_outer_finally.
    mt_scopes = lt_outer_scopes.
    mt_hoists = lt_outer_hoists.
    mr_outer_parent_locals = lr_previous_outer_parent.
    mr_outer_scopes = lr_previous_outer_scopes.
    mv_in_function = lv_outer_in_function.
    mv_in_generator = lv_outer_in_generator.
    mv_in_async = lv_outer_in_async.
    mo_last_function = lo_function.
    mo_emitter->emit_closure( zcl_qjs_value=>new_object( lo_function ) ).
  ENDMETHOD.

  METHOD parse_yield.
    IF mv_in_generator = abap_false.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Yield expression outside generator'.
    ENDIF.
    advance( ).
    IF ms_token-kind = zcl_qjs_lexer=>token_star
        AND ms_token-line_terminator_before = abap_false.
      advance( ).
      parse_assignment( ).
      IF mv_in_async = abap_true.
        mo_emitter->emit( zif_qjs_opcodes=>for_await_of_start ).
        mo_emitter->emit( zif_qjs_opcodes=>async_yield_star ).
      ELSE.
        mo_emitter->emit( zif_qjs_opcodes=>for_of_start ).
        mo_emitter->emit( zif_qjs_opcodes=>yield_star ).
      ENDIF.
      RETURN.
    ENDIF.
    IF ms_token-line_terminator_before = abap_true
        OR ms_token-kind = zcl_qjs_lexer=>token_semicolon
        OR ms_token-kind = zcl_qjs_lexer=>token_rbrace.
      mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
    ELSE.
      parse_assignment( ).
    ENDIF.
    mo_emitter->emit( zif_qjs_opcodes=>yield ).
  ENDMETHOD.

  METHOD is_pattern_assignment.
    DATA lo_scanner TYPE REF TO zcl_qjs_lexer.
    DATA ls_scan TYPE zcl_qjs_lexer=>ty_token.
    DATA lv_end_offset TYPE i.
    IF ms_token-kind <> zcl_qjs_lexer=>token_lbracket
        AND ms_token-kind <> zcl_qjs_lexer=>token_lbrace.
      RETURN.
    ENDIF.
    lv_end_offset = pattern_end_offset( ms_token-offset ).
    CREATE OBJECT lo_scanner EXPORTING cache = mo_lexer.
    lo_scanner->set_offset( lv_end_offset ).
    lo_scanner->next_into( CHANGING token = ls_scan ).
    result = xsdbool( ls_scan-kind = zcl_qjs_lexer=>token_assign ).
  ENDMETHOD.

  METHOD parse_pattern_assignment.
    DATA lv_start_offset TYPE i.
    DATA lv_end_offset TYPE i.
    DATA lv_resume_offset TYPE i.
    DATA ls_resume_token TYPE zcl_qjs_lexer=>ty_token.
    lv_start_offset = ms_token-offset.
    lv_end_offset = pattern_end_offset( lv_start_offset ).
    mo_lexer->set_offset( lv_end_offset ).
    advance( ).
    IF ms_token-kind <> zcl_qjs_lexer=>token_assign.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected destructuring assignment operator'.
    ENDIF.
    advance( ).
    parse_assignment( ).
    mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
    ls_resume_token = ms_token.
    lv_resume_offset = mo_lexer->get_offset( ).
    mo_lexer->set_offset( lv_start_offset ).
    advance( ).
    parse_binding_pattern( lexical = abap_false assignment = abap_true ).
    mo_lexer->set_offset( lv_resume_offset ).
    ms_token = ls_resume_token.
  ENDMETHOD.

  METHOD parse_conditional.
    DATA lv_false_jump TYPE i.
    DATA lv_end_jump TYPE i.
    parse_logical_or( ).
    IF ms_token-kind <> zcl_qjs_lexer=>token_question.
      RETURN.
    ENDIF.
    advance( ).
    lv_false_jump = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>if_false ).
    parse_assignment( ).
    IF ms_token-kind <> zcl_qjs_lexer=>token_colon.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Expected colon in conditional expression'.
    ENDIF.
    advance( ).
    lv_end_jump = mo_emitter->position( ).
    mo_emitter->emit( zif_qjs_opcodes=>goto ).
    mo_emitter->patch(
      instruction = lv_false_jump target = mo_emitter->position( ) ).
    parse_assignment( ).
    mo_emitter->patch(
      instruction = lv_end_jump target = mo_emitter->position( ) ).
  ENDMETHOD.

  METHOD is_compound_assignment.
    result = xsdbool( kind >= zcl_qjs_lexer=>token_add_assign
      AND kind <= zcl_qjs_lexer=>token_ushift_right_assign ).
  ENDMETHOD.

  METHOD is_identifier_name.
    result = abap_false.
    CASE kind.
      WHEN zcl_qjs_lexer=>token_identifier
          OR zcl_qjs_lexer=>token_true OR zcl_qjs_lexer=>token_false
          OR zcl_qjs_lexer=>token_null OR zcl_qjs_lexer=>token_undefined
          OR zcl_qjs_lexer=>token_if OR zcl_qjs_lexer=>token_else
          OR zcl_qjs_lexer=>token_var OR zcl_qjs_lexer=>token_while
          OR zcl_qjs_lexer=>token_for OR zcl_qjs_lexer=>token_break
          OR zcl_qjs_lexer=>token_continue OR zcl_qjs_lexer=>token_function
          OR zcl_qjs_lexer=>token_return OR zcl_qjs_lexer=>token_new
          OR zcl_qjs_lexer=>token_throw OR zcl_qjs_lexer=>token_try
          OR zcl_qjs_lexer=>token_catch OR zcl_qjs_lexer=>token_finally
          OR zcl_qjs_lexer=>token_let OR zcl_qjs_lexer=>token_const
          OR zcl_qjs_lexer=>token_this OR zcl_qjs_lexer=>token_instanceof
          OR zcl_qjs_lexer=>token_in OR zcl_qjs_lexer=>token_delete
          OR zcl_qjs_lexer=>token_typeof OR zcl_qjs_lexer=>token_class
          OR zcl_qjs_lexer=>token_extends OR zcl_qjs_lexer=>token_super.
        result = abap_true.
    ENDCASE.
  ENDMETHOD.

  METHOD emit_compound_operator.
    CASE kind.
      WHEN zcl_qjs_lexer=>token_add_assign.
        mo_emitter->emit( zif_qjs_opcodes=>add ).
      WHEN zcl_qjs_lexer=>token_subtract_assign.
        mo_emitter->emit( zif_qjs_opcodes=>subtract ).
      WHEN zcl_qjs_lexer=>token_multiply_assign.
        mo_emitter->emit( zif_qjs_opcodes=>multiply ).
      WHEN zcl_qjs_lexer=>token_divide_assign.
        mo_emitter->emit( zif_qjs_opcodes=>divide ).
      WHEN zcl_qjs_lexer=>token_modulo_assign.
        mo_emitter->emit( zif_qjs_opcodes=>modulo ).
      WHEN zcl_qjs_lexer=>token_bit_and_assign.
        mo_emitter->emit( zif_qjs_opcodes=>bitwise_and ).
      WHEN zcl_qjs_lexer=>token_bit_or_assign.
        mo_emitter->emit( zif_qjs_opcodes=>bitwise_or ).
      WHEN zcl_qjs_lexer=>token_bit_xor_assign.
        mo_emitter->emit( zif_qjs_opcodes=>bitwise_xor ).
      WHEN zcl_qjs_lexer=>token_shift_left_assign.
        mo_emitter->emit( zif_qjs_opcodes=>shift_left ).
      WHEN zcl_qjs_lexer=>token_shift_right_assign.
        mo_emitter->emit( zif_qjs_opcodes=>shift_right ).
      WHEN zcl_qjs_lexer=>token_ushift_right_assign.
        mo_emitter->emit( zif_qjs_opcodes=>shift_right_unsigned ).
      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Unknown compound assignment operator'.
    ENDCASE.
  ENDMETHOD.

  METHOD emit_binding_get.
    IF binding-kind = zcl_qjs_function=>capture_parent.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>get_capture operand = binding-index ).
    ELSEIF binding-lexical = abap_true.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>get_lexical operand = binding-index ).
    ELSE.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>get_local operand = binding-index ).
    ENDIF.
  ENDMETHOD.

  METHOD emit_binding_set.
    IF binding-kind = zcl_qjs_function=>capture_parent.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>set_capture operand = binding-index ).
    ELSEIF binding-lexical = abap_true.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>set_lexical operand = binding-index ).
    ELSE.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>set_local operand = binding-index ).
    ENDIF.
  ENDMETHOD.

  METHOD emit_binding_put.
    IF binding-kind = zcl_qjs_function=>capture_parent.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>put_capture operand = binding-index ).
    ELSEIF binding-lexical = abap_true.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>put_lexical operand = binding-index ).
    ELSE.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>put_local operand = binding-index ).
    ENDIF.
  ENDMETHOD.

  METHOD parse_logical_or.
    DATA lv_end_jump TYPE i.
    parse_logical_and( ).
    WHILE ms_token-kind = zcl_qjs_lexer=>token_or.
      advance( ).
      mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
      lv_end_jump = mo_emitter->position( ).
      mo_emitter->emit( zif_qjs_opcodes=>if_true ).
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
      parse_logical_and( ).
      mo_emitter->patch(
        instruction = lv_end_jump target = mo_emitter->position( ) ).
    ENDWHILE.
  ENDMETHOD.

  METHOD parse_logical_and.
    DATA lv_end_jump TYPE i.
    parse_bitwise_or( ).
    WHILE ms_token-kind = zcl_qjs_lexer=>token_and.
      advance( ).
      mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
      lv_end_jump = mo_emitter->position( ).
      mo_emitter->emit( zif_qjs_opcodes=>if_false ).
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
      parse_bitwise_or( ).
      mo_emitter->patch(
        instruction = lv_end_jump target = mo_emitter->position( ) ).
    ENDWHILE.
  ENDMETHOD.

  METHOD parse_bitwise_or.
    parse_bitwise_xor( ).
    WHILE ms_token-kind = zcl_qjs_lexer=>token_bit_or.
      advance( ).
      parse_bitwise_xor( ).
      mo_emitter->emit( zif_qjs_opcodes=>bitwise_or ).
    ENDWHILE.
  ENDMETHOD.

  METHOD parse_bitwise_xor.
    parse_bitwise_and( ).
    WHILE ms_token-kind = zcl_qjs_lexer=>token_bit_xor.
      advance( ).
      parse_bitwise_and( ).
      mo_emitter->emit( zif_qjs_opcodes=>bitwise_xor ).
    ENDWHILE.
  ENDMETHOD.

  METHOD parse_bitwise_and.
    parse_equality( ).
    WHILE ms_token-kind = zcl_qjs_lexer=>token_bit_and.
      advance( ).
      parse_equality( ).
      mo_emitter->emit( zif_qjs_opcodes=>bitwise_and ).
    ENDWHILE.
  ENDMETHOD.

  METHOD parse_equality.
    DATA lv_kind TYPE i.
    parse_comparison( ).
    WHILE ms_token-kind = zcl_qjs_lexer=>token_eq
        OR ms_token-kind = zcl_qjs_lexer=>token_neq
        OR ms_token-kind = zcl_qjs_lexer=>token_strict_eq
        OR ms_token-kind = zcl_qjs_lexer=>token_strict_neq.
      lv_kind = ms_token-kind.
      advance( ).
      parse_comparison( ).
      CASE lv_kind.
        WHEN zcl_qjs_lexer=>token_eq. mo_emitter->emit( zif_qjs_opcodes=>equal ).
        WHEN zcl_qjs_lexer=>token_neq. mo_emitter->emit( zif_qjs_opcodes=>not_equal ).
        WHEN zcl_qjs_lexer=>token_strict_eq. mo_emitter->emit( zif_qjs_opcodes=>strict_equal ).
        WHEN zcl_qjs_lexer=>token_strict_neq. mo_emitter->emit( zif_qjs_opcodes=>strict_not_equal ).
      ENDCASE.
    ENDWHILE.
  ENDMETHOD.

  METHOD parse_comparison.
    DATA lv_kind TYPE i.
    DATA lv_private_left TYPE abap_bool.
    lv_private_left = xsdbool(
      ms_token-kind = zcl_qjs_lexer=>token_private_identifier ).
    parse_shift( ).
    WHILE ( ms_token-kind >= zcl_qjs_lexer=>token_lt
        AND ms_token-kind <= zcl_qjs_lexer=>token_gte )
        OR ms_token-kind = zcl_qjs_lexer=>token_instanceof
        OR ms_token-kind = zcl_qjs_lexer=>token_in.
      lv_kind = ms_token-kind.
      advance( ).
      parse_shift( ).
      CASE lv_kind.
        WHEN zcl_qjs_lexer=>token_lt. mo_emitter->emit( zif_qjs_opcodes=>less_than ).
        WHEN zcl_qjs_lexer=>token_lte. mo_emitter->emit( zif_qjs_opcodes=>less_equal ).
        WHEN zcl_qjs_lexer=>token_gt. mo_emitter->emit( zif_qjs_opcodes=>greater_than ).
        WHEN zcl_qjs_lexer=>token_gte. mo_emitter->emit( zif_qjs_opcodes=>greater_equal ).
        WHEN zcl_qjs_lexer=>token_instanceof.
          mo_emitter->emit( zif_qjs_opcodes=>instance_of ).
        WHEN zcl_qjs_lexer=>token_in.
          IF lv_private_left = abap_true.
            mo_emitter->emit( zif_qjs_opcodes=>private_in ).
          ELSE.
            mo_emitter->emit( zif_qjs_opcodes=>in_operator ).
          ENDIF.
      ENDCASE.
      lv_private_left = abap_false.
    ENDWHILE.
  ENDMETHOD.

  METHOD parse_shift.
    DATA lv_kind TYPE i.
    parse_additive( ).
    WHILE ms_token-kind = zcl_qjs_lexer=>token_shift_left
        OR ms_token-kind = zcl_qjs_lexer=>token_shift_right
        OR ms_token-kind = zcl_qjs_lexer=>token_shift_right_unsigned.
      lv_kind = ms_token-kind.
      advance( ).
      parse_additive( ).
      CASE lv_kind.
        WHEN zcl_qjs_lexer=>token_shift_left.
          mo_emitter->emit( zif_qjs_opcodes=>shift_left ).
        WHEN zcl_qjs_lexer=>token_shift_right.
          mo_emitter->emit( zif_qjs_opcodes=>shift_right ).
        WHEN zcl_qjs_lexer=>token_shift_right_unsigned.
          mo_emitter->emit( zif_qjs_opcodes=>shift_right_unsigned ).
      ENDCASE.
    ENDWHILE.
  ENDMETHOD.

  METHOD parse_additive.
    DATA lv_kind TYPE i.
    parse_term( ).
    WHILE ms_token-kind = zcl_qjs_lexer=>token_plus
        OR ms_token-kind = zcl_qjs_lexer=>token_minus.
      lv_kind = ms_token-kind.
      advance( ).
      parse_term( ).
      IF lv_kind = zcl_qjs_lexer=>token_plus.
        mo_emitter->emit( zif_qjs_opcodes=>add ).
      ELSE.
        mo_emitter->emit( zif_qjs_opcodes=>subtract ).
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD parse_term.
    DATA lv_kind TYPE i.
    parse_postfix( ).
    WHILE ms_token-kind = zcl_qjs_lexer=>token_star
        OR ms_token-kind = zcl_qjs_lexer=>token_slash
        OR ms_token-kind = zcl_qjs_lexer=>token_percent.
      lv_kind = ms_token-kind.
      advance( ).
      parse_postfix( ).
      IF lv_kind = zcl_qjs_lexer=>token_star.
        mo_emitter->emit( zif_qjs_opcodes=>multiply ).
      ELSEIF lv_kind = zcl_qjs_lexer=>token_slash.
        mo_emitter->emit( zif_qjs_opcodes=>divide ).
      ELSE.
        mo_emitter->emit( zif_qjs_opcodes=>modulo ).
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD array_literal_has_spread.
    DATA lo_scanner TYPE REF TO zcl_qjs_lexer.
    DATA ls_scan TYPE zcl_qjs_lexer=>ty_token.
    DATA lv_depth TYPE i.
    CREATE OBJECT lo_scanner EXPORTING cache = mo_lexer.
    lo_scanner->set_offset( ms_token-offset ).
    WHILE abap_true = abap_true.
      lo_scanner->next_into( CHANGING token = ls_scan ).
      IF ls_scan-kind = zcl_qjs_lexer=>token_lbracket.
        lv_depth = lv_depth + 1.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_rbracket.
        lv_depth = lv_depth - 1.
        IF lv_depth = 0.
          RETURN.
        ENDIF.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_ellipsis AND lv_depth = 1.
        result = abap_true.
        RETURN.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_eof.
        RETURN.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD call_has_spread.
    DATA lo_scanner TYPE REF TO zcl_qjs_lexer.
    DATA ls_scan TYPE zcl_qjs_lexer=>ty_token.
    DATA lv_depth TYPE i.
    CREATE OBJECT lo_scanner EXPORTING cache = mo_lexer.
    lo_scanner->set_offset( ms_token-offset ).
    WHILE abap_true = abap_true.
      lo_scanner->next_into( CHANGING token = ls_scan ).
      IF ls_scan-kind = zcl_qjs_lexer=>token_lparen.
        lv_depth = lv_depth + 1.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_rparen.
        lv_depth = lv_depth - 1.
        IF lv_depth = 0.
          RETURN.
        ENDIF.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_ellipsis AND lv_depth = 1.
        result = abap_true.
        RETURN.
      ELSEIF ls_scan-kind = zcl_qjs_lexer=>token_eof.
        RETURN.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD parse_spread_arguments.
    mo_emitter->emit( opcode = zif_qjs_opcodes=>new_array operand = 0 ).
    mo_emitter->emit( opcode = zif_qjs_opcodes=>push_i32 operand = 0 ).
    IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
      WHILE abap_true = abap_true.
        IF ms_token-kind = zcl_qjs_lexer=>token_ellipsis.
          advance( ).
          parse_assignment( ).
        ELSE.
          parse_assignment( ).
          mo_emitter->emit( opcode = zif_qjs_opcodes=>new_array operand = 1 ).
        ENDIF.
        mo_emitter->emit( zif_qjs_opcodes=>append ).
        IF ms_token-kind = zcl_qjs_lexer=>token_comma.
          advance( ).
        ELSE.
          EXIT.
        ENDIF.
      ENDWHILE.
    ENDIF.
    mo_emitter->emit( zif_qjs_opcodes=>drop ).
  ENDMETHOD.

  METHOD parse_spread_array.
    mo_emitter->emit( opcode = zif_qjs_opcodes=>new_array operand = 0 ).
    mo_emitter->emit( opcode = zif_qjs_opcodes=>push_i32 operand = 0 ).
    WHILE ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
      IF ms_token-kind = zcl_qjs_lexer=>token_comma.
        mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
        mo_emitter->emit( opcode = zif_qjs_opcodes=>new_array operand = 1 ).
        mo_emitter->emit( zif_qjs_opcodes=>append ).
        mo_emitter->emit( zif_qjs_opcodes=>duplicate_two ).
        mo_emitter->emit( opcode = zif_qjs_opcodes=>push_i32 operand = 1 ).
        mo_emitter->emit( zif_qjs_opcodes=>subtract ).
        mo_emitter->emit( zif_qjs_opcodes=>delete_property ).
        mo_emitter->emit( zif_qjs_opcodes=>drop ).
        advance( ).
        CONTINUE.
      ENDIF.
      IF ms_token-kind = zcl_qjs_lexer=>token_ellipsis.
        advance( ).
        parse_assignment( ).
      ELSE.
        parse_assignment( ).
        mo_emitter->emit( opcode = zif_qjs_opcodes=>new_array operand = 1 ).
      ENDIF.
      mo_emitter->emit( zif_qjs_opcodes=>append ).
      IF ms_token-kind = zcl_qjs_lexer=>token_comma.
        advance( ).
      ELSE.
        EXIT.
      ENDIF.
    ENDWHILE.
    mo_emitter->emit( zif_qjs_opcodes=>drop ).
  ENDMETHOD.

  METHOD parse_postfix.
    DATA lv_argument_count TYPE i.
    DATA lv_atom TYPE i.
    DATA lv_method_call TYPE abap_bool.
    DATA lv_super_call TYPE abap_bool.
    DATA lt_optional_jumps TYPE ty_jump_indices.
    DATA lv_optional_jump TYPE i.
    parse_factor( ).
    lv_method_call = mv_factor_method_call.
    lv_super_call = mv_factor_super_call.
    CLEAR mv_factor_method_call.
    CLEAR mv_factor_super_call.
    WHILE ms_token-kind = zcl_qjs_lexer=>token_lparen
        OR ms_token-kind = zcl_qjs_lexer=>token_dot
        OR ms_token-kind = zcl_qjs_lexer=>token_optional_chain
        OR ms_token-kind = zcl_qjs_lexer=>token_lbracket
        OR ( ( ms_token-kind = zcl_qjs_lexer=>token_template_head
          OR ms_token-kind = zcl_qjs_lexer=>token_template_tail )
          AND ms_token-template_continuation = abap_false ).
      IF ms_token-kind = zcl_qjs_lexer=>token_lparen.
        DATA(lv_call_spread) = call_has_spread( ).
        IF lv_call_spread = abap_true AND lv_method_call = abap_false.
          mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
          mo_emitter->emit( zif_qjs_opcodes=>swap ).
        ENDIF.
        advance( ).
        IF lv_call_spread = abap_true.
          parse_spread_arguments( ).
          IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Expected closing spread-call parenthesis'.
          ENDIF.
          advance( ).
          mo_emitter->emit( zif_qjs_opcodes=>apply ).
          lv_method_call = abap_false.
          CONTINUE.
        ENDIF.
        lv_argument_count = 0.
        IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
          WHILE abap_true = abap_true.
            parse_assignment( ).
            lv_argument_count = lv_argument_count + 1.
            IF ms_token-kind = zcl_qjs_lexer=>token_comma.
              advance( ).
            ELSE.
              EXIT.
            ENDIF.
          ENDWHILE.
        ENDIF.
        IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected closing call parenthesis'.
        ENDIF.
        advance( ).
        IF lv_method_call = abap_true.
          mo_emitter->emit(
            opcode = zif_qjs_opcodes=>call_method operand = lv_argument_count
            operand2 = COND i( WHEN lv_super_call = abap_true THEN 1 ELSE 0 ) ).
          lv_method_call = abap_false.
          lv_super_call = abap_false.
        ELSE.
          mo_emitter->emit(
            opcode = zif_qjs_opcodes=>call operand = lv_argument_count ).
        ENDIF.
      ELSEIF ms_token-kind = zcl_qjs_lexer=>token_template_head
          OR ms_token-kind = zcl_qjs_lexer=>token_template_tail.
        parse_tagged_template( lv_method_call ).
        lv_method_call = abap_false.
      ELSEIF ms_token-kind = zcl_qjs_lexer=>token_dot
          OR ms_token-kind = zcl_qjs_lexer=>token_optional_chain.
        DATA(lv_optional_chain) = xsdbool(
          ms_token-kind = zcl_qjs_lexer=>token_optional_chain ).
        IF lv_optional_chain = abap_true.
          mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
          mo_emitter->emit( zif_qjs_opcodes=>push_null ).
          mo_emitter->emit( zif_qjs_opcodes=>strict_equal ).
          lv_optional_jump = mo_emitter->position( ).
          APPEND lv_optional_jump TO lt_optional_jumps.
          mo_emitter->emit( zif_qjs_opcodes=>if_true ).
          mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
          mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
          mo_emitter->emit( zif_qjs_opcodes=>strict_equal ).
          lv_optional_jump = mo_emitter->position( ).
          APPEND lv_optional_jump TO lt_optional_jumps.
          mo_emitter->emit( zif_qjs_opcodes=>if_true ).
        ENDIF.
        advance( ).
        IF ms_token-kind = zcl_qjs_lexer=>token_private_identifier.
          DATA(ls_private_member_binding) = find_binding( '#' && ms_token-text ).
          advance( ).
          IF ms_token-kind = zcl_qjs_lexer=>token_lparen.
            mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
            emit_binding_get( ls_private_member_binding ).
            mo_emitter->emit( zif_qjs_opcodes=>get_private_field ).
            lv_method_call = abap_true.
            CONTINUE.
          ENDIF.
          emit_binding_get( ls_private_member_binding ).
          IF ms_token-kind = zcl_qjs_lexer=>token_assign.
            advance( ).
            parse_assignment( ).
            mo_emitter->emit( zif_qjs_opcodes=>insert_three ).
            mo_emitter->emit( zif_qjs_opcodes=>swap ).
            mo_emitter->emit( zif_qjs_opcodes=>put_private_field ).
          ELSEIF is_compound_assignment( ms_token-kind ) = abap_true.
            DATA(lv_private_compound) = ms_token-kind.
            mo_emitter->emit( zif_qjs_opcodes=>duplicate_two ).
            mo_emitter->emit( zif_qjs_opcodes=>get_private_field ).
            advance( ).
            parse_assignment( ).
            emit_compound_operator( lv_private_compound ).
            mo_emitter->emit( zif_qjs_opcodes=>insert_three ).
            mo_emitter->emit( zif_qjs_opcodes=>swap ).
            mo_emitter->emit( zif_qjs_opcodes=>put_private_field ).
          ELSEIF ( ms_token-kind = zcl_qjs_lexer=>token_increment
                OR ms_token-kind = zcl_qjs_lexer=>token_decrement )
              AND ms_token-line_terminator_before = abap_false.
            DATA(lv_private_update) = zif_qjs_opcodes=>increment.
            IF ms_token-kind = zcl_qjs_lexer=>token_decrement.
              lv_private_update = zif_qjs_opcodes=>decrement.
            ENDIF.
            advance( ).
            mo_emitter->emit( zif_qjs_opcodes=>duplicate_two ).
            mo_emitter->emit( zif_qjs_opcodes=>get_private_field ).
            mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
            mo_emitter->emit( lv_private_update ).
            mo_emitter->emit( zif_qjs_opcodes=>permute_four ).
            mo_emitter->emit( zif_qjs_opcodes=>swap ).
            mo_emitter->emit( zif_qjs_opcodes=>put_private_field ).
          ELSE.
            mo_emitter->emit( zif_qjs_opcodes=>get_private_field ).
          ENDIF.
          CONTINUE.
        ENDIF.
        IF is_identifier_name( ms_token-kind ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected property name after dot'.
        ENDIF.
        lv_atom = mo_emitter->intern_atom( ms_token-text ).
        advance( ).
        IF ms_token-kind = zcl_qjs_lexer=>token_assign.
          advance( ).
          parse_assignment( ).
          mo_emitter->emit( zif_qjs_opcodes=>insert_two ).
          mo_emitter->emit( opcode = zif_qjs_opcodes=>put_field operand = lv_atom ).
        ELSEIF is_compound_assignment( ms_token-kind ) = abap_true.
          DATA(lv_field_compound) = ms_token-kind.
          mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
          mo_emitter->emit(
            opcode = zif_qjs_opcodes=>get_field operand = lv_atom ).
          advance( ).
          parse_assignment( ).
          emit_compound_operator( lv_field_compound ).
          mo_emitter->emit( zif_qjs_opcodes=>insert_two ).
          mo_emitter->emit( opcode = zif_qjs_opcodes=>put_field operand = lv_atom ).
        ELSEIF ( ms_token-kind = zcl_qjs_lexer=>token_increment
              OR ms_token-kind = zcl_qjs_lexer=>token_decrement )
            AND ms_token-line_terminator_before = abap_false.
          DATA(lv_field_update) = zif_qjs_opcodes=>increment.
          IF ms_token-kind = zcl_qjs_lexer=>token_decrement.
            lv_field_update = zif_qjs_opcodes=>decrement.
          ENDIF.
          advance( ).
          mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
          mo_emitter->emit(
            opcode = zif_qjs_opcodes=>get_field operand = lv_atom ).
          mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
          mo_emitter->emit( lv_field_update ).
          mo_emitter->emit( zif_qjs_opcodes=>permute_three ).
          mo_emitter->emit( opcode = zif_qjs_opcodes=>put_field operand = lv_atom ).
        ELSE.
          IF ms_token-kind = zcl_qjs_lexer=>token_lparen
              OR ( ( ms_token-kind = zcl_qjs_lexer=>token_template_head
                OR ms_token-kind = zcl_qjs_lexer=>token_template_tail )
                AND ms_token-template_continuation = abap_false ).
            mo_emitter->emit(
              opcode = zif_qjs_opcodes=>get_field_for_call operand = lv_atom ).
            lv_method_call = abap_true.
          ELSE.
            mo_emitter->emit( opcode = zif_qjs_opcodes=>get_field operand = lv_atom ).
          ENDIF.
        ENDIF.
      ELSE.
        advance( ).
        parse_expression( ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected closing property bracket'.
        ENDIF.
        advance( ).
        IF ms_token-kind = zcl_qjs_lexer=>token_assign.
          advance( ).
          parse_assignment( ).
          mo_emitter->emit( zif_qjs_opcodes=>insert_three ).
          mo_emitter->emit( zif_qjs_opcodes=>put_element ).
        ELSEIF is_compound_assignment( ms_token-kind ) = abap_true.
          DATA(lv_element_compound) = ms_token-kind.
          mo_emitter->emit( zif_qjs_opcodes=>duplicate_two ).
          mo_emitter->emit( zif_qjs_opcodes=>get_element ).
          advance( ).
          parse_assignment( ).
          emit_compound_operator( lv_element_compound ).
          mo_emitter->emit( zif_qjs_opcodes=>insert_three ).
          mo_emitter->emit( zif_qjs_opcodes=>put_element ).
        ELSEIF ( ms_token-kind = zcl_qjs_lexer=>token_increment
              OR ms_token-kind = zcl_qjs_lexer=>token_decrement )
            AND ms_token-line_terminator_before = abap_false.
          DATA(lv_element_update) = zif_qjs_opcodes=>increment.
          IF ms_token-kind = zcl_qjs_lexer=>token_decrement.
            lv_element_update = zif_qjs_opcodes=>decrement.
          ENDIF.
          advance( ).
          mo_emitter->emit( zif_qjs_opcodes=>duplicate_two ).
          mo_emitter->emit( zif_qjs_opcodes=>get_element ).
          mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
          mo_emitter->emit( lv_element_update ).
          mo_emitter->emit( zif_qjs_opcodes=>permute_four ).
          mo_emitter->emit( zif_qjs_opcodes=>put_element ).
        ELSE.
          IF ms_token-kind = zcl_qjs_lexer=>token_lparen
              OR ( ( ms_token-kind = zcl_qjs_lexer=>token_template_head
                OR ms_token-kind = zcl_qjs_lexer=>token_template_tail )
                AND ms_token-template_continuation = abap_false ).
            mo_emitter->emit( zif_qjs_opcodes=>get_element_for_call ).
            lv_method_call = abap_true.
          ELSE.
            mo_emitter->emit( zif_qjs_opcodes=>get_element ).
          ENDIF.
        ENDIF.
      ENDIF.
    ENDWHILE.
    IF lines( lt_optional_jumps ) > 0.
      DATA(lv_optional_end_jump) = mo_emitter->position( ).
      mo_emitter->emit( zif_qjs_opcodes=>goto ).
      DATA(lv_optional_null_target) = mo_emitter->position( ).
      mo_emitter->emit( zif_qjs_opcodes=>drop ).
      mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
      DATA(lv_optional_end_target) = mo_emitter->position( ).
      mo_emitter->patch(
        instruction = lv_optional_end_jump target = lv_optional_end_target ).
      LOOP AT lt_optional_jumps INTO lv_optional_jump.
        mo_emitter->patch(
          instruction = lv_optional_jump target = lv_optional_null_target ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD parse_prefix_update.
    IF ms_token-kind <> zcl_qjs_lexer=>token_identifier.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Invalid prefix update target'.
    ENDIF.
    DATA(ls_update_binding) = find_binding( ms_token-text ).
    emit_binding_get( ls_update_binding ).
    advance( ).
    IF ms_token-kind = zcl_qjs_lexer=>token_lparen.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Call update targets are not implemented'.
    ENDIF.
    IF ms_token-kind <> zcl_qjs_lexer=>token_dot
        AND ms_token-kind <> zcl_qjs_lexer=>token_lbracket.
      mo_emitter->emit( opcode ).
      emit_binding_set( ls_update_binding ).
      RETURN.
    ENDIF.
    WHILE ms_token-kind = zcl_qjs_lexer=>token_dot
        OR ms_token-kind = zcl_qjs_lexer=>token_lbracket.
      IF ms_token-kind = zcl_qjs_lexer=>token_dot.
        advance( ).
        IF is_identifier_name( ms_token-kind ) = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected property name after dot'.
        ENDIF.
        DATA(lv_update_atom) = mo_emitter->intern_atom( ms_token-text ).
        advance( ).
        IF ms_token-kind = zcl_qjs_lexer=>token_dot
            OR ms_token-kind = zcl_qjs_lexer=>token_lbracket.
          mo_emitter->emit(
            opcode = zif_qjs_opcodes=>get_field operand = lv_update_atom ).
        ELSE.
          mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
          mo_emitter->emit(
            opcode = zif_qjs_opcodes=>get_field operand = lv_update_atom ).
          mo_emitter->emit( opcode ).
          mo_emitter->emit( zif_qjs_opcodes=>insert_two ).
          mo_emitter->emit(
            opcode = zif_qjs_opcodes=>put_field operand = lv_update_atom ).
          RETURN.
        ENDIF.
      ELSE.
        advance( ).
        parse_expression( ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected closing property bracket'.
        ENDIF.
        advance( ).
        IF ms_token-kind = zcl_qjs_lexer=>token_dot
            OR ms_token-kind = zcl_qjs_lexer=>token_lbracket.
          mo_emitter->emit( zif_qjs_opcodes=>get_element ).
        ELSE.
          mo_emitter->emit( zif_qjs_opcodes=>duplicate_two ).
          mo_emitter->emit( zif_qjs_opcodes=>get_element ).
          mo_emitter->emit( opcode ).
          mo_emitter->emit( zif_qjs_opcodes=>insert_three ).
          mo_emitter->emit( zif_qjs_opcodes=>put_element ).
          RETURN.
        ENDIF.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD parse_template_literal.
    DATA lv_tail TYPE abap_bool.
    mo_emitter->emit_constant( zcl_qjs_value=>new_string( ms_token-text ) ).
    IF ms_token-kind = zcl_qjs_lexer=>token_template_tail.
      advance( ).
      RETURN.
    ENDIF.
    advance( ).
    WHILE abap_true = abap_true.
      parse_expression( ).
      mo_emitter->emit( zif_qjs_opcodes=>add ).
      IF ms_token-kind <> zcl_qjs_lexer=>token_template_middle
          AND ms_token-kind <> zcl_qjs_lexer=>token_template_tail.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected template interpolation boundary'.
      ENDIF.
      lv_tail = xsdbool(
        ms_token-kind = zcl_qjs_lexer=>token_template_tail ).
      mo_emitter->emit_constant( zcl_qjs_value=>new_string( ms_token-text ) ).
      mo_emitter->emit( zif_qjs_opcodes=>add ).
      advance( ).
      IF lv_tail = abap_true.
        RETURN.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD parse_tagged_template.
    DATA(lo_site) = NEW zcl_qjs_template_site( ).
    DATA(lv_tail) = xsdbool(
      ms_token-kind = zcl_qjs_lexer=>token_template_tail ).
    lo_site->add_part( cooked = ms_token-text raw = ms_token-raw ).
    mo_emitter->emit_constant( zcl_qjs_value=>new_object( lo_site ) ).
    DATA(lv_argument_count) = 1.
    advance( ).
    WHILE lv_tail = abap_false.
      parse_expression( ).
      lv_argument_count = lv_argument_count + 1.
      IF ms_token-kind <> zcl_qjs_lexer=>token_template_middle
          AND ms_token-kind <> zcl_qjs_lexer=>token_template_tail.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Expected tagged template interpolation boundary'.
      ENDIF.
      lv_tail = xsdbool(
        ms_token-kind = zcl_qjs_lexer=>token_template_tail ).
      lo_site->add_part( cooked = ms_token-text raw = ms_token-raw ).
      advance( ).
    ENDWHILE.
    IF method_call = abap_true.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>call_method operand = lv_argument_count ).
    ELSE.
      mo_emitter->emit(
        opcode = zif_qjs_opcodes=>call operand = lv_argument_count ).
    ENDIF.
  ENDMETHOD.

  METHOD parse_factor.
    DATA lv_number TYPE i.
    mv_parser_depth = mv_parser_depth + 1.
    IF mv_parser_depth > mv_checked_parser_depth.
      mo_limits->check_parser_depth( mv_parser_depth ).
      mv_checked_parser_depth = mv_parser_depth.
    ENDIF.
    CASE ms_token-kind.
      WHEN zcl_qjs_lexer=>token_number.
        lv_number = ms_token-number.
        DATA(ls_number_value) = zcl_qjs_number=>parse_literal( ms_token-text ).
        DATA(lv_integer_literal) = ms_token-integer_literal.
        advance( ).
        IF lv_integer_literal = abap_true.
          mo_emitter->emit(
            opcode  = zif_qjs_opcodes=>push_i32
            operand = lv_number ).
        ELSE.
          mo_emitter->emit_constant( ls_number_value ).
        ENDIF.
      WHEN zcl_qjs_lexer=>token_string.
        DATA(ls_string) = zcl_qjs_value=>new_string( ms_token-text ).
        advance( ).
        mo_emitter->emit_constant( ls_string ).
      WHEN zcl_qjs_lexer=>token_regexp.
        DATA(ls_regexp_pattern) = zcl_qjs_value=>new_string( ms_token-text ).
        DATA(ls_regexp_flags) = zcl_qjs_value=>new_string( ms_token-raw ).
        advance( ).
        mo_emitter->emit_constant( ls_regexp_pattern ).
        mo_emitter->emit_constant( ls_regexp_flags ).
        mo_emitter->emit( zif_qjs_opcodes=>regexp ).
      WHEN zcl_qjs_lexer=>token_template_head
          OR zcl_qjs_lexer=>token_template_tail.
        parse_template_literal( ).
      WHEN zcl_qjs_lexer=>token_true.
        advance( ).
        mo_emitter->emit( zif_qjs_opcodes=>push_true ).
      WHEN zcl_qjs_lexer=>token_false.
        advance( ).
        mo_emitter->emit( zif_qjs_opcodes=>push_false ).
      WHEN zcl_qjs_lexer=>token_null.
        advance( ).
        mo_emitter->emit( zif_qjs_opcodes=>push_null ).
      WHEN zcl_qjs_lexer=>token_undefined.
        advance( ).
        mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
      WHEN zcl_qjs_lexer=>token_identifier.
        IF is_async_function_start( ) = abap_true.
          mv_parsing_async_function = abap_true.
          advance( ).
          parse_function_expression( ).
          mv_parser_depth = mv_parser_depth - 1.
          RETURN.
        ELSEIF ms_token-text = 'await' AND mv_in_async = abap_true.
          advance( ).
          parse_postfix( ).
          mo_emitter->emit( zif_qjs_opcodes=>await ).
          mv_parser_depth = mv_parser_depth - 1.
          RETURN.
        ENDIF.
        DATA(lv_name) = ms_token-text.
        DATA(ls_binding) = find_binding( lv_name ).
        advance( ).
        IF ms_token-kind = zcl_qjs_lexer=>token_assign.
          advance( ).
          parse_assignment( ).
          emit_binding_set( ls_binding ).
        ELSEIF is_compound_assignment( ms_token-kind ) = abap_true.
          DATA(lv_compound_kind) = ms_token-kind.
          emit_binding_get( ls_binding ).
          advance( ).
          parse_assignment( ).
          emit_compound_operator( lv_compound_kind ).
          emit_binding_set( ls_binding ).
        ELSE.
          emit_binding_get( ls_binding ).
          IF ( ms_token-kind = zcl_qjs_lexer=>token_increment
                OR ms_token-kind = zcl_qjs_lexer=>token_decrement )
              AND ms_token-line_terminator_before = abap_false.
            DATA(lv_postfix_opcode) = zif_qjs_opcodes=>increment.
            IF ms_token-kind = zcl_qjs_lexer=>token_decrement.
              lv_postfix_opcode = zif_qjs_opcodes=>decrement.
            ENDIF.
            advance( ).
            mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
            mo_emitter->emit( lv_postfix_opcode ).
            emit_binding_put( ls_binding ).
          ENDIF.
        ENDIF.
      WHEN zcl_qjs_lexer=>token_private_identifier.
        DATA(ls_private_in_binding) = find_binding( '#' && ms_token-text ).
        advance( ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_in.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Private name must be used with in'.
        ENDIF.
        emit_binding_get( ls_private_in_binding ).
      WHEN zcl_qjs_lexer=>token_function.
        parse_function_expression( ).
      WHEN zcl_qjs_lexer=>token_class.
        parse_class_expression( ).
      WHEN zcl_qjs_lexer=>token_this.
        advance( ).
        IF mv_in_function = abap_true.
          DATA(ls_this_binding) = find_binding( 'this' ).
          IF ls_this_binding-kind = zcl_qjs_function=>capture_parent.
            mo_emitter->emit(
              opcode = zif_qjs_opcodes=>get_capture operand = ls_this_binding-index ).
          ELSE.
            mo_emitter->emit(
              opcode = zif_qjs_opcodes=>get_local operand = ls_this_binding-index ).
          ENDIF.
        ELSE.
          READ TABLE mt_locals WITH TABLE KEY name = 'globalThis'
            function_depth = mv_function_depth
            INTO DATA(ls_global_this_binding).
          IF sy-subrc = 0.
            mo_emitter->emit(
              opcode  = zif_qjs_opcodes=>get_local
              operand = ls_global_this_binding-index ).
          ELSE.
            mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
          ENDIF.
        ENDIF.
      WHEN zcl_qjs_lexer=>token_super.
        IF mv_has_super = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'super is only valid in a derived class'.
        ENDIF.
        DATA(ls_super_this) = find_binding( 'this' ).
        DATA(ls_super_target) = find_binding( ms_super_binding-name ).
        emit_binding_get( ls_super_this ).
        DATA(lv_super_this_local) = mo_emitter->allocate_local( ).
        mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>put_local operand = lv_super_this_local ).
        IF mv_super_object_method = abap_true.
          DATA(ls_super_object_binding) = find_binding( 'Object' ).
          emit_binding_get( ls_super_object_binding ).
          mo_emitter->emit(
            opcode  = zif_qjs_opcodes=>get_field_for_call
            operand = mo_emitter->intern_atom( 'getPrototypeOf' ) ).
          emit_binding_get( ls_super_target ).
          mo_emitter->emit(
            opcode = zif_qjs_opcodes=>call_method operand = 1 ).
        ELSE.
          emit_binding_get( ls_super_target ).
        ENDIF.
        advance( ).
        IF ms_token-kind = zcl_qjs_lexer=>token_lparen.
          IF mv_super_call_allowed = abap_false.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'super() is only valid in a derived constructor'.
          ENDIF.
          mv_factor_method_call = abap_true.
          mv_factor_super_call = abap_true.
        ELSEIF ms_token-kind = zcl_qjs_lexer=>token_dot
            OR ms_token-kind = zcl_qjs_lexer=>token_lbracket.
          IF mv_super_static = abap_false
              AND mv_super_object_method = abap_false.
            mo_emitter->emit(
              opcode  = zif_qjs_opcodes=>get_field
              operand = mo_emitter->intern_atom( 'prototype' ) ).
          ENDIF.
          IF ms_token-kind = zcl_qjs_lexer=>token_dot.
            advance( ).
            IF is_identifier_name( ms_token-kind ) = abap_false.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'Expected property name after super dot'.
            ENDIF.
            mo_emitter->emit_constant(
              zcl_qjs_value=>new_string( ms_token-text ) ).
            advance( ).
          ELSE.
            advance( ).
            parse_expression( ).
            IF ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'Expected closing super property bracket'.
            ENDIF.
            advance( ).
          ENDIF.
          IF ms_token-kind = zcl_qjs_lexer=>token_assign.
            advance( ).
            parse_assignment( ).
            DATA(lv_super_value_local) = mo_emitter->allocate_local( ).
            mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
            mo_emitter->emit(
              opcode  = zif_qjs_opcodes=>put_local
              operand = lv_super_value_local ).
            mo_emitter->emit( zif_qjs_opcodes=>put_super_value ).
            mo_emitter->emit(
              opcode  = zif_qjs_opcodes=>get_local
              operand = lv_super_value_local ).
          ELSE.
            mo_emitter->emit( zif_qjs_opcodes=>get_super_value ).
            IF ms_token-kind = zcl_qjs_lexer=>token_lparen
                OR ms_token-kind = zcl_qjs_lexer=>token_template_head
                OR ms_token-kind = zcl_qjs_lexer=>token_template_tail.
              mo_emitter->emit(
                opcode = zif_qjs_opcodes=>get_local operand = lv_super_this_local ).
              mo_emitter->emit( zif_qjs_opcodes=>swap ).
              mv_factor_method_call = abap_true.
            ENDIF.
          ENDIF.
        ELSE.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Invalid super expression'.
        ENDIF.
      WHEN zcl_qjs_lexer=>token_minus.
        advance( ).
        parse_postfix( ).
        mo_emitter->emit( zif_qjs_opcodes=>negate ).
      WHEN zcl_qjs_lexer=>token_plus.
        advance( ).
        parse_postfix( ).
        mo_emitter->emit( zif_qjs_opcodes=>unary_plus ).
      WHEN zcl_qjs_lexer=>token_bang.
        advance( ).
        parse_postfix( ).
        mo_emitter->emit( zif_qjs_opcodes=>logical_not ).
      WHEN zcl_qjs_lexer=>token_typeof.
        advance( ).
        DATA(lv_typeof_unresolvable) = abap_false.
        IF ms_token-kind = zcl_qjs_lexer=>token_identifier.
          lv_typeof_unresolvable = xsdbool(
            has_binding( ms_token-text ) = abap_false ).
        ENDIF.
        IF lv_typeof_unresolvable = abap_true.
          advance( ).
          IF ms_token-kind = zcl_qjs_lexer=>token_dot
              OR ms_token-kind = zcl_qjs_lexer=>token_lbracket
              OR ms_token-kind = zcl_qjs_lexer=>token_lparen.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Unknown JavaScript identifier in typeof operand'.
          ENDIF.
          mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
        ELSE.
          parse_postfix( ).
        ENDIF.
        mo_emitter->emit( zif_qjs_opcodes=>type_of ).
      WHEN zcl_qjs_lexer=>token_void.
        advance( ).
        parse_postfix( ).
        mo_emitter->emit( zif_qjs_opcodes=>drop ).
        mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
      WHEN zcl_qjs_lexer=>token_bit_not.
        advance( ).
        parse_postfix( ).
        mo_emitter->emit( zif_qjs_opcodes=>bitwise_not ).
      WHEN zcl_qjs_lexer=>token_increment OR zcl_qjs_lexer=>token_decrement.
        DATA(lv_prefix_opcode) = zif_qjs_opcodes=>increment.
        IF ms_token-kind = zcl_qjs_lexer=>token_decrement.
          lv_prefix_opcode = zif_qjs_opcodes=>decrement.
        ENDIF.
        advance( ).
        parse_prefix_update( lv_prefix_opcode ).
      WHEN zcl_qjs_lexer=>token_delete.
        advance( ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_identifier.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Delete target is not implemented'.
        ENDIF.
        DATA(ls_delete_binding) = find_binding( ms_token-text ).
        IF ls_delete_binding-kind = zcl_qjs_function=>capture_parent.
          mo_emitter->emit(
            opcode = zif_qjs_opcodes=>get_capture operand = ls_delete_binding-index ).
        ELSEIF ls_delete_binding-lexical = abap_true.
          mo_emitter->emit(
            opcode = zif_qjs_opcodes=>get_lexical operand = ls_delete_binding-index ).
        ELSE.
          mo_emitter->emit(
            opcode = zif_qjs_opcodes=>get_local operand = ls_delete_binding-index ).
        ENDIF.
        advance( ).
        IF ms_token-kind = zcl_qjs_lexer=>token_dot.
          advance( ).
          IF is_identifier_name( ms_token-kind ) = abap_false.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Expected property name after delete'.
          ENDIF.
          mo_emitter->emit_constant( zcl_qjs_value=>new_string( ms_token-text ) ).
          advance( ).
        ELSEIF ms_token-kind = zcl_qjs_lexer=>token_lbracket.
          advance( ).
          parse_expression( ).
          IF ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Expected closing delete bracket'.
          ENDIF.
          advance( ).
        ELSE.
          mo_emitter->emit( zif_qjs_opcodes=>drop ).
          mo_emitter->emit( zif_qjs_opcodes=>push_false ).
          mv_parser_depth = mv_parser_depth - 1.
          RETURN.
        ENDIF.
        mo_emitter->emit( zif_qjs_opcodes=>delete_property ).
      WHEN zcl_qjs_lexer=>token_lparen.
        advance( ).
        parse_expression( ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING
              reason = 'Expected closing parenthesis'.
        ENDIF.
        advance( ).
      WHEN zcl_qjs_lexer=>token_lbracket.
        DATA(lv_element_count) = 0.
        DATA lt_array_holes TYPE STANDARD TABLE OF i WITH EMPTY KEY.
        DATA(lv_array_spread) = array_literal_has_spread( ).
        advance( ).
        IF lv_array_spread = abap_true.
          parse_spread_array( ).
          IF ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Expected closing spread-array bracket'.
          ENDIF.
          advance( ).
        ELSE.
        WHILE ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
          IF ms_token-kind = zcl_qjs_lexer=>token_comma.
            APPEND lv_element_count TO lt_array_holes.
            mo_emitter->emit( zif_qjs_opcodes=>push_undefined ).
            lv_element_count = lv_element_count + 1.
            advance( ).
          ELSE.
            parse_assignment( ).
            lv_element_count = lv_element_count + 1.
            IF ms_token-kind = zcl_qjs_lexer=>token_comma.
              advance( ).
            ELSE.
              EXIT.
            ENDIF.
          ENDIF.
        ENDWHILE.
        IF ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected closing array bracket'.
        ENDIF.
        advance( ).
        mo_emitter->emit(
          opcode = zif_qjs_opcodes=>new_array operand = lv_element_count ).
        LOOP AT lt_array_holes INTO DATA(lv_array_hole).
          mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
          mo_emitter->emit(
            opcode = zif_qjs_opcodes=>push_i32 operand = lv_array_hole ).
          mo_emitter->emit( zif_qjs_opcodes=>delete_property ).
          mo_emitter->emit( zif_qjs_opcodes=>drop ).
        ENDLOOP.
        ENDIF.
      WHEN zcl_qjs_lexer=>token_lbrace.
        mo_emitter->emit( zif_qjs_opcodes=>new_object ).
        DATA ls_object_home_binding TYPE ty_local.
        ls_object_home_binding-index = mo_emitter->allocate_local( ).
        ls_object_home_binding-kind = zcl_qjs_function=>capture_local.
        ls_object_home_binding-name = `[[object-home-`
          && CONV string( ls_object_home_binding-index ) && `]]`.
        ls_object_home_binding-function_depth = mv_function_depth.
        INSERT ls_object_home_binding INTO TABLE mt_locals.
        mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
        mo_emitter->emit(
          opcode  = zif_qjs_opcodes=>put_local
          operand = ls_object_home_binding-index ).
        advance( ).
        WHILE ms_token-kind <> zcl_qjs_lexer=>token_rbrace.
          IF ms_token-kind = zcl_qjs_lexer=>token_identifier
              AND ms_token-text = 'async'.
            DATA(lo_object_async_scanner) = NEW zcl_qjs_lexer( cache = mo_lexer ).
            lo_object_async_scanner->set_offset( mo_lexer->get_offset( ) ).
            DATA(ls_object_async_lookahead) = lo_object_async_scanner->next( ).
            IF ls_object_async_lookahead-line_terminator_before = abap_false
                AND ls_object_async_lookahead-kind <> zcl_qjs_lexer=>token_lparen
                AND ls_object_async_lookahead-kind <> zcl_qjs_lexer=>token_colon
                AND ls_object_async_lookahead-kind <> zcl_qjs_lexer=>token_comma
                AND ls_object_async_lookahead-kind <> zcl_qjs_lexer=>token_rbrace
                AND ls_object_async_lookahead-kind <> zcl_qjs_lexer=>token_assign
                AND ls_object_async_lookahead-kind
                  <> zcl_qjs_lexer=>token_semicolon.
              advance( ).
              DATA(lv_object_async_generator) = xsdbool(
                ms_token-kind = zcl_qjs_lexer=>token_star ).
              IF lv_object_async_generator = abap_true.
                advance( ).
              ENDIF.
              DATA lv_object_async_computed TYPE abap_bool.
              DATA lv_object_async_name TYPE string.
              CLEAR lv_object_async_computed.
              CLEAR lv_object_async_name.
              IF ms_token-kind = zcl_qjs_lexer=>token_lbracket.
                lv_object_async_computed = abap_true.
                advance( ).
                parse_expression( ).
                IF ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
                  RAISE EXCEPTION TYPE zcx_qjs_error
                    EXPORTING reason =
                      'Expected closing computed async-method bracket'.
                ENDIF.
              ELSE.
                IF is_identifier_name( ms_token-kind ) = abap_false
                    AND ms_token-kind <> zcl_qjs_lexer=>token_string
                    AND ms_token-kind <> zcl_qjs_lexer=>token_number.
                  RAISE EXCEPTION TYPE zcx_qjs_error
                    EXPORTING reason = 'Expected object async method name'.
                ENDIF.
                lv_object_async_name = ms_token-text.
                IF ms_token-kind = zcl_qjs_lexer=>token_number.
                  lv_object_async_name = zcl_qjs_value=>to_string(
                    zcl_qjs_number=>parse_literal( ms_token-text ) ).
                ENDIF.
              ENDIF.
              DATA(ls_old_object_async_super) = ms_super_binding.
              DATA(lv_old_object_async_has_super) = mv_has_super.
              DATA(lv_old_object_async_static) = mv_super_static.
              DATA(lv_old_object_async_method) = mv_super_object_method.
              DATA(lv_old_object_async_call) = mv_super_call_allowed.
              ms_super_binding = ls_object_home_binding.
              mv_has_super = abap_true.
              mv_super_static = abap_true.
              mv_super_object_method = abap_true.
              mv_super_call_allowed = abap_false.
              mv_parsing_class_method = abap_true.
              mv_parsing_async_function = abap_true.
              mv_parsing_generator_method = lv_object_async_generator.
              ms_token-kind = zcl_qjs_lexer=>token_function.
              parse_function_expression( ).
              ms_super_binding = ls_old_object_async_super.
              mv_has_super = lv_old_object_async_has_super.
              mv_super_static = lv_old_object_async_static.
              mv_super_object_method = lv_old_object_async_method.
              mv_super_call_allowed = lv_old_object_async_call.
              IF lv_object_async_computed = abap_true.
                mo_emitter->emit(
                  opcode = zif_qjs_opcodes=>define_method_computed operand = 10 ).
              ELSE.
                mo_emitter->emit(
                  opcode   = zif_qjs_opcodes=>define_method
                  operand  = mo_emitter->intern_atom( lv_object_async_name )
                  operand2 = 10 ).
              ENDIF.
              ELSE.
                DATA(lv_object_name_async) = ms_token-text.
                DATA(lv_object_async_atom) = mo_emitter->intern_atom(
                  lv_object_name_async ).
              IF ls_object_async_lookahead-kind = zcl_qjs_lexer=>token_lparen.
                DATA(ls_old_named_async_super) = ms_super_binding.
                DATA(lv_old_named_async_has_super) = mv_has_super.
                DATA(lv_old_named_async_static) = mv_super_static.
                DATA(lv_old_named_async_method) = mv_super_object_method.
                DATA(lv_old_named_async_call) = mv_super_call_allowed.
                ms_super_binding = ls_object_home_binding.
                mv_has_super = abap_true.
                mv_super_static = abap_true.
                mv_super_object_method = abap_true.
                mv_super_call_allowed = abap_false.
                mv_parsing_class_method = abap_true.
                ms_token-kind = zcl_qjs_lexer=>token_function.
                parse_function_expression( ).
                ms_super_binding = ls_old_named_async_super.
                mv_has_super = lv_old_named_async_has_super.
                mv_super_static = lv_old_named_async_static.
                mv_super_object_method = lv_old_named_async_method.
                mv_super_call_allowed = lv_old_named_async_call.
                mo_emitter->emit(
                  opcode   = zif_qjs_opcodes=>define_method
                  operand  = lv_object_async_atom
                  operand2 = 10 ).
              ELSE.
                advance( ).
                IF ms_token-kind = zcl_qjs_lexer=>token_colon.
                  advance( ).
                  mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
                  parse_assignment( ).
                  mo_emitter->emit(
                    opcode  = zif_qjs_opcodes=>put_field
                    operand = lv_object_async_atom ).
                ELSEIF ms_token-kind = zcl_qjs_lexer=>token_comma
                    OR ms_token-kind = zcl_qjs_lexer=>token_rbrace.
                  mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
                  emit_binding_get( find_binding( lv_object_name_async ) ).
                  mo_emitter->emit(
                    opcode  = zif_qjs_opcodes=>put_field
                    operand = lv_object_async_atom ).
                ELSE.
                  RAISE EXCEPTION TYPE zcx_qjs_error
                    EXPORTING reason = 'Expected colon after object property name'.
                ENDIF.
              ENDIF.
            ENDIF.
          ELSEIF ms_token-kind = zcl_qjs_lexer=>token_star.
            DATA lv_object_generator_computed TYPE abap_bool.
            DATA lv_object_generator_name TYPE string.
            CLEAR lv_object_generator_computed.
            CLEAR lv_object_generator_name.
            advance( ).
            IF ms_token-kind = zcl_qjs_lexer=>token_lbracket.
              lv_object_generator_computed = abap_true.
              advance( ).
              parse_expression( ).
              IF ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
                RAISE EXCEPTION TYPE zcx_qjs_error
                  EXPORTING reason =
                    'Expected closing computed generator-method bracket'.
              ENDIF.
            ELSE.
              IF is_identifier_name( ms_token-kind ) = abap_false
                  AND ms_token-kind <> zcl_qjs_lexer=>token_string
                  AND ms_token-kind <> zcl_qjs_lexer=>token_number.
                RAISE EXCEPTION TYPE zcx_qjs_error
                  EXPORTING reason = 'Expected object generator method name'.
              ENDIF.
              lv_object_generator_name = ms_token-text.
              IF ms_token-kind = zcl_qjs_lexer=>token_number.
                lv_object_generator_name = zcl_qjs_value=>to_string(
                  zcl_qjs_number=>parse_literal( ms_token-text ) ).
              ENDIF.
            ENDIF.
            DATA(ls_old_object_gen_super) = ms_super_binding.
            DATA(lv_old_object_gen_has_super) = mv_has_super.
            DATA(lv_old_object_gen_static) = mv_super_static.
            DATA(lv_old_object_gen_method) = mv_super_object_method.
            DATA(lv_old_object_gen_call) = mv_super_call_allowed.
            ms_super_binding = ls_object_home_binding.
            mv_has_super = abap_true.
            mv_super_static = abap_true.
            mv_super_object_method = abap_true.
            mv_super_call_allowed = abap_false.
            mv_parsing_class_method = abap_true.
            mv_parsing_generator_method = abap_true.
            ms_token-kind = zcl_qjs_lexer=>token_function.
            parse_function_expression( ).
            ms_super_binding = ls_old_object_gen_super.
            mv_has_super = lv_old_object_gen_has_super.
            mv_super_static = lv_old_object_gen_static.
            mv_super_object_method = lv_old_object_gen_method.
            mv_super_call_allowed = lv_old_object_gen_call.
            IF lv_object_generator_computed = abap_true.
              mo_emitter->emit(
                opcode = zif_qjs_opcodes=>define_method_computed operand = 10 ).
            ELSE.
              mo_emitter->emit(
                opcode   = zif_qjs_opcodes=>define_method
                operand  = mo_emitter->intern_atom( lv_object_generator_name )
                operand2 = 10 ).
            ENDIF.
          ELSEIF ms_token-kind = zcl_qjs_lexer=>token_identifier
              AND ( ms_token-text = 'get' OR ms_token-text = 'set' ).
            DATA(lo_object_accessor_scanner) = NEW zcl_qjs_lexer( cache = mo_lexer ).
            lo_object_accessor_scanner->set_offset( mo_lexer->get_offset( ) ).
            DATA(ls_object_accessor_lookahead) = lo_object_accessor_scanner->next( ).
            IF ls_object_accessor_lookahead-kind = zcl_qjs_lexer=>token_lparen.
              DATA(lv_plain_accessor_name) = ms_token-text.
              DATA(lv_plain_accessor_atom) = mo_emitter->intern_atom(
                lv_plain_accessor_name ).
              DATA(ls_old_plain_acc_super) = ms_super_binding.
              DATA(lv_old_plain_acc_has_super) = mv_has_super.
              DATA(lv_old_plain_acc_static) = mv_super_static.
              DATA(lv_old_plain_acc_method) = mv_super_object_method.
              DATA(lv_old_plain_acc_call) = mv_super_call_allowed.
              ms_super_binding = ls_object_home_binding.
              mv_has_super = abap_true.
              mv_super_static = abap_true.
              mv_super_object_method = abap_true.
              mv_super_call_allowed = abap_false.
              mv_parsing_class_method = abap_true.
              ms_token-kind = zcl_qjs_lexer=>token_function.
              parse_function_expression( ).
              ms_super_binding = ls_old_plain_acc_super.
              mv_has_super = lv_old_plain_acc_has_super.
              mv_super_static = lv_old_plain_acc_static.
              mv_super_object_method = lv_old_plain_acc_method.
              mv_super_call_allowed = lv_old_plain_acc_call.
              mo_emitter->emit(
                opcode = zif_qjs_opcodes=>define_method
                operand = lv_plain_accessor_atom operand2 = 10 ).
            ELSEIF ls_object_accessor_lookahead-kind = zcl_qjs_lexer=>token_colon
                OR ls_object_accessor_lookahead-kind = zcl_qjs_lexer=>token_comma
                OR ls_object_accessor_lookahead-kind = zcl_qjs_lexer=>token_rbrace.
              DATA(lv_accessor_property_name) = ms_token-text.
              DATA(lv_accessor_property_atom) = mo_emitter->intern_atom(
                lv_accessor_property_name ).
              advance( ).
              mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
              IF ms_token-kind = zcl_qjs_lexer=>token_colon.
                advance( ).
                parse_assignment( ).
              ELSE.
                emit_binding_get( find_binding( lv_accessor_property_name ) ).
              ENDIF.
              mo_emitter->emit(
                opcode  = zif_qjs_opcodes=>put_field
                operand = lv_accessor_property_atom ).
            ELSE.
              DATA(lv_object_accessor_kind) = COND i(
                WHEN ms_token-text = 'get' THEN 1 ELSE 2 ).
              advance( ).
              DATA lv_object_accessor_computed TYPE abap_bool.
              DATA lv_object_accessor_name TYPE string.
              CLEAR lv_object_accessor_computed.
              CLEAR lv_object_accessor_name.
              IF ms_token-kind = zcl_qjs_lexer=>token_lbracket.
                lv_object_accessor_computed = abap_true.
                mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
                advance( ).
                parse_expression( ).
                IF ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
                  RAISE EXCEPTION TYPE zcx_qjs_error
                    EXPORTING reason =
                      'Expected closing computed accessor bracket'.
                ENDIF.
              ELSE.
                IF is_identifier_name( ms_token-kind ) = abap_false
                    AND ms_token-kind <> zcl_qjs_lexer=>token_string
                    AND ms_token-kind <> zcl_qjs_lexer=>token_number.
                  RAISE EXCEPTION TYPE zcx_qjs_error
                    EXPORTING reason = 'Expected object accessor name'.
                ENDIF.
                lv_object_accessor_name = ms_token-text.
                IF ms_token-kind = zcl_qjs_lexer=>token_number.
                  lv_object_accessor_name = zcl_qjs_value=>to_string(
                    zcl_qjs_number=>parse_literal( ms_token-text ) ).
                ENDIF.
              ENDIF.
              DATA(ls_old_object_acc_super) = ms_super_binding.
              DATA(lv_old_object_acc_has_super) = mv_has_super.
              DATA(lv_old_object_acc_static) = mv_super_static.
              DATA(lv_old_object_acc_method) = mv_super_object_method.
              DATA(lv_old_object_acc_call) = mv_super_call_allowed.
              ms_super_binding = ls_object_home_binding.
              mv_has_super = abap_true.
              mv_super_static = abap_true.
              mv_super_object_method = abap_true.
              mv_super_call_allowed = abap_false.
              mv_parsing_class_method = abap_true.
              ms_token-kind = zcl_qjs_lexer=>token_function.
              parse_function_expression( ).
              ms_super_binding = ls_old_object_acc_super.
              mv_has_super = lv_old_object_acc_has_super.
              mv_super_static = lv_old_object_acc_static.
              mv_super_object_method = lv_old_object_acc_method.
              mv_super_call_allowed = lv_old_object_acc_call.
              IF lv_object_accessor_computed = abap_true.
                mo_emitter->emit(
                  opcode  = zif_qjs_opcodes=>define_method_computed
                  operand = lv_object_accessor_kind + 10 ).
              ELSE.
                mo_emitter->emit(
                  opcode   = zif_qjs_opcodes=>define_method
                  operand  = mo_emitter->intern_atom( lv_object_accessor_name )
                  operand2 = lv_object_accessor_kind + 10 ).
              ENDIF.
            ENDIF.
          ELSEIF ms_token-kind = zcl_qjs_lexer=>token_ellipsis.
            advance( ).
            parse_assignment( ).
            mo_emitter->emit( zif_qjs_opcodes=>push_null ).
            mo_emitter->emit(
              opcode = zif_qjs_opcodes=>copy_data_properties operand = 6 ).
            mo_emitter->emit( zif_qjs_opcodes=>drop ).
            mo_emitter->emit( zif_qjs_opcodes=>drop ).
          ELSEIF ms_token-kind = zcl_qjs_lexer=>token_lbracket.
            mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
            advance( ).
            parse_expression( ).
            IF ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'Expected closing computed-key bracket'.
            ENDIF.
            DATA(lo_computed_method_scanner) = NEW zcl_qjs_lexer( cache = mo_lexer ).
            lo_computed_method_scanner->set_offset( mo_lexer->get_offset( ) ).
            DATA(ls_computed_method_lookahead) = lo_computed_method_scanner->next( ).
            IF ls_computed_method_lookahead-kind = zcl_qjs_lexer=>token_lparen.
              DATA(ls_old_computed_super) = ms_super_binding.
              DATA(lv_old_computed_has_super) = mv_has_super.
              DATA(lv_old_computed_static) = mv_super_static.
              DATA(lv_old_computed_method) = mv_super_object_method.
              DATA(lv_old_computed_call) = mv_super_call_allowed.
              ms_super_binding = ls_object_home_binding.
              mv_has_super = abap_true.
              mv_super_static = abap_true.
              mv_super_object_method = abap_true.
              mv_super_call_allowed = abap_false.
              mv_parsing_class_method = abap_true.
              ms_token-kind = zcl_qjs_lexer=>token_function.
              parse_function_expression( ).
              ms_super_binding = ls_old_computed_super.
              mv_has_super = lv_old_computed_has_super.
              mv_super_static = lv_old_computed_static.
              mv_super_object_method = lv_old_computed_method.
              mv_super_call_allowed = lv_old_computed_call.
              mo_emitter->emit(
                opcode = zif_qjs_opcodes=>define_method_computed operand = 10 ).
            ELSE.
              advance( ).
              IF ms_token-kind <> zcl_qjs_lexer=>token_colon.
                RAISE EXCEPTION TYPE zcx_qjs_error
                  EXPORTING reason = 'Expected colon after computed property key'.
              ENDIF.
              advance( ).
              parse_assignment( ).
              mo_emitter->emit( zif_qjs_opcodes=>put_element ).
            ENDIF.
          ELSE.
            IF is_identifier_name( ms_token-kind ) = abap_false
                AND ms_token-kind <> zcl_qjs_lexer=>token_string
                AND ms_token-kind <> zcl_qjs_lexer=>token_number.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'Expected object literal property name'.
            ENDIF.
            DATA(lv_object_name) = ms_token-text.
            DATA(lv_object_shorthand) = xsdbool(
              ms_token-kind = zcl_qjs_lexer=>token_identifier ).
            IF ms_token-kind = zcl_qjs_lexer=>token_number.
              lv_object_name = zcl_qjs_value=>to_string(
                zcl_qjs_number=>parse_literal( ms_token-text ) ).
            ENDIF.
            DATA(lv_object_atom) = mo_emitter->intern_atom( lv_object_name ).
            DATA(lo_object_method_scanner) = NEW zcl_qjs_lexer( cache = mo_lexer ).
            lo_object_method_scanner->set_offset( mo_lexer->get_offset( ) ).
            DATA(ls_object_method_lookahead) = lo_object_method_scanner->next( ).
            IF ls_object_method_lookahead-kind = zcl_qjs_lexer=>token_lparen.
              DATA(ls_old_object_method_super) = ms_super_binding.
              DATA(lv_old_object_method_has_super) = mv_has_super.
              DATA(lv_old_object_method_static) = mv_super_static.
              DATA(lv_old_object_method_flag) = mv_super_object_method.
              DATA(lv_old_object_method_call) = mv_super_call_allowed.
              ms_super_binding = ls_object_home_binding.
              mv_has_super = abap_true.
              mv_super_static = abap_true.
              mv_super_object_method = abap_true.
              mv_super_call_allowed = abap_false.
              mv_parsing_class_method = abap_true.
              ms_token-kind = zcl_qjs_lexer=>token_function.
              parse_function_expression( ).
              ms_super_binding = ls_old_object_method_super.
              mv_has_super = lv_old_object_method_has_super.
              mv_super_static = lv_old_object_method_static.
              mv_super_object_method = lv_old_object_method_flag.
              mv_super_call_allowed = lv_old_object_method_call.
              mo_emitter->emit(
                opcode   = zif_qjs_opcodes=>define_method
                operand  = lv_object_atom
                operand2 = 10 ).
            ELSE.
              advance( ).
              IF ms_token-kind = zcl_qjs_lexer=>token_colon.
                advance( ).
                mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
                parse_assignment( ).
                mo_emitter->emit(
                  opcode = zif_qjs_opcodes=>put_field operand = lv_object_atom ).
              ELSEIF lv_object_shorthand = abap_true
                  AND ( ms_token-kind = zcl_qjs_lexer=>token_comma
                    OR ms_token-kind = zcl_qjs_lexer=>token_rbrace ).
                mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
                emit_binding_get( find_binding( lv_object_name ) ).
                mo_emitter->emit(
                  opcode = zif_qjs_opcodes=>put_field operand = lv_object_atom ).
              ELSE.
                RAISE EXCEPTION TYPE zcx_qjs_error
                  EXPORTING reason = 'Expected colon after object property name'.
              ENDIF.
            ENDIF.
          ENDIF.
          IF ms_token-kind = zcl_qjs_lexer=>token_comma.
            advance( ).
          ELSEIF ms_token-kind <> zcl_qjs_lexer=>token_rbrace.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Expected comma in object literal'.
          ENDIF.
        ENDWHILE.
        advance( ).
        DELETE TABLE mt_locals WITH TABLE KEY name = ls_object_home_binding-name
          function_depth = mv_function_depth.
      WHEN zcl_qjs_lexer=>token_new.
        advance( ).
        IF ms_token-kind <> zcl_qjs_lexer=>token_identifier
            AND ms_token-kind <> zcl_qjs_lexer=>token_this.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'Expected constructor name'.
        ENDIF.
        IF ms_token-kind = zcl_qjs_lexer=>token_this.
          IF mv_in_function = abap_true.
            DATA(ls_constructor_this) = find_binding( 'this' ).
            emit_binding_get( ls_constructor_this ).
          ELSE.
            DATA(ls_constructor_global) = find_binding( 'globalThis' ).
            emit_binding_get( ls_constructor_global ).
          ENDIF.
        ELSE.
          DATA(lv_constructor_name) = ms_token-text.
          DATA(lv_constructor_binding) = find_binding( lv_constructor_name ).
          emit_binding_get( lv_constructor_binding ).
        ENDIF.
        advance( ).
        WHILE ms_token-kind = zcl_qjs_lexer=>token_dot
            OR ms_token-kind = zcl_qjs_lexer=>token_lbracket.
          IF ms_token-kind = zcl_qjs_lexer=>token_dot.
            advance( ).
            IF is_identifier_name( ms_token-kind ) = abap_false.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'Expected constructor property name'.
            ENDIF.
            DATA(lv_constructor_atom) = mo_emitter->intern_atom( ms_token-text ).
            advance( ).
            mo_emitter->emit(
              opcode = zif_qjs_opcodes=>get_field operand = lv_constructor_atom ).
          ELSE.
            advance( ).
            parse_expression( ).
            IF ms_token-kind <> zcl_qjs_lexer=>token_rbracket.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'Expected constructor property bracket'.
            ENDIF.
            advance( ).
            mo_emitter->emit( zif_qjs_opcodes=>get_element ).
          ENDIF.
        ENDWHILE.
        DATA(lv_constructor_arguments) = 0.
        IF ms_token-kind = zcl_qjs_lexer=>token_lparen.
          DATA(lv_constructor_spread) = call_has_spread( ).
          IF lv_constructor_spread = abap_true.
            mo_emitter->emit( zif_qjs_opcodes=>duplicate ).
            advance( ).
            parse_spread_arguments( ).
            IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'Expected closing spread constructor parenthesis'.
            ENDIF.
            advance( ).
            mo_emitter->emit(
              opcode = zif_qjs_opcodes=>apply operand = 1 ).
            mv_parser_depth = mv_parser_depth - 1.
            RETURN.
          ENDIF.
          advance( ).
          IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
            WHILE abap_true = abap_true.
              parse_assignment( ).
              lv_constructor_arguments = lv_constructor_arguments + 1.
              IF ms_token-kind = zcl_qjs_lexer=>token_comma.
                advance( ).
              ELSE.
                EXIT.
              ENDIF.
            ENDWHILE.
          ENDIF.
          IF ms_token-kind <> zcl_qjs_lexer=>token_rparen.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Expected closing constructor parenthesis'.
          ENDIF.
          advance( ).
        ENDIF.
        mo_emitter->emit(
          opcode  = zif_qjs_opcodes=>call_constructor
          operand = lv_constructor_arguments ).
      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING
            reason = 'Expected JavaScript expression'.
    ENDCASE.
    mv_parser_depth = mv_parser_depth - 1.
  ENDMETHOD.
ENDCLASS.
