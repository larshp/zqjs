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
    METHODS for_in_enumeration FOR TESTING RAISING cx_root.
    METHODS for_of_iteration FOR TESTING RAISING cx_root.
    METHODS functions_and_recursion FOR TESTING RAISING cx_root.
    METHODS ordinary_objects FOR TESTING RAISING cx_root.
    METHODS object_syntax FOR TESTING RAISING cx_root.
    METHODS destructuring_bindings FOR TESTING RAISING cx_root.
    METHODS tagged_templates FOR TESTING RAISING cx_root.
    METHODS class_syntax FOR TESTING RAISING cx_root.
    METHODS string_operators FOR TESTING RAISING cx_root.
    METHODS string_prototype_methods FOR TESTING RAISING cx_root.
    METHODS reflect_intrinsic FOR TESTING RAISING cx_root.
    METHODS map_set_intrinsics FOR TESTING RAISING cx_root.
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
    METHODS symbol_intrinsic FOR TESTING RAISING cx_root.
    METHODS symbol_keyed_properties FOR TESTING RAISING cx_root.
    METHODS global_numeric_functions FOR TESTING RAISING cx_root.
    METHODS number_static_methods FOR TESTING RAISING cx_root.
    METHODS math_unary_methods FOR TESTING RAISING cx_root.
    METHODS math_constants FOR TESTING RAISING cx_root.
    METHODS math_log_methods FOR TESTING RAISING cx_root.
    METHODS math_trig_methods FOR TESTING RAISING cx_root.
    METHODS math_pow_method FOR TESTING RAISING cx_root.
    METHODS math_precise_methods FOR TESTING RAISING cx_root.
    METHODS math_inverse_trig FOR TESTING RAISING cx_root.
    METHODS math_hyperbolic FOR TESTING RAISING cx_root.
    METHODS math_integer_utilities FOR TESTING RAISING cx_root.
    METHODS math_width_and_hypot FOR TESTING RAISING cx_root.
    METHODS math_random FOR TESTING RAISING cx_root.
    METHODS uri_globals FOR TESTING RAISING cx_root.
    METHODS function_intrinsics FOR TESTING RAISING cx_root.
    METHODS object_collection_methods FOR TESTING RAISING cx_root.
    METHODS array_prototype_methods FOR TESTING RAISING cx_root.
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

    ls_value = zcl_qjs_value=>new_string( '-42' ).
    ls_number = zcl_qjs_number=>to_number( ls_value ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_number )
      exp = CONV f( -42 ) ).

    ls_value = zcl_qjs_value=>new_string( '-0' ).
    ls_number = zcl_qjs_number=>to_number( ls_value ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_number-number_kind
      exp = zcl_qjs_value=>number_neg_zero ).

    ls_value = zcl_qjs_value=>new_string( '+Infinity' ).
    ls_number = zcl_qjs_number=>to_number( ls_value ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_number-number_kind
      exp = zcl_qjs_value=>number_pos_inf ).

    ls_value = zcl_qjs_value=>new_string( '-Infinity' ).
    ls_number = zcl_qjs_number=>to_number( ls_value ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_number-number_kind
      exp = zcl_qjs_value=>number_neg_inf ).

    ls_value = zcl_qjs_value=>new_string( '-0x1' ).
    ls_number = zcl_qjs_number=>to_number( ls_value ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_number-number_kind
      exp = zcl_qjs_value=>number_nan ).

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

    ls_result = zcl_qjs=>eval(
      'var value = 2; `value ${value}, next ${value + 1}`;' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( ) exp = 'value 2, next 3' ).

    ls_result = zcl_qjs=>eval(
      '`object ${({ value: 7 }).value}; nested ${`item ${2}`}`;' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( )
      exp = 'object 7; nested item 2' ).

    ls_result = zcl_qjs=>eval(
      'function render(value) { return `answer: ${value}`; } render(42);' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_result-string_ref->as_string( ) exp = 'answer: 42' ).
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
    ls_result = zcl_qjs=>eval(
      'var prototype = { inherited: 1 }; var object = Object.create(prototype);'
      && ' object.own = 2; var symbol = Symbol("key"); object[symbol] = 3;'
      && ' "own" in object && "inherited" in object'
      && ' && !("missing" in object) && symbol in object'
      && ' && "prototype" in Object;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'var caught = false; try { "x" in 1; }'
      && ' catch (error) { caught = error instanceof TypeError; } caught;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
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

  METHOD for_in_enumeration.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'var prototype = { inherited: 1, duplicate: 2 };'
      && ' Object.defineProperty(prototype, "hidden",'
      && ' { value: 3, enumerable: false });'
      && ' var object = Object.create(prototype);'
      && ' object.own = 4; object.duplicate = 5;'
      && ' var symbol = Symbol("ignored"); object[symbol] = 6;'
      && ' var keys = ""; for (var key in object) { keys = keys + key + ","; }'
      && ' keys === "own,duplicate,inherited,";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = { shadowed: 1 }; var object = Object.create(prototype);'
      && ' Object.defineProperty(object, "shadowed",'
      && ' { value: 2, enumerable: false });'
      && ' var count = 0; for (var key in object) { count = count + 1; }'
      && ' count === 0;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var object = { a: 1, b: 2, c: 3 }; var keys = "";'
      && ' for (var key in object) {'
      && ' keys = keys + key; if (key === "a") delete object.b; }'
      && ' keys === "ac";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var object = { a: 1, b: 2, c: 3 }; var keys = "";'
      && ' for (var key in object) {'
      && ' if (key === "a") continue; keys = keys + key;'
      && ' if (key === "b") break; } keys === "b";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var count = 0, key; for (key in null) { count = count + 1; }'
      && ' for (key in undefined) { count = count + 1; }'
      && ' var keys = ""; for (key in "ab") { keys = keys + key; }'
      && ' count === 0 && keys === "01";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var keys = ""; for (let key in { a: 1, b: 2 }) { keys = keys + key; }'
      && ' for (const key in { c: 3 }) { keys = keys + key; }'
      && ' keys === "abc";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var functions = {}; var object = Object.create(null);'
      && ' object.a = 1; object.b = 2; object.c = 3;'
      && ' for (let key in object) {'
      && ' functions[key] = function() { return key; }; }'
      && ' functions.a() === "a" && functions.b() === "b"'
      && ' && functions.c() === "c";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD for_of_iteration.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'var total = 0; for (var value of [1, 2, 3]) total = total + value;'
      && ' var text = ""; for (var character of "ab") text = text + character;'
      && ' total === 6 && text === "ab";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var map = new Map([["a", 1], ["b", 2]]); var mapped = "";'
      && ' for (var entry of map) mapped = mapped + entry[0] + entry[1];'
      && ' var set = new Set([3, 4]); var summed = 0;'
      && ' for (var item of set) summed = summed + item;'
      && ' mapped === "a1b2" && summed === 7;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var iterable = {}; iterable[Symbol.iterator] = function() {'
      && ' var next = 1; return { next: function() {'
      && ' if (next < 3) return { value: next++, done: false };'
      && ' return { value: undefined, done: true }; } }; };'
      && ' var total = 0; for (var value of iterable) total = total + value;'
      && ' var set = new Set(iterable);'
      && ' var mapSource = {}; mapSource[Symbol.iterator] = function() {'
      && ' var done = false; return { next: function() {'
      && ' if (!done) { done = true; return { value: ["key", 9], done: false }; }'
      && ' return { done: true }; } }; }; var map = new Map(mapSource);'
      && ' total === 3 && set.size === 2 && map.get("key") === 9;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var functions = []; for (let value of [1, 2]) {'
      && ' functions.push(function() { return value; }); }'
      && ' functions[0]() === 1 && functions[1]() === 2;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var closed = 0; function iterable() { var source = {};'
      && ' source[Symbol.iterator] = function() { return {'
      && ' next: function() { return { value: 1, done: false }; },'
      && ' return: function() { closed++; return {}; } }; }; return source; }'
      && ' for (var first of iterable()) { break; }'
      && ' function leave() { for (var second of iterable()) { return 7; } }'
      && ' var returned = leave(); var thrown = false; try {'
      && ' for (var third of iterable()) { throw 9; }'
      && ' } catch (error) { thrown = error === 9; }'
      && ' closed === 3 && returned === 7 && thrown;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
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

    ls_result = zcl_qjs=>eval(
      'var add = function(a, b) { return a + b; }; add(19, 23);' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 42 ) ).

    ls_result = zcl_qjs=>eval(
      '(function(value) { return value + 1; })(41);' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 42 ) ).

    ls_result = zcl_qjs=>eval(
      'var factorial = function recur(n) {'
      && ' if (n <= 1) return 1; return n * recur(n - 1); };'
      && ' factorial(6);' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 720 ) ).

    ls_result = zcl_qjs=>eval(
      'function make(value) { return function(delta) { return value + delta; }; }'
      && ' var add = make(40); add(2);' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 42 ) ).

    ls_result = zcl_qjs=>eval(
      'var named = function inner() {}; named.name === "inner"'
      && ' && named.length === 0;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var calls = 0; function count() { calls++; return 3; }'
      && ' function defaults(a, b = a + 1, c = count()) {'
      && ' return a + b + c; } var expression = function(value = 42) {'
      && ' return value; }; defaults(1) === 6 && calls === 1'
      && ' && defaults(5, 6, 7) === 18 && calls === 1'
      && ' && expression() === 42 && expression(9) === 9'
      && ' && defaults.length === 1 && expression.length === 0;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var described = function(value = 42) {};'
      && ' var descriptor = Object.getOwnPropertyDescriptor(described, "length");'
      && ' descriptor.value === 0 && descriptor.writable === false'
      && ' && descriptor.enumerable === false'
      && ' && descriptor.configurable === true'
      && ' && Object.prototype.hasOwnProperty.call(described, "length")'
      && ' && !Object.prototype.propertyIsEnumerable.call(described, "length")'
      && ' && delete described.length'
      && ' && !Object.prototype.hasOwnProperty.call(described, "length");' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function collect(first, ...rest) {'
      && ' return first + rest[0] + rest[1] + rest.length; }'
      && ' var expression = function(...items) { return items.length; };'
      && ' collect(10, 20, 9) === 41 && collect.length === 1'
      && ' && expression(1, 2, 3) === 3 && expression.length === 0;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
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

    ls_result = zcl_qjs=>eval(
      'var o = { 0: 2, 1e2: 3, null: 4 }; o[0] + o[100] + o.null;' ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_qjs_value=>as_finite_number( ls_result ) exp = CONV f( 9 ) ).

    ls_result = zcl_qjs=>eval(
      'Object.getPrototypeOf({}) === Object.prototype'
      && ' && Object.getPrototypeOf(Array.prototype) === Object.prototype'
      && ' && Object.prototype.toString.call([]) === "[object Array]"'
      && ' && Object.prototype.toString.call({}) === "[object Object]"'
      && ' && Object.prototype.toString.call(null) === "[object Null]"'
      && ' && Object.prototype.toString.call(1) === "[object Number]";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var tagged = {}; tagged[Symbol.toStringTag] = "Tagged";'
      && ' Object.prototype.toString.call(tagged) === "[object Tagged]"'
      && ' && Object.prototype.toString.length === 0'
      && ' && Object.prototype.toString.name === "toString";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = {}; var object = Object.create(prototype);'
      && ' var symbol = Symbol("enumerable"); object.visible = 1; object[symbol] = 2;'
      && ' Object.defineProperty(object, "hidden", { value: 3, enumerable: false });'
      && ' object.valueOf() === object && prototype.isPrototypeOf(object)'
      && ' && Object.prototype.isPrototypeOf.call(null, 1) === false'
      && ' && object.propertyIsEnumerable("visible")'
      && ' && object.propertyIsEnumerable(symbol)'
      && ' && !object.propertyIsEnumerable("hidden")'
      && ' && !object.propertyIsEnumerable("toString")'
      && ' && Object.prototype.valueOf.length === 0'
      && ' && Object.prototype.propertyIsEnumerable.length === 1'
      && ' && Object.prototype.isPrototypeOf.length === 1'
      && ' && Object.prototype.valueOf.name === "valueOf"'
      && ' && Object.prototype.propertyIsEnumerable.name === "propertyIsEnumerable"'
      && ' && Object.prototype.isPrototypeOf.name === "isPrototypeOf";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function Parent() {} function Child() {} var prototype = new Parent();'
      && ' Child.prototype = prototype; var child = new Child();'
      && ' prototype.isPrototypeOf(child);' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function Parent() {} function Child() {} var prototype = new Parent();'
      && ' Child.prototype = prototype; var child = new Child();'
      && ' Parent.prototype.isPrototypeOf(child);' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function Parent() {} function Child() {} var prototype = new Parent();'
      && ' Child.prototype = prototype; var child = new Child();'
      && ' !Number.isPrototypeOf(child);' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval( 'var o = {}; o === o;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var key = "answer"; var symbol = Symbol("computed");'
      && ' var object = { [key]: 42, [symbol]: 7 };'
      && ' object.answer === 42 && object[symbol] === 7;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var symbol = Symbol("spread"); var source = { first: 1 };'
      && ' source[symbol] = 2;'
      && ' Object.defineProperty(source, "hidden",'
      && ' { value: 3, enumerable: false });'
      && ' var target = { before: 0, ...source, first: 4, ...null, ..."xy" };'
      && ' target.before === 0 && target.first === 4'
      && ' && target[symbol] === 2 && target.hidden === undefined'
      && ' && target[0] === "x" && target[1] === "y";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD destructuring_bindings.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.

    ls_result = zcl_qjs=>eval(
      'var [first, , third = 3, ...tail] = [1, 2, undefined, 4, 5];'
      && ' first === 1 && third === 3 && tail.join("") === "45";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var [outer, { value: inner = 7 }] = [1, { value: undefined }];'
      && ' outer === 1 && inner === 7;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var symbol = Symbol("binding"); var source = { x: 1, y: 2 };'
      && ' source[symbol] = 3;'
      && ' const { x: alias, [symbol]: symbolic, ...rest } = source;'
      && ' let { missing = 4 } = source;'
      && ' alias === 1 && symbolic === 3 && missing === 4'
      && ' && rest.y === 2 && rest.x === undefined'
      && ' && rest[symbol] === undefined;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var closed = false; var iterable = {};'
      && ' iterable[Symbol.iterator] = function() { var index = 0; return {'
      && ' next: function() { index = index + 1;'
      && ' return { value: index, done: false }; },'
      && ' return: function() { closed = true; return { done: true }; } }; };'
      && ' var [only] = iterable; only === 1 && closed;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var a = 0; var b = 0; var rest; var result;'
      && ' result = ([a, b = 2, ...rest] = [1, undefined, 3, 4]);'
      && ' var c = 0; var others; var source = { c: 5, d: 6 };'
      && ' var objectResult = ({ c, ...others } = source);'
      && ' a === 1 && b === 2 && rest.join("") === "34"'
      && ' && result[0] === 1 && c === 5 && others.d === 6'
      && ' && objectResult === source;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function read([a = 1, { b }], { c, ...rest } = { c: 3, d: 4 }, last) {'
      && ' return a + b + c + rest.d + last; }'
      && ' var expression = function({ value: renamed }, [tail]) {'
      && ' return renamed + tail; };'
      && ' read([undefined, { b: 2 }], undefined, 5) === 15'
      && ' && read.length === 1'
      && ' && expression({ value: 6 }, [7]) === 13;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var total = 0; for (var [x, y] of [[1, 2], [3, 4]]) {'
      && ' total = total + x + y; }'
      && ' var readers = []; for (let { value } of [{ value: 5 }, { value: 6 }]) {'
      && ' readers.push(function() { return value; }); }'
      && ' var initials = ""; for (var [initial] in { alpha: 1, beta: 2 }) {'
      && ' initials = initials + initial; }'
      && ' total === 10 && readers[0]() === 5 && readers[1]() === 6'
      && ' && initials === "ab";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var caught = 0; try { throw { code: 7, detail: 8 }; }'
      && ' catch ({ code, ...extra }) { caught = code + extra.detail; }'
      && ' caught === 15;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var target = { nested: {} }; var key = "second";'
      && ' [target.first, target[key], target.fallback = 4] = [1, 2, undefined];'
      && ' ({ value: target.nested.answer } = { value: 3 });'
      && ' target.first === 1 && target.second === 2 && target.fallback === 4'
      && ' && target.nested.answer === 3;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function Box(left, right) { this.total = left + right; }'
      && ' var values = [4, 5]; var box = new Box(...values);'
      && ' box instanceof Box && box.total === 9;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD tagged_templates.
    DATA(ls_result) = zcl_qjs=>eval(
      'var cached; function tag(site, value) {'
      && ' if (cached === undefined) cached = site;'
      && ' return site === cached && site[0] === "a\n"'
      && ' && site.raw[0] === "a\\n" && site[1] === "b" && value > 0; }'
      && ' function run(value) { return tag`a\n${value}b`; }'
      && ' var object = { tag: function(site) {'
      && ' return this === object && site[0] === "member"; } };'
      && ' var first = run(1);'
      && ' var descriptor = Object.getOwnPropertyDescriptor(cached, "length");'
      && ' first && run(2) && object.tag`member`'
      && ' && descriptor.writable === false'
      && ' && descriptor.enumerable === false'
      && ' && descriptor.configurable === false;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD class_syntax.
    DATA(ls_result) = zcl_qjs=>eval(
      'class Point {'
      && ' constructor(x, y) { this.x = x; this.y = y; }'
      && ' sum() { return this.x + this.y; }'
      && ' static create(value) { return new Point(value, 2); }'
      && ' }'
      && ' class Empty {}'
      && ' var point = Point.create(5); var empty = new Empty;'
      && ' point instanceof Point && point.sum() === 7'
      && ' && Point.prototype.sum !== undefined'
      && ' && empty instanceof Empty;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'class Base {'
      && ' constructor(value) { this.value = value; }'
      && ' read() { return this.value; }'
      && ' static kind() { return "base"; }'
      && ' }'
      && ' class Child extends Base {'
      && ' constructor(value) { super(value); this.extra = 1; }'
      && ' total() { return this.read() + this.extra; }'
      && ' }'
      && ' var child = new Child(6);'
      && ' child instanceof Child && child instanceof Base'
      && ' && child.total() === 7 && Child.kind() === "base";' ).
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

  METHOD string_prototype_methods.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'String.prototype.constructor === String'
      && ' && Object.getPrototypeOf(new String("abc")) === String.prototype'
      && ' && new String("abc").valueOf() === "abc"'
      && ' && String.prototype.toString() === "";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      '"abc".length === 3 && "abc"[0] === "a" && "abc"["1"] === "b"'
      && ' && "abc"[3] === undefined && new String("abc")[2] === "c"'
      && ' && Object.keys(new String("abc")).join("") === "012";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      '"abc".charAt(1) === "b" && "abc".charAt(-1) === ""'
      && ' && "abc".charCodeAt(0) === 97 && "abc".charCodeAt(9) !== "abc".charCodeAt(9)'
      && ' && "abc".at(-1) === "c" && "abc".at(3) === undefined;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      '"bananas".indexOf("na") === 2 && "bananas".indexOf("na", 3) === 4'
      && ' && "bananas".lastIndexOf("na") === 4'
      && ' && "bananas".includes("ana") && !"bananas".includes("xyz")'
      && ' && "bananas".startsWith("ban") && "bananas".startsWith("ana", 1)'
      && ' && "bananas".endsWith("nas") && "bananas".endsWith("ana", 4);' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      '"abcdef".slice(1, 4) === "bcd" && "abcdef".slice(-3) === "def"'
      && ' && "abcdef".substring(4, 1) === "bcd"'
      && ' && "a".concat("b", 3) === "ab3" && "ab".repeat(3) === "ababab"'
      && ' && "  Ab C  ".trim() === "Ab C"'
      && ' && "  x ".trimStart() === "x " && " x  ".trimEnd() === " x"'
      && ' && "AbC".toLowerCase() === "abc" && "AbC".toUpperCase() === "ABC";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'String.prototype.indexOf.length === 1'
      && ' && String.prototype.substring.length === 2'
      && ' && String.prototype.repeat.name === "repeat"'
      && ' && Object.keys(String.prototype).length === 0;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var wrong = false, range = false;'
      && ' try { String.prototype.toString.call({}); }'
      && ' catch (error) { wrong = error instanceof TypeError; }'
      && ' try { "x".repeat(-1); }'
      && ' catch (error) { range = error instanceof RangeError; } wrong && range;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD reflect_intrinsic.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'typeof Reflect === "object"'
      && ' && Object.prototype.toString.call(Reflect) === "[object Reflect]"'
      && ' && Reflect.apply.length === 3 && Reflect.construct.length === 2'
      && ' && Reflect.defineProperty.length === 3 && Reflect.set.length === 3'
      && ' && Reflect.ownKeys.name === "ownKeys"'
      && ' && Object.keys(Reflect).length === 0;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var receiver = { base: 40 }; var target = {};'
      && ' Object.defineProperty(target, "value", {'
      && ' get: function() { return this.base + 2; },'
      && ' set: function(value) { this.stored = value; } });'
      && ' Reflect.get(target, "value", receiver) === 42'
      && ' && Reflect.set(target, "value", 9, receiver)'
      && ' && receiver.stored === 9;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var object = {}; var symbol = Symbol("key");'
      && ' Reflect.defineProperty(object, "fixed", {'
      && ' value: 4, writable: false, enumerable: false, configurable: false })'
      && ' && Reflect.defineProperty(object, symbol, { value: 7, configurable: true })'
      && ' && Reflect.getOwnPropertyDescriptor(object, "fixed").value === 4'
      && ' && Reflect.get(object, symbol) === 7'
      && ' && Reflect.set(object, "fixed", 8) === false'
      && ' && Reflect.deleteProperty(object, "fixed") === false'
      && ' && Reflect.deleteProperty(object, symbol)'
      && ' && !Reflect.has(object, symbol);' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = { inherited: 1 }; var object = Object.create(prototype);'
      && ' var symbol = Symbol("own"); object.visible = 2; object[symbol] = 3;'
      && ' var keys = Reflect.ownKeys(object);'
      && ' Reflect.has(object, "inherited") && keys.length === 2'
      && ' && keys[0] === "visible" && keys[1] === symbol'
      && ' && Reflect.getPrototypeOf(object) === prototype'
      && ' && Reflect.setPrototypeOf(object, null)'
      && ' && Reflect.getPrototypeOf(object) === null;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var object = {}; Reflect.isExtensible(object)'
      && ' && Reflect.preventExtensions(object)'
      && ' && !Reflect.isExtensible(object)'
      && ' && Reflect.defineProperty(object, "late", { value: 1 }) === false'
      && ' && Reflect.set(object, "late", 1) === false'
      && ' && Reflect.setPrototypeOf(object, {}) === false;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function sum(left, right) { return this.base + left + right; }'
      && ' function Box(left, right) { this.total = left + right; }'
      && ' function Other() {}'
      && ' var box = Reflect.construct(Box, [2, 3], Other);'
      && ' Reflect.apply(sum, { base: 10 }, [4, 5]) === 19'
      && ' && box.total === 5 && Object.getPrototypeOf(box) === Other.prototype;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var caught = 0;'
      && ' try { Reflect.get(1, "x"); } catch (error) {'
      && ' if (error instanceof TypeError) { caught = caught + 1; } }'
      && ' try { Reflect.apply({}, null, []); } catch (error) {'
      && ' if (error instanceof TypeError) { caught = caught + 1; } }'
      && ' try { Reflect.construct(function() {}, 1); } catch (error) {'
      && ' if (error instanceof TypeError) { caught = caught + 1; } } caught === 3;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD map_set_intrinsics.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'var key = {}; var map = new Map([[key, 1], [NaN, 2], [-0, 3]]);'
      && ' map.size === 3 && map.get(key) === 1 && map.get(NaN) === 2'
      && ' && map.has(0) && map.set("next", 4) === map'
      && ' && map.get("next") === 4 && map instanceof Map'
      && ' && Object.prototype.toString.call(map) === "[object Map]";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var map = new Map([["a", 1], ["b", 2]]); var iterator = map.entries();'
      && ' var first = iterator.next(); map.delete("b"); map.set("c", 3);'
      && ' var second = iterator.next(); var done = iterator.next();'
      && ' first.value[0] === "a" && first.value[1] === 1'
      && ' && second.value[0] === "c" && second.value[1] === 3'
      && ' && done.done && iterator[Symbol.iterator]() === iterator;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var map = new Map([["a", 1], ["b", 2]]); var seen = "";'
      && ' map.forEach(function(value, key, owner) {'
      && ' seen = seen + key + value; if (key === "a") owner.set("c", 3); });'
      && ' seen === "a1b2c3";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var set = new Set([1, 2, 2, NaN, NaN]); var entries = set.entries();'
      && ' var first = entries.next().value; var values = set.values();'
      && ' set.size === 3 && set.has(NaN) && set.add(3) === set'
      && ' && set.delete(2) && !set.has(2) && first[0] === first[1]'
      && ' && Set.prototype.keys === Set.prototype.values'
      && ' && Set.prototype[Symbol.iterator] === Set.prototype.values'
      && ' && values.next().value === 1 && set instanceof Set'
      && ' && Object.prototype.toString.call(set) === "[object Set]";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var caught = 0; try { Map(); } catch (error) {'
      && ' if (error instanceof TypeError) caught = caught + 1; }'
      && ' try { Map.prototype.get.call({}); } catch (error) {'
      && ' if (error instanceof TypeError) caught = caught + 1; }'
      && ' try { new Map([1]); } catch (error) {'
      && ' if (error instanceof TypeError) caught = caught + 1; } caught === 3;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
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

    ls_result = zcl_qjs=>eval(
      'var values = [, 1, ,]; values.length === 3'
      && ' && !Object.hasOwn(values, "0") && values[1] === 1'
      && ' && !Object.hasOwn(values, "2");' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [0, ...[1, 2], 3];'
      && ' var sparse = [, ...[4, 5]];'
      && ' values.length === 4 && values[0] === 0 && values[3] === 3'
      && ' && sparse.length === 3 && !Object.hasOwn(sparse, "0")'
      && ' && sparse[1] === 4 && sparse[2] === 5;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function sum(a, b, c) { return a + b + c; }'
      && ' var receiver = { base: 10, add: function(a, b) {'
      && ' return this.base + a + b; } };'
      && ' sum(...[1, 2], 3) === 6 && receiver.add(...[4, 5]) === 19;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
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

    ls_result = zcl_qjs=>eval(
      'var calls = 0; var first = true ? (calls = calls + 1) : (calls = 99);'
      && ' var second = false ? 10 : true ? 20 : 30;'
      && ' first === 1 && second === 20 && calls === 1'
      && ' && (false || true ? 3 : 4) === 3;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
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
      'Object.prototype.toString.call(new Error()) === "[object Error]"'
      && ' && Error.prototype.toString.call({}) === "Error"'
      && ' && Error.prototype.toString.call({ message: "42" }) === "Error: 42"'
      && ' && Error.prototype.toString.call({ name: "24" }) === "24";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var error = new TypeError("bad value"); var empty = new TypeError();'
      && ' error instanceof TypeError && error instanceof Error'
      && ' && !(error instanceof RangeError)'
      && ' && TypeError.prototype instanceof Error'
      && ' && Object.getPrototypeOf(TypeError.prototype) === Error.prototype'
      && ' && TypeError.prototype.constructor === TypeError'
      && ' && Error.prototype.constructor === Error'
      && ' && !Object.hasOwn(empty, "message")'
      && ' && Object.hasOwn(error, "message")'
      && ' && Error.length === 1 && TypeError.length === 1'
      && ' && Error.name === "Error" && TypeError.name === "TypeError"'
      && ' && Error.prototype.toString.length === 0;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var caught = false; try { var object = null; object.value; }'
      && ' catch (error) { caught = error instanceof TypeError'
      && ' && error instanceof Error && error.constructor === TypeError; } caught;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var caught = false; try { Object.prototype.valueOf.call(undefined); }'
      && ' catch (error) { caught = error.constructor === TypeError'
      && ' && error instanceof TypeError && error.name === "TypeError"; } caught;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var caught = false; try {'
      && ' Object.prototype.isPrototypeOf.call(null, function() {}); }'
      && ' catch (error) { caught = error.constructor === TypeError'
      && ' && error instanceof TypeError && error.name === "TypeError"; } caught;' ).
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

  METHOD symbol_intrinsic.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'var first = Symbol("item"); var second = Symbol("item");'
      && ' typeof Symbol === "function" && typeof first === "symbol"'
      && ' && first !== second;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var shared = Symbol.for("shared");'
      && ' shared === Symbol.for("shared")'
      && ' && Symbol.keyFor(shared) === "shared"'
      && ' && Symbol.keyFor(Symbol("local")) === undefined'
      && ' && Symbol.keyFor(Symbol.for("")) === "";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var caught = 0; try { Symbol.keyFor("not a symbol"); }'
      && ' catch (error) { if (error.name === "TypeError") caught = caught + 1; }'
      && ' try { new Symbol("item"); }'
      && ' catch (error) { if (error.name === "TypeError") caught = caught + 1; }'
      && ' caught === 2;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'typeof Symbol.iterator === "symbol"'
      && ' && Symbol.iterator === Symbol.iterator'
      && ' && Symbol.iterator !== Symbol.asyncIterator'
      && ' && Symbol.dispose !== Symbol.asyncDispose'
      && ' && Symbol.keyFor(Symbol.toPrimitive) === undefined'
      && ' && String(Symbol("item")) === "Symbol(item)"'
      && ' && String(Symbol()) === "Symbol()";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD symbol_keyed_properties.
    DATA(ls_result) = zcl_qjs=>eval(
      'var key = Symbol("key"); var object = {};'
      && ' object[key] = 7; object["Symbol(key)"] = 8;'
      && ' object[key] === 7 && object["Symbol(key)"] === 8'
      && ' && Object.keys(object).length === 1'
      && ' && Object.getOwnPropertyNames(object).length === 1'
      && ' && Object.getOwnPropertySymbols(object).length === 1'
      && ' && Object.getOwnPropertySymbols(object)[0] === key'
      && ' && Object.hasOwn(object, key);' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var key = Symbol("descriptor"); var object = {};'
      && ' Object.defineProperty(object, key,'
      && '   { value: 4, writable: true, enumerable: false, configurable: true });'
      && ' object[key] = 5; var descriptor = Object.getOwnPropertyDescriptor(object, key);'
      && ' descriptor.value === 5 && descriptor.writable'
      && ' && !descriptor.enumerable && descriptor.configurable'
      && ' && delete object[key] && object[key] === undefined;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var key = Symbol("copy"); var source = {}; source[key] = 9;'
      && ' var copy = Object.assign({}, source);'
      && ' var prototype = {}; prototype[key] = 3;'
      && ' var child = Object.create(prototype); child[key] = 4;'
      && ' copy[key] === 9 && child[key] === 4 && prototype[key] === 3;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var key = Symbol("create"); var descriptors = {};'
      && ' descriptors[key] = { value: 12, enumerable: true };'
      && ' var object = Object.create(null, descriptors);'
      && ' object[key] === 12 && Object.hasOwn(object, key);' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD global_numeric_functions.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'parseInt("  -0xFtail") === -15 && parseInt("11", 2) === 3'
      && ' && parseInt("z", 36) === 35 && isNaN(parseInt("10", 1))'
      && ' && 1 / parseInt("-0") === -Infinity;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'parseFloat("  -1.25e2tail") === -125'
      && ' && parseFloat(".5") === 0.5 && parseFloat("1e") === 1'
      && ' && parseFloat("Infinity-and-beyond") === Infinity;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'isFinite("42") && isFinite(null) && !isFinite("not numeric")'
      && ' && !isFinite(Infinity) && !isFinite(NaN);' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD number_static_methods.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'Number.isNaN(NaN) && !Number.isNaN("NaN")'
      && ' && Number.isFinite(1) && Number.isFinite(-0)'
      && ' && !Number.isFinite("1") && !Number.isFinite(Infinity);' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'Number.isInteger(1) && Number.isInteger(-0) && Number.isInteger(1e21)'
      && ' && !Number.isInteger(1.5) && !Number.isInteger("1")'
      && ' && Number.isSafeInteger(Number.MAX_SAFE_INTEGER)'
      && ' && Number.isSafeInteger(Number.MIN_SAFE_INTEGER)'
      && ' && !Number.isSafeInteger(Number.MAX_SAFE_INTEGER + 1);' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'Number.parseInt === parseInt && Number.parseFloat === parseFloat'
      && ' && Number.NaN !== Number.NaN'
      && ' && Number.POSITIVE_INFINITY === Infinity'
      && ' && Number.NEGATIVE_INFINITY === -Infinity && Number.EPSILON > 0;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD math_unary_methods.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'Math.trunc(3.9) === 3 && Math.trunc(-3.9) === -3'
      && ' && 1 / Math.trunc(-0.1) === -Infinity'
      && ' && Math.trunc(Infinity) === Infinity && isNaN(Math.trunc(NaN));' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'Math.round(1.49) === 1 && Math.round(1.5) === 2'
      && ' && Math.round(-1.5) === -1 && 1 / Math.round(-0.5) === -Infinity'
      && ' && 1 / Math.ceil(-0.1) === -Infinity;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'Math.sign(-8) === -1 && Math.sign(8) === 1 && Math.sign(0) === 0'
      && ' && 1 / Math.sign(-0) === -Infinity && isNaN(Math.sign(NaN))'
      && ' && Math.sqrt(9) === 3 && Math.sqrt(Infinity) === Infinity'
      && ' && isNaN(Math.sqrt(-1)) && 1 / Math.sqrt(-0) === -Infinity;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      '+Infinity === Infinity && +"42" === 42 && 1 / +(-0) === -Infinity;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD math_constants.
    DATA(ls_result) = zcl_qjs=>eval(
      'Math.E === 2.718281828459045 && Math.LN10 === 2.302585092994046'
      && ' && Math.LN2 === 0.6931471805599453'
      && ' && Math.LOG10E === 0.4342944819032518'
      && ' && Math.LOG2E === 1.4426950408889634'
      && ' && Math.PI === 3.141592653589793'
      && ' && Math.SQRT1_2 === 0.7071067811865476'
      && ' && Math.SQRT2 === 1.4142135623730951;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'var d = Object.getOwnPropertyDescriptor(Math, "PI");'
      && ' d.value === Math.PI && !d.writable && !d.enumerable && !d.configurable;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD math_log_methods.
    DATA(ls_result) = zcl_qjs=>eval(
      'Math.exp(0) === 1 && Math.exp(-0) === 1'
      && ' && Math.exp(Infinity) === Infinity && Math.exp(-Infinity) === 0'
      && ' && isNaN(Math.exp(NaN));' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.abs(Math.exp(1) - Math.E) < 1e-15'
      && ' && Math.abs(Math.log(Math.E) - 1) < 1e-15'
      && ' && Math.exp(710) === Infinity && Math.exp(-746) === 0;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.log(1) === 0 && Math.log(Infinity) === Infinity'
      && ' && Math.log(0) === -Infinity && Math.log(-0) === -Infinity'
      && ' && isNaN(Math.log(-1)) && isNaN(Math.log(NaN));' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.abs(Math.log10(1000) - 3) < 1e-14 && Math.log10(1) === 0'
      && ' && Math.abs(Math.log2(8) - 3) < 1e-14 && Math.log2(1) === 0'
      && ' && Math.log10(0) === -Infinity && Math.log2(0) === -Infinity;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD math_trig_methods.
    DATA(ls_result) = zcl_qjs=>eval(
      'Math.sin(0) === 0 && 1 / Math.sin(-0) === -Infinity'
      && ' && Math.cos(0) === 1 && Math.cos(-0) === 1'
      && ' && Math.tan(0) === 0 && 1 / Math.tan(-0) === -Infinity;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'isNaN(Math.sin(Infinity)) && isNaN(Math.cos(-Infinity))'
      && ' && isNaN(Math.tan(NaN));' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.abs(Math.sin(Math.PI / 2) - 1) < 1e-14'
      && ' && Math.abs(Math.cos(Math.PI) + 1) < 1e-14'
      && ' && Math.abs(Math.tan(Math.PI / 4) - 1) < 1e-14;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD math_pow_method.
    DATA(ls_result) = zcl_qjs=>eval(
      'Math.pow(2, 10) === 1024 && Math.pow(2, -3) === 0.125'
      && ' && Math.pow(-2, 3) === -8 && Math.pow(-2, 2) === 4'
      && ' && Math.abs(Math.pow(9, 0.5) - 3) < 1e-14;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.pow(NaN, 0) === 1 && isNaN(Math.pow(NaN, 2))'
      && ' && isNaN(Math.pow(-2, 0.5)) && isNaN(Math.pow(1, Infinity))'
      && ' && Math.pow(2, Infinity) === Infinity'
      && ' && Math.pow(0.5, -Infinity) === Infinity;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      '1 / Math.pow(-0, 3) === -Infinity'
      && ' && 1 / Math.pow(-0, 2) === Infinity'
      && ' && Math.pow(-0, -3) === -Infinity'
      && ' && Math.pow(-Infinity, 3) === -Infinity'
      && ' && 1 / Math.pow(-Infinity, -3) === -Infinity;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.pow(2, 1024) === Infinity && Math.pow(2, -1075) === 0'
      && ' && Math.pow(0.5, -1075) === Infinity;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD math_precise_methods.
    DATA(ls_result) = zcl_qjs=>eval(
      'Math.abs(Math.cbrt(27) - 3) < 1e-14'
      && ' && Math.abs(Math.cbrt(-8) + 2) < 1e-14'
      && ' && Math.cbrt(Infinity) === Infinity'
      && ' && 1 / Math.cbrt(-0) === -Infinity && isNaN(Math.cbrt(NaN));' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.abs(Math.expm1(1) - (Math.E - 1)) < 1e-15'
      && ' && Math.abs(Math.expm1(1e-10) - 1.00000000005e-10) < 1e-24'
      && ' && Math.expm1(-Infinity) === -1'
      && ' && Math.expm1(Infinity) === Infinity'
      && ' && 1 / Math.expm1(-0) === -Infinity;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.abs(Math.log1p(Math.E - 1) - 1) < 1e-14'
      && ' && Math.abs(Math.log1p(1e-10) - 9.9999999995e-11) < 1e-24'
      && ' && Math.log1p(-1) === -Infinity && isNaN(Math.log1p(-2))'
      && ' && 1 / Math.log1p(-0) === -Infinity;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD math_inverse_trig.
    DATA(ls_result) = zcl_qjs=>eval(
      'Math.atan(0) === 0 && 1 / Math.atan(-0) === -Infinity'
      && ' && Math.abs(Math.atan(1) - Math.PI / 4) < 1e-14'
      && ' && Math.atan(Infinity) === Math.PI / 2'
      && ' && Math.atan(-Infinity) === -Math.PI / 2;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.asin(0) === 0 && 1 / Math.asin(-0) === -Infinity'
      && ' && Math.asin(1) === Math.PI / 2 && Math.asin(-1) === -Math.PI / 2'
      && ' && isNaN(Math.asin(2)) && Math.acos(1) === 0'
      && ' && Math.acos(-1) === Math.PI && Math.acos(0) === Math.PI / 2;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.atan2(0, 0) === 0 && 1 / Math.atan2(-0, 0) === -Infinity'
      && ' && Math.atan2(0, -0) === Math.PI'
      && ' && Math.atan2(-0, -0) === -Math.PI'
      && ' && Math.atan2(1, 0) === Math.PI / 2'
      && ' && Math.atan2(-1, 0) === -Math.PI / 2;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.atan2(Infinity, Infinity) === Math.PI / 4'
      && ' && Math.atan2(Infinity, -Infinity) === 3 * Math.PI / 4'
      && ' && Math.atan2(-Infinity, -Infinity) === -3 * Math.PI / 4'
      && ' && Math.abs(Math.atan2(1, -1) - 3 * Math.PI / 4) < 1e-14;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD math_hyperbolic.
    DATA(ls_result) = zcl_qjs=>eval(
      'Math.sinh(0) === 0 && 1 / Math.sinh(-0) === -Infinity'
      && ' && Math.sinh(Infinity) === Infinity'
      && ' && Math.sinh(-Infinity) === -Infinity'
      && ' && Math.abs(Math.sinh(1) - (Math.E - 1 / Math.E) / 2) < 1e-14;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.cosh(0) === 1 && Math.cosh(-0) === 1'
      && ' && Math.cosh(Infinity) === Infinity'
      && ' && Math.cosh(-Infinity) === Infinity'
      && ' && Math.abs(Math.cosh(1) - (Math.E + 1 / Math.E) / 2) < 1e-14;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.tanh(0) === 0 && 1 / Math.tanh(-0) === -Infinity'
      && ' && Math.tanh(Infinity) === 1 && Math.tanh(-Infinity) === -1'
      && ' && Math.abs(Math.tanh(1)'
      && ' - (Math.E * Math.E - 1) / (Math.E * Math.E + 1)) < 1e-14;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.asinh(0) === 0 && 1 / Math.asinh(-0) === -Infinity'
      && ' && Math.asinh(Infinity) === Infinity'
      && ' && Math.asinh(-Infinity) === -Infinity'
      && ' && Math.abs(Math.asinh(Math.sinh(1)) - 1) < 1e-13;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.acosh(1) === 0 && Math.acosh(Infinity) === Infinity'
      && ' && isNaN(Math.acosh(0.5))'
      && ' && Math.abs(Math.acosh(Math.cosh(1)) - 1) < 1e-13;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.atanh(0) === 0 && 1 / Math.atanh(-0) === -Infinity'
      && ' && Math.atanh(1) === Infinity && Math.atanh(-1) === -Infinity'
      && ' && isNaN(Math.atanh(2))'
      && ' && Math.abs(Math.atanh(Math.tanh(0.5)) - 0.5) < 1e-13;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD math_integer_utilities.
    DATA(ls_result) = zcl_qjs=>eval(
      'Math.clz32(0) === 32 && Math.clz32(1) === 31'
      && ' && Math.clz32(0x100) === 23 && Math.clz32(-1) === 0'
      && ' && Math.clz32(3.9) === 30 && Math.clz32(NaN) === 32'
      && ' && Math.clz32(Infinity) === 32;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.imul(2, 4) === 8 && Math.imul(-1, 8) === -8'
      && ' && Math.imul(0xffffffff, 5) === -5'
      && ' && Math.imul(0xfffffffe, 5) === -10'
      && ' && Math.imul(0x7fffffff, 2) === -2'
      && ' && Math.imul(0x80000000, 2) === 0'
      && ' && Math.imul(0x12345678, 0x9abcdef0) === 606937216;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD math_width_and_hypot.
    DATA(ls_result) = zcl_qjs=>eval(
      'Math.hypot() === 0 && Math.hypot(3, 4) === 5'
      && ' && Math.hypot(0, -0, 0) === 0'
      && ' && Math.hypot(NaN, Infinity) === Infinity'
      && ' && isNaN(Math.hypot(NaN, 3))'
      && ' && Math.abs(Math.hypot(3e200, 4e200) / 5e200 - 1) < 1e-15'
      && ' && Math.hypot("3", "4") === 5;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.fround(Infinity) === Infinity && isNaN(Math.fround(NaN))'
      && ' && 1 / Math.fround(-0) === -Infinity'
      && ' && Math.fround(0.1) === 0.10000000149011612'
      && ' && Math.fround(4294967295) === 4294967296'
      && ' && Math.fround(1.0000000596046448) === 1'
      && ' && Math.fround(1.0000001788139343) === 1.000000238418579;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'Math.f16round(0.1) === 0.0999755859375'
      && ' && Math.f16round(1.00048828125) === 1'
      && ' && Math.f16round(1.00146484375) === 1.001953125'
      && ' && Math.f16round(65504) === 65504'
      && ' && Math.f16round(65520) === Infinity'
      && ' && 1 / Math.f16round(-2.9802322387695312e-8) === -Infinity;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD math_random.
    DATA(ls_result) = zcl_qjs=>eval(
      'var valid = true; var changed = false; var first = Math.random();'
      && ' if (first < 0 || first >= 1) valid = false;'
      && ' for (var i = 0; i < 32; i++) {'
      && '   var value = Math.random();'
      && '   if (value < 0 || value >= 1) valid = false;'
      && '   if (value !== first) changed = true;'
      && ' } valid && changed;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD uri_globals.
    DATA(ls_result) = zcl_qjs=>eval(
      'encodeURI("https://example.com/a b?x=1&y=#")'
      && ' === "https://example.com/a%20b?x=1&y=#"'
      && ' && encodeURIComponent(";/?:@&=+$,#")'
      && ' === "%3B%2F%3F%3A%40%26%3D%2B%24%2C%23"'
      && ' && encodeURI() === "undefined" && encodeURIComponent(123) === "123";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'decodeURI("%3B%2f%3F%3a%40%26%3D%2b%24%2C%23")'
      && ' === "%3B%2f%3F%3a%40%26%3D%2b%24%2C%23"'
      && ' && decodeURIComponent("%3B%2F%3F%3A%40%26%3D%2B%24%2C%23")'
      && ' === ";/?:@&=+$,#"'
      && ' && encodeURIComponent(decodeURIComponent("%E2%82%AC")) === "%E2%82%AC"'
      && ' && encodeURIComponent(decodeURIComponent("%F0%9F%98%80"))'
      && ' === "%F0%9F%98%80";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
    ls_result = zcl_qjs=>eval(
      'var malformed = ["%", "%C0%AF", "%ED%A0%80", "%F4%90%80%80", "%E2%82"];'
      && ' var valid = true; for (var i = 0; i < malformed.length; i++) {'
      && '   try { decodeURIComponent(malformed[i]); valid = false; }'
      && '   catch (error) { if (error.name !== "URIError") valid = false; }'
      && ' } var constructed = new URIError("bad");'
      && ' valid && constructed.name === "URIError" && constructed.message === "bad";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD function_intrinsics.
    DATA(ls_result) = zcl_qjs=>eval(
      'function add(a, b) { return this.base + a + b; }'
      && ' add.call({ base: 1 }, 2, 3) === 6'
      && ' && add.apply({ base: 2 }, [3, 4]) === 9'
      && ' && add.apply({ base: 3 }, { "0": 4, "1": 5, length: 2 }) === 12'
      && ' && Function.prototype.call.call(add, { base: 4 }, 5, 6) === 15;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function add(a, b) { return this.base + a + b; }'
      && ' var bound = add.bind({ base: 10 }, 20);'
      && ' bound(30) === 60 && bound.call({ base: 99 }, 30) === 60'
      && ' && Function.prototype.constructor === Function;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var sum = Function("a", "b", "return a + b;");'
      && ' var empty = Function();'
      && ' sum(7, 8) === 15 && empty() === undefined;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var globalValue = 7;'
      && ' function make() { var globalValue = 99;'
      && '   return Function("return globalValue;"); }'
      && ' make()() === 7;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function Point(x, y) { this.x = x; this.y = y; }'
      && ' var BoundPoint = Point.bind({ x: 99 }, 4);'
      && ' var point = new BoundPoint(5);'
      && ' point.x === 4 && point.y === 5 && point instanceof Point;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var valid = false; try { Function.prototype.call.call({}, null); }'
      && ' catch (error) { valid = error.name === "TypeError"; } valid;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD object_collection_methods.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'var target = { a: 1 }; var source = { b: 2, a: 3 };'
      && ' Object.defineProperty(source, "hidden", { value: 9 });'
      && ' var returned = Object.assign(target, source, null, undefined);'
      && ' returned === target && target.a === 3 && target.b === 2'
      && ' && !Object.hasOwn(target, "hidden");' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = { inherited: 1 }; var object = Object.create(prototype);'
      && ' object[2] = "two"; object.first = 3; object.second = 4;'
      && ' Object.defineProperty(object, "hidden", { value: 5 });'
      && ' var values = Object.values(object); var entries = Object.entries(object);'
      && ' values.length === 3 && values[0] === "two" && values[2] === 4'
      && ' && entries[1][0] === "first" && entries[1][1] === 3'
      && ' && Object.hasOwn(object, "first")'
      && ' && !Object.hasOwn(object, "inherited");' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var object = {}; Object.is(NaN, NaN) && !Object.is(0, -0)'
      && ' && Object.is(-0, -0) && Object.is(object, object)'
      && ' && !Object.is({}, {}) && Object.is() && !Object.is(1, "1");' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.

  METHOD array_prototype_methods.
    DATA ls_result TYPE zcl_qjs_value=>ty_value.
    ls_result = zcl_qjs=>eval(
      'var values = [1, 2]; var length = values.push(3, 4);'
      && ' length === 4 && values.length === 4 && values[2] === 3'
      && ' && values[3] === 4;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [7, 8]; var last = values.pop();'
      && ' last === 8 && values.length === 1'
      && ' && !Object.hasOwn(values, "1") && values.pop() === 7'
      && ' && values.pop() === undefined && values.length === 0;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var object = { length: 1 }; object[0] = "first";'
      && ' var length = Array.prototype.push.call(object, "second");'
      && ' var value = Array.prototype.pop.call(object);'
      && ' length === 2 && value === "second" && object.length === 1'
      && ' && !Object.hasOwn(object, "1");' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'Array.isArray(Array.prototype)'
      && ' && Array.prototype.constructor === Array'
      && ' && Array.prototype.push.length === 1'
      && ' && Array.prototype.push.name === "push"'
      && ' && Array.prototype.pop.length === 0'
      && ' && Array.prototype.pop.name === "pop";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [1, 2, 3]; values.length = 1;'
      && ' var rangeError = false;'
      && ' try { values.length = -1; }'
      && ' catch (error) { rangeError = error.name === "RangeError"; }'
      && ' values.length === 1 && !Object.hasOwn(values, "1")'
      && ' && !Object.hasOwn(values, "2") && rangeError;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function joinObject() { var object = { length: 2 };'
      && ' object[0] = "a"; object[1] = "b";'
      && ' return Array.prototype.join.call(object, "|"); }'
      && ' [1, null, undefined, 4].join("-") === "1---4"'
      && ' && Array(3).join() === ",," && joinObject() === "a|b";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [1, 2, 1, NaN];'
      && ' values.indexOf(1) === 0 && values.indexOf(1, 1) === 2'
      && ' && values.indexOf(1, -1) === -1 && values.indexOf(NaN) === -1'
      && ' && Array(1).indexOf(undefined) === -1'
      && ' && values.includes(NaN) && Array(1).includes(undefined)'
      && ' && values.includes(2, -3) && !values.includes(2, 2);' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = { first: 0 }; prototype[0] = "inherited";'
      && ' var object = Object.create(prototype); object.length = 1;'
      && ' Array.prototype.indexOf.call(object, "inherited") === 0'
      && ' && Array.prototype.includes.call(object, "inherited")'
      && ' && Array.prototype.join.call(object) === "inherited"'
      && ' && Array.prototype.join.length === 1'
      && ' && Array.prototype.indexOf.length === 1'
      && ' && Array.prototype.includes.length === 1;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [1, 2, 3]; var first = values.shift();'
      && ' var length = values.unshift(-1, 0);'
      && ' first === 1 && length === 4 && values.length === 4'
      && ' && values[0] === -1 && values[1] === 0'
      && ' && values[2] === 2 && values[3] === 3;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var sparse = Array(3); sparse[2] = "last";'
      && ' sparse.shift() === undefined && sparse.length === 2'
      && ' && !Object.hasOwn(sparse, "0") && sparse[1] === "last"'
      && ' && [].shift() === undefined;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = {}; prototype[1] = "inherited";'
      && ' var object = Object.create(prototype); object[0] = "first";'
      && ' object.length = 2; var first = Array.prototype.shift.call(object);'
      && ' var length = Array.prototype.unshift.call(object, "new");'
      && ' first === "first" && length === 2 && object.length === 2'
      && ' && object[0] === "new" && object[1] === "inherited"'
      && ' && Array.prototype.shift.length === 0'
      && ' && Array.prototype.unshift.length === 1;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = []; values.length = 4294967295; var rangeError = false;'
      && ' try { values.push("edge"); }'
      && ' catch (error) { rangeError = error.name === "RangeError"; }'
      && ' rangeError && values.length === 4294967295'
      && ' && values[4294967295] === "edge";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [1, 2, 3, 4]; var returned = values.reverse();'
      && ' returned === values && values[0] === 4 && values[1] === 3'
      && ' && values[2] === 2 && values[3] === 1'
      && ' && Array.prototype.reverse.length === 0;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var sparse = Array(3); sparse[0] = "first"; sparse.reverse();'
      && ' !Object.hasOwn(sparse, "0") && !Object.hasOwn(sparse, "1")'
      && ' && sparse[2] === "first" && sparse.length === 3; ' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = {}; prototype[0] = "inherited";'
      && ' var object = Object.create(prototype); object[1] = "own"; object.length = 2;'
      && ' Array.prototype.reverse.call(object) === object'
      && ' && object[0] === "own" && object[1] === "inherited";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [1, 2, 1, NaN];'
      && ' values.lastIndexOf(1) === 2 && values.lastIndexOf(1, 1) === 0'
      && ' && values.lastIndexOf(2, -2) === 1'
      && ' && values.lastIndexOf(2, -3) === 1'
      && ' && values.lastIndexOf(2, -4) === -1'
      && ' && values.lastIndexOf(NaN) === -1'
      && ' && Array(2).lastIndexOf(undefined) === -1'
      && ' && Array.prototype.lastIndexOf.length === 1;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = {}; prototype[1] = "inherited";'
      && ' var object = Object.create(prototype); object.length = 3;'
      && ' Array.prototype.lastIndexOf.call(object, "inherited") === 1;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = ["first", "middle", "last"];'
      && ' values.at(0) === "first" && values.at(-1) === "last"'
      && ' && values.at(-2) === "middle" && values.at(3) === undefined'
      && ' && values.at(-4) === undefined && values.at(NaN) === "first"'
      && ' && values.at(Infinity) === undefined'
      && ' && Array.prototype.at.length === 1'
      && ' && Array.prototype.at.name === "at";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = {}; prototype[1] = "inherited";'
      && ' var object = Object.create(prototype); object.length = "3";'
      && ' Array.prototype.at.call(object, -2) === "inherited"'
      && ' && Array.prototype.at.call(object, 0) === undefined;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [0, 1, 2, 3]; var copy = values.slice(1, -1);'
      && ' copy !== values && copy.length === 2 && copy[0] === 1'
      && ' && copy[1] === 2 && values.length === 4'
      && ' && values.slice(-2)[0] === 2'
      && ' && values.slice(Infinity).length === 0'
      && ' && Array.prototype.slice.length === 2'
      && ' && Array.prototype.slice.name === "slice";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var sparse = [, "own", ,]; var copy = sparse.slice();'
      && ' copy.length === 3 && !Object.hasOwn(copy, "0")'
      && ' && copy[1] === "own" && !Object.hasOwn(copy, "2");' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = {}; prototype[1] = "inherited";'
      && ' var object = Object.create(prototype); object.length = "3";'
      && ' var copy = Array.prototype.slice.call(object, 0, 2);'
      && ' copy.length === 2 && !Object.hasOwn(copy, "0")'
      && ' && Object.hasOwn(copy, "1") && copy[1] === "inherited";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var total = 0; var indexes = ""; var values = [2, 3, 4];'
      && ' function visit(value, index, array) {'
      && ' total = total + value; indexes = indexes + index;'
      && ' if (array !== values) { total = -100; } }'
      && ' var returned = values.forEach(visit);'
      && ' returned === undefined && total === 9 && indexes === "012"'
      && ' && Array.prototype.forEach.length === 1;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var receiver = { factor: 3 }; function multiply(value) {'
      && ' return value * this.factor; }'
      && ' var mapped = [1, 2].map(multiply, receiver);'
      && ' mapped.length === 2 && mapped[0] === 3 && mapped[1] === 6'
      && ' && mapped !== receiver && Array.prototype.map.length === 1;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function double(value) { return value * 2; }'
      && ' function keep(value) { return value > 2; }'
      && ' var sparse = [, 2, , 4]; var mapped = sparse.map(double);'
      && ' var filtered = sparse.filter(keep);'
      && ' mapped.length === 4 && !Object.hasOwn(mapped, "0")'
      && ' && mapped[1] === 4 && !Object.hasOwn(mapped, "2")'
      && ' && mapped[3] === 8 && filtered.length === 1'
      && ' && filtered[0] === 4 && Array.prototype.filter.length === 1;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = {}; prototype[1] = 5;'
      && ' var object = Object.create(prototype); object.length = 3; var total = 0;'
      && ' function add(value) { total = total + value; }'
      && ' Array.prototype.forEach.call(object, add); total === 5;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var someCalls = 0; var everyCalls = 0; var receiver = { limit: 2 };'
      && ' function above(value) { someCalls++; return value > this.limit; }'
      && ' function below(value) { everyCalls++; return value < this.limit; }'
      && ' [1, 3, 5].some(above, receiver) && ![1, 3, 0].every(below, receiver)'
      && ' && someCalls === 2 && everyCalls === 2'
      && ' && Array.prototype.some.length === 1'
      && ' && Array.prototype.every.length === 1;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var calls = 0; function missing(value) {'
      && ' calls++; return value === undefined; }'
      && ' var sparse = Array(2); var someResult = sparse.some(missing);'
      && ' var someCalls = calls; calls = 0; var found = sparse.find(missing);'
      && ' var findCalls = calls; calls = 0; var index = sparse.findIndex(missing);'
      && ' !someResult && someCalls === 0 && found === undefined'
      && ' && findCalls === 1 && index === 0 && calls === 1;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function isThree(value) { return value === 3; }'
      && ' var values = [1, 3, 3]; values.find(isThree) === 3'
      && ' && values.findIndex(isThree) === 1'
      && ' && Array.prototype.find.length === 1'
      && ' && Array.prototype.findIndex.length === 1'
      && ' && Array.prototype.find.name === "find"'
      && ' && Array.prototype.findIndex.name === "findIndex";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = {}; prototype[1] = 3;'
      && ' var object = Object.create(prototype); object.length = 2;'
      && ' function isThree(value) { return value === 3; }'
      && ' Array.prototype.some.call(object, isThree)'
      && ' && Array.prototype.findIndex.call(object, isThree) === 1;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function add(accumulator, value) { return accumulator + value; }'
      && ' [1, 2, 3].reduce(add) === 6'
      && ' && [1, 2, 3].reduce(add, 10) === 16'
      && ' && [].reduce(add, 7) === 7'
      && ' && Array.prototype.reduce.length === 1'
      && ' && Array.prototype.reduce.name === "reduce";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function append(accumulator, value, index, array) {'
      && ' if (array.length !== 3) return "bad";'
      && ' return accumulator + value + index; }'
      && ' ["a", "b", "c"].reduce(append, "") === "a0b1c2"'
      && ' && ["a", "b", "c"].reduceRight(append, "") === "c2b1a0"'
      && ' && Array.prototype.reduceRight.length === 1'
      && ' && Array.prototype.reduceRight.name === "reduceRight";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var calls = 0; function add(accumulator, value) {'
      && ' calls++; return accumulator + value; }'
      && ' var sparse = [, , 3, , 5]; var value = sparse.reduce(add);'
      && ' value === 8 && calls === 1; ' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = {}; prototype[1] = 4;'
      && ' var object = Object.create(prototype); object[2] = 6; object.length = 3;'
      && ' function add(accumulator, value) { return accumulator + value; }'
      && ' Array.prototype.reduce.call(object, add, 1) === 11'
      && ' && Array.prototype.reduceRight.call(object, add) === 10;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var caught = false; function add(a, b) { return a + b; }'
      && ' try { Array(3).reduce(add); }'
      && ' catch (error) { caught = error.name === "TypeError"; } caught;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [1, 2, 3, 4]; var returned = values.fill(9, 1, -1);'
      && ' returned === values && values[0] === 1 && values[1] === 9'
      && ' && values[2] === 9 && values[3] === 4'
      && ' && Array.prototype.fill.length === 1'
      && ' && Array.prototype.fill.name === "fill";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var sparse = Array(3); sparse.fill("x", 1, undefined);'
      && ' var object = { length: "3" };'
      && ' var returned = Array.prototype.fill.call(object, 7, 1);'
      && ' sparse.length === 3 && !Object.hasOwn(sparse, "0")'
      && ' && Object.hasOwn(sparse, "1") && Object.hasOwn(sparse, "2")'
      && ' && sparse[1] === "x" && sparse[2] === "x"'
      && ' && returned === object && object[1] === 7 && object[2] === 7;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [1, 2, 3, 4, 5]; var returned = values.copyWithin(1, 3);'
      && ' var overlap = [1, 2, 3, 4, 5]; overlap.copyWithin(1, 0, 4);'
      && ' returned === values && values.join(",") === "1,4,5,4,5"'
      && ' && overlap.join(",") === "1,1,2,3,4"'
      && ' && Array.prototype.copyWithin.length === 2'
      && ' && Array.prototype.copyWithin.name === "copyWithin";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var sparse = [1, , 3, 4]; sparse.copyWithin(2, 0, 2);'
      && ' var prototype = {}; prototype[0] = "inherited";'
      && ' var object = Object.create(prototype); object.length = 2;'
      && ' var returned = Array.prototype.copyWithin.call(object, 1, 0, 1);'
      && ' sparse[2] === 1 && !Object.hasOwn(sparse, "3")'
      && ' && returned === object && Object.hasOwn(object, "1")'
      && ' && object[1] === "inherited";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var source = [1]; var result = source.concat([2, 3], 4);'
      && ' result.join(",") === "1,2,3,4" && source.join(",") === "1"'
      && ' && result !== source && Array.prototype.concat.length === 1'
      && ' && Array.prototype.concat.name === "concat";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = []; prototype[0] = "inherited";'
      && ' var source = [, 2]; Object.setPrototypeOf(source, prototype);'
      && ' var result = source.concat([3, , 5]);'
      && ' result.length === 5 && Object.hasOwn(result, "0")'
      && ' && result[0] === "inherited" && result[1] === 2 && result[2] === 3'
      && ' && !Object.hasOwn(result, "3") && result[4] === 5;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var receiver = { 0: "a", length: 1 };'
      && ' var generic = Array.prototype.concat.call(receiver, ["b"]);'
      && ' var nested = [1, 2]; nested[Symbol.isConcatSpreadable] = false;'
      && ' var nestedResult = [].concat(nested);'
      && ' generic.length === 2 && generic[0] === receiver && generic[1] === "b"'
      && ' && nestedResult.length === 1 && nestedResult[0] === nested;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = {}; prototype[0] = "inherited";'
      && ' var spread = Object.create(prototype); spread.length = 2;'
      && ' spread[1] = "own"; spread[Symbol.isConcatSpreadable] = true;'
      && ' var result = ["start"].concat(spread);'
      && ' result.length === 3 && result[0] === "start"'
      && ' && result[1] === "inherited" && result[2] === "own";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [1, 2, 3, 4]; var deleted = values.splice(1, 2, 9);'
      && ' var grown = [1, 4]; grown.splice(1, 0, 2, 3);'
      && ' values.join(",") === "1,9,4" && deleted.join(",") === "2,3"'
      && ' && grown.join(",") === "1,2,3,4"'
      && ' && Array.prototype.splice.length === 2'
      && ' && Array.prototype.splice.name === "splice";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var untouched = [1, 2]; var none = untouched.splice();'
      && ' var explicit = [1, 2]; var explicitNone = explicit.splice(1, undefined);'
      && ' var tail = [1, 2, 3]; var removed = tail.splice(1);'
      && ' none.length === 0 && untouched.join(",") === "1,2"'
      && ' && explicitNone.length === 0 && explicit.join(",") === "1,2"'
      && ' && removed.join(",") === "2,3" && tail.join(",") === "1";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var sparse = [, 1, , 3]; var deleted = sparse.splice(1, 2);'
      && ' sparse.length === 2 && !Object.hasOwn(sparse, "0")'
      && ' && sparse[1] === 3 && deleted.length === 2'
      && ' && deleted[0] === 1 && !Object.hasOwn(deleted, "1");' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = {}; prototype[1] = "inherited";'
      && ' var object = Object.create(prototype); object[0] = "head";'
      && ' object[3] = "tail"; object.length = "4";'
      && ' var deleted = Array.prototype.splice.call(object, 1, 2, "inserted");'
      && ' object.length === 3 && object[0] === "head"'
      && ' && object[1] === "inserted" && object[2] === "tail"'
      && ' && !Object.hasOwn(object, "3") && deleted.length === 2'
      && ' && deleted[0] === "inherited" && !Object.hasOwn(deleted, "1");' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [0, 1, 2]; var deleted = values.splice(-2, -1, 9);'
      && ' deleted.length === 0 && values.join(",") === "0,9,1,2";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [10, 2, 1]; var returned = values.sort();'
      && ' function numeric(left, right) { return left - right; }'
      && ' var numbers = [10, 2, 1]; numbers.sort(numeric);'
      && ' returned === values && values.join(",") === "1,10,2"'
      && ' && numbers.join(",") === "1,2,10"'
      && ' && Array.prototype.sort.length === 1'
      && ' && Array.prototype.sort.name === "sort";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function byKey(left, right) { return left.key - right.key; }'
      && ' var values = [{ key: 1, id: "a" }, { key: 0, id: "b" },'
      && ' { key: 1, id: "c" }]; values.sort(byKey);'
      && ' values[0].id === "b" && values[1].id === "a"'
      && ' && values[2].id === "c";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [undefined, 3, , 1]; values.sort();'
      && ' values.length === 4 && values[0] === 1 && values[1] === 3'
      && ' && Object.hasOwn(values, "2") && values[2] === undefined'
      && ' && !Object.hasOwn(values, "3");' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = {}; prototype[1] = "b";'
      && ' var object = Object.create(prototype); object[0] = "c";'
      && ' object[2] = "a"; object.length = 4;'
      && ' var returned = Array.prototype.sort.call(object);'
      && ' returned === object && object.length === 4'
      && ' && object[0] === "a" && object[1] === "b" && object[2] === "c"'
      && ' && Object.hasOwn(object, "1") && !Object.hasOwn(object, "3");' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var stable = [3, 2, 1]; function equal() { return NaN; } stable.sort(equal);'
      && ' var caught = false; try { stable.sort(1); }'
      && ' catch (error) { caught = error.name === "TypeError"; }'
      && ' stable.join(",") === "3,2,1" && caught;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var order = ""; var receiver = { target: 2 };'
      && ' function match(value, index, array) {'
      && ' order = order + index; return value === this.target && array.length === 4; }'
      && ' var values = [1, 2, 3, 2]; var found = values.findLast(match, receiver);'
      && ' found === 2 && order === "3"'
      && ' && values.findLastIndex(match, receiver) === 3'
      && ' && Array.prototype.findLast.length === 1'
      && ' && Array.prototype.findLastIndex.length === 1'
      && ' && Array.prototype.findLast.name === "findLast"'
      && ' && Array.prototype.findLastIndex.name === "findLastIndex";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var calls = 0; function missing(value) { calls++; return value === undefined; }'
      && ' var sparse = Array(3); var found = sparse.findLast(missing);'
      && ' var findCalls = calls; calls = 0;'
      && ' var index = sparse.findLastIndex(missing);'
      && ' found === undefined && findCalls === 1 && index === 2 && calls === 1;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = {}; prototype[2] = 7;'
      && ' var object = Object.create(prototype); object.length = 3;'
      && ' function isSeven(value, index, array) {'
      && ' return value === 7 && index === 2 && array === object; }'
      && ' Array.prototype.findLast.call(object, isSeven) === 7'
      && ' && Array.prototype.findLastIndex.call(object, isSeven) === 2;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var nested = [1, [2, [3]], 4]; var once = nested.flat();'
      && ' var twice = nested.flat(2); var defaulted = nested.flat(undefined);'
      && ' once.length === 4 && once[0] === 1 && once[1] === 2'
      && ' && Array.isArray(once[2]) && once[2][0] === 3 && once[3] === 4'
      && ' && twice.join(",") === "1,2,3,4"'
      && ' && defaulted.length === once.length'
      && ' && Array.prototype.flat.length === 0'
      && ' && Array.prototype.flat.name === "flat";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var inner = [1]; var sparse = [, inner, 2]; var copied = sparse.flat(0);'
      && ' var deep = [1, [2, [3]]].flat(Infinity);'
      && ' copied.length === 2 && copied[0] === inner && copied[1] === 2'
      && ' && deep.join(",") === "1,2,3";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = {}; prototype[0] = [1, 2];'
      && ' var object = Object.create(prototype); object[1] = 3; object.length = 2;'
      && ' Array.prototype.flat.call(object).join(",") === "1,2,3";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var sparse = [, 2]; var receiver = { factor: 3 }; var calls = 0;'
      && ' function expand(value, index, array) { calls++;'
      && ' if (array !== sparse) return []; return [value * this.factor, index]; }'
      && ' var mapped = sparse.flatMap(expand, receiver);'
      && ' var nested = [1].flatMap(function(value) { return [[value]]; });'
      && ' mapped.join(",") === "6,1" && calls === 1'
      && ' && nested.length === 1 && Array.isArray(nested[0])'
      && ' && nested[0][0] === 1 && Array.prototype.flatMap.length === 1'
      && ' && Array.prototype.flatMap.name === "flatMap";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var caught = false; try { [1].flatMap(1); }'
      && ' catch (error) { caught = error.name === "TypeError"; } caught;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = Array.of(1, undefined, 3); var empty = Array.of();'
      && ' Array.isArray(values) && values.length === 3 && values[0] === 1'
      && ' && Object.hasOwn(values, "1") && values[1] === undefined'
      && ' && values[2] === 3 && Array.isArray(empty) && empty.length === 0'
      && ' && Array.of.length === 0 && Array.of.name === "of";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function Collection(length) { this.constructedLength = length; }'
      && ' var result = Array.of.call(Collection, "a", "b");'
      && ' result instanceof Collection && result.constructedLength === 2'
      && ' && result.length === 2 && result[0] === "a" && result[1] === "b";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'function Collection(length) { this.constructedLength = length; }'
      && ' var Bound = Collection.bind(null);'
      && ' var boundResult = Array.of.call(Bound, 4, 5);'
      && ' var receiver = {}; var fallback = Array.of.call(receiver, 6, 7);'
      && ' boundResult instanceof Collection && boundResult.constructedLength === 2'
      && ' && boundResult.length === 2 && boundResult[0] === 4'
      && ' && Array.isArray(fallback) && fallback.length === 2'
      && ' && fallback[0] === 6 && fallback[1] === 7;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [1, 2, 3]; values.toString() === "1,2,3"'
      && ' && Array.prototype.toString.length === 0'
      && ' && Array.prototype.toString.name === "toString"'
      && ' && Array.prototype.toString.call({ length: 0, join: function() {'
      && ' if (this.length === 0) return "generic"; return "bad";'
      && ' } }) === "generic";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [1, 2]; values.join = function() {'
      && ' if (this === values) return "custom"; return "bad"; };'
      && ' var fallback = [1, 2]; fallback.join = 1;'
      && ' values.toString() === "custom"'
      && ' && fallback.toString() === "[object Array]";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var calls = 0; var values = [];'
      && ' Object.defineProperty(values, "join", { get: function() {'
      && ' calls++; return function() { return "dynamic"; }; } });'
      && ' values.toString() === "dynamic" && calls === 1;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [1, 2, 3]; var reversed = values.toReversed();'
      && ' reversed.join(",") === "3,2,1" && values.join(",") === "1,2,3"'
      && ' && reversed !== values && Array.prototype.toReversed.length === 0'
      && ' && Array.prototype.toReversed.name === "toReversed";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var sparse = Array(3); sparse[1] = 1; var reversed = sparse.toReversed();'
      && ' reversed.length === 3 && Object.hasOwn(reversed, "0")'
      && ' && Object.hasOwn(reversed, "1") && Object.hasOwn(reversed, "2")'
      && ' && reversed[0] === undefined && reversed[1] === 1'
      && ' && reversed[2] === undefined;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = {}; prototype[0] = "a";'
      && ' var object = Object.create(prototype); object[2] = "c"; object.length = 3;'
      && ' var reversed = Array.prototype.toReversed.call(object);'
      && ' reversed.length === 3 && reversed[0] === "c"'
      && ' && reversed[1] === undefined && reversed[2] === "a"'
      && ' && Object.hasOwn(reversed, "1");' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [1, 2, 3]; var changed = values.with(-1, 9);'
      && ' var fractional = values.with(1.9, 8);'
      && ' changed.join(",") === "1,2,9" && values.join(",") === "1,2,3"'
      && ' && fractional.join(",") === "1,8,3" && changed !== values'
      && ' && Array.prototype.with.length === 2'
      && ' && Array.prototype.with.name === "with";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      '[0, 4, 16].with("1", 3).join(",") === "0,3,16";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      '[0, 4, 16].with("-1", 5).join(",") === "0,4,5";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      '[0, 4, 16].with(NaN, 2).join(",") === "2,4,16";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      '[0, 4, 16].with("dog", "cat").join(",") === "cat,4,16";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = {}; prototype[0] = "inherited";'
      && ' var object = Object.create(prototype); object.length = 2;'
      && ' var changed = Array.prototype.with.call(object, 1, "new");'
      && ' changed.length === 2 && changed[0] === "inherited"'
      && ' && changed[1] === "new" && Object.hasOwn(changed, "0")'
      && ' && Object.hasOwn(changed, "1");' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var caughtHigh = false; var caughtLow = false; var caughtInfinity = false;'
      && ' try { [1, 2, 3].with(3, 0); } catch (error) {'
      && ' caughtHigh = error.name === "RangeError"; }'
      && ' try { [1, 2, 3].with(-4, 0); } catch (error) {'
      && ' caughtLow = error.name === "RangeError"; }'
      && ' try { [1, 2, 3].with(Infinity, 0); } catch (error) {'
      && ' caughtInfinity = error.name === "RangeError"; }'
      && ' caughtHigh && caughtLow && caughtInfinity;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [3, 1, 2]; var sorted = values.toSorted();'
      && ' var descending = values.toSorted(function(a, b) { return b - a; });'
      && ' sorted.join(",") === "1,2,3" && descending.join(",") === "3,2,1"'
      && ' && values.join(",") === "3,1,2" && sorted !== values'
      && ' && Array.prototype.toSorted.length === 1'
      && ' && Array.prototype.toSorted.name === "toSorted";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = { inherited: 1 }; var object = Object.create(prototype);'
      && ' var key = Symbol("key"); object.own = 2; object[key] = 3;'
      && ' object.hasOwnProperty("own") && !object.hasOwnProperty("inherited")'
      && ' && object.hasOwnProperty(key)'
      && ' && Object.prototype.hasOwnProperty.length === 1'
      && ' && Object.prototype.hasOwnProperty.name === "hasOwnProperty";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = {}; prototype[1] = "a";'
      && ' var object = Object.create(prototype); object[2] = "b"; object.length = 4;'
      && ' var sorted = Array.prototype.toSorted.call(object);'
      && ' sorted.length === 4 && sorted[0] === "a" && sorted[1] === "b"'
      && ' && sorted[2] === undefined && sorted[3] === undefined'
      && ' && Object.hasOwn(sorted, "2") && Object.hasOwn(sorted, "3");' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var values = [1, 2, 3, 4]; var changed = values.toSpliced(1, 2, "a", "b");'
      && ' changed.join(",") === "1,a,b,4" && values.join(",") === "1,2,3,4"'
      && ' && changed !== values && Array.prototype.toSpliced.length === 2'
      && ' && Array.prototype.toSpliced.name === "toSpliced"'
      && ' && values.toSpliced().join(",") === "1,2,3,4"'
      && ' && values.toSpliced(2).join(",") === "1,2";' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).

    ls_result = zcl_qjs=>eval(
      'var prototype = {}; prototype[0] = "inherited";'
      && ' var object = Object.create(prototype); object[2] = "tail"; object.length = 3;'
      && ' var changed = Array.prototype.toSpliced.call(object, 1, 1, "new");'
      && ' changed.length === 3 && changed[0] === "inherited"'
      && ' && changed[1] === "new" && changed[2] === "tail"'
      && ' && Object.hasOwn(changed, "0") && object[1] === undefined;' ).
    cl_abap_unit_assert=>assert_true( ls_result-bool_value ).
  ENDMETHOD.
ENDCLASS.
