CLASS zcl_qjs_shape DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_descriptor,
      found TYPE abap_bool,
      name TYPE string,
      slot TYPE i,
      insertion_order TYPE i,
      accessor TYPE abap_bool,
      writable TYPE abap_bool,
      enumerable TYPE abap_bool,
      configurable TYPE abap_bool,
    END OF ty_descriptor.
    TYPES ty_descriptors TYPE SORTED TABLE OF ty_descriptor WITH UNIQUE KEY name.
    TYPES ty_names TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

    METHODS constructor IMPORTING descriptors TYPE ty_descriptors OPTIONAL.
    METHODS transition
      IMPORTING name TYPE string writable TYPE abap_bool DEFAULT abap_true
        enumerable TYPE abap_bool DEFAULT abap_true
        configurable TYPE abap_bool DEFAULT abap_true
        accessor TYPE abap_bool DEFAULT abap_false
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_shape.
    METHODS without
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE REF TO zcl_qjs_shape.
    METHODS lookup
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE ty_descriptor.
    METHODS property_count RETURNING VALUE(result) TYPE i.
    METHODS names
      IMPORTING enumerable_only TYPE abap_bool DEFAULT abap_false
      RETURNING VALUE(result) TYPE ty_names.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_transition,
      key TYPE string,
      shape TYPE REF TO zcl_qjs_shape,
    END OF ty_transition.
    TYPES ty_transitions TYPE HASHED TABLE OF ty_transition WITH UNIQUE KEY key.
    DATA mt_descriptors TYPE ty_descriptors.
    DATA mt_transitions TYPE ty_transitions.
ENDCLASS.

CLASS zcl_qjs_shape IMPLEMENTATION.
  METHOD constructor.
    mt_descriptors = descriptors.
  ENDMETHOD.

  METHOD lookup.
    READ TABLE mt_descriptors WITH TABLE KEY name = name INTO result.
    IF sy-subrc = 0.
      result-found = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD transition.
    DATA lv_key TYPE string.
    DATA ls_transition TYPE ty_transition.
    DATA lt_descriptors TYPE ty_descriptors.
    DATA ls_descriptor TYPE ty_descriptor.
    DATA lv_next_order TYPE i.
    ls_descriptor = lookup( name ).
    IF ls_descriptor-found = abap_true
        AND ls_descriptor-accessor = accessor
        AND ls_descriptor-writable = writable
        AND ls_descriptor-enumerable = enumerable
        AND ls_descriptor-configurable = configurable.
      result = me.
      RETURN.
    ENDIF.
    lv_key = name && `|` && accessor && writable && enumerable && configurable.
    READ TABLE mt_transitions WITH TABLE KEY key = lv_key INTO ls_transition.
    IF sy-subrc = 0.
      result = ls_transition-shape.
      RETURN.
    ENDIF.
    lt_descriptors = mt_descriptors.
    DELETE TABLE lt_descriptors WITH TABLE KEY name = name.
    IF ls_descriptor-found = abap_false.
      LOOP AT mt_descriptors INTO DATA(ls_ordered_descriptor).
        IF ls_ordered_descriptor-insertion_order >= lv_next_order.
          lv_next_order = ls_ordered_descriptor-insertion_order + 1.
        ENDIF.
      ENDLOOP.
      CLEAR ls_descriptor.
      ls_descriptor-slot = lines( mt_descriptors ).
      ls_descriptor-insertion_order = lv_next_order.
    ENDIF.
    ls_descriptor-found = abap_true.
    ls_descriptor-name = name.
    ls_descriptor-accessor = accessor.
    ls_descriptor-writable = writable.
    ls_descriptor-enumerable = enumerable.
    ls_descriptor-configurable = configurable.
    INSERT ls_descriptor INTO TABLE lt_descriptors.
    CREATE OBJECT result EXPORTING descriptors = lt_descriptors.
    ls_transition-key = lv_key.
    ls_transition-shape = result.
    INSERT ls_transition INTO TABLE mt_transitions.
  ENDMETHOD.

  METHOD without.
    DATA lt_descriptors TYPE ty_descriptors.
    lt_descriptors = mt_descriptors.
    DELETE TABLE lt_descriptors WITH TABLE KEY name = name.
    CREATE OBJECT result EXPORTING descriptors = lt_descriptors.
  ENDMETHOD.

  METHOD property_count.
    result = lines( mt_descriptors ).
  ENDMETHOD.

  METHOD names.
    DATA ls_descriptor TYPE ty_descriptor.
    TYPES: BEGIN OF ty_ordered_name,
      name TYPE string,
      index_group TYPE i,
      numeric_index TYPE int8,
      insertion_order TYPE i,
    END OF ty_ordered_name.
    DATA lt_ordered TYPE STANDARD TABLE OF ty_ordered_name WITH DEFAULT KEY.
    LOOP AT mt_descriptors INTO ls_descriptor.
      IF enumerable_only = abap_false OR ls_descriptor-enumerable = abap_true.
        DATA(ls_ordered) = VALUE ty_ordered_name(
          name = ls_descriptor-name index_group = 1
          insertion_order = ls_descriptor-insertion_order ).
        IF ls_descriptor-name IS NOT INITIAL
            AND ls_descriptor-name CO '0123456789'
            AND ( strlen( ls_descriptor-name ) = 1
              OR ls_descriptor-name+0(1) <> '0' ).
          TRY.
              ls_ordered-numeric_index = ls_descriptor-name.
              IF ls_ordered-numeric_index >= 0
                  AND ls_ordered-numeric_index <= 4294967294.
                ls_ordered-index_group = 0.
              ENDIF.
            CATCH cx_sy_conversion_error cx_sy_arithmetic_error.
          ENDTRY.
        ENDIF.
        APPEND ls_ordered TO lt_ordered.
      ENDIF.
    ENDLOOP.
    SORT lt_ordered BY index_group ASCENDING numeric_index ASCENDING
      insertion_order ASCENDING.
    LOOP AT lt_ordered INTO ls_ordered.
      APPEND ls_ordered-name TO result.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
