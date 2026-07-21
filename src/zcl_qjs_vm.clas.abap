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
      RETURNING
        VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING
        zcx_qjs_error.

  PRIVATE SECTION.
    TYPES ty_stack TYPE STANDARD TABLE OF zcl_qjs_value=>ty_value WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_handler,
      target TYPE i,
      stack_depth TYPE i,
    END OF ty_handler.
    TYPES ty_handlers TYPE STANDARD TABLE OF ty_handler WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_frame,
        function TYPE REF TO zcl_qjs_function,
        pc       TYPE i,
        locals   TYPE ty_cells,
        captures TYPE zcl_qjs_closure=>ty_cells,
        handlers TYPE ty_handlers,
        stack_base TYPE i,
        subroutine_returns TYPE STANDARD TABLE OF i WITH DEFAULT KEY,
        is_constructor TYPE abap_bool,
        constructor_this TYPE zcl_qjs_value=>ty_value,
      END OF ty_frame.
    TYPES ty_frames TYPE STANDARD TABLE OF ty_frame WITH DEFAULT KEY.

    DATA mo_limits TYPE REF TO zcl_qjs_limits.
    DATA mo_runtime TYPE REF TO zcl_qjs_runtime.

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

    IF function IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING
          reason = 'Cannot execute an initial bytecode function'.
    ENDIF.
    ls_frame-function = function.
    ls_frame-pc = 1.
    ls_frame-stack_base = 0.
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

    WHILE lines( lt_frames ) > 0.
      mo_limits->consume( ).
      lv_frame_index = lines( lt_frames ).
      READ TABLE lt_frames INDEX lv_frame_index INTO ls_frame.
      ls_instruction = ls_frame-function->get_instruction( ls_frame-pc ).
      ls_frame-pc = ls_frame-pc + 1.
      MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.

      TRY.
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
        WHEN zif_qjs_opcodes=>get_field OR zif_qjs_opcodes=>get_field_for_call.
          ls_value = pop( CHANGING stack = lt_stack ).
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
        WHEN zif_qjs_opcodes=>get_element OR zif_qjs_opcodes=>get_element_for_call.
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
              name = 'TypeError' message = 'property read from a non-object value' ).
          ENDIF.
          IF ls_right-tag = zcl_qjs_value=>tag_int.
            lv_element_index = ls_right-int_value.
            lv_property_name = lv_element_index.
            CONDENSE lv_property_name NO-GAPS.
          ELSE.
            lv_property_name = zcl_qjs_value=>to_string( ls_right ).
          ENDIF.
          IF lo_object IS BOUND AND ls_right-tag = zcl_qjs_value=>tag_int.
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
          IF ls_right-tag = zcl_qjs_value=>tag_int.
            lv_element_index = ls_right-int_value.
            lv_property_name = lv_element_index.
            CONDENSE lv_property_name NO-GAPS.
          ELSE.
            lv_property_name = zcl_qjs_value=>to_string( ls_right ).
          ENDIF.
          IF lo_object IS BOUND AND ls_right-tag = zcl_qjs_value=>tag_int.
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
          IF ls_right-tag = zcl_qjs_value=>tag_int.
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
          IF lo_object IS BOUND.
            DATA(lv_deleted) = lo_object->delete( lv_property_name ).
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
          READ TABLE ls_frame-locals INDEX lv_local_index INTO lo_cell.
          IF sy-subrc <> 0.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Bytecode lexical index out of bounds'.
          ENDIF.
          lo_cell->reset_uninitialized( ).
        WHEN zif_qjs_opcodes=>push_i32.
          ls_value = zcl_qjs_value=>new_int( ls_instruction-operand ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>push_const.
          ls_value = ls_frame-function->get_constant( ls_instruction-operand ).
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
          lo_properties = mo_runtime->create_object( ).
          lo_prototype = mo_runtime->create_object( ).
          CREATE OBJECT lo_closure
            EXPORTING function = lo_called captures = lt_capture_cells
              properties = lo_properties prototype_object = lo_prototype
              runtime = mo_runtime.
          ls_value = zcl_qjs_value=>new_object( lo_closure ).
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
          IF ls_right-tag <> zcl_qjs_value=>tag_object.
            throw_error(
              name = 'TypeError'
              message = 'right-hand side of instanceof is not constructable' ).
          ENDIF.
          TRY.
              lo_closure ?= ls_right-object_ref.
            CATCH cx_sy_move_cast_error.
              throw_error(
                name = 'TypeError'
                message = 'right-hand side of instanceof is not constructable' ).
          ENDTRY.
          IF lo_closure IS NOT BOUND.
            throw_error(
              name = 'TypeError'
              message = 'right-hand side of instanceof is not constructable' ).
          ENDIF.
          lo_prototype = lo_closure->get_prototype_object( ).
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
          ENDIF.
          ls_value = zcl_qjs_value=>new_boolean( lv_instance ).
          APPEND ls_value TO lt_stack.
          mo_limits->check_operand_stack( lines( lt_stack ) ).
        WHEN zif_qjs_opcodes=>equal OR zif_qjs_opcodes=>not_equal.
          ls_right = pop( CHANGING stack = lt_stack ).
          ls_left = pop( CHANGING stack = lt_stack ).
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
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'Bytecode subroutine stack underflow'.
          ENDIF.
          READ TABLE ls_frame-subroutine_returns INDEX lv_return_index
            INTO ls_frame-pc.
          DELETE ls_frame-subroutine_returns INDEX lv_return_index.
          MODIFY lt_frames FROM ls_frame INDEX lv_frame_index.
        WHEN zif_qjs_opcodes=>catch.
          ls_handler-target = ls_instruction-operand.
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
          IF ls_instruction-opcode = zif_qjs_opcodes=>call_constructor.
            CLEAR lo_prototype.
            IF lo_closure IS BOUND.
              lo_prototype = lo_closure->get_prototype_object( ).
            ENDIF.
            lo_object = mo_runtime->create_object( prototype = lo_prototype ).
            ls_this = zcl_qjs_value=>new_object( lo_object ).
          ENDIF.
          CLEAR ls_called_frame.
          ls_called_frame-function = lo_called.
          ls_called_frame-pc = 1.
          ls_called_frame-stack_base = lines( lt_stack ).
          IF ls_instruction-opcode = zif_qjs_opcodes=>call_constructor.
            ls_called_frame-is_constructor = abap_true.
            ls_called_frame-constructor_this = ls_this.
          ENDIF.
          IF lo_closure IS BOUND.
            ls_called_frame-captures = lo_closure->get_captures( ).
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
        WHEN zif_qjs_opcodes=>return.
          result = pop( CHANGING stack = lt_stack ).
          IF ls_frame-is_constructor = abap_true
              AND result-tag <> zcl_qjs_value=>tag_object.
            result = ls_frame-constructor_this.
          ENDIF.
          WHILE lines( lt_stack ) > ls_frame-stack_base.
            DELETE lt_stack INDEX lines( lt_stack ).
          ENDWHILE.
          DELETE lt_frames INDEX lv_frame_index.
          IF lines( lt_frames ) = 0.
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
          WHILE lines( lt_stack ) > ls_frame-stack_base.
            DELETE lt_stack INDEX lines( lt_stack ).
          ENDWHILE.
          DELETE lt_frames INDEX lv_frame_index.
          IF lines( lt_frames ) = 0.
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
ENDCLASS.
