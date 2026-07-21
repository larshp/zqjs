CLASS lcl_host_sum DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES zif_qjs_callable.
    DATA calls TYPE i READ-ONLY.
ENDCLASS.

CLASS lcl_host_sum IMPLEMENTATION.
  METHOD zif_qjs_callable~call.
    DATA ls_argument TYPE zcl_qjs_value=>ty_value.
    DATA lv_sum TYPE f.
    calls = calls + 1.
    LOOP AT arguments INTO ls_argument.
      lv_sum = lv_sum + zcl_qjs_value=>as_finite_number( ls_argument ).
    ENDLOOP.
    result = zcl_qjs_value=>new_finite( lv_sum ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_host_failure DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES zif_qjs_callable.
ENDCLASS.

CLASS lcl_host_failure IMPLEMENTATION.
  METHOD zif_qjs_callable~call.
    RAISE EXCEPTION TYPE zcx_qjs_error
      EXPORTING reason = 'HostError: deliberate failure'.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_host_receiver DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES zif_qjs_callable.
ENDCLASS.

CLASS lcl_host_receiver IMPLEMENTATION.
  METHOD zif_qjs_callable~call.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    lo_object ?= this_value-object_ref.
    result = lo_object->get( 'value' ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_host_box DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES zif_qjs_constructable.
ENDCLASS.

CLASS lcl_host_box IMPLEMENTATION.
  METHOD zif_qjs_constructable~construct.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    DATA ls_value TYPE zcl_qjs_value=>ty_value.
    lo_object = runtime->create_object( ).
    READ TABLE arguments INDEX 1 INTO ls_value.
    IF sy-subrc <> 0.
      ls_value = zcl_qjs_value=>new_undefined( ).
    ENDIF.
    lo_object->set( name = 'value' value = ls_value ).
    result = zcl_qjs_value=>new_object( lo_object ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_host_bad_box DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES zif_qjs_constructable.
ENDCLASS.

CLASS lcl_host_bad_box IMPLEMENTATION.
  METHOD zif_qjs_constructable~construct.
    RAISE EXCEPTION TYPE zcx_qjs_error
      EXPORTING reason = 'HostError: constructor failure'.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_cancel DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES zif_qjs_cancellation.
    METHODS cancel.
  PRIVATE SECTION.
    DATA mv_cancelled TYPE abap_bool.
ENDCLASS.

CLASS lcl_cancel IMPLEMENTATION.
  METHOD cancel.
    mv_cancelled = abap_true.
  ENDMETHOD.
  METHOD zif_qjs_cancellation~is_cancelled.
    result = mv_cancelled.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_host_resource DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES zif_qjs_disposable.
    DATA dispose_calls TYPE i READ-ONLY.
ENDCLASS.

CLASS lcl_host_resource IMPLEMENTATION.
  METHOD zif_qjs_disposable~dispose.
    dispose_calls = dispose_calls + 1.
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_qjs DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS eval_precedence FOR TESTING RAISING cx_root.
    METHODS eval_parentheses FOR TESTING RAISING cx_root.
    METHODS number_specials FOR TESTING RAISING cx_root.
    METHODS negative_zero FOR TESTING RAISING cx_root.
    METHODS instruction_budget FOR TESTING RAISING cx_root.
    METHODS disassembly FOR TESTING RAISING cx_root.
    METHODS atoms_are_bounded FOR TESTING RAISING cx_root.
    METHODS string_code_units FOR TESTING RAISING cx_root.
    METHODS invalid_syntax FOR TESTING RAISING cx_root.
    METHODS numeric_literals FOR TESTING RAISING cx_root.
    METHODS numeric_coercions FOR TESTING RAISING cx_root.
    METHODS string_equality FOR TESTING RAISING cx_root.
    METHODS completion_kinds FOR TESTING RAISING cx_root.
    METHODS resource_limits FOR TESTING RAISING cx_root.
    METHODS runtime_lifecycle FOR TESTING RAISING cx_root.
    METHODS lexer_literals FOR TESTING RAISING cx_root.
    METHODS eval_string_literal FOR TESTING RAISING cx_root.
    METHODS comparisons FOR TESTING RAISING cx_root.
    METHODS primitive_literals FOR TESTING RAISING cx_root.
    METHODS if_statements FOR TESTING RAISING cx_root.
    METHODS statement_blocks FOR TESTING RAISING cx_root.
    METHODS variables FOR TESTING RAISING cx_root.
    METHODS while_loops FOR TESTING RAISING cx_root.
    METHODS for_break_continue FOR TESTING RAISING cx_root.
    METHODS functions_and_recursion FOR TESTING RAISING cx_root.
    METHODS ordinary_objects FOR TESTING RAISING cx_root.
    METHODS object_syntax FOR TESTING RAISING cx_root.
    METHODS string_operators FOR TESTING RAISING cx_root.
    METHODS object_constructor FOR TESTING RAISING cx_root.
    METHODS thrown_values FOR TESTING RAISING cx_root.
    METHODS try_catch FOR TESTING RAISING cx_root.
    METHODS closures FOR TESTING RAISING cx_root.
    METHODS var_hoisting FOR TESTING RAISING cx_root.
    METHODS finally_semantics FOR TESTING RAISING cx_root.
    METHODS lexical_bindings FOR TESTING RAISING cx_root.
    METHODS function_hoisting FOR TESTING RAISING cx_root.
    METHODS logical_operators FOR TESTING RAISING cx_root.
    METHODS array_syntax FOR TESTING RAISING cx_root.
    METHODS comments_and_asi FOR TESTING RAISING cx_root.
    METHODS embedding_context FOR TESTING RAISING cx_root.
    METHODS constructor_semantics FOR TESTING RAISING cx_root.
    METHODS property_delete FOR TESTING RAISING cx_root.
    METHODS cooperative_cancellation FOR TESTING RAISING cx_root.
    METHODS core_intrinsics FOR TESTING RAISING cx_root.
    METHODS bitwise_operators FOR TESTING RAISING cx_root.
    METHODS assignment_updates FOR TESTING RAISING cx_root.
    METHODS declaration_lists FOR TESTING RAISING cx_root.
    METHODS property_reflection FOR TESTING RAISING cx_root.
    METHODS json_intrinsic FOR TESTING RAISING cx_root.
    METHODS number_formatting FOR TESTING RAISING cx_root.
    METHODS error_intrinsics FOR TESTING RAISING cx_root.
ENDCLASS.

CLASS ltcl_qjs IMPLEMENTATION.
  METHOD eval_precedence.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    DATA lv_actual TYPE f.
    DATA lv_expected TYPE f.
    ls_result = zcl_qjs=>eval( '1 + 2 * 3' ).
    lv_actual = zcl_qjs_value=>as_finite_number( ls_result ).
    lv_expected = 7.
    cl_abap_unit_assert=>assert_equals(
      act = lv_actual
      exp = lv_expected ).
  ENDMETHOD.

  METHOD eval_parentheses.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    DATA lv_actual TYPE f.
    DATA lv_expected TYPE f.
    ls_result = zcl_qjs=>eval( '(1 + 2) * 3' ).
    lv_actual = zcl_qjs_value=>as_finite_number( ls_result ).
    lv_expected = 9.
    cl_abap_unit_assert=>assert_equals(
      act = lv_actual
      exp = lv_expected ).
  ENDMETHOD.

  METHOD number_specials.
    DATA ls_zero TYPE zcl_qjs_value=>ty_value.
    DATA ls_one TYPE zcl_qjs_value=>ty_value.
    DATA ls_pos_inf TYPE zcl_qjs_value=>ty_value.
    DATA ls_neg_inf TYPE zcl_qjs_value=>ty_value.
    DATA ls_nan TYPE zcl_qjs_value=>ty_value.
    ls_zero = zcl_qjs_value=>new_int( 0 ).
    ls_one = zcl_qjs_value=>new_int( 1 ).
    ls_pos_inf = zcl_qjs_number=>divide( left = ls_one right = ls_zero ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_pos_inf-number_kind
      exp = zcl_qjs_value=>number_pos_inf ).

    ls_neg_inf = zcl_qjs_number=>negate( ls_pos_inf ).
    ls_nan = zcl_qjs_number=>add( left = ls_pos_inf right = ls_neg_inf ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_nan-number_kind
      exp = zcl_qjs_value=>number_nan ).

    ls_nan = zcl_qjs_number=>divide( left = ls_zero right = ls_zero ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_nan-number_kind
      exp = zcl_qjs_value=>number_nan ).
  ENDMETHOD.

  METHOD negative_zero.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    DATA ls_one TYPE zcl_qjs_value=>ty_value.
    DATA ls_divided TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval( '-0' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-number_kind
      exp = zcl_qjs_value=>number_neg_zero ).
    ls_one = zcl_qjs_value=>new_int( 1 ).
    ls_divided = zcl_qjs_number=>divide( left = ls_one right = ls_result ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_divided-number_kind
      exp = zcl_qjs_value=>number_neg_inf ).
  ENDMETHOD.

  METHOD instruction_budget.
    TRY.
        zcl_qjs=>eval(
          source    = '1 + 2 * 3'
          max_steps = 5 ).
        cl_abap_unit_assert=>fail( 'Expected instruction budget error' ).
      CATCH zcx_qjs_error INTO DATA(lx_error).
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->reason
          exp = 'JavaScript instruction budget exhausted' ).
    ENDTRY.
  ENDMETHOD.

  METHOD disassembly.
    DATA lo_function TYPE REF TO zcl_qjs_function.
    DATA lv_actual TYPE string.
    DATA lv_expected TYPE string.
    lo_function = zcl_qjs=>compile( '1 + 2 * 3' ).
    lv_actual = zcl_qjs_disasm=>disassemble( lo_function ).
    lv_expected = 'push_i32 1'
      && cl_abap_char_utilities=>newline && 'push_i32 2'
      && cl_abap_char_utilities=>newline && 'push_i32 3'
      && cl_abap_char_utilities=>newline && 'multiply'
      && cl_abap_char_utilities=>newline && 'add'
      && cl_abap_char_utilities=>newline && 'return'.
    cl_abap_unit_assert=>assert_equals(
      act = lv_actual
      exp = lv_expected ).
  ENDMETHOD.

  METHOD atoms_are_bounded.
    DATA lo_atoms TYPE REF TO zcl_qjs_atoms.
    DATA lv_first TYPE int8.
    DATA lv_again TYPE int8.
    CREATE OBJECT lo_atoms
      EXPORTING
        max_atoms = 1.
    lv_first = lo_atoms->intern( 'x' ).
    lv_again = lo_atoms->intern( 'x' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_again
      exp = lv_first ).
    TRY.
        lo_atoms->intern( 'y' ).
        cl_abap_unit_assert=>fail( 'Expected atom budget error' ).
      CATCH zcx_qjs_error INTO DATA(lx_error).
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->reason
          exp = 'JavaScript atom budget exhausted' ).
    ENDTRY.
  ENDMETHOD.

  METHOD string_code_units.
    DATA lo_string TYPE REF TO zcl_qjs_string.
    lo_string = zcl_qjs_string=>create( 'abc' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_string->length( )
      exp = 3 ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_string->code_unit_at( 1 )
      exp = 'b' ).
  ENDMETHOD.

  METHOD invalid_syntax.
    TRY.
        zcl_qjs=>eval( '1 +' ).
        cl_abap_unit_assert=>fail( 'Expected syntax error' ).
      CATCH zcx_qjs_error INTO DATA(lx_error).
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->reason
          exp = 'Expected JavaScript expression' ).
    ENDTRY.
  ENDMETHOD.

  METHOD numeric_literals.
    DATA ls_value TYPE zcl_qjs_value=>ty_value.
    DATA lv_actual TYPE f.
    DATA lv_expected TYPE f.

    ls_value = zcl_qjs_number=>parse_literal( '0x2a' ).
    lv_actual = zcl_qjs_value=>as_finite_number( ls_value ).
    lv_expected = 42.
    cl_abap_unit_assert=>assert_equals( act = lv_actual exp = lv_expected ).

    ls_value = zcl_qjs_number=>parse_literal( '0o52' ).
    lv_actual = zcl_qjs_value=>as_finite_number( ls_value ).
    cl_abap_unit_assert=>assert_equals( act = lv_actual exp = lv_expected ).

    ls_value = zcl_qjs_number=>parse_literal( '0b101010' ).
    lv_actual = zcl_qjs_value=>as_finite_number( ls_value ).
    cl_abap_unit_assert=>assert_equals( act = lv_actual exp = lv_expected ).

    ls_value = zcl_qjs_number=>parse_literal( '4.2e1' ).
    lv_actual = zcl_qjs_value=>as_finite_number( ls_value ).
    cl_abap_unit_assert=>assert_equals( act = lv_actual exp = lv_expected ).

    ls_value = zcl_qjs=>eval( '0.5 + 1.25;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_value ) exp = CONV f( '1.75' ) ).
    ls_value = zcl_qjs=>eval( '4.2e1 + 0x2a + 0o10 + 0b10;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_value ) exp = CONV f( 94 ) ).

    TRY.
        zcl_qjs_number=>parse_literal( '0xg' ).
        cl_abap_unit_assert=>fail( 'Expected invalid numeric literal' ).
      CATCH zcx_qjs_error.
    ENDTRY.
  ENDMETHOD.

  METHOD numeric_coercions.
    DATA ls_value TYPE zcl_qjs_value=>ty_value.
    DATA ls_number TYPE zcl_qjs_value=>ty_value.

    ls_value = zcl_qjs_value=>new_string( '42' ).
    ls_number = zcl_qjs_number=>to_number( ls_value ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_number )
      exp = CONV f( 42 ) ).

    ls_value = zcl_qjs_value=>new_undefined( ).
    ls_number = zcl_qjs_number=>to_number( ls_value ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_number-number_kind
      exp = zcl_qjs_value=>number_nan ).

    ls_value = zcl_qjs_value=>new_finite( CONV f( 4294967297 ) ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_number=>to_uint32( ls_value )
      exp = 1 ).

    ls_value = zcl_qjs_value=>new_finite( CONV f( 4294967295 ) ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_number=>to_int32( ls_value )
      exp = -1 ).
  ENDMETHOD.

  METHOD string_equality.
    DATA lo_left TYPE REF TO zcl_qjs_string.
    DATA lo_same TYPE REF TO zcl_qjs_string.
    DATA lo_other TYPE REF TO zcl_qjs_string.
    lo_left = zcl_qjs_string=>create( 'ab' ).
    lo_same = zcl_qjs_string=>create( 'a' )->concat( zcl_qjs_string=>create( 'b' ) ).
    lo_other = zcl_qjs_string=>create( 'ac' ).
    cl_abap_unit_assert=>assert_true( lo_left->equals( lo_same ) ).
    cl_abap_unit_assert=>assert_false( lo_left->equals( lo_other ) ).
  ENDMETHOD.

  METHOD completion_kinds.
    DATA ls_value TYPE zcl_qjs_value=>ty_value.
    DATA ls_completion TYPE zcl_qjs_completion=>ty_completion.
    ls_value = zcl_qjs_value=>new_undefined( ).
    ls_completion = zcl_qjs_completion=>broken( ls_value ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_completion-kind exp = zcl_qjs_completion=>kind_break ).
    ls_completion = zcl_qjs_completion=>continued( ls_value ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_completion-kind exp = zcl_qjs_completion=>kind_continue ).
  ENDMETHOD.

  METHOD resource_limits.
    DATA lo_limits TYPE REF TO zcl_qjs_limits.
    DATA lo_parser TYPE REF TO zcl_qjs_parser.
    DATA lo_emitter TYPE REF TO zcl_qjs_emitter.
    DATA lo_function TYPE REF TO zcl_qjs_function.
    DATA lo_vm TYPE REF TO zcl_qjs_vm.

    CREATE OBJECT lo_limits
      EXPORTING max_parser_depth = 2.
    TRY.
        CREATE OBJECT lo_parser
          EXPORTING source = '(((1)))' limits = lo_limits.
        lo_parser->compile( ).
        cl_abap_unit_assert=>fail( 'Expected parser depth limit' ).
      CATCH zcx_qjs_error INTO DATA(lx_depth).
        cl_abap_unit_assert=>assert_equals(
          act = lx_depth->reason exp = 'JavaScript parser depth budget exhausted' ).
    ENDTRY.

    CREATE OBJECT lo_limits
      EXPORTING max_bytecode_length = 1.
    CREATE OBJECT lo_emitter
      EXPORTING limits = lo_limits.
    lo_emitter->emit( zif_qjs_opcodes=>push_i32 ).
    TRY.
        lo_emitter->emit( zif_qjs_opcodes=>return ).
        cl_abap_unit_assert=>fail( 'Expected bytecode size limit' ).
      CATCH zcx_qjs_error INTO DATA(lx_bytecode).
        cl_abap_unit_assert=>assert_equals(
          act = lx_bytecode->reason exp = 'JavaScript bytecode size budget exhausted' ).
    ENDTRY.

    CREATE OBJECT lo_limits
      EXPORTING max_operand_stack = 1.
    CREATE OBJECT lo_emitter.
    lo_emitter->emit( opcode = zif_qjs_opcodes=>push_i32 operand = 1 ).
    lo_emitter->emit( opcode = zif_qjs_opcodes=>push_i32 operand = 2 ).
    lo_emitter->emit( zif_qjs_opcodes=>return ).
    lo_function = lo_emitter->to_function( ).
    CREATE OBJECT lo_vm EXPORTING limits = lo_limits.
    TRY.
        lo_vm->execute( lo_function ).
        cl_abap_unit_assert=>fail( 'Expected operand stack limit' ).
      CATCH zcx_qjs_error INTO DATA(lx_stack).
        cl_abap_unit_assert=>assert_equals(
          act = lx_stack->reason exp = 'JavaScript operand stack budget exhausted' ).
    ENDTRY.
  ENDMETHOD.

  METHOD runtime_lifecycle.
    DATA lo_runtime TYPE REF TO zcl_qjs_runtime.
    DATA lo_context TYPE REF TO zcl_qjs_context.
    DATA lo_resource TYPE REF TO lcl_host_resource.
    DATA ls_first TYPE zcl_qjs_value=>ty_value.
    DATA ls_second TYPE zcl_qjs_value=>ty_value.
    CREATE OBJECT lo_runtime.
    CREATE OBJECT lo_context EXPORTING runtime = lo_runtime.
    CREATE OBJECT lo_resource.
    lo_runtime->register_resource( lo_resource ).
    ls_first = lo_runtime->new_symbol( 'x' ).
    ls_second = lo_runtime->new_symbol( 'x' ).
    cl_abap_unit_assert=>assert_differs(
      act = ls_first-symbol_id exp = ls_second-symbol_id ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_runtime->symbol_description( ls_first ) exp = 'x' ).
    lo_context->dispose( ).
    cl_abap_unit_assert=>assert_true( lo_context->is_disposed( ) ).
    lo_runtime->dispose( ).
    lo_runtime->dispose( ).
    cl_abap_unit_assert=>assert_equals( act = lo_resource->dispose_calls exp = 1 ).
    TRY.
        lo_runtime->new_symbol( 'late' ).
        cl_abap_unit_assert=>fail( 'Expected disposed runtime error' ).
      CATCH zcx_qjs_error INTO DATA(lx_disposed).
        cl_abap_unit_assert=>assert_equals(
          act = lx_disposed->reason exp = 'JavaScript runtime is disposed' ).
    ENDTRY.
  ENDMETHOD.

  METHOD lexer_literals.
    DATA lo_lexer TYPE REF TO zcl_qjs_lexer.
    DATA ls_token TYPE zcl_qjs_lexer=>ty_token.
    CREATE OBJECT lo_lexer EXPORTING source = `answer + "line\nnext"`.
    ls_token = lo_lexer->next( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_token-kind exp = zcl_qjs_lexer=>token_identifier ).
    cl_abap_unit_assert=>assert_equals( act = ls_token-text exp = 'answer' ).
    ls_token = lo_lexer->next( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_token-kind exp = zcl_qjs_lexer=>token_plus ).
    ls_token = lo_lexer->next( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_token-kind exp = zcl_qjs_lexer=>token_string ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_token-text
      exp = 'line' && cl_abap_char_utilities=>newline && 'next' ).
  ENDMETHOD.

  METHOD eval_string_literal.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval( `"hello\nworld"` ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-tag exp = zcl_qjs_value=>tag_string ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( )
      exp = 'hello' && cl_abap_char_utilities=>newline && 'world' ).
    ls_result = zcl_qjs=>eval( `"hello world"` ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( ) exp = 'hello world' ).
  ENDMETHOD.

  METHOD comparisons.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval( '1 + 2 * 3 === 7' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-bool_value exp = abap_true ).
    ls_result = zcl_qjs=>eval( '3 < 2' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-bool_value exp = abap_false ).
    ls_result = zcl_qjs=>eval( '3 >= 3' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-bool_value exp = abap_true ).
    ls_result = zcl_qjs=>eval( `"x" !== "y"` ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-bool_value exp = abap_true ).
  ENDMETHOD.

  METHOD primitive_literals.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval( 'true === true' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval( 'null !== undefined' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval( 'false' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-tag exp = zcl_qjs_value=>tag_bool ).
    cl_abap_unit_assert=>assert_false( ls_result-bool_value ).
  ENDMETHOD.

  METHOD if_statements.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval( 'if (1 < 2) 42; else 7;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 42 ) ).
    ls_result = zcl_qjs=>eval( 'if (0) 42; else 7;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 7 ) ).
    ls_result = zcl_qjs=>eval( `if ("x") 3;` ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 3 ) ).
  ENDMETHOD.

  METHOD statement_blocks.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval( '{ 1; 2; 3; }' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 3 ) ).
    ls_result = zcl_qjs=>eval( 'if (false) { 1; 2; } else { 8; 9; }' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 9 ) ).
  ENDMETHOD.

  METHOD variables.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval( 'var x = 2; x = x * 5; x + 1;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 11 ) ).
    ls_result = zcl_qjs=>eval( 'var x = 1; var x = 3; x;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 3 ) ).
    ls_result = zcl_qjs=>eval( 'var x; x === undefined;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD while_loops.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'var x = 0; while (x < 5) { x = x + 1; } x;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 5 ) ).
    TRY.
        zcl_qjs=>eval( source = 'while (true) {}' max_steps = 20 ).
        cl_abap_unit_assert=>fail( 'Expected loop instruction budget error' ).
      CATCH zcx_qjs_error INTO DATA(lx_budget).
        cl_abap_unit_assert=>assert_equals(
          act = lx_budget->reason exp = 'JavaScript instruction budget exhausted' ).
    ENDTRY.
  ENDMETHOD.

  METHOD for_break_continue.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'var sum = 0; for (var i = 0; i < 5; i = i + 1) {'
      && ' if (i === 2) continue; sum = sum + i; } sum;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 8 ) ).

    ls_result = zcl_qjs=>eval(
      'var x = 0; while (true) { x = x + 1; if (x === 3) break; } x;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 3 ) ).

    ls_result = zcl_qjs=>eval(
      'var n = 0; for (var a = 0; a < 3; a = a + 1) {'
      && ' for (var b = 0; b < 4; b = b + 1) { n = n + 1; break; } } n;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 3 ) ).
  ENDMETHOD.

  METHOD functions_and_recursion.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'function add(a, b) { return a + b; } add(20, 22);' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 42 ) ).

    ls_result = zcl_qjs=>eval(
      'function factorial(n) {'
      && ' if (n <= 1) return 1; return n * factorial(n - 1); } factorial(6);' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 720 ) ).

    ls_result = zcl_qjs=>eval( 'function nothing() { 1 + 2; } nothing();' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-tag exp = zcl_qjs_value=>tag_undefined ).
    ls_result = zcl_qjs=>eval(
      'function inspect() { return arguments[0] + arguments[1] + arguments.length; }'
      && ' inspect(4, 5);' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 11 ) ).
  ENDMETHOD.

  METHOD ordinary_objects.
    DATA lo_runtime TYPE REF TO zcl_qjs_runtime.
    DATA lo_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    DATA ls_value TYPE zcl_qjs_value=>ty_value.
    CREATE OBJECT lo_runtime EXPORTING max_objects = 2.
    lo_prototype = lo_runtime->create_object( ).
    lo_prototype->set( name = 'inherited' value = zcl_qjs_value=>new_int( 7 ) ).
    lo_object = lo_runtime->create_object( lo_prototype ).
    lo_object->set( name = 'own' value = zcl_qjs_value=>new_int( 3 ) ).
    ls_value = lo_object->get( 'inherited' ).
    cl_abap_unit_assert=>assert_equals( act = ls_value-int_value exp = 7 ).
    cl_abap_unit_assert=>assert_true( lo_object->has_own( 'own' ) ).
    cl_abap_unit_assert=>assert_false( lo_object->has_own( 'inherited' ) ).
    cl_abap_unit_assert=>assert_true( lo_object->delete( 'own' ) ).
    ls_value = lo_object->get( 'own' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_value-tag exp = zcl_qjs_value=>tag_undefined ).
    lo_object->define_property(
      name = 'locked' value = zcl_qjs_value=>new_int( 11 )
      writable = abap_false configurable = abap_false ).
    DATA(ls_descriptor) = lo_object->get_descriptor( 'locked' ).
    cl_abap_unit_assert=>assert_true( ls_descriptor-found ).
    cl_abap_unit_assert=>assert_false( ls_descriptor-writable ).
    cl_abap_unit_assert=>assert_false( lo_object->delete( 'locked' ) ).
    TRY.
        lo_object->set( name = 'locked' value = zcl_qjs_value=>new_int( 12 ) ).
        cl_abap_unit_assert=>fail( 'Expected non-writable property error' ).
      CATCH zcx_qjs_throw INTO DATA(lx_property).
        cl_abap_unit_assert=>assert_equals(
          act = lx_property->value-tag exp = zcl_qjs_value=>tag_string ).
        cl_abap_unit_assert=>assert_equals(
          act = lx_property->value-string_ref->as_string( )
          exp = 'TypeError: property is not writable' ).
    ENDTRY.
    TRY.
        lo_runtime->create_object( ).
        cl_abap_unit_assert=>fail( 'Expected object allocation limit' ).
      CATCH zcx_qjs_error INTO DATA(lx_objects).
        cl_abap_unit_assert=>assert_equals(
          act = lx_objects->reason exp = 'JavaScript object budget exhausted' ).
    ENDTRY.
  ENDMETHOD.

  METHOD object_syntax.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'var o = { x: 1 }; o.y = 2; o.x + o.y;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 3 ) ).

    ls_result = zcl_qjs=>eval(
      'var o = { child: { value: 4 } }; o.child.value = 9; o.child.value;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 9 ) ).

    ls_result = zcl_qjs=>eval( 'var o = {}; o === o;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD string_operators.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval( `"answer=" + 42` ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( ) exp = 'answer=42' ).
    ls_result = zcl_qjs=>eval( `"a" < "b"` ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval( `"2" + true` ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( ) exp = '2true' ).
  ENDMETHOD.

  METHOD object_constructor.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'var left = new Object(); var right = new Object();'
      && ' left.value = 1; right.value = 2; left.value + right.value;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 3 ) ).
    ls_result = zcl_qjs=>eval(
      'var left = new Object(); var right = new Object(); left !== right;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD thrown_values.
    TRY.
        zcl_qjs=>eval( `throw "boom";` ).
        cl_abap_unit_assert=>fail( 'Expected JavaScript throw' ).
      CATCH zcx_qjs_throw INTO DATA(lx_throw).
        cl_abap_unit_assert=>assert_equals(
          act = lx_throw->value-string_ref->as_string( ) exp = 'boom' ).
    ENDTRY.
  ENDMETHOD.

  METHOD try_catch.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval( 'try { throw 5; } catch (error) { error + 1; }' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 6 ) ).

    ls_result = zcl_qjs=>eval(
      'function fail(value) { throw value; }'
      && ' try { fail(20); } catch (error) { error + 22; }' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 42 ) ).

    ls_result = zcl_qjs=>eval(
      'try { try { throw 2; } catch (inner) { throw inner + 3; } }'
      && ' catch (outer) { outer * 2; }' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 10 ) ).

    ls_result = zcl_qjs=>eval(
      'var error = 1; try { throw 2; } catch (error) { error; } error;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 1 ) ).
  ENDMETHOD.

  METHOD closures.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'function makeCounter() { var count = 0;'
      && ' function next() { count = count + 1; return count; } return next; }'
      && ' var counter = makeCounter(); counter(); counter();' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 2 ) ).

    ls_result = zcl_qjs=>eval(
      'function makeCounter() { var count = 0;'
      && ' function next() { count = count + 1; return count; } return next; }'
      && ' var first = makeCounter(); var second = makeCounter();'
      && ' first(); first(); second();' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 1 ) ).

    ls_result = zcl_qjs=>eval(
      'function outer() { var value = 9; function middle() { value;'
      && ' function inner() { return value; } return inner; } return middle(); }'
      && ' var read = outer(); read();' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 9 ) ).

    ls_result = zcl_qjs=>eval(
      'function outer() { var value = 11; function middle() {'
      && ' function inner() { return value; } return inner; } return middle(); }'
      && ' var read = outer(); read();' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 11 ) ).
  ENDMETHOD.

  METHOD var_hoisting.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'var observed = value === undefined; var value = 1; observed;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'if (false) { var hidden = 1; } hidden === undefined;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function outer() { function read() { return later; }'
      && ' var later = 7; return read; } var reader = outer(); reader();' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 7 ) ).
  ENDMETHOD.

  METHOD finally_semantics.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'var value = 0; try { value = 1; } finally { value = value + 1; } value;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 2 ) ).

    ls_result = zcl_qjs=>eval(
      'var value = 0; try { throw 2; } catch (error) { value = error; }'
      && ' finally { value = value + 1; } value;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 3 ) ).

    ls_result = zcl_qjs=>eval(
      'var marker = 0; try { try { throw 4; } finally { marker = 1; } }'
      && ' catch (error) { error + marker; }' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 5 ) ).

    ls_result = zcl_qjs=>eval(
      'function finish(object) { try { return 1; } finally { object.value = 2; } }'
      && ' var object = {}; finish(object) + object.value;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 3 ) ).

    ls_result = zcl_qjs=>eval(
      'function override() { try { return 1; } finally { return 2; } } override();' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 2 ) ).

    ls_result = zcl_qjs=>eval(
      'var count = 0; while (true) { try { break; } finally { count = count + 1; } } count;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 1 ) ).

    ls_result = zcl_qjs=>eval(
      'var count = 0; try { while (true) { break; } } finally { count = count + 1; } count;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 1 ) ).
  ENDMETHOD.

  METHOD lexical_bindings.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval( 'let value = 1; value = 2; value;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 2 ) ).

    ls_result = zcl_qjs=>eval(
      'try { const fixed = 1; fixed = 2; } catch (error) { error.toString(); }' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( )
      exp = 'TypeError: assignment to constant binding' ).

    ls_result = zcl_qjs=>eval(
      'try { temporal; let temporal = 1; } catch (error) { error.toString(); }' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( )
      exp = 'ReferenceError: lexical binding is uninitialized' ).

    ls_result = zcl_qjs=>eval(
      'let outer = 1; { let outer = 2; outer; } outer;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 1 ) ).

    ls_result = zcl_qjs=>eval(
      'var sum = 0; var index = 0; while (index < 2) {'
      && ' let current = index; sum = sum + current; index = index + 1; } sum;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 1 ) ).

    ls_result = zcl_qjs=>eval(
      'function make() { const fixed = 9; function read() { return fixed; } return read; }'
      && ' var read = make(); read();' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 9 ) ).
  ENDMETHOD.

  METHOD function_hoisting.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'var result = add(20, 22); function add(left, right) {'
      && ' return left + right; } result;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 42 ) ).

    ls_result = zcl_qjs=>eval(
      'function outer() { return inner(); function inner() { return 7; } } outer();' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 7 ) ).

    ls_result = zcl_qjs=>eval(
      'var result = choose(); function choose() { return 1; }'
      && ' function choose() { return 2; } result;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 2 ) ).
  ENDMETHOD.

  METHOD logical_operators.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval( '17 % 5' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 2 ) ).

    ls_result = zcl_qjs=>eval( `!!"value"` ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval( 'null == undefined' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval( `"42" == 42` ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval( 'false == 0' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval( 'false === 0' ).
    cl_abap_unit_assert=>assert_false( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function fail() { throw 1; } false && fail();' ).
    cl_abap_unit_assert=>assert_false( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'function fail() { throw 1; } true || fail();' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval( `0 || "fallback"` ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( ) exp = 'fallback' ).
    ls_result = zcl_qjs=>eval( `"left" && 7` ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 7 ) ).

    ls_result = zcl_qjs=>eval(
      'var value = 0; false && (value = 1); true || (value = 2); value;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 0 ) ).
  ENDMETHOD.

  METHOD array_syntax.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval( '[1, 2, 3].length' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 3 ) ).

    ls_result = zcl_qjs=>eval(
      'var values = [1, 2]; values[1] = 7; values[0] + values[1];' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 8 ) ).

    ls_result = zcl_qjs=>eval( 'var values = []; values[2] = 4; values.length;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 3 ) ).

    ls_result = zcl_qjs=>eval( 'var values = [9]; values[4];' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-tag exp = zcl_qjs_value=>tag_undefined ).
  ENDMETHOD.

  METHOD comments_and_asi.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'var value = 1; // ignored' && cl_abap_char_utilities=>newline
      && '/* block' && cl_abap_char_utilities=>newline && 'comment */ value + 2;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 3 ) ).

    ls_result = zcl_qjs=>eval(
      'function answer() { return' && cl_abap_char_utilities=>newline
      && '42; } answer();' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-tag exp = zcl_qjs_value=>tag_undefined ).

    TRY.
        zcl_qjs=>eval(
          'throw' && cl_abap_char_utilities=>newline && '1;' ).
        cl_abap_unit_assert=>fail( 'Line terminator after throw must be rejected' ).
      CATCH zcx_qjs_error.
    ENDTRY.
  ENDMETHOD.

  METHOD embedding_context.
    DATA lo_runtime TYPE REF TO zcl_qjs_runtime.
    DATA lo_context TYPE REF TO zcl_qjs_context.
    DATA lo_sum TYPE REF TO lcl_host_sum.
    DATA lo_failure TYPE REF TO lcl_host_failure.
    DATA lo_receiver TYPE REF TO lcl_host_receiver.
    DATA lo_box TYPE REF TO lcl_host_box.
    DATA lo_bad_box TYPE REF TO lcl_host_bad_box.
    DATA lo_payload TYPE REF TO zcl_qjs_object.
    DATA lo_items TYPE REF TO zcl_qjs_object.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    DATA lt_call_arguments TYPE zif_qjs_callable=>ty_arguments.
    CREATE OBJECT lo_runtime.
    CREATE OBJECT lo_context EXPORTING runtime = lo_runtime.
    CREATE OBJECT lo_sum.
    CREATE OBJECT lo_failure.
    CREATE OBJECT lo_receiver.
    CREATE OBJECT lo_box.
    CREATE OBJECT lo_bad_box.
    lo_context->set_global( name = 'seed' value = zcl_qjs_value=>new_int( 4 ) ).
    lo_context->register_function( name = 'hostSum' callable = lo_sum ).
    lo_context->register_function( name = 'hostFailure' callable = lo_failure ).
    lo_context->register_function( name = 'hostRead' callable = lo_receiver ).
    lo_context->register_constructor( name = 'HostBox' constructor = lo_box ).
    lo_context->register_constructor( name = 'BadBox' constructor = lo_bad_box ).

    ls_result = lo_context->eval( 'seed = hostSum(seed, 6); seed;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 10 ) ).
    cl_abap_unit_assert=>assert_equals( act = lo_sum->calls exp = 1 ).
    ls_result = lo_context->eval(
      'var hostError; try { hostFailure(); } catch (error) {'
      && ' hostError = error.toString(); }'
      && ' hostError;' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( ) exp = 'HostError: deliberate failure' ).
    ls_result = lo_context->eval(
      'var constructorError; try { new BadBox(); } catch (error) {'
      && ' constructorError = error.toString(); } constructorError;' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( ) exp = 'HostError: constructor failure' ).
    ls_result = lo_context->eval( 'seed + 1;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 11 ) ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( lo_context->get_global( 'seed' ) )
      exp = CONV f( 10 ) ).

    ls_result = lo_context->eval(
      'var object = { value: 12, read: hostRead }; object.read();' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 12 ) ).
    ls_result = lo_context->eval(
      'var object = { value: 13, read: hostRead }; object["read"]();' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 13 ) ).
    ls_result = lo_context->eval(
      'function read() { return this.value; } var object = { value: 14 };'
      && ' object.read = read; object.read();' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 14 ) ).

    lo_context->eval(
      'var persisted = 5; function addPersisted(value) {'
      && ' return persisted + value; } 0;' ).
    ls_result = lo_context->eval( 'addPersisted(3);' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 8 ) ).
    APPEND zcl_qjs_value=>new_int( 2 ) TO lt_call_arguments.
    ls_result = lo_context->call(
      name = 'addPersisted' arguments = lt_call_arguments ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 7 ) ).
    ls_result = lo_context->eval( 'var box = new HostBox(21); box.value;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 21 ) ).

    lo_payload = lo_runtime->create_object( ).
    lo_items = lo_runtime->create_array( ).
    lo_items->set_element( index = 0 value = zcl_qjs_value=>new_int( 3 ) ).
    lo_items->set_element( index = 1 value = zcl_qjs_value=>new_int( 4 ) ).
    lo_payload->set(
      name = 'items' value = zcl_qjs_value=>new_object( lo_items ) ).
    lo_context->set_global(
      name = 'payload' value = zcl_qjs_value=>new_object( lo_payload ) ).
    ls_result = lo_context->eval(
      'payload.total = payload.items[0] + payload.items[1]; payload;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( lo_payload->get( 'total' ) )
      exp = CONV f( 7 ) ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-object_ref exp = lo_payload ).

    lo_context->dispose( ).
    TRY.
        lo_context->eval( '1;' ).
        cl_abap_unit_assert=>fail( 'Disposed context must reject evaluation' ).
      CATCH zcx_qjs_error INTO DATA(lx_disposed).
        cl_abap_unit_assert=>assert_equals(
          act = lx_disposed->reason exp = 'JavaScript context is disposed' ).
    ENDTRY.
  ENDMETHOD.

  METHOD constructor_semantics.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'function Point(x) { this.x = x; } var point = new Point(42); point.x;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 42 ) ).

    ls_result = zcl_qjs=>eval(
      'function Box() { this.x = 7; return 1; } var box = new Box(); box.x;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 7 ) ).

    ls_result = zcl_qjs=>eval(
      'function Factory() { return { x: 9 }; } var made = new Factory(); made.x;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 9 ) ).

    ls_result = zcl_qjs=>eval(
      'function Point() {} Point.prototype.answer = 42;'
      && ' var point = new Point(); point.answer;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 42 ) ).
    ls_result = zcl_qjs=>eval(
      'function Point() {} var point = new Point(); point instanceof Point;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'function Point() {} var object = {}; object instanceof Point;' ).
    cl_abap_unit_assert=>assert_false( ls_result-bool_value ).
  ENDMETHOD.

  METHOD property_delete.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'var object = { kept: 1, removed: 2 }; delete object.removed;'
      && ' object.removed === undefined && object.kept === 1;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var key = "value"; var object = { value: 3 }; delete object[key];'
      && ' object.value === undefined;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval( 'var object = {}; delete object.missing;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD cooperative_cancellation.
    DATA lo_cancel TYPE REF TO lcl_cancel.
    DATA lo_runtime TYPE REF TO zcl_qjs_runtime.
    DATA lo_context TYPE REF TO zcl_qjs_context.
    CREATE OBJECT lo_cancel.
    CREATE OBJECT lo_runtime EXPORTING cancellation = lo_cancel.
    CREATE OBJECT lo_context EXPORTING runtime = lo_runtime.
    lo_cancel->cancel( ).
    TRY.
        lo_context->eval( 'while (true) {}' ).
        cl_abap_unit_assert=>fail( 'Expected cooperative cancellation' ).
      CATCH zcx_qjs_error INTO DATA(lx_cancelled).
        cl_abap_unit_assert=>assert_equals(
          act = lx_cancelled->reason exp = 'JavaScript execution cancelled' ).
    ENDTRY.
  ENDMETHOD.

  METHOD core_intrinsics.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval( 'Number("42") + 1;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 43 ) ).
    ls_result = zcl_qjs=>eval( 'String(42) === "42";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval( 'Boolean(0);' ).
    cl_abap_unit_assert=>assert_false( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval( 'isNaN("not a number");' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval( 'Array(3).length;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 3 ) ).
    ls_result = zcl_qjs=>eval( 'Array(2, 4)[1];' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 4 ) ).
    ls_result = zcl_qjs=>eval( 'var object = Object(); object.x = 8; object.x;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 8 ) ).
    ls_result = zcl_qjs=>eval(
      'typeof undefined === "undefined" && typeof null === "object"'
      && ' && typeof 1 === "number" && typeof "x" === "string"'
      && ' && typeof Object === "function" && typeof {} === "object";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval( 'isNaN(NaN) && Infinity > 1;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.abs(-3) + Math.floor(1.9) + Math.ceil(1.1)'
      && ' + Math.max(2, 7, 4) + Math.min(6, 3, 5);' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 16 ) ).
    ls_result = zcl_qjs=>eval(
      'Math.max(-Infinity, 4, Infinity) === Infinity'
      && ' && Math.min(Infinity, -4, -Infinity) === -Infinity'
      && ' && 1 / Math.max(-0, 0) === Infinity'
      && ' && 1 / Math.min(0, -0) === -Infinity'
      && ' && isNaN(Math.max(1, NaN));' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval( 'Array;' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-tag exp = zcl_qjs_value=>tag_object ).
    cl_abap_unit_assert=>assert_bound( ls_result-object_ref ).
    cl_abap_unit_assert=>assert_bound( ls_result-property_ref ).
    ls_result = zcl_qjs=>eval( 'Array.isArray([]);' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval( 'Array.isArray({});' ).
    cl_abap_unit_assert=>assert_false( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval( 'Array.isArray([]) && !Array.isArray({});' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'var keys = Object.keys({ first: 1, second: 2 }); keys.length;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 2 ) ).
  ENDMETHOD.

  METHOD bitwise_operators.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval( '(6 & 3) + (4 | 1) + (7 ^ 3);' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 11 ) ).
    ls_result = zcl_qjs=>eval( '~0;' ).
    cl_abap_unit_assert=>assert_equals( act = ls_result-int_value exp = -1 ).
    ls_result = zcl_qjs=>eval( '(1 << 4) + (32 >> 2);' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 24 ) ).
    ls_result = zcl_qjs=>eval( '-1 >>> 1;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 2147483647 ) ).
    ls_result = zcl_qjs=>eval( '1 + 2 << 2;' ).
    cl_abap_unit_assert=>assert_equals( act = ls_result-int_value exp = 12 ).
  ENDMETHOD.

  METHOD assignment_updates.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'var value = 5; value += 3; value *= 2; value -= 1;'
      && ' value /= 3; value %= 4; value;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 1 ) ).
    ls_result = zcl_qjs=>eval(
      'var value = 7; value &= 6; value |= 8; value ^= 3;'
      && ' value <<= 2; value >>= 1; value >>>= 1; value;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 13 ) ).
    ls_result = zcl_qjs=>eval(
      'var value = 1; var old = value++; var current = ++value;'
      && ' old * 100 + current * 10 + value;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 133 ) ).
    ls_result = zcl_qjs=>eval( 'var value = "4"; value++; value === 5;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'var object = { x: 2, nested: { y: 4 } }; var old = object.x++;'
      && ' var current = ++object.nested.y; object.x += 5;'
      && ' old * 1000 + current * 100 + object.x * 10 + object.nested.y;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 2585 ) ).
    ls_result = zcl_qjs=>eval(
      'var values = [3]; var old = values[0]++; var current = ++values[0];'
      && ' values[0] *= 2; old * 100 + current * 10 + values[0];' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 360 ) ).
    ls_result = zcl_qjs=>eval(
      'var calls = 0; function key() { calls++; return "x"; }'
      && ' var object = { x: 1 }; object[key()] += 2; calls * 10 + object.x;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 13 ) ).
    ls_result = zcl_qjs=>eval(
      'var value = 1; value' && cl_abap_char_utilities=>newline
      && '++value; value;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 2 ) ).
  ENDMETHOD.

  METHOD declaration_lists.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'var first = 1, second = first + 1, third; third = 3;'
      && ' first * 100 + second * 10 + third;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 123 ) ).
    ls_result = zcl_qjs=>eval(
      'let first = 1, second = first + 2, third; third = 4;'
      && ' const fourth = 5, fifth = fourth + 1;'
      && ' first + second + third + fourth + fifth;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 19 ) ).
    ls_result = zcl_qjs=>eval(
      'var caught = false; try { let first = second, second = 1; }'
      && ' catch (error) { caught = true; } caught;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'var sum = 0; for (var index = 0, value = 1; index < 3; index++)'
      && ' { sum += value; value++; } sum;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 6 ) ).
    ls_result = zcl_qjs=>eval( 'var value = 1, value = 2; value;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 2 ) ).
    ls_result = zcl_qjs=>eval(
      'var value = 0; var result = (value = 1, value + 2);'
      && ' result * 10 + value;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 31 ) ).
    ls_result = zcl_qjs=>eval(
      'function pair(first, second) { return first * 10 + second; }'
      && ' var value = 0; pair((value = 1, value + 1), 3);' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 23 ) ).
    ls_result = zcl_qjs=>eval(
      'var first = 0, second = 0;'
      && ' for (; first < 3; first++, second += 2) {} first * 10 + second;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 36 ) ).
    ls_result = zcl_qjs=>eval(
      'var values = [(1, 2), 3]; var object = { x: (1, 2), y: 3 };'
      && ' values[0] * 1000 + values[1] * 100 + object.x * 10 + object.y;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 2323 ) ).
  ENDMETHOD.

  METHOD property_reflection.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'function readValue() { return this._value + 1; }'
      && ' function writeValue(value) { this._value = value * 2; }'
      && ' var object = { _value: 2 };'
      && ' var returned = Object.defineProperty(object, "value",'
      && ' { get: readValue, set: writeValue, enumerable: true, configurable: true });'
      && ' var before = object.value; object.value = 5; var after = object.value;'
      && ' var descriptor = Object.getOwnPropertyDescriptor(object, "value");'
      && ' returned === object && before === 3 && after === 11'
      && ' && descriptor.get === readValue && descriptor.set === writeValue'
      && ' && descriptor.enumerable && descriptor.configurable'
      && ' && Object.keys(object).length === 2;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var object = {}; Object.defineProperty(object, "fixed",'
      && ' { value: 7, writable: false, enumerable: false, configurable: false });'
      && ' var descriptor = Object.getOwnPropertyDescriptor(object, "fixed");'
      && ' object.fixed === 7 && descriptor.value === 7 && !descriptor.writable'
      && ' && !descriptor.enumerable && !descriptor.configurable'
      && ' && Object.keys(object).length === 0;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var object = {}; Object.defineProperty(object, "fixed",'
      && ' { value: 1, writable: false }); var caught;'
      && ' try { object.fixed = 2; } catch (error) { caught = error; }'
      && ' caught.toString() === "TypeError: property is not writable"'
      && ' && object.fixed === 1;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function inheritedRead() { return this._value + 1; }'
      && ' function inheritedWrite(value) { this._value = value; }'
      && ' var prototype = { inherited: 4 };'
      && ' Object.defineProperty(prototype, "value",'
      && ' { get: inheritedRead, set: inheritedWrite });'
      && ' var child = Object.create(prototype); child._value = 8;'
      && ' var before = child.value; child.value = 12; child.inherited = 6;'
      && ' before === 9 && child.value === 13 && prototype._value === undefined'
      && ' && child.inherited === 6 && prototype.inherited === 4'
      && ' && Object.getPrototypeOf(child) === prototype;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var first = { marker: 1 }; var second = {};'
      && ' Object.setPrototypeOf(second, first);'
      && ' var bare = Object.create(null);'
      && ' second.marker === 1 && Object.getPrototypeOf(second) === first'
      && ' && Object.getPrototypeOf(bare) === null;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = { inherited: 1 };'
      && ' var object = Object.create(prototype, {'
      && ' hidden: { value: 2 },'
      && ' shown: { value: 3, enumerable: true } });'
      && ' Object.defineProperties(object, {'
      && ' fourth: { value: 4, enumerable: true },'
      && ' fifth: { value: 5 } });'
      && ' var names = Object.getOwnPropertyNames(object);'
      && ' object.inherited === 1 && object.hidden === 2 && object.shown === 3'
      && ' && object.fourth === 4 && object.fifth === 5'
      && ' && Object.keys(object).length === 2 && names.length === 4;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var ordered = { b: 1, a: 2 }; var keys = Object.keys(ordered);'
      && ' keys[0] === "b" && keys[1] === "a"'
      && ' && JSON.stringify(ordered) === "{\"b\":1,\"a\":2}";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var indexed = {}; indexed[10] = "ten"; indexed.b = 1;'
      && ' indexed[2] = "two"; indexed.a = 2; var keys = Object.keys(indexed);'
      && ' keys[0] === "2" && keys[1] === "10"'
      && ' && keys[2] === "b" && keys[3] === "a";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function read() { return this._value; }'
      && ' function write(value) { this._value = value; }'
      && ' var object = { _value: 1 };'
      && ' Object.defineProperty(object, "accessor",'
      && ' { get: read, set: write, enumerable: true, configurable: true });'
      && ' Object.defineProperty(object, "accessor", { enumerable: false });'
      && ' object.accessor = 7;'
      && ' var accessor = Object.getOwnPropertyDescriptor(object, "accessor");'
      && ' Object.defineProperty(object, "data",'
      && ' { value: 3, writable: true, configurable: false });'
      && ' Object.defineProperty(object, "data", { value: 8, writable: false });'
      && ' var data = Object.getOwnPropertyDescriptor(object, "data");'
      && ' object.accessor === 7 && accessor.get === read && accessor.set === write'
      && ' && !accessor.enumerable && accessor.configurable'
      && ' && data.value === 8 && !data.writable && !data.configurable;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var object = {}; object[true] = 1; object[null] = 2;'
      && ' object[false] = 4; delete object[false];'
      && ' object[true] + object[null] === 3 && object[false] === undefined;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var caught; try { var object = {}; Object.defineProperty(object, "value",'
      && ' { value: 1, get: object }); } catch (error) { caught = error; }'
      && ' caught.toString();' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( )
      exp = 'TypeError: invalid mixed property descriptor' ).

    ls_result = zcl_qjs=>eval(
      'var caught; try { var object = {}; Object.defineProperty(object, "value",'
      && ' { value: 1, writable: false, configurable: false });'
      && ' Object.defineProperty(object, "value", { value: 2 }); }'
      && ' catch (error) { caught = error; }'
      && ' caught.toString();' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( )
      exp = 'TypeError: property is not configurable' ).

    ls_result = zcl_qjs=>eval(
      'var caught; try { var first = {}; var second = Object.create(first);'
      && ' Object.setPrototypeOf(first, second); } catch (error) { caught = error; }'
      && ' caught.toString();' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( )
      exp = 'TypeError: cyclic prototype value' ).

    TRY.
        zcl_qjs=>eval(
          'function recurse() { return this.value; } var object = {};'
          && ' Object.defineProperty(object, "value", { get: recurse });'
          && ' object.value;' ).
        cl_abap_unit_assert=>fail( 'Expected accessor frame budget rejection' ).
      CATCH zcx_qjs_error INTO DATA(lx_accessor_depth).
        cl_abap_unit_assert=>assert_equals(
          act = lx_accessor_depth->reason exp = 'JavaScript frame budget exhausted' ).
    ENDTRY.
  ENDMETHOD.

  METHOD json_intrinsic.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    DATA lo_runtime TYPE REF TO zcl_qjs_runtime.
    DATA lv_deep TYPE string VALUE '0'.
    DATA lv_whitespace_json TYPE string.
    ls_result = zcl_qjs=>eval(
      `var data = JSON.parse('{"name":"Ada","items":[1,true,null],`
      && `"escaped":"line\\nnext"}');`
      && ` data.name === "Ada" && data.items.length === 3`
      && ` && data.items[0] === 1 && data.items[1] === true`
      && ` && data.items[2] === null;` ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval( `JSON.parse('"\\u0041"');` ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( ) exp = 'A' ).

    ls_result = zcl_qjs=>eval( `JSON.parse('"line\\nnext"');` ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( )
      exp = 'line' && cl_abap_char_utilities=>newline && 'next' ).

    ls_result = zcl_qjs=>eval( `JSON.stringify(JSON.parse('-0'));` ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( ) exp = '0' ).
    ls_result = zcl_qjs=>eval( `JSON.stringify(JSON.parse('1.5'));` ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( ) exp = '1.5' ).

    ls_result = zcl_qjs=>eval(
      `var encoded = JSON.stringify({ b: 2, a: "x", skip: undefined,`
      && ` nan: NaN, items: [1, undefined] });`
      && ` var decoded = JSON.parse(encoded);`
      && ` decoded.a === "x" && decoded.b === 2 && decoded.nan === null`
      && ` && decoded.items[0] === 1 && decoded.items[1] === null`
      && ` && decoded.skip === undefined;` ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      `JSON.stringify(undefined) === undefined`
      && ` && JSON.stringify([NaN, Infinity, -Infinity]) === "[null,null,null]";` ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      `var cycle = {}; cycle.self = cycle; var caught;`
      && ` try { JSON.stringify(cycle); } catch (error) {`
      && ` caught = error.toString(); } caught;` ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( ) exp = 'TypeError: cyclic object value' ).

    ls_result = zcl_qjs=>eval(
      `var rejected = 0; try { JSON.parse('{"a":1,}'); }`
      && ` catch (error) { rejected = rejected + 1; }`
      && ` try { JSON.parse('[01]'); } catch (error) { rejected = rejected + 1; }`
      && ` try { JSON.parse("{'a':1}"); } catch (error) {`
      && ` rejected = rejected + 1; } rejected === 3;` ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    CREATE OBJECT lo_runtime.
    lv_whitespace_json = cl_abap_char_utilities=>horizontal_tab
      && cl_abap_char_utilities=>cr_lf+0(1) && ` `
      && cl_abap_char_utilities=>newline && `{"a": 1 } `.
    DATA(ls_whitespace_value) = zcl_qjs_json=>parse(
      source = lv_whitespace_json runtime = lo_runtime ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_whitespace_value-tag exp = zcl_qjs_value=>tag_object ).

    ls_result = zcl_qjs=>eval(
      `var whitespaceError; try { JSON.parse('\t\r \n{"a": 1 } ').a; }`
      && ` catch (error) { whitespaceError = error.toString(); } whitespaceError;` ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-tag exp = zcl_qjs_value=>tag_undefined ).

    DO 257 TIMES.
      lv_deep = '[' && lv_deep && ']'.
    ENDDO.
    TRY.
        zcl_qjs_json=>parse( source = lv_deep runtime = lo_runtime ).
        cl_abap_unit_assert=>fail( 'Expected JSON nesting budget rejection' ).
      CATCH zcx_qjs_error INTO DATA(lx_json_depth).
        cl_abap_unit_assert=>assert_equals(
          act = lx_json_depth->reason
          exp = 'JavaScript parser depth budget exhausted' ).
    ENDTRY.
  ENDMETHOD.

  METHOD number_formatting.
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>to_string( zcl_qjs_number=>parse_literal( '1.5' ) )
      exp = '1.5' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>to_string( zcl_qjs_number=>parse_literal( '1e-6' ) )
      exp = '0.000001' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>to_string( zcl_qjs_number=>parse_literal( '1e-7' ) )
      exp = '1e-7' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>to_string( zcl_qjs_number=>parse_literal( '1e20' ) )
      exp = '100000000000000000000' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>to_string( zcl_qjs_number=>parse_literal( '1e21' ) )
      exp = '1e+21' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>to_string( zcl_qjs_number=>parse_literal( '1.23' ) )
      exp = '1.23' ).
  ENDMETHOD.

  METHOD error_intrinsics.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'var error = new TypeError("bad value");'
      && ' error.toString();' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( ) exp = 'TypeError: bad value' ).
    ls_result = zcl_qjs=>eval(
      'var error = new TypeError("bad value");'
      && ' error.name === "TypeError" && error.message === "bad value"'
      && ' && Object.keys(error).length === 0;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var names = Error().name + RangeError().name + SyntaxError().name'
      && ' + ReferenceError().name;'
      && ' names === "ErrorRangeErrorSyntaxErrorReferenceError";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var caught; try { throw new Error("boom"); } catch (error) {'
      && ' caught = error.toString(); } caught === "Error: boom";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var caught = 0; try { var value = 1; value(); } catch (error) {'
      && ' if (error.name === "TypeError") caught = caught + 1; }'
      && ' try { var object = null; object.value; } catch (error) {'
      && ' if (error.name === "TypeError") caught = caught + 1; }'
      && ' try { 1 instanceof 2; } catch (error) {'
      && ' if (error.name === "TypeError") caught = caught + 1; } caught === 3;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.
ENDCLASS.
