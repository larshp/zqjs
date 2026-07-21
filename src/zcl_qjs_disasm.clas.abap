CLASS zcl_qjs_disasm DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS disassemble
      IMPORTING
        function      TYPE REF TO zcl_qjs_function
      RETURNING
        VALUE(result) TYPE string
      RAISING
        zcx_qjs_error.

  PRIVATE SECTION.
    CLASS-METHODS opcode_name
      IMPORTING
        opcode        TYPE i
      RETURNING
        VALUE(result) TYPE string
      RAISING
        zcx_qjs_error.
ENDCLASS.

CLASS zcl_qjs_disasm IMPLEMENTATION.
  METHOD opcode_name.
    CASE opcode.
      WHEN zif_qjs_opcodes=>push_i32.
        result = 'push_i32'.
      WHEN zif_qjs_opcodes=>push_const.
        result = 'push_const'.
      WHEN zif_qjs_opcodes=>push_true. result = 'push_true'.
      WHEN zif_qjs_opcodes=>push_false. result = 'push_false'.
      WHEN zif_qjs_opcodes=>push_null. result = 'push_null'.
      WHEN zif_qjs_opcodes=>push_undefined. result = 'push_undefined'.
      WHEN zif_qjs_opcodes=>add.
        result = 'add'.
      WHEN zif_qjs_opcodes=>subtract.
        result = 'subtract'.
      WHEN zif_qjs_opcodes=>multiply.
        result = 'multiply'.
      WHEN zif_qjs_opcodes=>divide.
        result = 'divide'.
      WHEN zif_qjs_opcodes=>negate.
        result = 'negate'.
      WHEN zif_qjs_opcodes=>return.
        result = 'return'.
      WHEN zif_qjs_opcodes=>less_than. result = 'less_than'.
      WHEN zif_qjs_opcodes=>less_equal. result = 'less_equal'.
      WHEN zif_qjs_opcodes=>greater_than. result = 'greater_than'.
      WHEN zif_qjs_opcodes=>greater_equal. result = 'greater_equal'.
      WHEN zif_qjs_opcodes=>strict_equal. result = 'strict_equal'.
      WHEN zif_qjs_opcodes=>strict_not_equal. result = 'strict_not_equal'.
      WHEN zif_qjs_opcodes=>drop. result = 'drop'.
      WHEN zif_qjs_opcodes=>if_false. result = 'if_false'.
      WHEN zif_qjs_opcodes=>if_true. result = 'if_true'.
      WHEN zif_qjs_opcodes=>goto. result = 'goto'.
      WHEN zif_qjs_opcodes=>get_local. result = 'get_local'.
      WHEN zif_qjs_opcodes=>put_local. result = 'put_local'.
      WHEN zif_qjs_opcodes=>set_local. result = 'set_local'.
      WHEN zif_qjs_opcodes=>call. result = 'call'.
      WHEN zif_qjs_opcodes=>return_undefined. result = 'return_undefined'.
      WHEN zif_qjs_opcodes=>new_object. result = 'new_object'.
      WHEN zif_qjs_opcodes=>duplicate. result = 'duplicate'.
      WHEN zif_qjs_opcodes=>duplicate_two. result = 'duplicate_two'.
      WHEN zif_qjs_opcodes=>insert_two. result = 'insert_two'.
      WHEN zif_qjs_opcodes=>insert_three. result = 'insert_three'.
      WHEN zif_qjs_opcodes=>permute_three. result = 'permute_three'.
      WHEN zif_qjs_opcodes=>permute_four. result = 'permute_four'.
      WHEN zif_qjs_opcodes=>new_array. result = 'new_array'.
      WHEN zif_qjs_opcodes=>call_method. result = 'call_method'.
      WHEN zif_qjs_opcodes=>call_constructor. result = 'call_constructor'.
      WHEN zif_qjs_opcodes=>get_field. result = 'get_field'.
      WHEN zif_qjs_opcodes=>get_field_for_call. result = 'get_field_for_call'.
      WHEN zif_qjs_opcodes=>put_field. result = 'put_field'.
      WHEN zif_qjs_opcodes=>get_element. result = 'get_element'.
      WHEN zif_qjs_opcodes=>get_element_for_call. result = 'get_element_for_call'.
      WHEN zif_qjs_opcodes=>put_element. result = 'put_element'.
      WHEN zif_qjs_opcodes=>throw. result = 'throw'.
      WHEN zif_qjs_opcodes=>catch. result = 'catch'.
      WHEN zif_qjs_opcodes=>leave_catch. result = 'leave_catch'.
      WHEN zif_qjs_opcodes=>gosub. result = 'gosub'.
      WHEN zif_qjs_opcodes=>ret. result = 'ret'.
      WHEN zif_qjs_opcodes=>make_closure. result = 'make_closure'.
      WHEN zif_qjs_opcodes=>get_capture. result = 'get_capture'.
      WHEN zif_qjs_opcodes=>put_capture. result = 'put_capture'.
      WHEN zif_qjs_opcodes=>set_capture. result = 'set_capture'.
      WHEN zif_qjs_opcodes=>get_lexical. result = 'get_lexical'.
      WHEN zif_qjs_opcodes=>put_lexical. result = 'put_lexical'.
      WHEN zif_qjs_opcodes=>set_lexical. result = 'set_lexical'.
      WHEN zif_qjs_opcodes=>initialize_lexical. result = 'initialize_lexical'.
      WHEN zif_qjs_opcodes=>reset_lexical. result = 'reset_lexical'.
      WHEN zif_qjs_opcodes=>logical_not. result = 'logical_not'.
      WHEN zif_qjs_opcodes=>type_of. result = 'type_of'.
      WHEN zif_qjs_opcodes=>bitwise_not. result = 'bitwise_not'.
      WHEN zif_qjs_opcodes=>bitwise_and. result = 'bitwise_and'.
      WHEN zif_qjs_opcodes=>bitwise_xor. result = 'bitwise_xor'.
      WHEN zif_qjs_opcodes=>bitwise_or. result = 'bitwise_or'.
      WHEN zif_qjs_opcodes=>shift_left. result = 'shift_left'.
      WHEN zif_qjs_opcodes=>shift_right. result = 'shift_right'.
      WHEN zif_qjs_opcodes=>shift_right_unsigned. result = 'shift_right_unsigned'.
      WHEN zif_qjs_opcodes=>delete_property. result = 'delete_property'.
      WHEN zif_qjs_opcodes=>modulo. result = 'modulo'.
      WHEN zif_qjs_opcodes=>increment. result = 'increment'.
      WHEN zif_qjs_opcodes=>decrement. result = 'decrement'.
      WHEN zif_qjs_opcodes=>equal. result = 'equal'.
      WHEN zif_qjs_opcodes=>not_equal. result = 'not_equal'.
      WHEN zif_qjs_opcodes=>instance_of. result = 'instance_of'.
      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING
            reason = 'Cannot disassemble unknown opcode'.
    ENDCASE.
  ENDMETHOD.

  METHOD disassemble.
    DATA lt_code TYPE zcl_qjs_function=>ty_code.
    DATA ls_instruction TYPE zcl_qjs_function=>ty_instruction.
    DATA lv_name TYPE string.
    DATA lv_operand TYPE string.
    DATA lv_line TYPE string.
    IF function IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING
          reason = 'Cannot disassemble an initial function'.
    ENDIF.
    lt_code = function->get_code( ).
    LOOP AT lt_code INTO ls_instruction.
      lv_name = opcode_name( ls_instruction-opcode ).
      lv_line = lv_name.
      IF ls_instruction-opcode = zif_qjs_opcodes=>push_i32
          OR ls_instruction-opcode = zif_qjs_opcodes=>push_const
          OR ls_instruction-opcode = zif_qjs_opcodes=>make_closure
          OR ls_instruction-opcode = zif_qjs_opcodes=>if_false
          OR ls_instruction-opcode = zif_qjs_opcodes=>if_true
          OR ls_instruction-opcode = zif_qjs_opcodes=>goto
          OR ls_instruction-opcode = zif_qjs_opcodes=>catch
          OR ls_instruction-opcode = zif_qjs_opcodes=>gosub
          OR ls_instruction-opcode = zif_qjs_opcodes=>get_local
          OR ls_instruction-opcode = zif_qjs_opcodes=>put_local
          OR ls_instruction-opcode = zif_qjs_opcodes=>set_local
          OR ls_instruction-opcode = zif_qjs_opcodes=>call
          OR ls_instruction-opcode = zif_qjs_opcodes=>call_method
          OR ls_instruction-opcode = zif_qjs_opcodes=>call_constructor
          OR ls_instruction-opcode = zif_qjs_opcodes=>new_array
          OR ls_instruction-opcode = zif_qjs_opcodes=>get_field
          OR ls_instruction-opcode = zif_qjs_opcodes=>get_field_for_call
          OR ls_instruction-opcode = zif_qjs_opcodes=>put_field
          OR ls_instruction-opcode = zif_qjs_opcodes=>get_capture
          OR ls_instruction-opcode = zif_qjs_opcodes=>put_capture
          OR ls_instruction-opcode = zif_qjs_opcodes=>set_capture
          OR ls_instruction-opcode = zif_qjs_opcodes=>get_lexical
          OR ls_instruction-opcode = zif_qjs_opcodes=>put_lexical
          OR ls_instruction-opcode = zif_qjs_opcodes=>set_lexical
          OR ls_instruction-opcode = zif_qjs_opcodes=>initialize_lexical
          OR ls_instruction-opcode = zif_qjs_opcodes=>reset_lexical.
        lv_operand = ls_instruction-operand.
        CONDENSE lv_operand NO-GAPS.
        lv_line = lv_line && ` ` && lv_operand.
      ENDIF.
      IF result IS INITIAL.
        result = lv_line.
      ELSE.
        result = result && cl_abap_char_utilities=>newline && lv_line.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
