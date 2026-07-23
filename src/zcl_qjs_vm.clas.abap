CLASS zcl_qjs_vm DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES ty_cells TYPE STANDARD TABLE OF REF TO zcl_qjs_cell WITH DEFAULT KEY.
    METHODS constructor
      IMPORTING
        limits TYPE REF TO zcl_qjs_limits OPTIONAL
        runtime TYPE REF TO zcl_qjs_runtime OPTIONAL
      RAISING
        zcx_qjs_error.

    METHODS execute
      IMPORTING
        function      TYPE REF TO zcl_qjs_function
        initial_cells TYPE ty_cells OPTIONAL
        initial_closure TYPE REF TO zcl_qjs_closure OPTIONAL
        initial_this TYPE zcl_qjs_value=>ty_value OPTIONAL
        initial_arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
        initial_constructor TYPE abap_bool DEFAULT abap_false
        resume TYPE abap_bool DEFAULT abap_false
        resume_kind TYPE i DEFAULT 0
        resume_value TYPE zcl_qjs_value=>ty_value OPTIONAL
      RETURNING
        VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING
        zcx_qjs_error.
    METHODS was_suspended RETURNING VALUE(result) TYPE abap_bool.
    METHODS was_await_suspended RETURNING VALUE(result) TYPE abap_bool.
    METHODS was_async_yield_star_suspended RETURNING VALUE(result) TYPE abap_bool.
    METHODS is_complete RETURNING VALUE(result) TYPE abap_bool.

  PRIVATE SECTION.
    TYPES ty_stack TYPE STANDARD TABLE OF zcl_qjs_value=>ty_value WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_handler,
      target TYPE i,
      finally_target TYPE i,
      stack_depth TYPE i,
    END OF ty_handler.
    TYPES ty_handlers TYPE STANDARD TABLE OF ty_handler WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_frame,
        function TYPE REF TO zcl_qjs_function,
        pc       TYPE i,
        locals   TYPE ty_cells,
        captures TYPE zcl_qjs_closure=>ty_cells,
        arguments TYPE zif_qjs_callable=>ty_arguments,
        handlers TYPE ty_handlers,
        stack_base TYPE i,
        subroutine_returns TYPE STANDARD TABLE OF i WITH DEFAULT KEY,
        is_constructor TYPE abap_bool,
        constructor_this TYPE zcl_qjs_value=>ty_value,
        closure TYPE REF TO zcl_qjs_closure,
        after_return_fields TYPE REF TO zcl_qjs_closure,
        after_return_receiver TYPE zcl_qjs_value=>ty_value,
        abrupt_return_pending TYPE abap_bool,
        abrupt_return_value TYPE zcl_qjs_value=>ty_value,
        abrupt_throw_pending TYPE abap_bool,
        abrupt_throw_value TYPE zcl_qjs_value=>ty_value,
      END OF ty_frame.
    TYPES ty_frames TYPE STANDARD TABLE OF ty_frame WITH DEFAULT KEY.

    DATA mo_limits TYPE REF TO zcl_qjs_limits.
    DATA mo_runtime TYPE REF TO zcl_qjs_runtime.
    DATA mt_saved_stack TYPE ty_stack.
    DATA mt_saved_frames TYPE ty_frames.
    DATA mv_generator_suspended TYPE abap_bool.
    DATA mv_generator_complete TYPE abap_bool.
    DATA mv_generator_delegating TYPE abap_bool.
    DATA mv_await_suspended TYPE abap_bool.
    DATA mv_async_yield_star TYPE abap_bool.

    METHODS pop
      CHANGING
        stack         TYPE ty_stack
      RETURNING
        VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING
        zcx_qjs_error.
    METHODS throw_error IMPORTING name TYPE string message TYPE string.
ENDCLASS.

CLASS zcl_qjs_vm IMPLEMENTATION.
  METHOD throw_error.
    DATA ls_error TYPE zcl_qjs_value=>ty_value.
    IF mo_runtime IS BOUND.
      TRY.
          ls_error = mo_runtime->create_error( name = name message = message ).
        CATCH zcx_qjs_error.
      ENDTRY.
    ENDIF.
    IF ls_error-tag = 0.
      DATA lv_separator TYPE string VALUE ': '.
      ls_error = zcl_qjs_value=>new_string( name && lv_separator && message ).
    ENDIF.
    RAISE EXCEPTION TYPE zcx_qjs_throw EXPORTING value = ls_error.
  ENDMETHOD.

  METHOD constructor.
    IF runtime IS BOUND.
      mo_runtime = runtime.
    ELSE.
      CREATE OBJECT mo_runtime.
    ENDIF.
    IF limits IS BOUND.
      mo_limits = limits.
    ELSE.
      mo_limits = mo_runtime->get_limits( ).
    ENDIF.
  ENDMETHOD.

  METHOD pop.
    DATA lv_index TYPE i.
    lv_index = lines( stack ).
    IF lv_index = 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING
          reason = 'JavaScript operand stack underflow'.
    ENDIF.
    READ TABLE stack INDEX lv_index INTO result.
    DELETE stack INDEX lv_index.
  ENDMETHOD.

  METHOD execute.
    DATA lt_stack TYPE ty_stack.
    DATA lt_frames TYPE ty_frames.
    DATA ls_frame TYPE ty_frame.
    DATA ls_instruction TYPE zcl_qjs_function=>ty_instruction.
    DATA ls_left TYPE zcl_qjs_value=>ty_value.
    DATA ls_right TYPE zcl_qjs_value=>ty_value.
    DATA ls_value TYPE zcl_qjs_value=>ty_value.
    DATA lv_frame_index TYPE i.
    DATA lo_called TYPE REF TO zcl_qjs_function.
    DATA lt_arguments TYPE ty_stack.
    DATA lv_argument_index TYPE i.
    DATA lv_local_index TYPE i.
    DATA ls_called_frame TYPE ty_frame.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    DATA lv_atom TYPE string.
    DATA ls_handler TYPE ty_handler.
    DATA lv_handler_index TYPE i.
    DATA lo_throw TYPE REF TO zcx_qjs_throw.
    DATA lv_handled TYPE abap_bool.
    DATA lo_cell TYPE REF TO zcl_qjs_cell.
    DATA lo_closure TYPE REF TO zcl_qjs_closure.
    DATA lt_capture_cells TYPE zcl_qjs_closure=>ty_cells.
    DATA lt_capture_descriptors TYPE zcl_qjs_function=>ty_captures.
    DATA ls_capture_descriptor TYPE zcl_qjs_function=>ty_capture.
    DATA ls_local_spec TYPE zcl_qjs_function=>ty_local_spec.
    DATA lv_element_index TYPE int8.
    DATA lv_property_name TYPE string.
    DATA lo_host_callable TYPE REF TO zif_qjs_callable.
    DATA lo_host_constructor TYPE REF TO zif_qjs_constructable.
    DATA lo_host_error TYPE REF TO zcx_qjs_error.
    DATA ls_this TYPE zcl_qjs_value=>ty_value.
    DATA lo_properties TYPE REF TO zcl_qjs_object.
    DATA lo_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_current_prototype TYPE REF TO zcl_qjs_object.
    DATA lo_property_container TYPE REF TO zif_qjs_property_container.
    DATA lo_for_in_iterator TYPE REF TO zcl_qjs_for_in_iterator.
    DATA ls_for_in_next TYPE zcl_qjs_for_in_iterator=>ty_next.
    DATA ls_for_of_next TYPE zcl_qjs_runtime=>ty_iterator_result.
    DATA ls_iterator_resume TYPE zcl_qjs_runtime=>ty_iterator_resume_result.
    DATA lo_native_function TYPE REF TO zcl_qjs_native_function.
    DATA lt_copy_names TYPE zcl_qjs_shape=>ty_names.
    DATA lt_copy_symbols TYPE zcl_qjs_object=>ty_symbol_ids.
    DATA lv_copy_name TYPE string.
    DATA lv_copy_symbol TYPE int8.
    DATA lo_copy_source TYPE REF TO zcl_qjs_object.
    DATA lo_copy_target TYPE REF TO zcl_qjs_object.
    DATA lo_copy_exclude TYPE REF TO zcl_qjs_object.
    DATA ls_copy_property TYPE zcl_qjs_object=>ty_own_property.
    DATA ls_field_key TYPE zcl_qjs_value=>ty_value.
    DATA lv_private_method_added TYPE abap_bool.
    DATA lv_injected_throw TYPE abap_bool.
    DATA lt_resume_finally_targets TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    DATA lv_resume_finally_index TYPE i.

    IF resume = abap_true.
      IF mv_generator_suspended = abap_false.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Generator is not suspended'.
      ENDIF.
      lt_stack = mt_saved_stack.
      lt_frames = mt_saved_frames.
      CLEAR mt_saved_stack.
      CLEAR mt_saved_frames.
      CLEAR mv_generator_suspended.
      CLEAR mv_await_suspended.
      CLEAR mv_async_yield_star.
      IF mv_generator_delegating = abap_true.
        APPEND resume_value TO lt_stack.
        APPEND zcl_qjs_value=>new_int( resume_kind ) TO lt_stack.
        mo_limits->check_operand_stack( lines( lt_stack ) ).
      ELSEIF resume_kind = 1.
        lv_frame_index = lines( lt_frames ).
        READ TABLE lt_frames INDEX lv_frame_index INTO ls_frame.
        WHILE lines( lt_stack ) > ls_frame-stack_base.
          DELETE lt_stack INDEX lines( lt_stack ).
        ENDWHILE.
        APPEND resume_value TO lt_stack.
        CLEAR ls_frame-subroutine_returns.
        CLEAR lt_resume_finally_targets.
        LOOP AT ls_frame-handlers INTO ls_handler.
          IF ls_handler-finally_target > 0.
            APPEND ls_handler-finally_target TO lt_resume_finally_targets.
          ENDIF.
        ENDLOOP.
        CLEAR ls_frame-handlers.
        lv_resume_finally_index = lines( lt_resume_finally_targets ).
        IF lv_resume_finally_index = 0.
          mv_generator_complete = abap_true.
          result = resume_value.
          RETURN.
        ENDIF.
        ls_frame-abrupt_return_pending = abap_true.
        ls_frame-abrupt_return_value = resume_value.
        READ TABLE lt_resume_finally_targets INDEX lv_resume_finally_index
          INTO ls_frame-pc.
        DO lv_resume_finally_index - 1 TIMES.
          READ TABLE lt_resume_finally_targets INDEX sy-index
            INTO DATA(lv_resume_finally_target).
          APPEND lv_resume_finally_target TO ls_frame-subroutine_returns.
        ENDDO.
        MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.
      ELSEIF resume_kind = 2.
        lv_injected_throw = abap_true.
      ELSE.
        APPEND resume_value TO lt_stack.
        mo_limits->check_operand_stack( lines( lt_stack ) ).
      ENDIF.
    ELSE.
    IF function IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING
          reason = 'Cannot execute an initial bytecode function'.
    ENDIF.
    ls_frame-function = function.
    ls_frame-arguments = initial_arguments.
    ls_frame-pc = 1.
    ls_frame-stack_base = 0.
    ls_frame-is_constructor = initial_constructor.
    IF initial_constructor = abap_true.
      ls_frame-constructor_this = initial_this.
    ENDIF.
    DO function->get_local_count( ) TIMES.
      READ TABLE initial_cells INDEX sy-index INTO lo_cell.
      IF sy-subrc <> 0.
        ls_value = zcl_qjs_value=>new_undefined( ).
        ls_local_spec = function->get_local_spec( sy-index - 1 ).
        CREATE OBJECT lo_cell
          EXPORTING value = ls_value initialized = ls_local_spec-initialized
            mutable = ls_local_spec-mutable runtime = mo_runtime.
      ENDIF.
      APPEND lo_cell TO ls_frame-locals.
    ENDDO.
    IF initial_closure IS BOUND.
      ls_frame-captures = initial_closure->get_captures( ).
      ls_frame-closure = initial_closure.
    ENDIF.
    lv_local_index = 1.
    IF function->has_self_binding( ) = abap_true.
      IF initial_closure IS BOUND.
        ls_value = zcl_qjs_value=>new_object( initial_closure ).
      ELSE.
        ls_value = zcl_qjs_value=>new_object( function ).
      ENDIF.
      READ TABLE ls_frame-locals INDEX lv_local_index INTO lo_cell.
      lo_cell->set( ls_value ).
      lv_local_index = lv_local_index + 1.
    ENDIF.
    IF function->has_this_binding( ) = abap_true.
      ls_value = initial_this.
      IF ls_value-tag = 0.
        ls_value = zcl_qjs_value=>new_undefined( ).
      ENDIF.
      READ TABLE ls_frame-locals INDEX lv_local_index INTO lo_cell.
      lo_cell->set( ls_value ).
      lv_local_index = lv_local_index + 1.
    ENDIF.
    IF function->has_arguments_binding( ) = abap_true.
      lo_object = mo_runtime->create_array( ).
      lv_element_index = 0.
      LOOP AT initial_arguments INTO ls_value.
        lo_object->set_element( index = lv_element_index value = ls_value ).
        lv_element_index = lv_element_index + 1.
      ENDLOOP.
      ls_value = zcl_qjs_value=>new_object( lo_object ).
      READ TABLE ls_frame-locals INDEX lv_local_index INTO lo_cell.
      lo_cell->set( ls_value ).
      lv_local_index = lv_local_index + 1.
    ENDIF.
    lv_argument_index = 1.
    WHILE lv_argument_index <= function->get_parameter_count( ).
      READ TABLE initial_arguments INDEX lv_argument_index INTO ls_value.
      IF sy-subrc <> 0.
        ls_value = zcl_qjs_value=>new_undefined( ).
      ENDIF.
      READ TABLE ls_frame-locals INDEX lv_local_index INTO lo_cell.
      lo_cell->set( ls_value ).
      lv_argument_index = lv_argument_index + 1.
      lv_local_index = lv_local_index + 1.
    ENDWHILE.
    APPEND ls_frame TO lt_frames.
    mo_limits->check_frame_stack( lines( lt_frames ) ).
    ENDIF.

    WHILE lines( lt_frames ) > 0.
      mo_limits->consume( ).
      lv_frame_index = lines( lt_frames ).
      READ TABLE lt_frames INDEX lv_frame_index INTO ls_frame.
      ls_instruction = ls_frame-function->get_instruction( ls_frame-pc ).
      ls_frame-pc = ls_frame-pc + 1.
      MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.

      TRY.
        IF lv_injected_throw = abap_true.
          RAISE EXCEPTION TYPE zcx_qjs_throw
            EXPORTING value = resume_value.
        ENDIF.
        CASE ls_instruction-opcode.
        WHEN zif_qjs_opcodes=>drop.
          pop( CHANGING stack = lt_stack ).
        WHEN zif_qjs_opcodes=>duplicate.
          ls_value = pop( CHANGING stack = lt_stack ).
          APPEND ls_value TO lt_stack.
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>duplicate_two.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          APPEND ls_left TO lt_stack.
          APPEND ls_right TO lt_stack.
          APPEND ls_left TO lt_stack.
          APPEND ls_right TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>swap.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          APPEND ls_right TO lt_stack.
          APPEND ls_left TO lt_stack.
        WHEN zif_qjs_opcodes=>insert_two.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          APPEND ls_right TO lt_stack.
          APPEND ls_left TO lt_stack.
          APPEND ls_right TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>insert_three.
          ls_value = pop( CHANGING stack = lt_stack ).
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          APPEND ls_value TO lt_stack.
          APPEND ls_left TO lt_stack.
          APPEND ls_right TO lt_stack.
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>permute_three.
          ls_value = pop( CHANGING stack = lt_stack ).
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          APPEND ls_right TO lt_stack.
          APPEND ls_left TO lt_stack.
          APPEND ls_value TO lt_stack.
        WHEN zif_qjs_opcodes=>permute_four.
          ls_value = pop( CHANGING stack = lt_stack ).
          DATA(ls_update_value) = pop( CHANGING stack = lt_stack ).
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          APPEND ls_update_value TO lt_stack.
          APPEND ls_left TO lt_stack.
          APPEND ls_right TO lt_stack.
          APPEND ls_value TO lt_stack.
        WHEN zif_qjs_opcodes=>new_object.
          lo_object = mo_runtime->create_object( ).
          ls_value = zcl_qjs_value=>new_object( lo_object ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>regexp.
          DATA(ls_regexp_flags) = pop( CHANGING stack = lt_stack ).
          DATA(ls_regexp_pattern) = pop( CHANGING stack = lt_stack ).
          DATA(lo_regexp) = mo_runtime->create_regexp(
            pattern = mo_runtime->to_string( ls_regexp_pattern )
            flags   = mo_runtime->to_string( ls_regexp_flags ) ).
          APPEND zcl_qjs_value=>new_object( lo_regexp ) TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>new_array.
          CLEAR lt_arguments.
          DO ls_instruction-operand TIMES.
            ls_value = pop( CHANGING stack = lt_stack ).
            INSERT ls_value INTO lt_arguments INDEX 1.
          ENDDO.
          lo_object = mo_runtime->create_array( ).
          lv_element_index = 0.
          LOOP AT lt_arguments INTO ls_value.
            lo_object->set_element( index = lv_element_index value = ls_value ).
            lv_element_index = lv_element_index + 1.
          ENDLOOP.
          ls_value = zcl_qjs_value=>new_object( lo_object ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>rest.
          lo_object = mo_runtime->create_array( ).
          lv_element_index = 0.
          lv_argument_index = ls_instruction-operand + 1.
          WHILE lv_argument_index <= lines( ls_frame-arguments ).
            READ TABLE ls_frame-arguments INDEX lv_argument_index INTO ls_value.
            lo_object->set_element( index = lv_element_index value = ls_value ).
            lv_argument_index = lv_argument_index + 1.
            lv_element_index = lv_element_index + 1.
          ENDWHILE.
          APPEND zcl_qjs_value=>new_object( lo_object ) TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>append.
          DATA(ls_append_source) = pop( CHANGING stack = lt_stack ).
          DATA(ls_append_position) = pop( CHANGING stack = lt_stack ).
          DATA(ls_append_target) = pop( CHANGING stack = lt_stack ).
          CLEAR lo_object.
          TRY.
              lo_object ?= ls_append_target-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_object IS NOT BOUND OR lo_object->is_array( ) = abap_false.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Spread append target is not an array'.
          ENDIF.
          lv_element_index = ls_append_position-int_value.
          DATA(ls_append_iterator) = mo_runtime->get_iterator( ls_append_source ).
          WHILE abap_true = abap_true.
            ls_for_of_next = mo_runtime->iterator_next( ls_append_iterator ).
            IF ls_for_of_next-done = abap_true.
              EXIT.
            ENDIF.
            lo_object->set_element(
              index = lv_element_index value = ls_for_of_next-value ).
            lv_element_index = lv_element_index + 1.
          ENDWHILE.
          APPEND ls_append_target TO lt_stack.
          APPEND zcl_qjs_value=>new_int( CONV i( lv_element_index ) ) TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>copy_data_properties.
          DATA(ls_copy_exclude_value) = pop( CHANGING stack = lt_stack ).
          DATA(ls_copy_source_value) = pop( CHANGING stack = lt_stack ).
          DATA(ls_copy_target_value) = pop( CHANGING stack = lt_stack ).
          CLEAR: lo_copy_source, lo_copy_target, lo_copy_exclude, lo_closure.
          TRY.
              lo_copy_target ?= ls_copy_target_value-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_copy_target IS NOT BOUND.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Object spread target is not an object'.
          ENDIF.
          IF ls_copy_exclude_value-tag = zcl_qjs_value=>tag_object.
            TRY.
                lo_copy_exclude ?= ls_copy_exclude_value-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
          ENDIF.
          IF ls_copy_source_value-tag = zcl_qjs_value=>tag_object.
            TRY.
                lo_copy_source ?= ls_copy_source_value-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
            IF lo_copy_source IS NOT BOUND.
              TRY.
                  lo_closure ?= ls_copy_source_value-object_ref.
                CATCH cx_sy_move_cast_error.
              ENDTRY.
              IF lo_closure IS BOUND.
                lo_copy_source = lo_closure->get_property_storage( ).
              ENDIF.
            ENDIF.
          ENDIF.
          IF lo_copy_source IS BOUND.
            lt_copy_names = lo_copy_source->own_keys( ).
            LOOP AT lt_copy_names INTO lv_copy_name.
              IF lo_copy_exclude IS BOUND
                  AND lo_copy_exclude->has_own( lv_copy_name ) = abap_true.
                CONTINUE.
              ENDIF.
              lo_copy_target->define_property(
                name = lv_copy_name value = lo_copy_source->get( lv_copy_name ) ).
            ENDLOOP.
            lt_copy_symbols = lo_copy_source->own_property_symbols( ).
            LOOP AT lt_copy_symbols INTO lv_copy_symbol.
              ls_copy_property = lo_copy_source->get_own_symbol_property(
                lv_copy_symbol ).
              IF ls_copy_property-enumerable = abap_false
                  OR ( lo_copy_exclude IS BOUND
                    AND lo_copy_exclude->has_own_symbol(
                      lv_copy_symbol ) = abap_true ).
                CONTINUE.
              ENDIF.
              lo_copy_target->define_symbol_property(
                identity = lv_copy_symbol
                value    = lo_copy_source->get_symbol( lv_copy_symbol ) ).
            ENDLOOP.
          ELSEIF ls_copy_source_value-tag = zcl_qjs_value=>tag_string.
            lv_element_index = 0.
            WHILE lv_element_index < ls_copy_source_value-string_ref->length( ).
              lv_copy_name = lv_element_index.
              CONDENSE lv_copy_name NO-GAPS.
              IF lo_copy_exclude IS NOT BOUND
                  OR lo_copy_exclude->has_own( lv_copy_name ) = abap_false.
                lo_copy_target->define_property(
                  name  = lv_copy_name
                  value = zcl_qjs_value=>new_string(
                    ls_copy_source_value-string_ref->code_unit_at(
                      CONV i( lv_element_index ) ) ) ).
              ENDIF.
              lv_element_index = lv_element_index + 1.
            ENDWHILE.
          ENDIF.
          APPEND ls_copy_target_value TO lt_stack.
          APPEND ls_copy_source_value TO lt_stack.
          APPEND ls_copy_exclude_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>for_in_start.
          ls_value = pop( CHANGING stack = lt_stack ).
          CREATE OBJECT lo_for_in_iterator EXPORTING source = ls_value.
          ls_value = zcl_qjs_value=>new_object( lo_for_in_iterator ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>for_in_next.
          ls_value = pop( CHANGING stack = lt_stack ).
          CLEAR lo_for_in_iterator.
          TRY.
              lo_for_in_iterator ?= ls_value-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_for_in_iterator IS BOUND.
            ls_for_in_next = lo_for_in_iterator->next( ).
          ELSE.
            ls_for_in_next-done = abap_true.
            ls_for_in_next-value = zcl_qjs_value=>new_undefined( ).
          ENDIF.
          APPEND ls_value TO lt_stack.
          APPEND ls_for_in_next-value TO lt_stack.
          APPEND zcl_qjs_value=>new_boolean( ls_for_in_next-done ) TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>for_of_start.
          ls_value = pop( CHANGING stack = lt_stack ).
          ls_value = mo_runtime->get_iterator( ls_value ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>for_await_of_start.
          ls_value = pop( CHANGING stack = lt_stack ).
          ls_value = mo_runtime->get_async_iterator( ls_value ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>for_of_next.
          ls_value = pop( CHANGING stack = lt_stack ).
          ls_for_of_next = mo_runtime->iterator_next( ls_value ).
          APPEND ls_value TO lt_stack.
          APPEND ls_for_of_next-value TO lt_stack.
          APPEND zcl_qjs_value=>new_boolean( ls_for_of_next-done ) TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>for_await_of_next.
          ls_value = pop( CHANGING stack = lt_stack ).
          DATA(ls_async_iterator) = ls_value.
          ls_value = mo_runtime->iterator_next_value( ls_async_iterator ).
          APPEND ls_async_iterator TO lt_stack.
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>iterator_get_value_done.
          ls_value = pop( CHANGING stack = lt_stack ).
          ls_for_of_next = mo_runtime->iterator_result( ls_value ).
          APPEND ls_for_of_next-value TO lt_stack.
          APPEND zcl_qjs_value=>new_boolean( ls_for_of_next-done ) TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>iterator_call.
          ls_value = pop( CHANGING stack = lt_stack ).
          ls_value = mo_runtime->iterator_close_value( ls_value ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>iterator_check_object.
          ls_value = pop( CHANGING stack = lt_stack ).
          IF ls_value-tag <> zcl_qjs_value=>tag_object.
            throw_error(
              name = 'TypeError' message = 'iterator result is not an object' ).
          ENDIF.
          APPEND ls_value TO lt_stack.
        WHEN zif_qjs_opcodes=>iterator_close.
          ls_value = pop( CHANGING stack = lt_stack ).
          mo_runtime->iterator_close( ls_value ).
        WHEN zif_qjs_opcodes=>to_object.
          ls_value = pop( CHANGING stack = lt_stack ).
          IF ls_value-tag = zcl_qjs_value=>tag_null
              OR ls_value-tag = zcl_qjs_value=>tag_undefined.
            throw_error(
              name = 'TypeError' message = 'cannot destructure null or undefined' ).
          ENDIF.
          APPEND ls_value TO lt_stack.
        WHEN zif_qjs_opcodes=>get_field OR zif_qjs_opcodes=>get_field_for_call.
          ls_value = pop( CHANGING stack = lt_stack ).
          lv_atom = ls_frame-function->get_atom( ls_instruction-operand ).
          IF ls_value-tag = zcl_qjs_value=>tag_string.
            IF ls_instruction-opcode = zif_qjs_opcodes=>get_field_for_call.
              APPEND ls_value TO lt_stack.
            ENDIF.
            IF lv_atom = 'length'.
              ls_value = zcl_qjs_value=>new_int( ls_value-string_ref->length( ) ).
            ELSE.
              lo_prototype = mo_runtime->get_string_prototype( ).
              IF lo_prototype IS BOUND.
                ls_value = lo_prototype->get( lv_atom ).
              ELSE.
                ls_value = zcl_qjs_value=>new_undefined( ).
              ENDIF.
            ENDIF.
            APPEND ls_value TO lt_stack.
            mo_limits->check_operand_stack( lines( lt_stack ) ).
            CONTINUE.
          ENDIF.
          CLEAR lo_object.
          CLEAR lo_closure.
          CLEAR lo_property_container.
          lo_property_container = ls_value-property_ref.
          TRY.
              lo_object ?= ls_value-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_object IS NOT BOUND.
            TRY.
                lo_closure ?= ls_value-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
          ENDIF.
          IF lo_object IS NOT BOUND AND lo_closure IS NOT BOUND
              AND lo_property_container IS NOT BOUND.
            TRY.
                lo_property_container ?= ls_value-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
          ENDIF.
          IF lo_object IS NOT BOUND AND lo_closure IS NOT BOUND
              AND lo_property_container IS NOT BOUND.
            throw_error(
              name = 'TypeError' message = 'property read from a non-object value' ).
          ENDIF.
          lv_atom = ls_frame-function->get_atom( ls_instruction-operand ).
          IF ls_instruction-opcode = zif_qjs_opcodes=>get_field_for_call.
            APPEND ls_value TO lt_stack.
          ENDIF.
          IF lo_object IS BOUND.
            ls_value = lo_object->get( lv_atom ).
          ELSEIF lo_closure IS BOUND.
            ls_value = lo_closure->get_property( lv_atom ).
          ELSE.
            ls_value = lo_property_container->get_property( lv_atom ).
          ENDIF.
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>put_field.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          CLEAR lo_object.
          CLEAR lo_closure.
          CLEAR lo_property_container.
          lo_property_container = ls_left-property_ref.
          TRY.
              lo_object ?= ls_left-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_object IS NOT BOUND.
            TRY. lo_closure ?= ls_left-object_ref. CATCH cx_sy_move_cast_error. ENDTRY.
          ENDIF.
          IF lo_object IS NOT BOUND AND lo_closure IS NOT BOUND
              AND lo_property_container IS NOT BOUND.
            TRY.
                lo_property_container ?= ls_left-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
          ENDIF.
          IF lo_object IS NOT BOUND AND lo_closure IS NOT BOUND
              AND lo_property_container IS NOT BOUND.
            throw_error(
              name = 'TypeError' message = 'property write to a non-object value' ).
          ENDIF.
          lv_atom = ls_frame-function->get_atom( ls_instruction-operand ).
          IF lo_object IS BOUND.
            lo_object->set( name = lv_atom value = ls_right ).
          ELSEIF lo_closure IS BOUND.
            lo_closure->set_property( name = lv_atom value = ls_right ).
          ELSE.
            lo_property_container->set_property( name = lv_atom value = ls_right ).
          ENDIF.
        WHEN zif_qjs_opcodes=>define_method
            OR zif_qjs_opcodes=>define_method_computed.
          ls_right = pop( CHANGING stack = lt_stack ).
          DATA(ls_method_key) = zcl_qjs_value=>new_undefined( ).
          DATA(lv_method_kind) = ls_instruction-operand2.
          DATA(lv_method_enumerable) = abap_false.
          IF ls_instruction-opcode = zif_qjs_opcodes=>define_method_computed.
            ls_method_key = pop( CHANGING stack = lt_stack ).
            lv_method_kind = ls_instruction-operand.
          ENDIF.
          IF lv_method_kind >= 10.
            lv_method_kind = lv_method_kind - 10.
            lv_method_enumerable = abap_true.
          ENDIF.
          ls_left = pop( CHANGING stack = lt_stack ).
          CLEAR lo_object.
          CLEAR lo_closure.
          TRY.
              lo_object ?= ls_left-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_object IS NOT BOUND.
            TRY.
                lo_closure ?= ls_left-object_ref.
                lo_object = lo_closure->get_property_storage( ).
              CATCH cx_sy_move_cast_error.
            ENDTRY.
          ENDIF.
          IF lo_object IS NOT BOUND.
            throw_error(
              name = 'TypeError' message = 'method target is not an object' ).
          ENDIF.
          IF ls_instruction-opcode = zif_qjs_opcodes=>define_method.
            lv_atom = ls_frame-function->get_atom( ls_instruction-operand ).
          ELSEIF ls_method_key-tag <> zcl_qjs_value=>tag_symbol.
            lv_atom = zcl_qjs_value=>to_string( ls_method_key ).
          ENDIF.
          IF lv_method_kind = 0.
            IF ls_method_key-tag = zcl_qjs_value=>tag_symbol.
              lo_object->define_symbol_property(
                identity = ls_method_key-symbol_id value = ls_right
                writable = abap_true enumerable = lv_method_enumerable
                configurable = abap_true ).
            ELSE.
              lo_object->define_property(
                name = lv_atom value = ls_right writable = abap_true
                enumerable = lv_method_enumerable configurable = abap_true ).
            ENDIF.
          ELSE.
            DATA(ls_method_getter) = zcl_qjs_value=>new_undefined( ).
            DATA(ls_method_setter) = zcl_qjs_value=>new_undefined( ).
            IF ls_method_key-tag = zcl_qjs_value=>tag_symbol.
              DATA(ls_method_property) = lo_object->get_own_symbol_property(
                ls_method_key-symbol_id ).
            ELSE.
              ls_method_property = lo_object->get_own_property( lv_atom ).
            ENDIF.
            IF ls_method_property-found = abap_true
                AND ls_method_property-accessor = abap_true.
              ls_method_getter = ls_method_property-getter.
              ls_method_setter = ls_method_property-setter.
            ENDIF.
            IF lv_method_kind = 1.
              ls_method_getter = ls_right.
            ELSE.
              ls_method_setter = ls_right.
            ENDIF.
            IF ls_method_key-tag = zcl_qjs_value=>tag_symbol.
              lo_object->define_symbol_accessor(
                identity = ls_method_key-symbol_id getter = ls_method_getter
                setter = ls_method_setter enumerable = lv_method_enumerable
                configurable = abap_true ).
            ELSE.
              lo_object->define_accessor(
                name = lv_atom getter = ls_method_getter setter = ls_method_setter
                enumerable = lv_method_enumerable configurable = abap_true ).
            ENDIF.
          ENDIF.
          APPEND ls_left TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>get_private_field
            OR zif_qjs_opcodes=>put_private_field
            OR zif_qjs_opcodes=>define_private_field.
          IF ls_instruction-opcode = zif_qjs_opcodes=>get_private_field.
            ls_right = pop( CHANGING stack = lt_stack ).
            ls_left = pop( CHANGING stack = lt_stack ).
          ELSEIF ls_instruction-opcode = zif_qjs_opcodes=>put_private_field.
            ls_right = pop( CHANGING stack = lt_stack ).
            ls_value = pop( CHANGING stack = lt_stack ).
            ls_left = pop( CHANGING stack = lt_stack ).
          ELSE.
            ls_value = pop( CHANGING stack = lt_stack ).
            ls_right = pop( CHANGING stack = lt_stack ).
            ls_left = pop( CHANGING stack = lt_stack ).
          ENDIF.
          CLEAR lo_object.
          CLEAR lo_closure.
          TRY.
              lo_object ?= ls_left-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_object IS NOT BOUND.
            TRY.
                lo_closure ?= ls_left-object_ref.
                lo_object = lo_closure->get_property_storage( ).
              CATCH cx_sy_move_cast_error.
            ENDTRY.
          ENDIF.
          IF lo_object IS NOT BOUND
              OR ls_right-tag <> zcl_qjs_value=>tag_symbol.
            throw_error(
              name = 'TypeError' message = 'invalid private field access' ).
          ENDIF.
          IF ls_instruction-opcode = zif_qjs_opcodes=>get_private_field.
            IF lo_object->has_private_field( ls_right-symbol_id ) = abap_false.
              throw_error(
                name = 'TypeError' message = 'private field brand check failed' ).
            ENDIF.
            ls_value = lo_object->get_private_field(
              identity = ls_right-symbol_id receiver = ls_left ).
            APPEND ls_value TO lt_stack.
          ELSEIF ls_instruction-opcode = zif_qjs_opcodes=>put_private_field.
            IF lo_object->set_private_field(
                identity = ls_right-symbol_id value = ls_value
                receiver = ls_left ) = abap_false.
              throw_error(
                name = 'TypeError' message = 'private field brand check failed' ).
            ENDIF.
          ELSE.
            IF lo_object->add_private_field(
                identity = ls_right-symbol_id value = ls_value ) = abap_false.
              throw_error(
                name = 'TypeError' message = 'private field already exists' ).
            ENDIF.
            APPEND ls_left TO lt_stack.
          ENDIF.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>define_field.
          IF ls_instruction-operand2 >= 4 AND ls_instruction-operand2 <= 9.
            ls_value = pop( CHANGING stack = lt_stack ).
            ls_right = pop( CHANGING stack = lt_stack ).
            ls_left = pop( CHANGING stack = lt_stack ).
            IF ls_right-tag <> zcl_qjs_value=>tag_symbol.
              throw_error(
                name = 'TypeError' message = 'private method name is not a symbol' ).
            ENDIF.
            CLEAR lo_closure.
            TRY.
                lo_closure ?= ls_left-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
            IF lo_closure IS NOT BOUND.
              throw_error(
                name = 'TypeError' message = 'private method owner is not a class' ).
            ENDIF.
            IF ls_instruction-operand2 = 4
                OR ls_instruction-operand2 = 6
                OR ls_instruction-operand2 = 7.
              IF ls_instruction-operand2 = 4.
                lo_closure->register_private_method(
                  key = ls_right value = ls_value ).
              ELSE.
                lo_closure->register_private_accessor(
                  key = ls_right value = ls_value
                  kind = ls_instruction-operand2 - 5 ).
              ENDIF.
            ELSE.
              lo_object = lo_closure->get_property_storage( ).
              IF ls_instruction-operand2 = 5.
                lv_private_method_added = lo_object->add_private_field(
                  identity = ls_right-symbol_id value = ls_value
                  writable = abap_false ).
              ELSEIF ls_instruction-operand2 = 8.
                lv_private_method_added = lo_object->add_private_accessor(
                  identity = ls_right-symbol_id getter = ls_value
                  setter = zcl_qjs_value=>new_undefined( ) ).
              ELSE.
                lv_private_method_added = lo_object->add_private_accessor(
                  identity = ls_right-symbol_id
                  getter = zcl_qjs_value=>new_undefined( ) setter = ls_value ).
              ENDIF.
              IF lv_private_method_added = abap_false.
                throw_error(
                  name = 'TypeError' message = 'private element already exists' ).
              ENDIF.
            ENDIF.
            APPEND ls_left TO lt_stack.
            mo_limits->check_operand_stack( lines( lt_stack ) ).
            CONTINUE.
          ENDIF.
          IF ls_instruction-operand2 = 1 OR ls_instruction-operand2 = 3.
            ls_value = pop( CHANGING stack = lt_stack ).
            ls_right = pop( CHANGING stack = lt_stack ).
            ls_left = pop( CHANGING stack = lt_stack ).
            CLEAR lo_closure.
            TRY.
                lo_closure ?= ls_left-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
            IF lo_closure IS NOT BOUND.
              throw_error(
                name = 'TypeError' message = 'field owner is not a class' ).
            ENDIF.
            DATA lo_initializer_closure TYPE REF TO zcl_qjs_closure.
            TRY.
                lo_initializer_closure ?= ls_value-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
            IF lo_initializer_closure IS NOT BOUND.
              throw_error(
                name = 'TypeError' message = 'field initializer is not callable' ).
            ENDIF.
            lo_closure->register_instance_field(
              key = ls_right initializer = lo_initializer_closure
              private = xsdbool( ls_instruction-operand2 = 3 ) ).
            APPEND ls_left TO lt_stack.
            mo_limits->check_operand_stack( lines( lt_stack ) ).
            CONTINUE.
          ENDIF.
          ls_right = pop( CHANGING stack = lt_stack ).
          CLEAR ls_field_key.
          IF ls_instruction-operand2 = 2.
            ls_field_key = pop( CHANGING stack = lt_stack ).
          ENDIF.
          ls_left = pop( CHANGING stack = lt_stack ).
          CLEAR lo_object.
          CLEAR lo_closure.
          TRY.
              lo_object ?= ls_left-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_object IS NOT BOUND.
            TRY.
                lo_closure ?= ls_left-object_ref.
                lo_object = lo_closure->get_property_storage( ).
              CATCH cx_sy_move_cast_error.
            ENDTRY.
          ENDIF.
          IF lo_object IS NOT BOUND.
            throw_error(
              name = 'TypeError' message = 'field target is not an object' ).
          ENDIF.
          IF ls_instruction-operand2 = 2
              AND ls_field_key-tag = zcl_qjs_value=>tag_symbol.
            lo_object->define_symbol_property(
              identity = ls_field_key-symbol_id value = ls_right
              writable = abap_true enumerable = abap_true
              configurable = abap_true ).
          ELSE.
            IF ls_instruction-operand2 = 2.
              lv_atom = zcl_qjs_value=>to_string( ls_field_key ).
            ELSE.
              lv_atom = ls_frame-function->get_atom( ls_instruction-operand ).
            ENDIF.
            lo_object->define_property(
              name = lv_atom value = ls_right writable = abap_true
              enumerable = abap_true configurable = abap_true ).
          ENDIF.
          APPEND ls_left TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>get_super_value.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          ls_value = pop( CHANGING stack = lt_stack ).
          CLEAR lo_object.
          CLEAR lo_closure.
          TRY.
              lo_object ?= ls_left-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_object IS NOT BOUND.
            TRY.
                lo_closure ?= ls_left-object_ref.
                lo_object = lo_closure->get_property_storage( ).
              CATCH cx_sy_move_cast_error.
            ENDTRY.
          ENDIF.
          IF lo_object IS NOT BOUND.
            throw_error(
              name = 'TypeError' message = 'super base is not an object' ).
          ENDIF.
          IF ls_right-tag = zcl_qjs_value=>tag_symbol.
            ls_value = lo_object->reflect_get_symbol(
              identity = ls_right-symbol_id receiver = ls_value ).
          ELSE.
            ls_value = lo_object->reflect_get(
              name = zcl_qjs_value=>to_string( ls_right ) receiver = ls_value ).
          ENDIF.
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>put_super_value.
          DATA(ls_super_value) = pop( CHANGING stack = lt_stack ).
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          ls_value = pop( CHANGING stack = lt_stack ).
          CLEAR lo_object.
          CLEAR lo_closure.
          TRY.
              lo_object ?= ls_left-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_object IS NOT BOUND.
            TRY.
                lo_closure ?= ls_left-object_ref.
                lo_object = lo_closure->get_property_storage( ).
              CATCH cx_sy_move_cast_error.
            ENDTRY.
          ENDIF.
          IF lo_object IS NOT BOUND.
            throw_error(
              name = 'TypeError' message = 'super base is not an object' ).
          ENDIF.
          IF ls_right-tag = zcl_qjs_value=>tag_symbol.
            DATA(lv_super_set) = lo_object->reflect_set_symbol(
              identity = ls_right-symbol_id value = ls_super_value
              receiver = ls_value ).
          ELSE.
            lv_super_set = lo_object->reflect_set(
              name = zcl_qjs_value=>to_string( ls_right ) value = ls_super_value
              receiver = ls_value ).
          ENDIF.
          IF lv_super_set = abap_false.
            throw_error(
              name = 'TypeError' message = 'super property write failed' ).
          ENDIF.
        WHEN zif_qjs_opcodes=>get_element OR zif_qjs_opcodes=>get_element_for_call.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          IF ls_left-tag = zcl_qjs_value=>tag_string.
            IF ls_instruction-opcode = zif_qjs_opcodes=>get_element_for_call.
              APPEND ls_left TO lt_stack.
            ENDIF.
            IF ls_right-tag = zcl_qjs_value=>tag_symbol.
              lo_prototype = mo_runtime->get_string_prototype( ).
              IF lo_prototype IS BOUND.
                ls_value = lo_prototype->get_symbol( ls_right-symbol_id ).
              ELSE.
                ls_value = zcl_qjs_value=>new_undefined( ).
              ENDIF.
            ELSE.
              IF ls_right-tag = zcl_qjs_value=>tag_int.
                lv_element_index = ls_right-int_value.
                lv_property_name = lv_element_index.
                CONDENSE lv_property_name NO-GAPS.
              ELSE.
                lv_property_name = zcl_qjs_value=>to_string( ls_right ).
                lv_element_index = -1.
                IF lv_property_name IS NOT INITIAL
                    AND lv_property_name CO '0123456789'
                    AND ( strlen( lv_property_name ) = 1
                      OR lv_property_name+0(1) <> '0' ).
                  TRY.
                      lv_element_index = lv_property_name.
                    CATCH cx_sy_conversion_error cx_sy_arithmetic_error.
                      lv_element_index = -1.
                  ENDTRY.
                ENDIF.
              ENDIF.
              IF lv_property_name = 'length'.
                ls_value = zcl_qjs_value=>new_int( ls_left-string_ref->length( ) ).
              ELSEIF lv_element_index >= 0
                  AND lv_element_index < ls_left-string_ref->length( ).
                ls_value = zcl_qjs_value=>new_string(
                  ls_left-string_ref->code_unit_at( CONV i( lv_element_index ) ) ).
              ELSE.
                lo_prototype = mo_runtime->get_string_prototype( ).
                IF lo_prototype IS BOUND.
                  ls_value = lo_prototype->get( lv_property_name ).
                ELSE.
                  ls_value = zcl_qjs_value=>new_undefined( ).
                ENDIF.
              ENDIF.
            ENDIF.
            APPEND ls_value TO lt_stack.
            mo_limits->check_operand_stack( lines( lt_stack ) ).
            CONTINUE.
          ENDIF.
          CLEAR lo_object.
          CLEAR lo_closure.
          CLEAR lo_property_container.
          lo_property_container = ls_left-property_ref.
          TRY.
              lo_object ?= ls_left-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_object IS NOT BOUND.
            TRY. lo_closure ?= ls_left-object_ref. CATCH cx_sy_move_cast_error. ENDTRY.
          ENDIF.
          IF lo_object IS NOT BOUND AND lo_closure IS NOT BOUND
              AND lo_property_container IS NOT BOUND.
            TRY.
                lo_property_container ?= ls_left-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
          ENDIF.
          IF lo_object IS NOT BOUND AND lo_closure IS NOT BOUND
              AND lo_property_container IS NOT BOUND.
            throw_error(
              name = 'TypeError' message = 'property read from a non-object value' ).
          ENDIF.
          IF ls_right-tag = zcl_qjs_value=>tag_symbol.
            CLEAR lv_property_name.
          ELSEIF ls_right-tag = zcl_qjs_value=>tag_int.
            lv_element_index = ls_right-int_value.
            lv_property_name = lv_element_index.
            CONDENSE lv_property_name NO-GAPS.
          ELSE.
            lv_property_name = zcl_qjs_value=>to_string( ls_right ).
          ENDIF.
          IF lo_object IS BOUND AND ls_right-tag = zcl_qjs_value=>tag_symbol.
            ls_value = lo_object->get_symbol( ls_right-symbol_id ).
          ELSEIF lo_closure IS BOUND AND ls_right-tag = zcl_qjs_value=>tag_symbol.
            ls_value = lo_closure->get_symbol_property( ls_right-symbol_id ).
          ELSEIF lo_property_container IS BOUND
              AND ls_right-tag = zcl_qjs_value=>tag_symbol.
            ls_value = lo_property_container->get_symbol_property(
              ls_right-symbol_id ).
          ELSEIF lo_object IS BOUND AND ls_right-tag = zcl_qjs_value=>tag_int.
            ls_value = lo_object->get_element( lv_element_index ).
          ELSEIF lo_object IS BOUND.
            ls_value = lo_object->get( lv_property_name ).
          ELSEIF lo_closure IS BOUND.
            ls_value = lo_closure->get_property( lv_property_name ).
          ELSE.
            ls_value = lo_property_container->get_property( lv_property_name ).
          ENDIF.
          IF ls_instruction-opcode = zif_qjs_opcodes=>get_element_for_call.
            APPEND ls_left TO lt_stack.
          ENDIF.
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>put_element.
          ls_value = pop( CHANGING stack = lt_stack ).
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          CLEAR lo_object.
          CLEAR lo_closure.
          CLEAR lo_property_container.
          lo_property_container = ls_left-property_ref.
          TRY.
              lo_object ?= ls_left-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_object IS NOT BOUND.
            TRY. lo_closure ?= ls_left-object_ref. CATCH cx_sy_move_cast_error. ENDTRY.
          ENDIF.
          IF lo_object IS NOT BOUND AND lo_closure IS NOT BOUND
              AND lo_property_container IS NOT BOUND.
            TRY.
                lo_property_container ?= ls_left-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
          ENDIF.
          IF lo_object IS NOT BOUND AND lo_closure IS NOT BOUND
              AND lo_property_container IS NOT BOUND.
            throw_error(
              name = 'TypeError' message = 'property write to a non-object value' ).
          ENDIF.
          IF ls_right-tag = zcl_qjs_value=>tag_symbol.
            CLEAR lv_property_name.
          ELSEIF ls_right-tag = zcl_qjs_value=>tag_int.
            lv_element_index = ls_right-int_value.
            lv_property_name = lv_element_index.
            CONDENSE lv_property_name NO-GAPS.
          ELSE.
            lv_property_name = zcl_qjs_value=>to_string( ls_right ).
          ENDIF.
          IF lo_object IS BOUND AND ls_right-tag = zcl_qjs_value=>tag_symbol.
            lo_object->set_symbol(
              identity = ls_right-symbol_id value = ls_value ).
          ELSEIF lo_closure IS BOUND AND ls_right-tag = zcl_qjs_value=>tag_symbol.
            lo_closure->set_symbol_property(
              identity = ls_right-symbol_id value = ls_value ).
          ELSEIF lo_property_container IS BOUND
              AND ls_right-tag = zcl_qjs_value=>tag_symbol.
            lo_property_container->set_symbol_property(
              identity = ls_right-symbol_id value = ls_value ).
          ELSEIF lo_object IS BOUND AND ls_right-tag = zcl_qjs_value=>tag_int.
            lo_object->set_element( index = lv_element_index value = ls_value ).
          ELSEIF lo_object IS BOUND.
            lo_object->set( name = lv_property_name value = ls_value ).
          ELSEIF lo_closure IS BOUND.
            lo_closure->set_property( name = lv_property_name value = ls_value ).
          ELSE.
            lo_property_container->set_property(
              name = lv_property_name value = ls_value ).
          ENDIF.
        WHEN zif_qjs_opcodes=>delete_property.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          IF ls_right-tag = zcl_qjs_value=>tag_symbol.
            CLEAR lv_property_name.
          ELSEIF ls_right-tag = zcl_qjs_value=>tag_int.
            lv_property_name = ls_right-int_value.
            CONDENSE lv_property_name NO-GAPS.
          ELSE.
            lv_property_name = zcl_qjs_value=>to_string( ls_right ).
          ENDIF.
          CLEAR lo_object.
          CLEAR lo_closure.
          CLEAR lo_property_container.
          lo_property_container = ls_left-property_ref.
          TRY.
              lo_object ?= ls_left-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_object IS NOT BOUND.
            TRY. lo_closure ?= ls_left-object_ref. CATCH cx_sy_move_cast_error. ENDTRY.
          ENDIF.
          IF lo_object IS NOT BOUND AND lo_closure IS NOT BOUND
              AND lo_property_container IS NOT BOUND.
            TRY.
                lo_property_container ?= ls_left-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
          ENDIF.
          IF lo_object IS NOT BOUND AND lo_closure IS NOT BOUND
              AND lo_property_container IS NOT BOUND.
            throw_error(
              name = 'TypeError' message = 'property delete from a non-object value' ).
          ENDIF.
          IF lo_object IS BOUND AND ls_right-tag = zcl_qjs_value=>tag_symbol.
            DATA(lv_deleted) = lo_object->delete_symbol( ls_right-symbol_id ).
          ELSEIF lo_closure IS BOUND AND ls_right-tag = zcl_qjs_value=>tag_symbol.
            lv_deleted = lo_closure->delete_symbol_property( ls_right-symbol_id ).
          ELSEIF lo_property_container IS BOUND
              AND ls_right-tag = zcl_qjs_value=>tag_symbol.
            lv_deleted = lo_property_container->delete_symbol_property(
              ls_right-symbol_id ).
          ELSEIF lo_object IS BOUND.
            lv_deleted = lo_object->delete( lv_property_name ).
          ELSEIF lo_closure IS BOUND.
            lv_deleted = lo_closure->delete_property( lv_property_name ).
          ELSE.
            lv_deleted = lo_property_container->delete_property( lv_property_name ).
          ENDIF.
          ls_value = zcl_qjs_value=>new_boolean( lv_deleted ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>get_local OR zif_qjs_opcodes=>get_lexical.
          lv_local_index = ls_instruction-operand + 1.
          READ TABLE ls_frame-locals INDEX lv_local_index INTO lo_cell.
          IF sy-subrc <> 0.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Bytecode local index out of bounds'.
          ENDIF.
          ls_value = lo_cell->get( ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>get_arg.
          READ TABLE ls_frame-arguments INDEX ls_instruction-operand + 1
            INTO ls_value.
          IF sy-subrc <> 0.
            ls_value = zcl_qjs_value=>new_undefined( ).
          ENDIF.
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>get_capture.
          lv_local_index = ls_instruction-operand + 1.
          READ TABLE ls_frame-captures INDEX lv_local_index INTO lo_cell.
          IF sy-subrc <> 0.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Bytecode capture index out of bounds'.
          ENDIF.
          ls_value = lo_cell->get( ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>put_capture OR zif_qjs_opcodes=>set_capture.
          lv_local_index = ls_instruction-operand + 1.
          ls_value = pop( CHANGING stack = lt_stack ).
          READ TABLE ls_frame-captures INDEX lv_local_index INTO lo_cell.
          IF sy-subrc <> 0.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Bytecode capture index out of bounds'.
          ENDIF.
          lo_cell->set( ls_value ).
          IF ls_instruction-opcode = zif_qjs_opcodes=>set_capture.
            APPEND ls_value TO lt_stack.
            mo_limits->check_operand_stack( lines( lt_stack ) ).
          ENDIF.
        WHEN zif_qjs_opcodes=>put_local OR zif_qjs_opcodes=>set_local
            OR zif_qjs_opcodes=>put_lexical OR zif_qjs_opcodes=>set_lexical.
          lv_local_index = ls_instruction-operand + 1.
          ls_value = pop( CHANGING stack = lt_stack ).
          READ TABLE ls_frame-locals INDEX lv_local_index INTO lo_cell.
          IF sy-subrc <> 0.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Bytecode local index out of bounds'.
          ENDIF.
          lo_cell->set( ls_value ).
          MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.
          IF ls_instruction-opcode = zif_qjs_opcodes=>set_local
              OR ls_instruction-opcode = zif_qjs_opcodes=>set_lexical.
            APPEND ls_value TO lt_stack.
            mo_limits->check_operand_stack( lines( lt_stack ) ).
          ENDIF.
        WHEN zif_qjs_opcodes=>initialize_lexical.
          lv_local_index = ls_instruction-operand + 1.
          ls_value = pop( CHANGING stack = lt_stack ).
          READ TABLE ls_frame-locals INDEX lv_local_index INTO lo_cell.
          IF sy-subrc <> 0.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Bytecode lexical index out of bounds'.
          ENDIF.
          lo_cell->initialize( ls_value ).
        WHEN zif_qjs_opcodes=>reset_lexical.
          lv_local_index = ls_instruction-operand + 1.
          IF lv_local_index < 1 OR lv_local_index > lines( ls_frame-locals ).
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Bytecode lexical index out of bounds'.
          ENDIF.
          ls_local_spec = ls_frame-function->get_local_spec(
            ls_instruction-operand ).
          ls_value = zcl_qjs_value=>new_undefined( ).
          CREATE OBJECT lo_cell
            EXPORTING value = ls_value initialized = abap_false
              mutable = ls_local_spec-mutable runtime = mo_runtime.
          MODIFY ls_frame-locals FROM lo_cell INDEX lv_local_index.
          MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.
        WHEN zif_qjs_opcodes=>push_i32.
          ls_value = zcl_qjs_value=>new_int( ls_instruction-operand ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>push_const.
          ls_value = ls_frame-function->get_constant( ls_instruction-operand ).
          IF ls_value-tag = zcl_qjs_value=>tag_object.
            DATA lo_template_site TYPE REF TO zcl_qjs_template_site.
            TRY.
                lo_template_site ?= ls_value-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
            IF lo_template_site IS BOUND.
              ls_value = lo_template_site->materialize( mo_runtime ).
            ENDIF.
          ENDIF.
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>make_closure.
          ls_value = ls_frame-function->get_constant( ls_instruction-operand ).
          TRY.
              lo_called ?= ls_value-object_ref.
            CATCH cx_sy_move_cast_error.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'Closure constant is not a function'.
          ENDTRY.
          CLEAR lt_capture_cells.
          lt_capture_descriptors = lo_called->get_captures( ).
          LOOP AT lt_capture_descriptors INTO ls_capture_descriptor.
            lv_local_index = ls_capture_descriptor-source_index + 1.
            IF ls_capture_descriptor-source_kind = zcl_qjs_function=>capture_local.
              READ TABLE ls_frame-locals INDEX lv_local_index INTO lo_cell.
            ELSE.
              READ TABLE ls_frame-captures INDEX lv_local_index INTO lo_cell.
            ENDIF.
            IF sy-subrc <> 0.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'Closure capture source is out of bounds'.
            ENDIF.
            APPEND lo_cell TO lt_capture_cells.
          ENDLOOP.
          lo_properties = mo_runtime->create_function_properties(
            generator = lo_called->is_generator( ) async = lo_called->is_async( ) ).
          IF lo_called->is_generator( ) = abap_true
              AND lo_called->is_async( ) = abap_true.
            lo_prototype = mo_runtime->create_object(
              prototype = mo_runtime->get_async_generator_prototype( ) ).
          ELSEIF lo_called->is_generator( ) = abap_true.
            lo_prototype = mo_runtime->create_object(
              prototype = mo_runtime->get_generator_prototype( ) ).
          ELSEIF lo_called->is_constructible( ) = abap_true.
            lo_prototype = mo_runtime->create_object( ).
          ELSE.
            CLEAR lo_prototype.
          ENDIF.
          CREATE OBJECT lo_closure
            EXPORTING function = lo_called captures = lt_capture_cells
              properties = lo_properties prototype_object = lo_prototype
              runtime = mo_runtime.
          ls_value = zcl_qjs_value=>new_object( lo_closure ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>private_symbol.
          lv_atom = ls_frame-function->get_atom( ls_instruction-operand ).
          ls_value = mo_runtime->new_symbol( description = '#' && lv_atom ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>push_true.
          ls_value = zcl_qjs_value=>new_boolean( abap_true ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>push_false.
          ls_value = zcl_qjs_value=>new_boolean( abap_false ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>push_null.
          ls_value = zcl_qjs_value=>new_null( ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>push_undefined.
          ls_value = zcl_qjs_value=>new_undefined( ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>type_of.
          ls_value = pop( CHANGING stack = lt_stack ).
          DATA(lv_type) = ``.
          CASE ls_value-tag.
            WHEN zcl_qjs_value=>tag_undefined. lv_type = 'undefined'.
            WHEN zcl_qjs_value=>tag_null. lv_type = 'object'.
            WHEN zcl_qjs_value=>tag_bool. lv_type = 'boolean'.
            WHEN zcl_qjs_value=>tag_int OR zcl_qjs_value=>tag_number.
              lv_type = 'number'.
            WHEN zcl_qjs_value=>tag_string. lv_type = 'string'.
            WHEN zcl_qjs_value=>tag_symbol. lv_type = 'symbol'.
            WHEN zcl_qjs_value=>tag_object.
              lv_type = 'object'.
              CLEAR lo_closure.
              CLEAR lo_host_callable.
              TRY.
                  lo_closure ?= ls_value-object_ref.
                CATCH cx_sy_move_cast_error.
              ENDTRY.
              TRY.
                  lo_host_callable ?= ls_value-object_ref.
                CATCH cx_sy_move_cast_error.
              ENDTRY.
              IF lo_closure IS BOUND OR lo_host_callable IS BOUND.
                lv_type = 'function'.
              ENDIF.
          ENDCASE.
          ls_value = zcl_qjs_value=>new_string( lv_type ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>bitwise_not.
          ls_value = pop( CHANGING stack = lt_stack ).
          ls_value = zcl_qjs_number=>bitwise_not( ls_value ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>bitwise_and OR zif_qjs_opcodes=>bitwise_xor
            OR zif_qjs_opcodes=>bitwise_or.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          ls_left = mo_runtime->to_primitive( ls_left ).
          ls_right = mo_runtime->to_primitive( ls_right ).
          DATA(lv_bitwise_operation) = 1.
          IF ls_instruction-opcode = zif_qjs_opcodes=>bitwise_xor.
            lv_bitwise_operation = 2.
          ELSEIF ls_instruction-opcode = zif_qjs_opcodes=>bitwise_or.
            lv_bitwise_operation = 3.
          ENDIF.
          ls_value = zcl_qjs_number=>bitwise(
            left = ls_left right = ls_right operation = lv_bitwise_operation ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>shift_left OR zif_qjs_opcodes=>shift_right
            OR zif_qjs_opcodes=>shift_right_unsigned.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          ls_left = mo_runtime->to_primitive( ls_left ).
          ls_right = mo_runtime->to_primitive( ls_right ).
          DATA(lv_shift_operation) = 1.
          IF ls_instruction-opcode = zif_qjs_opcodes=>shift_right.
            lv_shift_operation = 2.
          ELSEIF ls_instruction-opcode = zif_qjs_opcodes=>shift_right_unsigned.
            lv_shift_operation = 3.
          ENDIF.
          ls_value = zcl_qjs_number=>shift(
            left = ls_left right = ls_right operation = lv_shift_operation ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>add.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          TRY.
              IF ls_left-tag = zcl_qjs_value=>tag_object.
                ls_left = mo_runtime->to_primitive( ls_left ).
              ENDIF.
              IF ls_right-tag = zcl_qjs_value=>tag_object.
                ls_right = mo_runtime->to_primitive( ls_right ).
              ENDIF.
            CATCH zcx_qjs_error INTO lo_host_error.
              RAISE EXCEPTION TYPE zcx_qjs_throw
                EXPORTING value = mo_runtime->create_error_from_reason(
                  lo_host_error->reason ).
          ENDTRY.
          ls_value = zcl_qjs_number=>add( left = ls_left right = ls_right ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>subtract.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          ls_value = zcl_qjs_number=>subtract( left = ls_left right = ls_right ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>multiply.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          ls_value = zcl_qjs_number=>multiply( left = ls_left right = ls_right ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>divide.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          ls_value = zcl_qjs_number=>divide( left = ls_left right = ls_right ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>modulo.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          ls_value = zcl_qjs_number=>modulo( left = ls_left right = ls_right ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>negate.
          ls_value = pop( CHANGING stack = lt_stack ).
          ls_value = zcl_qjs_number=>negate( ls_value ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>unary_plus.
          ls_value = pop( CHANGING stack = lt_stack ).
          ls_value = zcl_qjs_number=>to_number( ls_value ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>increment OR zif_qjs_opcodes=>decrement.
          ls_value = pop( CHANGING stack = lt_stack ).
          ls_value = zcl_qjs_number=>to_number( ls_value ).
          IF ls_instruction-opcode = zif_qjs_opcodes=>increment.
            ls_value = zcl_qjs_number=>add(
              left = ls_value right = zcl_qjs_value=>new_int( 1 ) ).
          ELSE.
            ls_value = zcl_qjs_number=>subtract(
              left = ls_value right = zcl_qjs_value=>new_int( 1 ) ).
          ENDIF.
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>logical_not.
          ls_value = pop( CHANGING stack = lt_stack ).
          ls_value = zcl_qjs_value=>new_boolean(
            xsdbool( zcl_qjs_value=>to_boolean( ls_value ) = abap_false ) ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>less_than OR zif_qjs_opcodes=>less_equal
            OR zif_qjs_opcodes=>greater_than OR zif_qjs_opcodes=>greater_equal.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          DATA(lv_compare) = abap_false.
          IF ls_instruction-opcode = zif_qjs_opcodes=>less_than.
            lv_compare = zcl_qjs_number=>less_than( left = ls_left right = ls_right ).
          ELSEIF ls_instruction-opcode = zif_qjs_opcodes=>greater_than.
            lv_compare = zcl_qjs_number=>less_than( left = ls_right right = ls_left ).
          ELSEIF ls_instruction-opcode = zif_qjs_opcodes=>less_equal.
            lv_compare = zcl_qjs_number=>less_than( left = ls_left right = ls_right ).
            IF lv_compare = abap_false.
              lv_compare = zcl_qjs_number=>equal( left = ls_left right = ls_right ).
            ENDIF.
          ELSE.
            lv_compare = zcl_qjs_number=>less_than( left = ls_right right = ls_left ).
            IF lv_compare = abap_false.
              lv_compare = zcl_qjs_number=>equal( left = ls_left right = ls_right ).
            ENDIF.
          ENDIF.
          ls_value = zcl_qjs_value=>new_boolean( lv_compare ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>strict_equal OR zif_qjs_opcodes=>strict_not_equal.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          DATA(lv_equal) = zcl_qjs_value=>strict_equal( left = ls_left right = ls_right ).
          IF ls_instruction-opcode = zif_qjs_opcodes=>strict_not_equal.
            lv_equal = xsdbool( lv_equal = abap_false ).
          ENDIF.
          ls_value = zcl_qjs_value=>new_boolean( lv_equal ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>instance_of.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          CLEAR lo_closure.
          CLEAR lo_prototype.
          IF ls_right-tag <> zcl_qjs_value=>tag_object.
            throw_error(
              name    = 'TypeError'
              message = 'right-hand side of instanceof is not constructable' ).
          ENDIF.
          TRY.
              lo_closure ?= ls_right-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_closure IS BOUND.
            lo_prototype = lo_closure->get_prototype_object( ).
          ELSE.
            CLEAR lo_property_container.
            lo_property_container = ls_right-property_ref.
            IF lo_property_container IS NOT BOUND.
              TRY.
                  lo_property_container ?= ls_right-object_ref.
                CATCH cx_sy_move_cast_error.
              ENDTRY.
            ENDIF.
            IF lo_property_container IS BOUND.
              DATA(ls_constructor_prototype) =
                lo_property_container->get_property( 'prototype' ).
              IF ls_constructor_prototype-tag = zcl_qjs_value=>tag_object.
                TRY.
                    lo_prototype ?= ls_constructor_prototype-object_ref.
                  CATCH cx_sy_move_cast_error.
                ENDTRY.
              ENDIF.
            ENDIF.
            IF lo_prototype IS NOT BOUND.
              throw_error(
                name    = 'TypeError'
                message = 'right-hand side of instanceof is not constructable' ).
            ENDIF.
          ENDIF.
          DATA(lv_instance) = abap_false.
          CLEAR lo_object.
          TRY.
              lo_object ?= ls_left-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_object IS BOUND.
            lo_current_prototype = lo_object->get_prototype( ).
            WHILE lo_current_prototype IS BOUND.
              IF lo_current_prototype = lo_prototype.
                lv_instance = abap_true.
                EXIT.
              ENDIF.
              lo_current_prototype = lo_current_prototype->get_prototype( ).
            ENDWHILE.
          ELSEIF lo_prototype = mo_runtime->get_function_prototype( ).
            CLEAR lo_host_callable.
            CLEAR lo_closure.
            TRY.
                lo_closure ?= ls_left-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
            TRY.
                lo_host_callable ?= ls_left-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
            IF lo_closure IS BOUND OR lo_host_callable IS BOUND.
              lv_instance = abap_true.
            ENDIF.
          ENDIF.
          ls_value = zcl_qjs_value=>new_boolean( lv_instance ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>private_in.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          CLEAR lo_object.
          CLEAR lo_closure.
          IF ls_right-tag = zcl_qjs_value=>tag_object.
            TRY.
                lo_object ?= ls_right-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
            IF lo_object IS NOT BOUND.
              TRY.
                  lo_closure ?= ls_right-object_ref.
                  lo_object = lo_closure->get_property_storage( ).
                CATCH cx_sy_move_cast_error.
              ENDTRY.
            ENDIF.
          ENDIF.
          IF lo_object IS NOT BOUND
              OR ls_left-tag <> zcl_qjs_value=>tag_symbol.
            throw_error(
              name = 'TypeError' message = 'right-hand side of private in is not an object' ).
          ENDIF.
          ls_value = zcl_qjs_value=>new_boolean(
            lo_object->has_private_field( ls_left-symbol_id ) ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>in_operator.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          CLEAR lo_object.
          CLEAR lo_closure.
          CLEAR lo_native_function.
          IF ls_right-tag = zcl_qjs_value=>tag_object.
            TRY.
                lo_object ?= ls_right-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
            TRY.
                lo_closure ?= ls_right-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
            TRY.
                lo_native_function ?= ls_right-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
          ENDIF.
          IF lo_object IS NOT BOUND AND lo_closure IS NOT BOUND
              AND lo_native_function IS NOT BOUND.
            throw_error(
              name = 'TypeError' message = 'right-hand side of in is not an object' ).
          ENDIF.
          DATA(lv_has_property) = abap_false.
          IF ls_left-tag = zcl_qjs_value=>tag_symbol.
            IF lo_object IS BOUND.
              lv_has_property = lo_object->has_symbol_property( ls_left-symbol_id ).
            ELSEIF lo_closure IS BOUND.
              lv_has_property = lo_closure->has_symbol_property( ls_left-symbol_id ).
            ELSE.
              lv_has_property = lo_native_function->has_symbol_property(
                ls_left-symbol_id ).
            ENDIF.
          ELSE.
            lv_property_name = zcl_qjs_value=>to_string( ls_left ).
            IF lo_object IS BOUND.
              lv_has_property = lo_object->has_property( lv_property_name ).
            ELSEIF lo_closure IS BOUND.
              lv_has_property = lo_closure->has_property( lv_property_name ).
            ELSE.
              lv_has_property = lo_native_function->has_property( lv_property_name ).
            ENDIF.
          ENDIF.
          ls_value = zcl_qjs_value=>new_boolean( lv_has_property ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>equal OR zif_qjs_opcodes=>not_equal.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
          IF ls_left-tag = zcl_qjs_value=>tag_object
              AND ls_right-tag <> zcl_qjs_value=>tag_object.
            ls_left = mo_runtime->to_primitive( ls_left ).
          ELSEIF ls_right-tag = zcl_qjs_value=>tag_object
              AND ls_left-tag <> zcl_qjs_value=>tag_object.
            ls_right = mo_runtime->to_primitive( ls_right ).
          ENDIF.
          lv_equal = zcl_qjs_value=>abstract_equal( left = ls_left right = ls_right ).
          IF ls_instruction-opcode = zif_qjs_opcodes=>not_equal.
            lv_equal = xsdbool( lv_equal = abap_false ).
          ENDIF.
          ls_value = zcl_qjs_value=>new_boolean( lv_equal ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>if_false OR zif_qjs_opcodes=>if_true.
          ls_value = pop( CHANGING stack = lt_stack ).
          DATA(lv_truthy) = zcl_qjs_value=>to_boolean( ls_value ).
          IF ( ls_instruction-opcode = zif_qjs_opcodes=>if_false
                AND lv_truthy = abap_false )
              OR ( ls_instruction-opcode = zif_qjs_opcodes=>if_true
                AND lv_truthy = abap_true ).
            ls_frame-pc = ls_instruction-operand.
            MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.
          ENDIF.
        WHEN zif_qjs_opcodes=>goto.
          ls_frame-pc = ls_instruction-operand.
          MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.
        WHEN zif_qjs_opcodes=>gosub.
          APPEND ls_frame-pc TO ls_frame-subroutine_returns.
          ls_frame-pc = ls_instruction-operand.
          MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.
        WHEN zif_qjs_opcodes=>ret.
          DATA(lv_return_index) = lines( ls_frame-subroutine_returns ).
          IF lv_return_index = 0.
            IF ls_frame-abrupt_throw_pending = abap_true.
              ls_value = ls_frame-abrupt_throw_value.
              CLEAR ls_frame-abrupt_throw_pending.
              MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.
              lv_injected_throw = abap_true.
              RAISE EXCEPTION TYPE zcx_qjs_throw
                EXPORTING value = ls_value.
            ELSEIF ls_frame-abrupt_return_pending = abap_false.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'Bytecode subroutine stack underflow'.
            ENDIF.
            result = ls_frame-abrupt_return_value.
            WHILE lines( lt_stack ) > ls_frame-stack_base.
              DELETE lt_stack INDEX lines( lt_stack ).
            ENDWHILE.
            DELETE lt_frames INDEX lv_frame_index.
            IF lines( lt_frames ) = 0.
              mv_generator_complete = abap_true.
              RETURN.
            ENDIF.
            APPEND result TO lt_stack.
            mo_limits->check_operand_stack( lines( lt_stack ) ).
            CONTINUE.
          ENDIF.
          READ TABLE ls_frame-subroutine_returns INDEX lv_return_index
            INTO ls_frame-pc.
          DELETE ls_frame-subroutine_returns INDEX lv_return_index.
          MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.
        WHEN zif_qjs_opcodes=>catch.
          ls_handler-target = ls_instruction-operand.
          ls_handler-finally_target = ls_instruction-operand2.
          ls_handler-stack_depth = lines( lt_stack ).
          APPEND ls_handler TO ls_frame-handlers.
          ls_value = zcl_qjs_value=>new_undefined( ).
          APPEND ls_value TO lt_stack.
          MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>leave_catch.
          ls_value = pop( CHANGING stack = lt_stack ).
          pop( CHANGING stack = lt_stack ).
          lv_handler_index = lines( ls_frame-handlers ).
          IF lv_handler_index = 0.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Bytecode catch stack underflow'.
          ENDIF.
          DELETE ls_frame-handlers INDEX lv_handler_index.
          MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.
          APPEND ls_value TO lt_stack.
        WHEN zif_qjs_opcodes=>apply.
          DATA(ls_apply_arguments) = pop( CHANGING stack = lt_stack ).
          DATA(ls_apply_callable) = pop( CHANGING stack = lt_stack ).
          DATA(ls_apply_this) = pop( CHANGING stack = lt_stack ).
          CLEAR lo_object.
          TRY.
              lo_object ?= ls_apply_arguments-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_object IS NOT BOUND OR lo_object->is_array( ) = abap_false.
            throw_error( name = 'TypeError' message = 'spread arguments are not an array' ).
          ENDIF.
          CLEAR lt_arguments.
          DATA(ls_apply_length) = lo_object->get( 'length' ).
          lv_argument_index = 0.
          WHILE lv_argument_index < ls_apply_length-int_value.
            APPEND lo_object->get_element( CONV int8( lv_argument_index ) )
              TO lt_arguments.
            lv_argument_index = lv_argument_index + 1.
          ENDWHILE.
          TRY.
              IF ls_instruction-operand = 1.
                ls_value = mo_runtime->construct_value(
                  constructor = ls_apply_callable arguments = lt_arguments ).
              ELSE.
                ls_value = mo_runtime->invoke_callable(
                  callable = ls_apply_callable this_value = ls_apply_this
                  arguments = lt_arguments ).
              ENDIF.
            CATCH zcx_qjs_error INTO lo_host_error.
              RAISE EXCEPTION TYPE zcx_qjs_throw
                EXPORTING value = mo_runtime->create_error_from_reason(
                  lo_host_error->reason ).
          ENDTRY.
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>call OR zif_qjs_opcodes=>call_method
            OR zif_qjs_opcodes=>call_constructor.
          CLEAR lt_arguments.
          DO ls_instruction-operand TIMES.
            ls_value = pop( CHANGING stack = lt_stack ).
            INSERT ls_value INTO lt_arguments INDEX 1.
          ENDDO.
          ls_value = pop( CHANGING stack = lt_stack ).
          IF ls_instruction-opcode = zif_qjs_opcodes=>call_method.
            ls_this = pop( CHANGING stack = lt_stack ).
          ELSEIF ls_instruction-opcode = zif_qjs_opcodes=>call_constructor.
            ls_this = zcl_qjs_value=>new_undefined( ).
          ELSE.
            ls_this = zcl_qjs_value=>new_undefined( ).
          ENDIF.
          IF ls_value-tag <> zcl_qjs_value=>tag_object.
            throw_error( name = 'TypeError' message = 'value is not callable' ).
          ENDIF.
          IF ls_instruction-opcode = zif_qjs_opcodes=>call_method
              AND ls_instruction-operand2 = 1.
            IF ls_frame-closure IS NOT BOUND.
              throw_error( name = 'TypeError' message = 'super constructor is invalid' ).
            ENDIF.
            DATA lo_super_result_prototype TYPE REF TO zcl_qjs_object.
            DATA lo_super_placeholder TYPE REF TO zcl_qjs_object.
            TRY.
                lo_super_placeholder ?= ls_frame-constructor_this-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
            IF lo_super_placeholder IS BOUND.
              lo_super_result_prototype = lo_super_placeholder->get_prototype( ).
            ENDIF.
            DATA(ls_super_new_target) = zcl_qjs_value=>new_object(
              ls_frame-closure ).
            TRY.
                ls_this = mo_runtime->construct_value(
                  constructor = ls_value new_target = ls_super_new_target
                  arguments = lt_arguments ).
              CATCH zcx_qjs_error INTO lo_host_error.
                RAISE EXCEPTION TYPE zcx_qjs_throw
                  EXPORTING value = mo_runtime->create_error_from_reason(
                    lo_host_error->reason ).
            ENDTRY.
            IF lo_super_result_prototype IS BOUND.
              DATA lo_super_result_object TYPE REF TO zcl_qjs_object.
              TRY.
                  lo_super_result_object ?= ls_this-object_ref.
                CATCH cx_sy_move_cast_error.
              ENDTRY.
              IF lo_super_result_object IS BOUND.
                lo_super_result_object->set_prototype( lo_super_result_prototype ).
              ENDIF.
            ENDIF.
            DATA(lv_super_this_index) = 1.
            IF ls_frame-function->has_self_binding( ) = abap_true.
              lv_super_this_index = 2.
            ENDIF.
            READ TABLE ls_frame-locals INDEX lv_super_this_index INTO lo_cell.
            IF sy-subrc = 0.
              lo_cell->set( ls_this ).
            ENDIF.
            IF ls_frame-is_constructor = abap_true.
              ls_frame-constructor_this = ls_this.
              MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.
            ENDIF.
            ls_frame-closure->initialize_instance_fields( receiver = ls_this ).
            APPEND ls_this TO lt_stack.
            mo_limits->check_operand_stack( lines( lt_stack ) ).
            CONTINUE.
          ENDIF.
          CLEAR lo_host_constructor.
          IF ls_instruction-opcode = zif_qjs_opcodes=>call_constructor.
            TRY.
                lo_host_constructor ?= ls_value-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
            IF lo_host_constructor IS BOUND.
              TRY.
                  ls_value = lo_host_constructor->construct(
                    runtime = mo_runtime arguments = lt_arguments ).
                CATCH zcx_qjs_error INTO lo_host_error.
                  RAISE EXCEPTION TYPE zcx_qjs_throw
                    EXPORTING value = mo_runtime->create_error_from_reason(
                      lo_host_error->reason ).
              ENDTRY.
              IF ls_value-tag <> zcl_qjs_value=>tag_object.
                RAISE EXCEPTION TYPE zcx_qjs_error
                  EXPORTING reason = 'Host constructor must return an object'.
              ENDIF.
              APPEND ls_value TO lt_stack.
              mo_limits->check_operand_stack( lines( lt_stack ) ).
              CONTINUE.
            ENDIF.
          ENDIF.
          CLEAR lo_host_callable.
          TRY.
              lo_host_callable ?= ls_value-object_ref.
            CATCH cx_sy_move_cast_error.
          ENDTRY.
          IF lo_host_callable IS BOUND.
            IF ls_instruction-opcode = zif_qjs_opcodes=>call_constructor.
              throw_error( name = 'TypeError' message = 'value is not constructable' ).
            ENDIF.
            TRY.
                ls_value = lo_host_callable->call(
                  this_value = ls_this arguments = lt_arguments ).
              CATCH zcx_qjs_error INTO lo_host_error.
                RAISE EXCEPTION TYPE zcx_qjs_throw
                  EXPORTING value = mo_runtime->create_error_from_reason(
                    lo_host_error->reason ).
            ENDTRY.
            APPEND ls_value TO lt_stack.
            mo_limits->check_operand_stack( lines( lt_stack ) ).
            CONTINUE.
          ENDIF.
          CLEAR lo_called.
          CLEAR lo_closure.
          TRY.
              lo_closure ?= ls_value-object_ref.
              lo_called = lo_closure->get_function( ).
            CATCH cx_sy_move_cast_error.
              TRY.
                  lo_called ?= ls_value-object_ref.
                CATCH cx_sy_move_cast_error.
                  throw_error( name = 'TypeError' message = 'object is not callable' ).
              ENDTRY.
          ENDTRY.
          IF lo_called->is_class_constructor( ) = abap_true
              AND ls_instruction-opcode <> zif_qjs_opcodes=>call_constructor
              AND NOT ( ls_instruction-opcode = zif_qjs_opcodes=>call_method
                AND ls_instruction-operand2 = 1 ).
            throw_error(
              name    = 'TypeError'
              message = 'class constructor cannot be called without new' ).
          ENDIF.
          IF ls_instruction-opcode = zif_qjs_opcodes=>call_constructor.
            IF lo_called->is_constructible( ) = abap_false.
              throw_error( name = 'TypeError' message = 'value is not constructable' ).
            ENDIF.
            CLEAR lo_prototype.
            IF lo_closure IS BOUND.
              lo_prototype = lo_closure->get_prototype_object( ).
            ENDIF.
            lo_object = mo_runtime->create_object( prototype = lo_prototype ).
            ls_this = zcl_qjs_value=>new_object( lo_object ).
          ENDIF.
          IF lo_called->is_generator( ) = abap_true
              AND lo_called->is_async( ) = abap_true.
            IF lo_closure IS NOT BOUND.
              throw_error(
                name = 'TypeError' message = 'async generator has no closure' ).
            ENDIF.
            lo_object = mo_runtime->create_async_generator(
              closure = lo_closure this_value = ls_this arguments = lt_arguments ).
            APPEND zcl_qjs_value=>new_object( lo_object ) TO lt_stack.
            mo_limits->check_operand_stack( lines( lt_stack ) ).
            CONTINUE.
          ENDIF.
          IF lo_called->is_generator( ) = abap_true.
            IF lo_closure IS NOT BOUND.
              throw_error(
                name = 'TypeError' message = 'generator function has no closure' ).
            ENDIF.
            lo_object = mo_runtime->create_generator(
              closure = lo_closure this_value = ls_this arguments = lt_arguments ).
            APPEND zcl_qjs_value=>new_object( lo_object ) TO lt_stack.
            mo_limits->check_operand_stack( lines( lt_stack ) ).
            CONTINUE.
          ENDIF.
          IF lo_called->is_async( ) = abap_true.
            IF lo_closure IS NOT BOUND.
              throw_error(
                name = 'TypeError' message = 'async function has no closure' ).
            ENDIF.
            DATA(lo_async_task) = NEW zcl_qjs_async_task(
              runtime = mo_runtime closure = lo_closure this_value = ls_this
              arguments = lt_arguments ).
            APPEND lo_async_task->start( ) TO lt_stack.
            mo_limits->check_operand_stack( lines( lt_stack ) ).
            CONTINUE.
          ENDIF.
          IF lo_closure IS BOUND
              AND lo_called->is_default_derived_constructor( ) = abap_true.
            TRY.
                ls_this = lo_closure->invoke_default_derived(
                  receiver = ls_this arguments = lt_arguments ).
              CATCH zcx_qjs_error INTO lo_host_error.
                RAISE EXCEPTION TYPE zcx_qjs_throw
                  EXPORTING value = mo_runtime->create_error_from_reason(
                    lo_host_error->reason ).
            ENDTRY.
            IF ls_instruction-opcode = zif_qjs_opcodes=>call_method
                AND ls_instruction-operand2 = 1
                AND ls_frame-closure IS BOUND.
              ls_frame-closure->initialize_instance_fields( receiver = ls_this ).
            ENDIF.
            IF ls_instruction-opcode = zif_qjs_opcodes=>call_constructor.
              ls_value = ls_this.
            ELSE.
              ls_value = zcl_qjs_value=>new_undefined( ).
            ENDIF.
            APPEND ls_value TO lt_stack.
            mo_limits->check_operand_stack( lines( lt_stack ) ).
            CONTINUE.
          ENDIF.
          IF lo_closure IS BOUND
              AND lo_called->is_class_constructor( ) = abap_true.
            IF lo_called->is_derived_class( ) = abap_false.
              lo_closure->initialize_instance_fields( receiver = ls_this ).
            ENDIF.
          ENDIF.
          CLEAR ls_called_frame.
          ls_called_frame-function = lo_called.
          ls_called_frame-arguments = lt_arguments.
          ls_called_frame-pc = 1.
          ls_called_frame-stack_base = lines( lt_stack ).
          IF ls_instruction-opcode = zif_qjs_opcodes=>call_constructor.
            ls_called_frame-is_constructor = abap_true.
            ls_called_frame-constructor_this = ls_this.
          ENDIF.
          IF lo_closure IS BOUND.
            ls_called_frame-captures = lo_closure->get_captures( ).
            ls_called_frame-closure = lo_closure.
          ENDIF.
          IF ls_instruction-opcode = zif_qjs_opcodes=>call_method
              AND ls_instruction-operand2 = 1.
            ls_called_frame-after_return_fields = ls_frame-closure.
            ls_called_frame-after_return_receiver = ls_this.
          ENDIF.
          DO lo_called->get_local_count( ) TIMES.
            DATA(ls_undefined) = zcl_qjs_value=>new_undefined( ).
            ls_local_spec = lo_called->get_local_spec( sy-index - 1 ).
            CREATE OBJECT lo_cell
              EXPORTING value = ls_undefined initialized = ls_local_spec-initialized
                mutable = ls_local_spec-mutable runtime = mo_runtime.
            APPEND lo_cell TO ls_called_frame-locals.
          ENDDO.
          lv_local_index = 1.
          IF lo_called->has_self_binding( ) = abap_true.
            IF lo_closure IS BOUND.
              DATA(ls_self) = zcl_qjs_value=>new_object( lo_closure ).
            ELSE.
              ls_self = zcl_qjs_value=>new_object( lo_called ).
            ENDIF.
            READ TABLE ls_called_frame-locals INDEX 1 INTO lo_cell.
            lo_cell->set( ls_self ).
            lv_local_index = 2.
          ENDIF.
          IF lo_called->has_this_binding( ) = abap_true.
            READ TABLE ls_called_frame-locals INDEX lv_local_index INTO lo_cell.
            lo_cell->set( ls_this ).
            lv_local_index = lv_local_index + 1.
          ENDIF.
          IF lo_called->has_arguments_binding( ) = abap_true.
            lo_object = mo_runtime->create_array( ).
            lv_element_index = 0.
            LOOP AT lt_arguments INTO ls_value.
              lo_object->set_element( index = lv_element_index value = ls_value ).
              lv_element_index = lv_element_index + 1.
            ENDLOOP.
            ls_value = zcl_qjs_value=>new_object( lo_object ).
            READ TABLE ls_called_frame-locals INDEX lv_local_index INTO lo_cell.
            lo_cell->set( ls_value ).
            lv_local_index = lv_local_index + 1.
          ENDIF.
          lv_argument_index = 1.
          WHILE lv_argument_index <= lo_called->get_parameter_count( ).
            READ TABLE lt_arguments INDEX lv_argument_index INTO ls_value.
            IF sy-subrc <> 0.
              ls_value = zcl_qjs_value=>new_undefined( ).
            ENDIF.
            READ TABLE ls_called_frame-locals INDEX lv_local_index INTO lo_cell.
            lo_cell->set( ls_value ).
            lv_argument_index = lv_argument_index + 1.
            lv_local_index = lv_local_index + 1.
          ENDWHILE.
          APPEND ls_called_frame TO lt_frames.
          mo_limits->check_frame_stack( lines( lt_frames ) ).
        WHEN zif_qjs_opcodes=>yield_star.
          DATA lv_yield_star_kind TYPE i.
          DATA ls_yield_star_input TYPE zcl_qjs_value=>ty_value.
          DATA ls_yield_star_iterator TYPE zcl_qjs_value=>ty_value.
          DATA lv_yield_star_pass_value TYPE abap_bool.
          IF mv_generator_delegating = abap_true.
            ls_value = pop( CHANGING stack = lt_stack ).
            lv_yield_star_kind = ls_value-int_value.
            ls_yield_star_input = pop( CHANGING stack = lt_stack ).
            ls_yield_star_iterator = pop( CHANGING stack = lt_stack ).
            lv_yield_star_pass_value = abap_true.
            CLEAR mv_generator_delegating.
          ELSE.
            ls_yield_star_iterator = pop( CHANGING stack = lt_stack ).
            ls_yield_star_input = zcl_qjs_value=>new_undefined( ).
          ENDIF.
          ls_iterator_resume = mo_runtime->iterator_resume(
            iterator   = ls_yield_star_iterator
            kind       = lv_yield_star_kind
            value      = ls_yield_star_input
            pass_value = lv_yield_star_pass_value ).
          IF ls_iterator_resume-found = abap_false.
            IF lv_yield_star_kind = 0.
              throw_error(
                name = 'TypeError' message = 'iterator next method is missing' ).
            ELSEIF lv_yield_star_kind = 2.
              mo_runtime->iterator_close( ls_yield_star_iterator ).
              throw_error(
                name = 'TypeError' message = 'iterator throw method is missing' ).
            ENDIF.
          ENDIF.
          IF ls_iterator_resume-found = abap_true
              AND ls_iterator_resume-done = abap_false.
            APPEND ls_yield_star_iterator TO lt_stack.
            READ TABLE lt_frames INDEX lv_frame_index INTO ls_frame.
            ls_frame-pc = ls_frame-pc - 1.
            MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.
            mt_saved_stack = lt_stack.
            mt_saved_frames = lt_frames.
            mv_generator_delegating = abap_true.
            mv_generator_suspended = abap_true.
            result = ls_iterator_resume-value.
            RETURN.
          ENDIF.
          IF lv_yield_star_kind = 1.
            IF ls_iterator_resume-found = abap_true.
              ls_value = ls_iterator_resume-value.
            ELSE.
              ls_value = ls_yield_star_input.
            ENDIF.
            READ TABLE lt_frames INDEX lv_frame_index INTO ls_frame.
            WHILE lines( lt_stack ) > ls_frame-stack_base.
              DELETE lt_stack INDEX lines( lt_stack ).
            ENDWHILE.
            APPEND ls_value TO lt_stack.
            CLEAR ls_frame-subroutine_returns.
            CLEAR lt_resume_finally_targets.
            LOOP AT ls_frame-handlers INTO ls_handler.
              IF ls_handler-finally_target > 0.
                APPEND ls_handler-finally_target TO lt_resume_finally_targets.
              ENDIF.
            ENDLOOP.
            CLEAR ls_frame-handlers.
            lv_resume_finally_index = lines( lt_resume_finally_targets ).
            IF lv_resume_finally_index = 0.
              mv_generator_complete = abap_true.
              result = ls_value.
              RETURN.
            ENDIF.
            ls_frame-abrupt_return_pending = abap_true.
            ls_frame-abrupt_return_value = ls_value.
            READ TABLE lt_resume_finally_targets INDEX lv_resume_finally_index
              INTO ls_frame-pc.
            DO lv_resume_finally_index - 1 TIMES.
              READ TABLE lt_resume_finally_targets INDEX sy-index
                INTO lv_resume_finally_target.
              APPEND lv_resume_finally_target TO ls_frame-subroutine_returns.
            ENDDO.
            MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.
          ELSE.
            APPEND ls_iterator_resume-value TO lt_stack.
            mo_limits->check_operand_stack( lines( lt_stack ) ).
          ENDIF.
        WHEN zif_qjs_opcodes=>initial_yield.
          result = zcl_qjs_value=>new_undefined( ).
          mt_saved_stack = lt_stack.
          mt_saved_frames = lt_frames.
          mv_generator_suspended = abap_true.
          RETURN.
        WHEN zif_qjs_opcodes=>yield.
          result = pop( CHANGING stack = lt_stack ).
          mt_saved_stack = lt_stack.
          mt_saved_frames = lt_frames.
          mv_generator_suspended = abap_true.
          RETURN.
        WHEN zif_qjs_opcodes=>async_yield_star.
          result = pop( CHANGING stack = lt_stack ).
          mt_saved_stack = lt_stack.
          mt_saved_frames = lt_frames.
          mv_generator_suspended = abap_true.
          mv_async_yield_star = abap_true.
          RETURN.
        WHEN zif_qjs_opcodes=>await.
          result = pop( CHANGING stack = lt_stack ).
          mt_saved_stack = lt_stack.
          mt_saved_frames = lt_frames.
          mv_generator_suspended = abap_true.
          mv_await_suspended = abap_true.
          RETURN.
        WHEN zif_qjs_opcodes=>return.
          result = pop( CHANGING stack = lt_stack ).
          IF ls_frame-is_constructor = abap_true
              AND result-tag <> zcl_qjs_value=>tag_object.
            result = ls_frame-constructor_this.
          ENDIF.
          IF ls_frame-after_return_fields IS BOUND.
            ls_frame-after_return_fields->initialize_instance_fields(
              receiver = ls_frame-after_return_receiver ).
          ENDIF.
          WHILE lines( lt_stack ) > ls_frame-stack_base.
            DELETE lt_stack INDEX lines( lt_stack ).
          ENDWHILE.
          DELETE lt_frames INDEX lv_frame_index.
          IF lines( lt_frames ) = 0.
            mv_generator_complete = abap_true.
            RETURN.
          ENDIF.
          APPEND result TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>return_undefined.
          IF ls_frame-is_constructor = abap_true.
            result = ls_frame-constructor_this.
          ELSE.
            result = zcl_qjs_value=>new_undefined( ).
          ENDIF.
          IF ls_frame-after_return_fields IS BOUND.
            ls_frame-after_return_fields->initialize_instance_fields(
              receiver = ls_frame-after_return_receiver ).
          ENDIF.
          WHILE lines( lt_stack ) > ls_frame-stack_base.
            DELETE lt_stack INDEX lines( lt_stack ).
          ENDWHILE.
          DELETE lt_frames INDEX lv_frame_index.
          IF lines( lt_frames ) = 0.
            mv_generator_complete = abap_true.
            RETURN.
          ENDIF.
          APPEND result TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>throw.
          ls_value = pop( CHANGING stack = lt_stack ).
          RAISE EXCEPTION TYPE zcx_qjs_throw
            EXPORTING value = ls_value.
        WHEN OTHERS.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING
              reason = 'Unknown zqjs opcode'.
        ENDCASE.
      CATCH zcx_qjs_throw INTO lo_throw.
        lv_handled = abap_false.
        WHILE lines( lt_frames ) > 0.
          lv_frame_index = lines( lt_frames ).
          READ TABLE lt_frames INDEX lv_frame_index INTO ls_frame.
          lv_handler_index = lines( ls_frame-handlers ).
          IF lv_handler_index > 0.
            READ TABLE ls_frame-handlers INDEX lv_handler_index INTO ls_handler.
            WHILE lines( lt_stack ) > ls_handler-stack_depth.
              DELETE lt_stack INDEX lines( lt_stack ).
            ENDWHILE.
            DELETE ls_frame-handlers INDEX lv_handler_index.
            IF ls_handler-target = 0.
              IF lv_injected_throw = abap_true
                  AND ls_handler-finally_target > 0.
                CLEAR ls_frame-subroutine_returns.
                ls_frame-abrupt_throw_pending = abap_true.
                ls_frame-abrupt_throw_value = lo_throw->value.
                ls_frame-pc = ls_handler-finally_target.
                MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.
                lv_injected_throw = abap_false.
                lv_handled = abap_true.
                EXIT.
              ENDIF.
              MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.
              CONTINUE.
            ENDIF.
            lv_injected_throw = abap_false.
            CLEAR ls_frame-abrupt_throw_pending.
            ls_frame-pc = ls_handler-target.
            MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.
            APPEND lo_throw->value TO lt_stack.
            mo_limits->check_operand_stack( lines( lt_stack ) ).
            lv_handled = abap_true.
            EXIT.
          ENDIF.
          WHILE lines( lt_stack ) > ls_frame-stack_base.
            DELETE lt_stack INDEX lines( lt_stack ).
          ENDWHILE.
          DELETE lt_frames INDEX lv_frame_index.
        ENDWHILE.
        IF lv_handled = abap_false.
          RAISE EXCEPTION TYPE zcx_qjs_throw
            EXPORTING value = lo_throw->value.
        ENDIF.
      ENDTRY.
    ENDWHILE.

    RAISE EXCEPTION TYPE zcx_qjs_error
      EXPORTING
        reason = 'Bytecode function completed without return'.
  ENDMETHOD.

  METHOD was_suspended.
    result = mv_generator_suspended.
  ENDMETHOD.

  METHOD was_await_suspended.
    result = mv_await_suspended.
  ENDMETHOD.
  METHOD was_async_yield_star_suspended.
    result = mv_async_yield_star.
  ENDMETHOD.

  METHOD is_complete.
    result = mv_generator_complete.
  ENDMETHOD.
ENDCLASS.
