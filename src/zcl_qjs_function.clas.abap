CLASS zcl_qjs_function DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_instruction,
        opcode  TYPE i,
        operand TYPE i,
        operand2 TYPE i,
      END OF ty_instruction.
    TYPES ty_code TYPE STANDARD TABLE OF ty_instruction WITH DEFAULT KEY.
    TYPES ty_constants TYPE STANDARD TABLE OF zcl_qjs_value=>ty_value WITH DEFAULT KEY.
    TYPES ty_atoms TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    CONSTANTS capture_local TYPE i VALUE 1.
    CONSTANTS capture_parent TYPE i VALUE 2.
    TYPES: BEGIN OF ty_capture,
      source_kind TYPE i,
      source_index TYPE i,
    END OF ty_capture.
    TYPES ty_captures TYPE STANDARD TABLE OF ty_capture WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_local_spec,
      initialized TYPE abap_bool,
      mutable TYPE abap_bool,
    END OF ty_local_spec.
    TYPES ty_local_specs TYPE STANDARD TABLE OF ty_local_spec WITH DEFAULT KEY.

    METHODS constructor
      IMPORTING
        code TYPE ty_code
        constants TYPE ty_constants OPTIONAL
        local_count TYPE i DEFAULT 0
        parameter_count TYPE i DEFAULT 0
        function_length TYPE i DEFAULT -1
        name TYPE string OPTIONAL
        has_self TYPE abap_bool DEFAULT abap_false
        has_this TYPE abap_bool DEFAULT abap_false
        has_arguments TYPE abap_bool DEFAULT abap_false
        constructible TYPE abap_bool DEFAULT abap_true
        class_constructor TYPE abap_bool DEFAULT abap_false
        generator TYPE abap_bool DEFAULT abap_false
        async TYPE abap_bool DEFAULT abap_false
        atoms TYPE ty_atoms OPTIONAL
        captures TYPE ty_captures OPTIONAL
        local_specs TYPE ty_local_specs OPTIONAL.

    METHODS instruction_count
      RETURNING
        VALUE(result) TYPE i.

    METHODS get_instruction
      IMPORTING
        index         TYPE i
      RETURNING
        VALUE(result) TYPE ty_instruction
      RAISING
        zcx_qjs_error.

    METHODS get_code
      RETURNING
        VALUE(result) TYPE ty_code.

    METHODS get_constant
      IMPORTING index TYPE i
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS get_local_count RETURNING VALUE(result) TYPE i.
    METHODS get_parameter_count RETURNING VALUE(result) TYPE i.
    METHODS get_function_length RETURNING VALUE(result) TYPE i.
    METHODS get_name RETURNING VALUE(result) TYPE string.
    METHODS set_name IMPORTING name TYPE string.
    METHODS has_self_binding RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_this_binding RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_arguments_binding RETURNING VALUE(result) TYPE abap_bool.
    METHODS is_constructible RETURNING VALUE(result) TYPE abap_bool.
    METHODS is_class_constructor RETURNING VALUE(result) TYPE abap_bool.
    METHODS is_generator RETURNING VALUE(result) TYPE abap_bool.
    METHODS is_async RETURNING VALUE(result) TYPE abap_bool.
    METHODS set_class_field_metadata
      IMPORTING derived TYPE abap_bool
        default_derived TYPE abap_bool DEFAULT abap_false.
    METHODS is_derived_class RETURNING VALUE(result) TYPE abap_bool.
    METHODS is_default_derived_constructor RETURNING VALUE(result) TYPE abap_bool.
    METHODS get_atom
      IMPORTING index TYPE i
      RETURNING VALUE(result) TYPE string
      RAISING zcx_qjs_error.
    METHODS get_captures RETURNING VALUE(result) TYPE ty_captures.
    METHODS get_local_spec
      IMPORTING index TYPE i
      RETURNING VALUE(result) TYPE ty_local_spec
      RAISING zcx_qjs_error.

  PRIVATE SECTION.
    DATA mt_code TYPE ty_code.
    DATA mt_constants TYPE ty_constants.
    DATA mv_local_count TYPE i.
    DATA mv_parameter_count TYPE i.
    DATA mv_function_length TYPE i.
    DATA mv_name TYPE string.
    DATA mv_has_self TYPE abap_bool.
    DATA mv_has_this TYPE abap_bool.
    DATA mv_has_arguments TYPE abap_bool.
    DATA mv_constructible TYPE abap_bool.
    DATA mv_class_constructor TYPE abap_bool.
    DATA mv_generator TYPE abap_bool.
    DATA mv_async TYPE abap_bool.
    DATA mv_derived_class TYPE abap_bool.
    DATA mv_default_derived TYPE abap_bool.
    DATA mt_atoms TYPE ty_atoms.
    DATA mt_captures TYPE ty_captures.
    DATA mt_local_specs TYPE ty_local_specs.
ENDCLASS.

CLASS zcl_qjs_function IMPLEMENTATION.
  METHOD constructor.
    mt_code = code.
    mt_constants = constants.
    mv_local_count = local_count.
    mv_parameter_count = parameter_count.
    IF function_length < 0.
      mv_function_length = parameter_count.
    ELSE.
      mv_function_length = function_length.
    ENDIF.
    mv_name = name.
    mv_has_self = has_self.
    mv_has_this = has_this.
    mv_has_arguments = has_arguments.
    mv_constructible = constructible.
    mv_class_constructor = class_constructor.
    mv_generator = generator.
    mv_async = async.
    mt_atoms = atoms.
    mt_captures = captures.
    mt_local_specs = local_specs.
  ENDMETHOD.

  METHOD instruction_count.
    result = lines( mt_code ).
  ENDMETHOD.

  METHOD get_instruction.
    READ TABLE mt_code INDEX index INTO result.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING
          reason = 'Bytecode program counter out of bounds'.
    ENDIF.
  ENDMETHOD.

  METHOD get_code.
    result = mt_code.
  ENDMETHOD.

  METHOD get_constant.
    DATA lv_index TYPE i.
    lv_index = index + 1.
    READ TABLE mt_constants INDEX lv_index INTO result.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Bytecode constant index out of bounds'.
    ENDIF.
  ENDMETHOD.

  METHOD get_local_count.
    result = mv_local_count.
  ENDMETHOD.

  METHOD get_parameter_count.
    result = mv_parameter_count.
  ENDMETHOD.

  METHOD get_function_length.
    result = mv_function_length.
  ENDMETHOD.

  METHOD get_name.
    result = mv_name.
  ENDMETHOD.

  METHOD set_name.
    mv_name = name.
  ENDMETHOD.

  METHOD has_self_binding.
    result = mv_has_self.
  ENDMETHOD.

  METHOD has_this_binding.
    result = mv_has_this.
  ENDMETHOD.

  METHOD has_arguments_binding.
    result = mv_has_arguments.
  ENDMETHOD.
  METHOD is_constructible.
    result = mv_constructible.
  ENDMETHOD.
  METHOD is_class_constructor.
    result = mv_class_constructor.
  ENDMETHOD.
  METHOD is_generator.
    result = mv_generator.
  ENDMETHOD.
  METHOD is_async.
    result = mv_async.
  ENDMETHOD.
  METHOD set_class_field_metadata.
    mv_derived_class = derived.
    mv_default_derived = default_derived.
  ENDMETHOD.
  METHOD is_derived_class.
    result = mv_derived_class.
  ENDMETHOD.
  METHOD is_default_derived_constructor.
    result = mv_default_derived.
  ENDMETHOD.

  METHOD get_atom.
    DATA lv_index TYPE i.
    lv_index = index + 1.
    READ TABLE mt_atoms INDEX lv_index INTO result.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Bytecode atom index out of bounds'.
    ENDIF.
  ENDMETHOD.

  METHOD get_captures.
    result = mt_captures.
  ENDMETHOD.

  METHOD get_local_spec.
    DATA lv_index TYPE i.
    lv_index = index + 1.
    READ TABLE mt_local_specs INDEX lv_index INTO result.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Function local specification is out of bounds'.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
