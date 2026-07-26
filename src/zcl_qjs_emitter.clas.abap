CLASS zcl_qjs_emitter DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING limits TYPE REF TO zcl_qjs_limits OPTIONAL
      RAISING zcx_qjs_error.

    METHODS emit
      IMPORTING
        opcode   TYPE i
        operand  TYPE i DEFAULT 0
        operand2 TYPE i DEFAULT 0
      RAISING zcx_qjs_error.

    METHODS to_function
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_function
      RAISING zcx_qjs_error.

    METHODS emit_constant
      IMPORTING value TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS emit_closure
      IMPORTING value TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS add_constant
      IMPORTING value         TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE i.

    METHODS position RETURNING VALUE(result) TYPE i.
    METHODS patch
      IMPORTING instruction TYPE i target TYPE i
      RAISING zcx_qjs_error.
    METHODS patch_second
      IMPORTING instruction TYPE i target TYPE i
      RAISING zcx_qjs_error.
    METHODS replace
      IMPORTING instruction TYPE i opcode TYPE i operand TYPE i DEFAULT 0
      RAISING zcx_qjs_error.
    METHODS allocate_local
      IMPORTING initialized   TYPE abap_bool DEFAULT abap_true
        mutable               TYPE abap_bool DEFAULT abap_true
      RETURNING VALUE(result) TYPE i.
    METHODS set_signature
      IMPORTING parameter_count TYPE i function_length TYPE i DEFAULT -1
        has_self TYPE abap_bool DEFAULT abap_false
        has_this TYPE abap_bool DEFAULT abap_false name TYPE string OPTIONAL
        has_arguments TYPE abap_bool DEFAULT abap_false
        constructible TYPE abap_bool DEFAULT abap_true
        class_constructor TYPE abap_bool DEFAULT abap_false
        generator TYPE abap_bool DEFAULT abap_false
        async TYPE abap_bool DEFAULT abap_false.
    METHODS mark_arguments_used.
    METHODS intern_atom
      IMPORTING name          TYPE string
      RETURNING VALUE(result) TYPE i.
    METHODS allocate_capture
      IMPORTING source_kind TYPE i source_index TYPE i
      RETURNING VALUE(result) TYPE i.
    METHODS append_capture
      IMPORTING source_kind TYPE i source_index TYPE i
      RETURNING VALUE(result) TYPE i.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_atom_index,
      name  TYPE string,
      index TYPE i,
      END OF ty_atom_index.
    TYPES ty_atom_indices TYPE HASHED TABLE OF ty_atom_index
      WITH UNIQUE KEY name.
    TYPES: BEGIN OF ty_capture_index,
      source_kind  TYPE i,
      source_index TYPE i,
      index        TYPE i,
      END OF ty_capture_index.
    TYPES ty_capture_indices TYPE HASHED TABLE OF ty_capture_index
      WITH UNIQUE KEY source_kind source_index.
    DATA mt_code TYPE zcl_qjs_function=>ty_code.
    DATA mo_limits TYPE REF TO zcl_qjs_limits.
    DATA mt_constants TYPE zcl_qjs_function=>ty_constants.
    DATA mv_local_count TYPE i.
    DATA mv_parameter_count TYPE i.
    DATA mv_function_length TYPE i VALUE -1.
    DATA mv_name TYPE string.
    DATA mv_has_self TYPE abap_bool.
    DATA mv_has_this TYPE abap_bool.
    DATA mv_has_arguments TYPE abap_bool.
    DATA mv_arguments_used TYPE abap_bool.
    DATA mv_constructible TYPE abap_bool VALUE abap_true.
    DATA mv_class_constructor TYPE abap_bool.
    DATA mv_generator TYPE abap_bool.
    DATA mv_async TYPE abap_bool.
    DATA mt_atoms TYPE zcl_qjs_function=>ty_atoms.
    DATA mt_atom_indices TYPE ty_atom_indices.
    DATA mt_captures TYPE zcl_qjs_function=>ty_captures.
    DATA mt_capture_indices TYPE ty_capture_indices.
    DATA mt_local_specs TYPE zcl_qjs_function=>ty_local_specs.
ENDCLASS.

CLASS zcl_qjs_emitter IMPLEMENTATION.
  METHOD constructor.
    IF limits IS BOUND.
      mo_limits = limits.
    ELSE.
      CREATE OBJECT mo_limits.
    ENDIF.
  ENDMETHOD.

  METHOD emit.
    DATA ls_instruction TYPE zcl_qjs_function=>ty_instruction.
    ls_instruction-opcode = opcode.
    ls_instruction-operand = operand.
    ls_instruction-operand2 = operand2.
    APPEND ls_instruction TO mt_code.
    mo_limits->check_bytecode_length( lines( mt_code ) ).
  ENDMETHOD.

  METHOD to_function.
    CREATE OBJECT result
      EXPORTING
        code            = mt_code
        constants       = mt_constants
        local_count     = mv_local_count
        parameter_count = mv_parameter_count function_length = mv_function_length
        name            = mv_name
        has_self        = mv_has_self
        has_this        = mv_has_this
        has_arguments   = mv_has_arguments
        arguments_used  = mv_arguments_used
        constructible   = mv_constructible
        class_constructor = mv_class_constructor
        generator         = mv_generator
        async             = mv_async
        atoms           = mt_atoms
        captures        = mt_captures
        local_specs     = mt_local_specs.
  ENDMETHOD.

  METHOD emit_constant.
    DATA(lv_index) = add_constant( value ).
    emit( opcode = zif_qjs_opcodes=>push_const operand = lv_index ).
  ENDMETHOD.

  METHOD emit_closure.
    DATA(lv_index) = add_constant( value ).
    emit( opcode = zif_qjs_opcodes=>make_closure operand = lv_index ).
  ENDMETHOD.

  METHOD add_constant.
    result = lines( mt_constants ).
    APPEND value TO mt_constants.
  ENDMETHOD.

  METHOD position.
    result = lines( mt_code ) + 1.
  ENDMETHOD.

  METHOD patch.
    FIELD-SYMBOLS <instruction> TYPE zcl_qjs_function=>ty_instruction.
    READ TABLE mt_code INDEX instruction ASSIGNING <instruction>.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Cannot patch unknown bytecode instruction'.
    ENDIF.
    <instruction>-operand = target.
  ENDMETHOD.

  METHOD patch_second.
    READ TABLE mt_code INDEX instruction INTO DATA(ls_instruction).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Invalid bytecode patch index'.
    ENDIF.
    ls_instruction-operand2 = target.
    MODIFY mt_code FROM ls_instruction INDEX instruction.
  ENDMETHOD.

  METHOD replace.
    FIELD-SYMBOLS <instruction> TYPE zcl_qjs_function=>ty_instruction.
    READ TABLE mt_code INDEX instruction ASSIGNING <instruction>.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Cannot replace unknown bytecode instruction'.
    ENDIF.
    <instruction>-opcode = opcode.
    <instruction>-operand = operand.
  ENDMETHOD.

  METHOD allocate_local.
    DATA ls_spec TYPE zcl_qjs_function=>ty_local_spec.
    result = mv_local_count.
    mv_local_count = mv_local_count + 1.
    ls_spec-initialized = initialized.
    ls_spec-mutable = mutable.
    APPEND ls_spec TO mt_local_specs.
  ENDMETHOD.

  METHOD set_signature.
    mv_parameter_count = parameter_count.
    mv_function_length = function_length.
    mv_name = name.
    mv_has_self = has_self.
    mv_has_this = has_this.
    mv_has_arguments = has_arguments.
    mv_constructible = constructible.
    mv_class_constructor = class_constructor.
    mv_generator = generator.
    mv_async = async.
  ENDMETHOD.

  METHOD mark_arguments_used.
    mv_arguments_used = abap_true.
  ENDMETHOD.

  METHOD intern_atom.
    READ TABLE mt_atom_indices WITH TABLE KEY name = name
      INTO DATA(ls_atom_index).
    IF sy-subrc = 0.
      result = ls_atom_index-index.
      RETURN.
    ENDIF.
    result = lines( mt_atoms ).
    APPEND name TO mt_atoms.
    ls_atom_index-name = name.
    ls_atom_index-index = result.
    INSERT ls_atom_index INTO TABLE mt_atom_indices.
  ENDMETHOD.

  METHOD allocate_capture.
    DATA ls_capture TYPE zcl_qjs_function=>ty_capture.
    READ TABLE mt_capture_indices
      WITH TABLE KEY source_kind = source_kind source_index = source_index
      INTO DATA(ls_capture_index).
    IF sy-subrc = 0.
      result = ls_capture_index-index.
      RETURN.
    ENDIF.
    ls_capture-source_kind = source_kind.
    ls_capture-source_index = source_index.
    result = lines( mt_captures ).
    APPEND ls_capture TO mt_captures.
    ls_capture_index-source_kind = source_kind.
    ls_capture_index-source_index = source_index.
    ls_capture_index-index = result.
    INSERT ls_capture_index INTO TABLE mt_capture_indices.
  ENDMETHOD.

  METHOD append_capture.
    result = lines( mt_captures ).
    APPEND VALUE zcl_qjs_function=>ty_capture(
      source_kind = source_kind source_index = source_index ) TO mt_captures.
  ENDMETHOD.
ENDCLASS.
