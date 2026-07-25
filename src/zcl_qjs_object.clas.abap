CLASS zcl_qjs_object DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    CONSTANTS collection_none TYPE i VALUE 0.
    CONSTANTS collection_map TYPE i VALUE 1.
    CONSTANTS collection_set TYPE i VALUE 2.
    CONSTANTS iterator_keys TYPE i VALUE 1.
    CONSTANTS iterator_values TYPE i VALUE 2.
    CONSTANTS iterator_entries TYPE i VALUE 3.
    CONSTANTS promise_pending TYPE i VALUE 1.
    CONSTANTS promise_fulfilled TYPE i VALUE 2.
    CONSTANTS promise_rejected TYPE i VALUE 3.
    METHODS constructor IMPORTING prototype TYPE REF TO zcl_qjs_object OPTIONAL
      is_array TYPE abap_bool DEFAULT abap_false
      shape TYPE REF TO zcl_qjs_shape OPTIONAL
      runtime TYPE REF TO zcl_qjs_runtime OPTIONAL.
    METHODS set_regexp_metadata IMPORTING pattern TYPE string flags TYPE string.
    METHODS is_regexp RETURNING VALUE(result) TYPE abap_bool.
    METHODS get_regexp_pattern RETURNING VALUE(result) TYPE string.
    METHODS get_regexp_flags RETURNING VALUE(result) TYPE string.
    TYPES: BEGIN OF ty_own_property,
      found TYPE abap_bool,
      accessor TYPE abap_bool,
      value TYPE zcl_qjs_value=>ty_value,
      getter TYPE zcl_qjs_value=>ty_value,
      setter TYPE zcl_qjs_value=>ty_value,
      writable TYPE abap_bool,
      enumerable TYPE abap_bool,
      configurable TYPE abap_bool,
    END OF ty_own_property.
    TYPES ty_symbol_ids TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_collection_entry,
      found TYPE abap_bool,
      deleted TYPE abap_bool,
      key TYPE zcl_qjs_value=>ty_value,
      value TYPE zcl_qjs_value=>ty_value,
    END OF ty_collection_entry.
    METHODS get
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS set IMPORTING name TYPE string value TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS get_symbol
      IMPORTING identity TYPE i
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS reflect_get
      IMPORTING name TYPE string receiver TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS reflect_get_symbol
      IMPORTING identity TYPE i receiver TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS reflect_set
      IMPORTING name TYPE string value TYPE zcl_qjs_value=>ty_value
        receiver TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS reflect_set_symbol
      IMPORTING identity TYPE i value TYPE zcl_qjs_value=>ty_value
        receiver TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS set_symbol
      IMPORTING identity TYPE i value TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS define_property
      IMPORTING name TYPE string value TYPE zcl_qjs_value=>ty_value
        writable TYPE abap_bool DEFAULT abap_true
        enumerable TYPE abap_bool DEFAULT abap_true
        configurable TYPE abap_bool DEFAULT abap_true
      RAISING zcx_qjs_error.
    METHODS define_cell_property
      IMPORTING name TYPE string cell TYPE REF TO zcl_qjs_cell
        writable TYPE abap_bool DEFAULT abap_true
        enumerable TYPE abap_bool DEFAULT abap_false
        configurable TYPE abap_bool DEFAULT abap_true
      RAISING zcx_qjs_error.
    METHODS define_accessor
      IMPORTING name TYPE string getter TYPE zcl_qjs_value=>ty_value
        setter TYPE zcl_qjs_value=>ty_value
        enumerable TYPE abap_bool DEFAULT abap_false
        configurable TYPE abap_bool DEFAULT abap_false
      RAISING zcx_qjs_error.
    METHODS define_symbol_property
      IMPORTING identity TYPE i value TYPE zcl_qjs_value=>ty_value
        writable TYPE abap_bool DEFAULT abap_true
        enumerable TYPE abap_bool DEFAULT abap_true
        configurable TYPE abap_bool DEFAULT abap_true
      RAISING zcx_qjs_error.
    METHODS define_symbol_accessor
      IMPORTING identity TYPE i getter TYPE zcl_qjs_value=>ty_value
        setter TYPE zcl_qjs_value=>ty_value
        enumerable TYPE abap_bool DEFAULT abap_false
        configurable TYPE abap_bool DEFAULT abap_false
      RAISING zcx_qjs_error.
    METHODS delete
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS delete_symbol
      IMPORTING identity TYPE i
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_own
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_property
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_own_symbol
      IMPORTING identity TYPE i
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_symbol_property
      IMPORTING identity TYPE i
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS add_private_field
      IMPORTING identity TYPE i value TYPE zcl_qjs_value=>ty_value
        writable TYPE abap_bool DEFAULT abap_true
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_private_field
      IMPORTING identity TYPE i
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS get_private_field
      IMPORTING identity TYPE i receiver TYPE zcl_qjs_value=>ty_value OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS set_private_field
      IMPORTING identity TYPE i value TYPE zcl_qjs_value=>ty_value
        receiver TYPE zcl_qjs_value=>ty_value OPTIONAL
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS add_private_accessor
      IMPORTING identity TYPE i getter TYPE zcl_qjs_value=>ty_value
        setter TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS own_property_count RETURNING VALUE(result) TYPE i.
    METHODS get_prototype RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS get_descriptor
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_shape=>ty_descriptor.
    METHODS get_own_property
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE ty_own_property.
    METHODS get_own_symbol_property
      IMPORTING identity TYPE i
      RETURNING VALUE(result) TYPE ty_own_property.
    METHODS set_element IMPORTING index TYPE int8 value TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS has_element IMPORTING index TYPE int8
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS get_element
      IMPORTING index TYPE int8
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS is_array RETURNING VALUE(result) TYPE abap_bool.
    METHODS set_array_length IMPORTING length TYPE int8 RAISING zcx_qjs_error.
    METHODS lock_array_length.
    METHODS own_keys RETURNING VALUE(result) TYPE zcl_qjs_shape=>ty_names.
    METHODS own_property_names RETURNING VALUE(result) TYPE zcl_qjs_shape=>ty_names.
    METHODS own_property_symbols RETURNING VALUE(result) TYPE ty_symbol_ids.
    METHODS set_prototype IMPORTING prototype TYPE REF TO zcl_qjs_object OPTIONAL
      RAISING zcx_qjs_error.
    METHODS is_extensible RETURNING VALUE(result) TYPE abap_bool.
    METHODS prevent_extensions.
    METHODS initialize_collection IMPORTING kind TYPE i.
    METHODS collection_kind RETURNING VALUE(result) TYPE i.
    METHODS collection_size RETURNING VALUE(result) TYPE i.
    METHODS collection_slots RETURNING VALUE(result) TYPE i.
    METHODS collection_get
      IMPORTING key TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE ty_collection_entry
      RAISING zcx_qjs_error.
    METHODS collection_set_entry
      IMPORTING key TYPE zcl_qjs_value=>ty_value
        value TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS collection_delete
      IMPORTING key TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS collection_clear.
    METHODS collection_entry_at
      IMPORTING index TYPE i
      RETURNING VALUE(result) TYPE ty_collection_entry.
    METHODS initialize_iterator
      IMPORTING collection TYPE REF TO zcl_qjs_object kind TYPE i.
    METHODS initialize_array_iterator
      IMPORTING array TYPE REF TO zcl_qjs_object kind TYPE i.
    METHODS initialize_string_iterator
      IMPORTING value TYPE zcl_qjs_value=>ty_value.
    METHODS iterator_next
      RETURNING VALUE(result) TYPE ty_collection_entry
      RAISING zcx_qjs_error.
    METHODS iterator_kind RETURNING VALUE(result) TYPE i.
    METHODS initialize_generator
      IMPORTING function TYPE REF TO zcl_qjs_function
        closure TYPE REF TO zcl_qjs_closure
        this_value TYPE zcl_qjs_value=>ty_value
        arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
      RAISING zcx_qjs_error.
    METHODS generator_next
      IMPORTING input TYPE zcl_qjs_value=>ty_value OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS generator_throw
      IMPORTING input TYPE zcl_qjs_value=>ty_value OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS generator_return
      IMPORTING input TYPE zcl_qjs_value=>ty_value OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS is_generator RETURNING VALUE(result) TYPE abap_bool.
    METHODS initialize_async_generator
      IMPORTING function TYPE REF TO zcl_qjs_function
        closure TYPE REF TO zcl_qjs_closure
        this_value TYPE zcl_qjs_value=>ty_value
        arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
      RAISING zcx_qjs_error.
    METHODS async_generator_enqueue
      IMPORTING kind TYPE i input TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS is_async_generator RETURNING VALUE(result) TYPE abap_bool.
    METHODS initialize_promise.
    METHODS is_promise RETURNING VALUE(result) TYPE abap_bool.
    METHODS promise_state RETURNING VALUE(result) TYPE i.
    METHODS promise_result RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value.
    METHODS promise_settle
      IMPORTING value TYPE zcl_qjs_value=>ty_value rejected TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS promise_add_reaction
      IMPORTING on_fulfilled TYPE zcl_qjs_value=>ty_value
        on_rejected TYPE zcl_qjs_value=>ty_value
        next_promise TYPE REF TO zcl_qjs_object OPTIONAL
        next_resolve TYPE zcl_qjs_value=>ty_value OPTIONAL
        next_reject TYPE zcl_qjs_value=>ty_value OPTIONAL
      RAISING zcx_qjs_error.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_property,
      name TYPE string,
      value TYPE zcl_qjs_value=>ty_value,
      accessor TYPE REF TO zcl_qjs_accessor_pair,
      cell TYPE REF TO zcl_qjs_cell,
    END OF ty_property.
    TYPES ty_properties TYPE HASHED TABLE OF ty_property WITH UNIQUE KEY name.
    TYPES: BEGIN OF ty_element,
      index TYPE int8,
      present TYPE abap_bool,
      value TYPE zcl_qjs_value=>ty_value,
    END OF ty_element.
    TYPES ty_elements TYPE STANDARD TABLE OF ty_element WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_array_index,
      found TYPE abap_bool,
      index TYPE int8,
    END OF ty_array_index.
    TYPES: BEGIN OF ty_symbol_property,
      identity TYPE i,
      value TYPE zcl_qjs_value=>ty_value,
      accessor_pair TYPE REF TO zcl_qjs_accessor_pair,
      accessor TYPE abap_bool,
      writable TYPE abap_bool,
      enumerable TYPE abap_bool,
      configurable TYPE abap_bool,
      insertion_order TYPE i,
    END OF ty_symbol_property.
    TYPES ty_symbol_properties TYPE HASHED TABLE OF ty_symbol_property
      WITH UNIQUE KEY identity.
    TYPES: BEGIN OF ty_private_field,
      identity TYPE i,
      value TYPE zcl_qjs_value=>ty_value,
      writable TYPE abap_bool,
      accessor TYPE abap_bool,
      accessor_pair TYPE REF TO zcl_qjs_accessor_pair,
    END OF ty_private_field.
    TYPES ty_private_fields TYPE HASHED TABLE OF ty_private_field
      WITH UNIQUE KEY identity.
    DATA mt_properties TYPE ty_properties.
    DATA mr_elements TYPE REF TO ty_elements.
    DATA mt_symbol_properties TYPE ty_symbol_properties.
    DATA mr_private_fields TYPE REF TO ty_private_fields.
    DATA mv_next_symbol_order TYPE i.
    DATA mo_prototype TYPE REF TO zcl_qjs_object.
    DATA mv_is_array TYPE abap_bool.
    DATA mv_extensible TYPE abap_bool VALUE abap_true.
    TYPES ty_collection_entries TYPE STANDARD TABLE OF ty_collection_entry
      WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_promise_reaction,
      on_fulfilled TYPE zcl_qjs_value=>ty_value,
      on_rejected TYPE zcl_qjs_value=>ty_value,
      next_promise TYPE REF TO zcl_qjs_object,
      next_resolve TYPE zcl_qjs_value=>ty_value,
      next_reject TYPE zcl_qjs_value=>ty_value,
    END OF ty_promise_reaction.
    TYPES ty_promise_reactions TYPE STANDARD TABLE OF ty_promise_reaction
      WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_cold_state,
      collection_kind TYPE i,
      collection_entries TYPE REF TO ty_collection_entries,
      iterator_collection TYPE REF TO zcl_qjs_object,
      iterator_kind TYPE i,
      iterator_index TYPE i,
      iterator_source_kind TYPE i,
      iterator_string TYPE REF TO zcl_qjs_value=>ty_value,
      generator_function TYPE REF TO zcl_qjs_function,
      generator_closure TYPE REF TO zcl_qjs_closure,
      generator_vm TYPE REF TO zcl_qjs_vm,
      generator_this TYPE REF TO zcl_qjs_value=>ty_value,
      generator_arguments TYPE REF TO zif_qjs_callable=>ty_arguments,
      generator_state TYPE i,
      async_generator TYPE REF TO zcl_qjs_async_generator,
      promise_state TYPE i,
      promise_result TYPE REF TO zcl_qjs_value=>ty_value,
      promise_reactions TYPE REF TO ty_promise_reactions,
      promise_handled TYPE abap_bool,
      promise_rejection_notified TYPE abap_bool,
      is_regexp TYPE abap_bool,
      regexp_pattern TYPE string,
      regexp_flags TYPE string,
    END OF ty_cold_state.
    DATA mr_cold TYPE REF TO ty_cold_state.
    DATA mv_length TYPE int8.
    DATA mv_length_writable TYPE abap_bool VALUE abap_true.
    DATA mo_shape TYPE REF TO zcl_qjs_shape.
    DATA mo_runtime TYPE REF TO zcl_qjs_runtime.
    METHODS get_with_receiver
      IMPORTING name TYPE string receiver TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS set_with_receiver
      IMPORTING name TYPE string value TYPE zcl_qjs_value=>ty_value
        receiver TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS get_symbol_with_receiver
      IMPORTING identity TYPE i receiver TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS set_symbol_with_receiver
      IMPORTING identity TYPE i value TYPE zcl_qjs_value=>ty_value
        receiver TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS invoke_callable
      IMPORTING callable TYPE zcl_qjs_value=>ty_value
        this_value TYPE zcl_qjs_value=>ty_value
        arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS raise_error IMPORTING name TYPE string message TYPE string.
    METHODS collection_key_equal
      IMPORTING left TYPE zcl_qjs_value=>ty_value
        right TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS array_index_from_name IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE ty_array_index.
    METHODS ensure_cold_state.
ENDCLASS.

CLASS zcl_qjs_object IMPLEMENTATION.
  METHOD array_index_from_name.
    IF name IS INITIAL OR name CN '0123456789'
        OR ( strlen( name ) > 1 AND name+0(1) = '0' ).
      RETURN.
    ENDIF.
    TRY.
        result-index = name.
      CATCH cx_sy_conversion_error cx_sy_arithmetic_error.
        RETURN.
    ENDTRY.
    IF result-index >= 0 AND result-index <= 4294967294.
      result-found = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD ensure_cold_state.
    IF mr_cold IS NOT BOUND. CREATE DATA mr_cold. ENDIF.
  ENDMETHOD.

  METHOD set_regexp_metadata.
    ensure_cold_state( ).
    mr_cold->is_regexp = abap_true.
    mr_cold->regexp_pattern = pattern.
    mr_cold->regexp_flags = flags.
  ENDMETHOD.

  METHOD is_regexp.
    IF mr_cold IS BOUND. result = mr_cold->is_regexp. ENDIF.
  ENDMETHOD.

  METHOD get_regexp_pattern.
    IF mr_cold IS BOUND. result = mr_cold->regexp_pattern. ENDIF.
  ENDMETHOD.

  METHOD get_regexp_flags.
    IF mr_cold IS BOUND. result = mr_cold->regexp_flags. ENDIF.
  ENDMETHOD.

  METHOD raise_error.
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
    mo_prototype = prototype.
    mv_is_array = is_array.
    mo_runtime = runtime.
    IF shape IS BOUND.
      mo_shape = shape.
    ELSE.
      CREATE OBJECT mo_shape.
    ENDIF.
  ENDMETHOD.

  METHOD get.
    IF mv_is_array = abap_true AND name = 'length'.
      IF mv_length <= 2147483647.
        result = zcl_qjs_value=>new_int( CONV i( mv_length ) ).
      ELSE.
        result = zcl_qjs_value=>new_finite( CONV f( mv_length ) ).
      ENDIF.
      RETURN.
    ENDIF.
    READ TABLE mt_properties WITH TABLE KEY name = name
      REFERENCE INTO DATA(lr_direct_property).
    IF sy-subrc = 0 AND lr_direct_property->accessor IS NOT BOUND.
      IF lr_direct_property->cell IS BOUND.
        result = lr_direct_property->cell->get( ).
      ELSE.
        result = lr_direct_property->value.
      ENDIF.
      RETURN.
    ENDIF.
    result = get_with_receiver(
      name = name receiver = zcl_qjs_value=>new_object( me ) ).
  ENDMETHOD.

  METHOD reflect_get.
    result = get_with_receiver( name = name receiver = receiver ).
  ENDMETHOD.

  METHOD reflect_get_symbol.
    result = get_symbol_with_receiver(
      identity = identity receiver = receiver ).
  ENDMETHOD.

  METHOD get_with_receiver.
    IF mv_is_array = abap_true AND name = 'length'.
      IF mv_length <= 2147483647.
        result = zcl_qjs_value=>new_int( CONV i( mv_length ) ).
      ELSE.
        result = zcl_qjs_value=>new_finite( CONV f( mv_length ) ).
      ENDIF.
      RETURN.
    ENDIF.
    READ TABLE mt_properties WITH TABLE KEY name = name
      REFERENCE INTO DATA(lr_property).
    IF sy-subrc = 0.
      " Accessor rows always carry initialized getter/setter values; ordinary
      " data and cell rows leave both tags initial. Avoid a second shape-table
      " lookup on every property read.
      IF lr_property->accessor IS BOUND.
        IF lr_property->accessor->getter-tag = zcl_qjs_value=>tag_undefined.
          result = zcl_qjs_value=>new_undefined( ).
        ELSE.
          result = invoke_callable(
            callable = lr_property->accessor->getter this_value = receiver ).
        ENDIF.
      ELSE.
        IF lr_property->cell IS BOUND.
          result = lr_property->cell->get( ).
        ELSE.
          result = lr_property->value.
        ENDIF.
      ENDIF.
    ELSEIF mv_is_array = abap_true.
      DATA(ls_array_index) = array_index_from_name( name ).
      IF ls_array_index-found = abap_true AND mr_elements IS BOUND.
        READ TABLE mr_elements->* INDEX ls_array_index-index + 1
          INTO DATA(ls_element).
        IF sy-subrc = 0 AND ls_element-present = abap_true.
          result = ls_element-value.
          RETURN.
        ENDIF.
      ENDIF.
      IF mo_prototype IS BOUND.
        result = mo_prototype->get_with_receiver( name = name receiver = receiver ).
      ELSE.
        result = zcl_qjs_value=>new_undefined( ).
      ENDIF.
    ELSEIF mo_prototype IS BOUND.
      result = mo_prototype->get_with_receiver( name = name receiver = receiver ).
    ELSE.
      result = zcl_qjs_value=>new_undefined( ).
    ENDIF.
  ENDMETHOD.

  METHOD set.
    DATA(ls_direct_descriptor) = mo_shape->lookup( name ).
    IF ls_direct_descriptor-found = abap_true
        AND ls_direct_descriptor-accessor = abap_false
        AND ls_direct_descriptor-writable = abap_true.
      READ TABLE mt_properties WITH TABLE KEY name = name
        REFERENCE INTO DATA(lr_direct_property).
      IF sy-subrc = 0.
        IF lr_direct_property->cell IS BOUND.
          lr_direct_property->cell->set( value ).
        ELSE.
          lr_direct_property->value = value.
        ENDIF.
        RETURN.
      ENDIF.
    ENDIF.
    set_with_receiver(
      name = name value = value receiver = zcl_qjs_value=>new_object( me ) ).
  ENDMETHOD.

  METHOD get_symbol.
    result = get_symbol_with_receiver(
      identity = identity receiver = zcl_qjs_value=>new_object( me ) ).
  ENDMETHOD.

  METHOD get_symbol_with_receiver.
    READ TABLE mt_symbol_properties WITH TABLE KEY identity = identity
      INTO DATA(ls_property).
    IF sy-subrc = 0.
      IF ls_property-accessor = abap_true.
        IF ls_property-accessor_pair->getter-tag = zcl_qjs_value=>tag_undefined.
          result = zcl_qjs_value=>new_undefined( ).
        ELSE.
          result = invoke_callable(
            callable = ls_property-accessor_pair->getter this_value = receiver ).
        ENDIF.
      ELSE.
        result = ls_property-value.
      ENDIF.
    ELSEIF mo_prototype IS BOUND.
      result = mo_prototype->get_symbol_with_receiver(
        identity = identity receiver = receiver ).
    ELSE.
      result = zcl_qjs_value=>new_undefined( ).
    ENDIF.
  ENDMETHOD.

  METHOD set_symbol.
    set_symbol_with_receiver(
      identity = identity value = value
      receiver = zcl_qjs_value=>new_object( me ) ).
  ENDMETHOD.

  METHOD set_symbol_with_receiver.
    READ TABLE mt_symbol_properties WITH TABLE KEY identity = identity
      INTO DATA(ls_existing).
    IF sy-subrc = 0.
      IF ls_existing-accessor = abap_true.
        IF ls_existing-accessor_pair->setter-tag = zcl_qjs_value=>tag_undefined.
          raise_error( name = 'TypeError' message = 'property has no setter' ).
        ENDIF.
        DATA lt_setter_arguments TYPE zif_qjs_callable=>ty_arguments.
        APPEND value TO lt_setter_arguments.
        DATA(ls_ignored) = invoke_callable(
          callable = ls_existing-accessor_pair->setter this_value = receiver
          arguments = lt_setter_arguments ).
        RETURN.
      ELSEIF ls_existing-writable = abap_false.
        raise_error( name = 'TypeError' message = 'property is not writable' ).
      ELSEIF receiver-object_ref = me.
        ls_existing-value = value.
        DELETE TABLE mt_symbol_properties WITH TABLE KEY identity = identity.
        INSERT ls_existing INTO TABLE mt_symbol_properties.
        RETURN.
      ENDIF.
    ELSEIF mo_prototype IS BOUND.
      mo_prototype->set_symbol_with_receiver(
        identity = identity value = value receiver = receiver ).
      RETURN.
    ENDIF.
    DATA lo_receiver TYPE REF TO zcl_qjs_object.
    TRY.
        lo_receiver ?= receiver-object_ref.
      CATCH cx_sy_move_cast_error.
        raise_error(
          name = 'TypeError' message = 'property receiver is not an ordinary object' ).
    ENDTRY.
    lo_receiver->define_symbol_property( identity = identity value = value ).
  ENDMETHOD.

  METHOD reflect_set_symbol.
    READ TABLE mt_symbol_properties WITH TABLE KEY identity = identity
      INTO DATA(ls_existing).
    IF sy-subrc = 0.
      IF ls_existing-accessor = abap_true.
        IF ls_existing-accessor_pair->setter-tag = zcl_qjs_value=>tag_undefined.
          RETURN.
        ENDIF.
        DATA lt_setter_arguments TYPE zif_qjs_callable=>ty_arguments.
        APPEND value TO lt_setter_arguments.
        DATA(ls_ignored) = invoke_callable(
          callable = ls_existing-accessor_pair->setter this_value = receiver
          arguments = lt_setter_arguments ).
        result = abap_true.
        RETURN.
      ELSEIF ls_existing-writable = abap_false.
        RETURN.
      ELSEIF receiver-object_ref = me.
        ls_existing-value = value.
        DELETE TABLE mt_symbol_properties WITH TABLE KEY identity = identity.
        INSERT ls_existing INTO TABLE mt_symbol_properties.
        result = abap_true.
        RETURN.
      ENDIF.
    ELSEIF mo_prototype IS BOUND.
      result = mo_prototype->reflect_set_symbol(
        identity = identity value = value receiver = receiver ).
      RETURN.
    ENDIF.
    DATA lo_receiver TYPE REF TO zcl_qjs_object.
    TRY.
        lo_receiver ?= receiver-object_ref.
      CATCH cx_sy_move_cast_error.
        TRY.
            DATA(lo_receiver_closure) = CAST zcl_qjs_closure( receiver-object_ref ).
            lo_receiver = lo_receiver_closure->get_property_storage( ).
          CATCH cx_sy_move_cast_error.
            RETURN.
        ENDTRY.
    ENDTRY.
    DATA(ls_receiver_property) = lo_receiver->get_own_symbol_property( identity ).
    IF ls_receiver_property-found = abap_true.
      IF ls_receiver_property-accessor = abap_true
          OR ls_receiver_property-writable = abap_false.
        RETURN.
      ENDIF.
      lo_receiver->define_symbol_property(
        identity = identity value = value
        writable = ls_receiver_property-writable
        enumerable = ls_receiver_property-enumerable
        configurable = ls_receiver_property-configurable ).
    ELSE.
      IF lo_receiver->is_extensible( ) = abap_false.
        RETURN.
      ENDIF.
      lo_receiver->define_symbol_property( identity = identity value = value ).
    ENDIF.
    result = abap_true.
  ENDMETHOD.

  METHOD set_with_receiver.
    IF mv_is_array = abap_true AND name = 'length' AND receiver-object_ref = me.
      IF mv_length_writable = abap_false.
        raise_error( name = 'TypeError' message = 'property is not writable' ).
      ENDIF.
      DATA(ls_length_value) = zcl_qjs_number=>to_number( value ).
      DATA(lv_new_length) = CONV int8( 0 ).
      DATA lv_max_array_length TYPE int8.
      DATA lv_max_array_length_f TYPE f.
      lv_max_array_length = '4294967295'.
      lv_max_array_length_f = '4294967295'.
      IF ls_length_value-tag = zcl_qjs_value=>tag_int
          AND ls_length_value-int_value >= 0.
        lv_new_length = ls_length_value-int_value.
      ELSEIF ls_length_value-tag = zcl_qjs_value=>tag_number
          AND ls_length_value-int_value = zcl_qjs_value=>number_neg_zero.
        lv_new_length = 0.
      ELSEIF ls_length_value-tag = zcl_qjs_value=>tag_number
          AND ls_length_value-int_value = zcl_qjs_value=>number_finite
          AND ls_length_value-float_value >= 0
          AND ls_length_value-float_value <= lv_max_array_length_f
          AND trunc( ls_length_value-float_value ) = ls_length_value-float_value.
        lv_new_length = trunc( ls_length_value-float_value ).
      ELSE.
        raise_error( name = 'RangeError' message = 'invalid array length' ).
      ENDIF.
      IF lv_new_length > lv_max_array_length.
        raise_error( name = 'RangeError' message = 'invalid array length' ).
      ENDIF.
      set_array_length( lv_new_length ).
      RETURN.
    ENDIF.
    IF mv_is_array = abap_true AND receiver-object_ref = me.
      DATA(ls_direct_index) = array_index_from_name( name ).
      IF ls_direct_index-found = abap_true
          AND mo_shape->lookup( name )-found = abap_false.
        set_element( index = ls_direct_index-index value = value ).
        RETURN.
      ENDIF.
    ENDIF.
    DATA ls_descriptor TYPE zcl_qjs_shape=>ty_descriptor.
    ls_descriptor = mo_shape->lookup( name ).
    IF ls_descriptor-found = abap_true.
      READ TABLE mt_properties WITH TABLE KEY name = name
        REFERENCE INTO DATA(lr_existing).
      IF ls_descriptor-accessor = abap_true.
        IF lr_existing->accessor->setter-tag = zcl_qjs_value=>tag_undefined.
          raise_error( name = 'TypeError' message = 'property has no setter' ).
        ENDIF.
        DATA lt_setter_arguments TYPE zif_qjs_callable=>ty_arguments.
        APPEND value TO lt_setter_arguments.
        DATA(ls_ignored) = invoke_callable(
          callable = lr_existing->accessor->setter this_value = receiver
          arguments = lt_setter_arguments ).
        RETURN.
      ELSEIF ls_descriptor-writable = abap_false.
        raise_error( name = 'TypeError' message = 'property is not writable' ).
      ELSEIF receiver-object_ref = me.
        IF lr_existing->cell IS BOUND.
          lr_existing->cell->set( value ).
        ELSE.
          lr_existing->value = value.
        ENDIF.
        RETURN.
      ENDIF.
    ELSEIF mo_prototype IS BOUND.
      mo_prototype->set_with_receiver(
        name = name value = value receiver = receiver ).
      RETURN.
    ENDIF.
    DATA lo_receiver TYPE REF TO zcl_qjs_object.
    TRY.
        lo_receiver ?= receiver-object_ref.
      CATCH cx_sy_move_cast_error.
        raise_error(
          name = 'TypeError' message = 'property receiver is not an ordinary object' ).
    ENDTRY.
    lo_receiver->define_property( name = name value = value ).
  ENDMETHOD.

  METHOD reflect_set.
    IF mv_is_array = abap_true AND name = 'length' AND receiver-object_ref = me.
      IF mv_length_writable = abap_false.
        RETURN.
      ENDIF.
      set_with_receiver( name = name value = value receiver = receiver ).
      result = abap_true.
      RETURN.
    ENDIF.
    DATA(ls_descriptor) = mo_shape->lookup( name ).
    IF ls_descriptor-found = abap_true.
      READ TABLE mt_properties WITH TABLE KEY name = name
        REFERENCE INTO DATA(lr_existing).
      IF ls_descriptor-accessor = abap_true.
        IF lr_existing->accessor->setter-tag = zcl_qjs_value=>tag_undefined.
          RETURN.
        ENDIF.
        DATA lt_setter_arguments TYPE zif_qjs_callable=>ty_arguments.
        APPEND value TO lt_setter_arguments.
        DATA(ls_ignored) = invoke_callable(
          callable = lr_existing->accessor->setter this_value = receiver
          arguments = lt_setter_arguments ).
        result = abap_true.
        RETURN.
      ELSEIF ls_descriptor-writable = abap_false.
        RETURN.
      ELSEIF receiver-object_ref = me.
        IF lr_existing->cell IS BOUND.
          lr_existing->cell->set( value ).
        ELSE.
          lr_existing->value = value.
        ENDIF.
        result = abap_true.
        RETURN.
      ENDIF.
    ELSEIF mo_prototype IS BOUND.
      result = mo_prototype->reflect_set(
        name = name value = value receiver = receiver ).
      RETURN.
    ENDIF.
    DATA lo_receiver TYPE REF TO zcl_qjs_object.
    TRY.
        lo_receiver ?= receiver-object_ref.
      CATCH cx_sy_move_cast_error.
        TRY.
            DATA(lo_receiver_closure) = CAST zcl_qjs_closure( receiver-object_ref ).
            lo_receiver = lo_receiver_closure->get_property_storage( ).
          CATCH cx_sy_move_cast_error.
            RETURN.
        ENDTRY.
    ENDTRY.
    DATA(ls_receiver_property) = lo_receiver->get_own_property( name ).
    IF ls_receiver_property-found = abap_true.
      IF ls_receiver_property-accessor = abap_true
          OR ls_receiver_property-writable = abap_false.
        RETURN.
      ENDIF.
      lo_receiver->define_property(
        name = name value = value writable = ls_receiver_property-writable
        enumerable = ls_receiver_property-enumerable
        configurable = ls_receiver_property-configurable ).
    ELSE.
      IF lo_receiver->is_extensible( ) = abap_false.
        RETURN.
      ENDIF.
      lo_receiver->define_property( name = name value = value ).
    ENDIF.
    result = abap_true.
  ENDMETHOD.

  METHOD define_property.
    DATA ls_descriptor TYPE zcl_qjs_shape=>ty_descriptor.
    ls_descriptor = mo_shape->lookup( name ).
    IF ls_descriptor-found = abap_false AND mv_extensible = abap_false.
      raise_error( name = 'TypeError' message = 'object is not extensible' ).
    ENDIF.
    IF ls_descriptor-found = abap_true AND ls_descriptor-configurable = abap_false.
      READ TABLE mt_properties WITH TABLE KEY name = name INTO DATA(ls_old_property).
      IF ls_descriptor-accessor = abap_true OR configurable = abap_true
          OR ls_descriptor-enumerable <> enumerable
          OR ( ls_descriptor-writable = abap_false AND writable = abap_true )
          OR ( ls_descriptor-writable = abap_false
            AND zcl_qjs_value=>strict_equal(
              left = ls_old_property-value right = value ) = abap_false ).
        raise_error( name = 'TypeError' message = 'property is not configurable' ).
      ENDIF.
    ENDIF.
    mo_shape = mo_shape->transition(
      name = name writable = writable enumerable = enumerable
      configurable = configurable accessor = abap_false ).
    DATA ls_property TYPE ty_property.
    ls_property-name = name.
    READ TABLE mt_properties WITH TABLE KEY name = name INTO DATA(ls_cell_property).
    IF sy-subrc = 0 AND ls_cell_property-cell IS BOUND
        AND ls_descriptor-accessor = abap_false.
      ls_cell_property-cell->set( value ).
      ls_property-cell = ls_cell_property-cell.
    ELSE.
      ls_property-value = value.
    ENDIF.
    DELETE TABLE mt_properties WITH TABLE KEY name = name.
    INSERT ls_property INTO TABLE mt_properties.
  ENDMETHOD.

  METHOD define_cell_property.
    IF cell IS NOT BOUND.
      raise_error( name = 'TypeError' message = 'global property cell is not bound' ).
    ENDIF.
    DATA(ls_descriptor) = mo_shape->lookup( name ).
    IF ls_descriptor-found = abap_false AND mv_extensible = abap_false.
      raise_error( name = 'TypeError' message = 'object is not extensible' ).
    ENDIF.
    mo_shape = mo_shape->transition(
      name = name writable = writable enumerable = enumerable
      configurable = configurable accessor = abap_false ).
    DATA(ls_property) = VALUE ty_property( name = name cell = cell ).
    DELETE TABLE mt_properties WITH TABLE KEY name = name.
    INSERT ls_property INTO TABLE mt_properties.
  ENDMETHOD.

  METHOD define_accessor.
    DATA(ls_descriptor) = mo_shape->lookup( name ).
    IF ls_descriptor-found = abap_false AND mv_extensible = abap_false.
      raise_error( name = 'TypeError' message = 'object is not extensible' ).
    ENDIF.
    IF ls_descriptor-found = abap_true AND ls_descriptor-configurable = abap_false.
      READ TABLE mt_properties WITH TABLE KEY name = name INTO DATA(ls_old_accessor).
      IF ls_descriptor-accessor = abap_false OR configurable = abap_true
          OR ls_descriptor-enumerable <> enumerable
          OR zcl_qjs_value=>strict_equal(
            left = ls_old_accessor-accessor->getter right = getter ) = abap_false
          OR zcl_qjs_value=>strict_equal(
            left = ls_old_accessor-accessor->setter right = setter ) = abap_false.
        raise_error( name = 'TypeError' message = 'property is not configurable' ).
      ENDIF.
    ENDIF.
    mo_shape = mo_shape->transition(
      name = name writable = abap_false enumerable = enumerable
      configurable = configurable accessor = abap_true ).
    DATA ls_property TYPE ty_property.
    ls_property-name = name.
    ls_property-accessor = NEW zcl_qjs_accessor_pair(
      getter = getter setter = setter ).
    DELETE TABLE mt_properties WITH TABLE KEY name = name.
    INSERT ls_property INTO TABLE mt_properties.
  ENDMETHOD.

  METHOD define_symbol_property.
    READ TABLE mt_symbol_properties WITH TABLE KEY identity = identity
      INTO DATA(ls_old_property).
    IF sy-subrc <> 0 AND mv_extensible = abap_false.
      raise_error( name = 'TypeError' message = 'object is not extensible' ).
    ENDIF.
    IF sy-subrc = 0 AND ls_old_property-configurable = abap_false.
      IF ls_old_property-accessor = abap_true OR configurable = abap_true
          OR ls_old_property-enumerable <> enumerable
          OR ( ls_old_property-writable = abap_false AND writable = abap_true )
          OR ( ls_old_property-writable = abap_false
            AND zcl_qjs_value=>strict_equal(
              left = ls_old_property-value right = value ) = abap_false ).
        raise_error( name = 'TypeError' message = 'property is not configurable' ).
      ENDIF.
    ENDIF.
    DATA ls_property TYPE ty_symbol_property.
    IF sy-subrc = 0.
      ls_property-insertion_order = ls_old_property-insertion_order.
    ELSE.
      ls_property-insertion_order = mv_next_symbol_order.
      mv_next_symbol_order = mv_next_symbol_order + 1.
    ENDIF.
    ls_property-identity = identity.
    ls_property-value = value.
    ls_property-writable = writable.
    ls_property-enumerable = enumerable.
    ls_property-configurable = configurable.
    DELETE TABLE mt_symbol_properties WITH TABLE KEY identity = identity.
    INSERT ls_property INTO TABLE mt_symbol_properties.
  ENDMETHOD.

  METHOD define_symbol_accessor.
    READ TABLE mt_symbol_properties WITH TABLE KEY identity = identity
      INTO DATA(ls_old_property).
    IF sy-subrc <> 0 AND mv_extensible = abap_false.
      raise_error( name = 'TypeError' message = 'object is not extensible' ).
    ENDIF.
    IF sy-subrc = 0 AND ls_old_property-configurable = abap_false.
      IF ls_old_property-accessor = abap_false OR configurable = abap_true
          OR ls_old_property-enumerable <> enumerable
          OR zcl_qjs_value=>strict_equal(
            left = ls_old_property-accessor_pair->getter right = getter ) = abap_false
          OR zcl_qjs_value=>strict_equal(
            left = ls_old_property-accessor_pair->setter right = setter ) = abap_false.
        raise_error( name = 'TypeError' message = 'property is not configurable' ).
      ENDIF.
    ENDIF.
    DATA ls_property TYPE ty_symbol_property.
    IF sy-subrc = 0.
      ls_property-insertion_order = ls_old_property-insertion_order.
    ELSE.
      ls_property-insertion_order = mv_next_symbol_order.
      mv_next_symbol_order = mv_next_symbol_order + 1.
    ENDIF.
    ls_property-identity = identity.
    ls_property-accessor_pair = NEW zcl_qjs_accessor_pair(
      getter = getter setter = setter ).
    ls_property-accessor = abap_true.
    ls_property-enumerable = enumerable.
    ls_property-configurable = configurable.
    DELETE TABLE mt_symbol_properties WITH TABLE KEY identity = identity.
    INSERT ls_property INTO TABLE mt_symbol_properties.
  ENDMETHOD.

  METHOD invoke_callable.
    DATA lo_closure TYPE REF TO zcl_qjs_closure.
    DATA lo_callable TYPE REF TO zif_qjs_callable.
    IF callable-tag <> zcl_qjs_value=>tag_object.
      raise_error( name = 'TypeError' message = 'accessor is not callable' ).
    ENDIF.
    IF callable-object_ref IS INSTANCE OF zcl_qjs_closure.
        lo_closure ?= callable-object_ref.
      result = lo_closure->invoke(
        this_value = this_value arguments = arguments ).
      RETURN.
    ENDIF.
    IF callable-object_ref IS INSTANCE OF zcl_qjs_native_function.
      lo_callable ?= callable-object_ref.
    ELSE.
      TRY.
        lo_callable ?= callable-object_ref.
        CATCH cx_sy_move_cast_error.
          raise_error( name = 'TypeError' message = 'accessor is not callable' ).
      ENDTRY.
    ENDIF.
    TRY.
        result = lo_callable->call(
          this_value = this_value arguments = arguments ).
      CATCH zcx_qjs_error INTO DATA(lx_host_error).
        RAISE EXCEPTION TYPE zcx_qjs_throw
          EXPORTING value = mo_runtime->create_error_from_reason( lx_host_error->reason ).
    ENDTRY.
  ENDMETHOD.

  METHOD delete.
    IF mv_is_array = abap_true AND name = 'length'.
      result = abap_false.
      RETURN.
    ENDIF.
    DATA(ls_descriptor) = mo_shape->lookup( name ).
    IF ls_descriptor-found = abap_true AND ls_descriptor-configurable = abap_false.
      result = abap_false.
      RETURN.
    ENDIF.
    IF ls_descriptor-found = abap_false AND mv_is_array = abap_true
        AND mr_elements IS BOUND.
      DATA(ls_delete_index) = array_index_from_name( name ).
      IF ls_delete_index-found = abap_true.
        READ TABLE mr_elements->* INDEX ls_delete_index-index + 1
          ASSIGNING FIELD-SYMBOL(<ls_delete_element>).
        IF sy-subrc = 0. CLEAR <ls_delete_element>-present. ENDIF.
        result = abap_true.
        RETURN.
      ENDIF.
    ENDIF.
    DELETE TABLE mt_properties WITH TABLE KEY name = name.
    mo_shape = mo_shape->without( name ).
    result = abap_true.
  ENDMETHOD.

  METHOD delete_symbol.
    READ TABLE mt_symbol_properties WITH TABLE KEY identity = identity
      INTO DATA(ls_property).
    IF sy-subrc = 0 AND ls_property-configurable = abap_false.
      result = abap_false.
      RETURN.
    ENDIF.
    DELETE TABLE mt_symbol_properties WITH TABLE KEY identity = identity.
    result = abap_true.
  ENDMETHOD.

  METHOD has_own.
    IF mv_is_array = abap_true AND name = 'length'.
      result = abap_true.
      RETURN.
    ENDIF.
    result = mo_shape->lookup( name )-found.
    IF result = abap_false AND mv_is_array = abap_true AND mr_elements IS BOUND.
      DATA(ls_has_index) = array_index_from_name( name ).
      IF ls_has_index-found = abap_true.
        READ TABLE mr_elements->* INDEX ls_has_index-index + 1
          INTO DATA(ls_has_element).
        result = xsdbool( sy-subrc = 0 AND ls_has_element-present = abap_true ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD has_property.
    result = has_own( name ).
    IF result = abap_false AND mo_prototype IS BOUND.
      result = mo_prototype->has_property( name ).
    ENDIF.
  ENDMETHOD.

  METHOD has_own_symbol.
    READ TABLE mt_symbol_properties WITH TABLE KEY identity = identity
      TRANSPORTING NO FIELDS.
    result = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.

  METHOD has_symbol_property.
    result = has_own_symbol( identity ).
    IF result = abap_false AND mo_prototype IS BOUND.
      result = mo_prototype->has_symbol_property( identity ).
    ENDIF.
  ENDMETHOD.

  METHOD add_private_field.
    IF mr_private_fields IS NOT BOUND. CREATE DATA mr_private_fields. ENDIF.
    DATA ls_field TYPE ty_private_field.
    READ TABLE mr_private_fields->* WITH TABLE KEY identity = identity
      TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      RETURN.
    ENDIF.
    ls_field-identity = identity.
    ls_field-value = value.
    ls_field-writable = writable.
    INSERT ls_field INTO TABLE mr_private_fields->*.
    result = abap_true.
  ENDMETHOD.

  METHOD has_private_field.
    IF mr_private_fields IS NOT BOUND. RETURN. ENDIF.
    READ TABLE mr_private_fields->* WITH TABLE KEY identity = identity
      TRANSPORTING NO FIELDS.
    result = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.

  METHOD get_private_field.
    IF mr_private_fields IS NOT BOUND.
      result = zcl_qjs_value=>new_undefined( ).
      RETURN.
    ENDIF.
    READ TABLE mr_private_fields->* WITH TABLE KEY identity = identity
      INTO DATA(ls_field).
    IF sy-subrc = 0.
      IF ls_field-accessor = abap_true.
        IF ls_field-accessor_pair->getter-tag = zcl_qjs_value=>tag_undefined.
          raise_error(
            name = 'TypeError' message = 'private accessor has no getter' ).
        ENDIF.
        result = invoke_callable(
          callable = ls_field-accessor_pair->getter this_value = receiver ).
      ELSE.
        result = ls_field-value.
      ENDIF.
    ELSE.
      result = zcl_qjs_value=>new_undefined( ).
    ENDIF.
  ENDMETHOD.

  METHOD set_private_field.
    IF mr_private_fields IS NOT BOUND. RETURN. ENDIF.
    FIELD-SYMBOLS <field> TYPE ty_private_field.
    READ TABLE mr_private_fields->* WITH TABLE KEY identity = identity
      ASSIGNING <field>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    IF <field>-accessor = abap_true.
      IF <field>-accessor_pair->setter-tag = zcl_qjs_value=>tag_undefined.
        RETURN.
      ENDIF.
      DATA lt_private_setter_args TYPE zif_qjs_callable=>ty_arguments.
      APPEND value TO lt_private_setter_args.
      DATA(ls_private_setter_result) = invoke_callable(
        callable = <field>-accessor_pair->setter this_value = receiver
        arguments = lt_private_setter_args ).
      result = abap_true.
      RETURN.
    ENDIF.
    IF <field>-writable = abap_false.
      RETURN.
    ENDIF.
    <field>-value = value.
    result = abap_true.
  ENDMETHOD.

  METHOD add_private_accessor.
    IF mr_private_fields IS NOT BOUND. CREATE DATA mr_private_fields. ENDIF.
    FIELD-SYMBOLS <field> TYPE ty_private_field.
    READ TABLE mr_private_fields->* WITH TABLE KEY identity = identity
      ASSIGNING <field>.
    IF sy-subrc = 0.
      IF <field>-accessor = abap_false.
        RETURN.
      ENDIF.
      DATA(ls_getter) = <field>-accessor_pair->getter.
      DATA(ls_setter) = <field>-accessor_pair->setter.
      IF getter-tag <> zcl_qjs_value=>tag_undefined. ls_getter = getter. ENDIF.
      IF setter-tag <> zcl_qjs_value=>tag_undefined. ls_setter = setter. ENDIF.
      <field>-accessor_pair = NEW zcl_qjs_accessor_pair(
        getter = ls_getter setter = ls_setter ).
      result = abap_true.
      RETURN.
    ENDIF.
    DATA ls_accessor TYPE ty_private_field.
    ls_accessor-identity = identity.
    ls_accessor-accessor = abap_true.
    ls_accessor-accessor_pair = NEW zcl_qjs_accessor_pair(
      getter = getter setter = setter ).
    INSERT ls_accessor INTO TABLE mr_private_fields->*.
    result = abap_true.
  ENDMETHOD.

  METHOD own_property_count.
    result = mo_shape->property_count( ) + lines( mt_symbol_properties ).
    IF mr_elements IS BOUND.
      LOOP AT mr_elements->* TRANSPORTING NO FIELDS WHERE present = abap_true.
        result = result + 1.
      ENDLOOP.
    ENDIF.
    IF mv_is_array = abap_true.
      result = result + 1.
    ENDIF.
  ENDMETHOD.

  METHOD get_prototype.
    result = mo_prototype.
  ENDMETHOD.

  METHOD get_descriptor.
    result = mo_shape->lookup( name ).
  ENDMETHOD.

  METHOD get_own_property.
    IF mv_is_array = abap_true AND name = 'length'.
      result-found = abap_true.
      IF mv_length <= 2147483647.
        result-value = zcl_qjs_value=>new_int( CONV i( mv_length ) ).
      ELSE.
        result-value = zcl_qjs_value=>new_finite( CONV f( mv_length ) ).
      ENDIF.
      result-writable = mv_length_writable.
      result-enumerable = abap_false.
      result-configurable = abap_false.
      RETURN.
    ENDIF.
    DATA(ls_descriptor) = mo_shape->lookup( name ).
    IF ls_descriptor-found = abap_false.
      IF mv_is_array = abap_true AND mr_elements IS BOUND.
        DATA(ls_own_index) = array_index_from_name( name ).
        IF ls_own_index-found = abap_true.
          READ TABLE mr_elements->* INDEX ls_own_index-index + 1
            INTO DATA(ls_own_element).
          IF sy-subrc = 0 AND ls_own_element-present = abap_true.
            result-found = abap_true.
            result-value = ls_own_element-value.
            result-writable = abap_true.
            result-enumerable = abap_true.
            result-configurable = abap_true.
          ENDIF.
        ENDIF.
      ENDIF.
      RETURN.
    ENDIF.
    READ TABLE mt_properties WITH TABLE KEY name = name INTO DATA(ls_property).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    result-found = abap_true.
    result-accessor = ls_descriptor-accessor.
    IF ls_property-cell IS BOUND.
      result-value = ls_property-cell->get( ).
    ELSE.
      result-value = ls_property-value.
    ENDIF.
    IF ls_property-accessor IS BOUND.
      result-getter = ls_property-accessor->getter.
      result-setter = ls_property-accessor->setter.
    ENDIF.
    result-writable = ls_descriptor-writable.
    result-enumerable = ls_descriptor-enumerable.
    result-configurable = ls_descriptor-configurable.
  ENDMETHOD.

  METHOD get_own_symbol_property.
    READ TABLE mt_symbol_properties WITH TABLE KEY identity = identity
      INTO DATA(ls_property).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    result-found = abap_true.
    result-accessor = ls_property-accessor.
    result-value = ls_property-value.
    IF ls_property-accessor_pair IS BOUND.
      result-getter = ls_property-accessor_pair->getter.
      result-setter = ls_property-accessor_pair->setter.
    ENDIF.
    result-writable = ls_property-writable.
    result-enumerable = ls_property-enumerable.
    result-configurable = ls_property-configurable.
  ENDMETHOD.

  METHOD set_element.
    DATA lv_name TYPE string.
    DATA lv_max_array_length TYPE int8.
    lv_max_array_length = '4294967295'.
    lv_name = index.
    CONDENSE lv_name NO-GAPS.
    DATA lv_element_slots TYPE i.
    IF mr_elements IS BOUND. lv_element_slots = lines( mr_elements->* ). ENDIF.
    IF mv_is_array = abap_true AND index >= 0 AND index < lv_max_array_length
        AND index <= lv_element_slots + 64
        AND mo_shape->lookup( lv_name )-found = abap_false.
      IF mr_elements IS NOT BOUND. CREATE DATA mr_elements. ENDIF.
      WHILE lines( mr_elements->* ) <= index.
        APPEND VALUE ty_element( index = lines( mr_elements->* ) )
          TO mr_elements->*.
      ENDWHILE.
      READ TABLE mr_elements->* INDEX index + 1
        ASSIGNING FIELD-SYMBOL(<ls_element>).
      <ls_element>-present = abap_true.
      <ls_element>-value = value.
    ELSE.
      set( name = lv_name value = value ).
    ENDIF.
    IF index >= mv_length AND index >= 0 AND index < lv_max_array_length.
      mv_length = index + 1.
    ENDIF.
  ENDMETHOD.

  METHOD has_element.
    IF mv_is_array = abap_true AND mr_elements IS BOUND.
      READ TABLE mr_elements->* INDEX index + 1 INTO DATA(ls_element).
      IF sy-subrc = 0 AND ls_element-present = abap_true.
        result = abap_true.
        RETURN.
      ENDIF.
    ENDIF.
    DATA(lv_name) = CONV string( index ).
    CONDENSE lv_name NO-GAPS.
    result = has_property( lv_name ).
  ENDMETHOD.

  METHOD get_element.
    DATA lv_name TYPE string.
    IF mv_is_array = abap_true AND mr_elements IS BOUND.
      READ TABLE mr_elements->* INDEX index + 1 INTO DATA(ls_element).
      IF sy-subrc = 0 AND ls_element-present = abap_true.
        result = ls_element-value.
        RETURN.
      ENDIF.
    ENDIF.
    lv_name = index.
    CONDENSE lv_name NO-GAPS.
    result = get( lv_name ).
  ENDMETHOD.

  METHOD is_array.
    result = mv_is_array.
  ENDMETHOD.

  METHOD set_array_length.
    DATA lv_max_array_length TYPE int8.
    lv_max_array_length = '4294967295'.
    IF mv_is_array = abap_false OR length < 0 OR length > lv_max_array_length.
      raise_error( name = 'RangeError' message = 'invalid array length' ).
    ENDIF.
    IF length < mv_length.
      IF mr_elements IS BOUND.
        LOOP AT mr_elements->* ASSIGNING FIELD-SYMBOL(<ls_truncated_element>)
            WHERE index >= length.
          CLEAR <ls_truncated_element>-present.
        ENDLOOP.
      ENDIF.
      DATA lt_delete_names TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
      LOOP AT mt_properties INTO DATA(ls_property).
        DATA(lv_index) = CONV int8( 0 ).
        DATA(lv_canonical_name) = ``.
        TRY.
            lv_index = ls_property-name.
            lv_canonical_name = lv_index.
            CONDENSE lv_canonical_name NO-GAPS.
            IF lv_index >= length AND lv_index >= 0
                AND lv_index < lv_max_array_length
                AND lv_canonical_name = ls_property-name.
              APPEND ls_property-name TO lt_delete_names.
            ENDIF.
          CATCH cx_sy_conversion_no_number cx_sy_conversion_overflow.
        ENDTRY.
      ENDLOOP.
      LOOP AT lt_delete_names INTO DATA(lv_delete_name).
        IF delete( lv_delete_name ) = abap_false.
          raise_error(
            name = 'TypeError' message = 'array element is not configurable' ).
        ENDIF.
      ENDLOOP.
    ENDIF.
    mv_length = length.
  ENDMETHOD.

  METHOD lock_array_length.
    mv_length_writable = abap_false.
  ENDMETHOD.

  METHOD own_keys.
    result = mo_shape->names( enumerable_only = abap_true ).
    IF mr_elements IS BOUND.
      DATA lt_indices TYPE STANDARD TABLE OF int8 WITH DEFAULT KEY.
      LOOP AT mr_elements->* INTO DATA(ls_key_element).
        IF ls_key_element-present = abap_false. CONTINUE. ENDIF.
        APPEND ls_key_element-index TO lt_indices.
      ENDLOOP.
      SORT lt_indices ASCENDING.
      LOOP AT lt_indices INTO DATA(lv_key_index).
        DATA(lv_key_name) = CONV string( lv_key_index ).
        CONDENSE lv_key_name NO-GAPS.
        INSERT lv_key_name INTO result INDEX sy-tabix.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD own_property_names.
    IF mr_elements IS BOUND.
      DATA lt_indices TYPE STANDARD TABLE OF int8 WITH DEFAULT KEY.
      LOOP AT mr_elements->* INTO DATA(ls_key_element).
        IF ls_key_element-present = abap_false. CONTINUE. ENDIF.
        APPEND ls_key_element-index TO lt_indices.
      ENDLOOP.
      SORT lt_indices ASCENDING.
      LOOP AT lt_indices INTO DATA(lv_key_index).
        DATA(lv_key_name) = CONV string( lv_key_index ).
        CONDENSE lv_key_name NO-GAPS.
        APPEND lv_key_name TO result.
      ENDLOOP.
    ENDIF.
    APPEND LINES OF mo_shape->names( ) TO result.
    IF mv_is_array = abap_true.
      APPEND 'length' TO result.
    ENDIF.
  ENDMETHOD.

  METHOD own_property_symbols.
    DATA lt_properties TYPE STANDARD TABLE OF ty_symbol_property WITH DEFAULT KEY.
    LOOP AT mt_symbol_properties INTO DATA(ls_property).
      APPEND ls_property TO lt_properties.
    ENDLOOP.
    SORT lt_properties BY insertion_order ASCENDING.
    LOOP AT lt_properties INTO ls_property.
      APPEND ls_property-identity TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD set_prototype.
    IF mv_extensible = abap_false AND prototype <> mo_prototype.
      raise_error( name = 'TypeError' message = 'object is not extensible' ).
    ENDIF.
    DATA lo_current TYPE REF TO zcl_qjs_object.
    lo_current = prototype.
    WHILE lo_current IS BOUND.
      IF lo_current = me.
        raise_error( name = 'TypeError' message = 'cyclic prototype value' ).
      ENDIF.
      lo_current = lo_current->get_prototype( ).
    ENDWHILE.
    mo_prototype = prototype.
  ENDMETHOD.

  METHOD is_extensible.
    result = mv_extensible.
  ENDMETHOD.

  METHOD prevent_extensions.
    mv_extensible = abap_false.
  ENDMETHOD.

  METHOD initialize_collection.
    ensure_cold_state( ).
    mr_cold->collection_kind = kind.
    IF mr_cold->collection_entries IS BOUND.
      CLEAR mr_cold->collection_entries->*.
    ELSE.
      CREATE DATA mr_cold->collection_entries.
    ENDIF.
  ENDMETHOD.

  METHOD collection_kind.
    IF mr_cold IS BOUND. result = mr_cold->collection_kind. ENDIF.
  ENDMETHOD.

  METHOD collection_key_equal.
    result = zcl_qjs_value=>strict_equal( left = left right = right ).
    IF result = abap_false
        AND left-tag = zcl_qjs_value=>tag_number
        AND right-tag = zcl_qjs_value=>tag_number
        AND left-int_value = zcl_qjs_value=>number_nan
        AND right-int_value = zcl_qjs_value=>number_nan.
      result = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD collection_size.
    IF mr_cold IS NOT BOUND. RETURN. ENDIF.
    IF mr_cold->collection_entries IS NOT BOUND. RETURN. ENDIF.
    LOOP AT mr_cold->collection_entries->* INTO DATA(ls_entry).
      IF ls_entry-deleted = abap_false.
        result = result + 1.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD collection_slots.
    IF mr_cold IS NOT BOUND. RETURN. ENDIF.
    IF mr_cold->collection_entries IS BOUND.
      result = lines( mr_cold->collection_entries->* ).
    ENDIF.
  ENDMETHOD.

  METHOD collection_get.
    IF mr_cold IS NOT BOUND. RETURN. ENDIF.
    IF mr_cold->collection_entries IS NOT BOUND. RETURN. ENDIF.
    LOOP AT mr_cold->collection_entries->* INTO DATA(ls_entry).
      IF ls_entry-deleted = abap_false AND collection_key_equal(
          left = ls_entry-key right = key ) = abap_true.
        result = ls_entry.
        result-found = abap_true.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD collection_set_entry.
    ensure_cold_state( ).
    IF mr_cold->collection_entries IS NOT BOUND. CREATE DATA mr_cold->collection_entries. ENDIF.
    LOOP AT mr_cold->collection_entries->* ASSIGNING FIELD-SYMBOL(<ls_entry>).
      IF <ls_entry>-deleted = abap_false AND collection_key_equal(
          left = <ls_entry>-key right = key ) = abap_true.
        <ls_entry>-value = value.
        RETURN.
      ENDIF.
    ENDLOOP.
    DATA ls_entry TYPE ty_collection_entry.
    ls_entry-key = key.
    ls_entry-value = value.
    APPEND ls_entry TO mr_cold->collection_entries->*.
  ENDMETHOD.

  METHOD collection_delete.
    IF mr_cold IS NOT BOUND. RETURN. ENDIF.
    IF mr_cold->collection_entries IS NOT BOUND. RETURN. ENDIF.
    LOOP AT mr_cold->collection_entries->* ASSIGNING FIELD-SYMBOL(<ls_entry>).
      IF <ls_entry>-deleted = abap_false AND collection_key_equal(
          left = <ls_entry>-key right = key ) = abap_true.
        <ls_entry>-deleted = abap_true.
        result = abap_true.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD collection_clear.
    IF mr_cold IS NOT BOUND. RETURN. ENDIF.
    IF mr_cold->collection_entries IS NOT BOUND. RETURN. ENDIF.
    LOOP AT mr_cold->collection_entries->* ASSIGNING FIELD-SYMBOL(<ls_entry>).
      <ls_entry>-deleted = abap_true.
    ENDLOOP.
  ENDMETHOD.

  METHOD collection_entry_at.
    IF mr_cold IS NOT BOUND. RETURN. ENDIF.
    IF mr_cold->collection_entries IS NOT BOUND. RETURN. ENDIF.
    READ TABLE mr_cold->collection_entries->* INDEX index INTO result.
    IF sy-subrc = 0.
      result-found = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD initialize_iterator.
    ensure_cold_state( ).
    mr_cold->iterator_collection = collection.
    mr_cold->iterator_kind = kind.
    mr_cold->iterator_index = 1.
    mr_cold->iterator_source_kind = 1.
  ENDMETHOD.

  METHOD initialize_array_iterator.
    ensure_cold_state( ).
    mr_cold->iterator_collection = array.
    mr_cold->iterator_kind = kind.
    mr_cold->iterator_index = 0.
    mr_cold->iterator_source_kind = 2.
  ENDMETHOD.

  METHOD initialize_string_iterator.
    ensure_cold_state( ).
    CREATE DATA mr_cold->iterator_string.
    mr_cold->iterator_string->* = value.
    mr_cold->iterator_kind = iterator_values.
    mr_cold->iterator_index = 0.
    mr_cold->iterator_source_kind = 3.
  ENDMETHOD.

  METHOD iterator_next.
    IF mr_cold IS NOT BOUND. RETURN. ENDIF.
    IF mr_cold->iterator_source_kind = 2 AND mr_cold->iterator_collection IS BOUND.
      DATA(ls_length_value) = mr_cold->iterator_collection->get( 'length' ).
      DATA(lv_length) = CONV int8( 0 ).
      IF ls_length_value-tag = zcl_qjs_value=>tag_int.
        lv_length = ls_length_value-int_value.
      ENDIF.
      IF mr_cold->iterator_index < lv_length.
        result-found = abap_true.
        result-key = zcl_qjs_value=>new_int( mr_cold->iterator_index ).
        result-value = mr_cold->iterator_collection->get_element(
          CONV int8( mr_cold->iterator_index ) ).
        mr_cold->iterator_index = mr_cold->iterator_index + 1.
        RETURN.
      ENDIF.
      CLEAR mr_cold->iterator_collection.
      CLEAR mr_cold->iterator_source_kind.
      RETURN.
    ELSEIF mr_cold->iterator_source_kind = 3
        AND mr_cold->iterator_string IS BOUND
        AND mr_cold->iterator_string->tag = zcl_qjs_value=>tag_string.
      IF mr_cold->iterator_index < strlen( mr_cold->iterator_string->string_ref->as_string( ) ).
        result-found = abap_true.
        result-key = zcl_qjs_value=>new_int( mr_cold->iterator_index ).
        DATA(lv_first_code) = zcl_qjs_string=>code_unit_value(
          value = mr_cold->iterator_string->string_ref->as_string( ) index = mr_cold->iterator_index ).
        DATA(lv_width) = 1.
        IF lv_first_code >= 55296 AND lv_first_code <= 56319
            AND mr_cold->iterator_index + 1 < strlen( mr_cold->iterator_string->string_ref->as_string( ) ).
          DATA(lv_second_index) = mr_cold->iterator_index + 1.
          DATA(lv_second_code) =
            zcl_qjs_string=>code_unit_value(
              value = mr_cold->iterator_string->string_ref->as_string( ) index = lv_second_index ).
          IF lv_second_code >= 56320 AND lv_second_code <= 57343.
            lv_width = 2.
          ENDIF.
        ENDIF.
        DATA(lv_string_source) = mr_cold->iterator_string->string_ref->as_string( ).
        DATA lv_iterator_value TYPE string.
        lv_iterator_value = lv_string_source+mr_cold->iterator_index(lv_width).
        result-value = zcl_qjs_value=>new_string( lv_iterator_value ).
        mr_cold->iterator_index = mr_cold->iterator_index + lv_width.
        RETURN.
      ENDIF.
      FREE mr_cold->iterator_string.
      CLEAR mr_cold->iterator_source_kind.
      RETURN.
    ENDIF.
    WHILE mr_cold->iterator_source_kind = 1 AND mr_cold->iterator_collection IS BOUND
        AND mr_cold->iterator_index <= mr_cold->iterator_collection->collection_slots( ).
      result = mr_cold->iterator_collection->collection_entry_at( mr_cold->iterator_index ).
      mr_cold->iterator_index = mr_cold->iterator_index + 1.
      IF result-found = abap_true AND result-deleted = abap_false.
        RETURN.
      ENDIF.
    ENDWHILE.
    CLEAR result.
    CLEAR mr_cold->iterator_collection.
    CLEAR mr_cold->iterator_source_kind.
  ENDMETHOD.

  METHOD iterator_kind.
    IF mr_cold IS BOUND. result = mr_cold->iterator_kind. ENDIF.
  ENDMETHOD.

  METHOD initialize_generator.
    ensure_cold_state( ).
    IF function IS NOT BOUND OR closure IS NOT BOUND OR mo_runtime IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Generator requires an active function and runtime'.
    ENDIF.
    mr_cold->generator_function = function.
    mr_cold->generator_closure = closure.
    CREATE DATA mr_cold->generator_this.
    mr_cold->generator_this->* = this_value.
    CREATE DATA mr_cold->generator_arguments.
    mr_cold->generator_arguments->* = arguments.
    CREATE OBJECT mr_cold->generator_vm
      EXPORTING runtime = mo_runtime limits = mo_runtime->get_limits( ).
    mr_cold->generator_state = 1.
  ENDMETHOD.

  METHOD generator_next.
    IF mr_cold IS NOT BOUND OR mr_cold->generator_function IS NOT BOUND
        OR mr_cold->generator_vm IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: generator receiver is incompatible'.
    ENDIF.
    DATA ls_value TYPE zcl_qjs_value=>ty_value.
    DATA lv_done TYPE abap_bool.
    IF mr_cold->generator_state = 3.
      ls_value = zcl_qjs_value=>new_undefined( ).
      lv_done = abap_true.
    ELSEIF mr_cold->generator_state = 2.
      mr_cold->generator_state = 4.
      TRY.
          ls_value = mr_cold->generator_vm->execute(
            function     = mr_cold->generator_function
            resume       = abap_true
            resume_value = input ).
        CATCH zcx_qjs_error INTO DATA(lx_generator_resume).
          mr_cold->generator_state = 3.
          RAISE EXCEPTION lx_generator_resume.
        CATCH zcx_qjs_throw INTO DATA(lx_generator_resume_throw).
          mr_cold->generator_state = 3.
          RAISE EXCEPTION lx_generator_resume_throw.
      ENDTRY.
      IF mr_cold->generator_vm->was_suspended( ) = abap_true.
        mr_cold->generator_state = 2.
      ELSE.
        mr_cold->generator_state = 3.
        lv_done = abap_true.
      ENDIF.
    ELSEIF mr_cold->generator_state = 1.
      mr_cold->generator_state = 4.
      TRY.
          ls_value = mr_cold->generator_vm->execute(
            function          = mr_cold->generator_function
            initial_closure   = mr_cold->generator_closure
            initial_this      = mr_cold->generator_this->*
            initial_arguments = mr_cold->generator_arguments->* ).
        CATCH zcx_qjs_error INTO DATA(lx_generator_start).
          mr_cold->generator_state = 3.
          RAISE EXCEPTION lx_generator_start.
        CATCH zcx_qjs_throw INTO DATA(lx_generator_start_throw).
          mr_cold->generator_state = 3.
          RAISE EXCEPTION lx_generator_start_throw.
      ENDTRY.
      IF mr_cold->generator_vm->was_suspended( ) = abap_true.
        mr_cold->generator_state = 2.
      ELSE.
        mr_cold->generator_state = 3.
        lv_done = abap_true.
      ENDIF.
    ELSE.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: generator is already running'.
    ENDIF.
    DATA(lo_result) = mo_runtime->create_object( ).
    lo_result->define_property( name = 'value' value = ls_value ).
    lo_result->define_property(
      name = 'done' value = zcl_qjs_value=>new_boolean( lv_done ) ).
    result = zcl_qjs_value=>new_object( lo_result ).
  ENDMETHOD.

  METHOD generator_throw.
    IF mr_cold IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: generator receiver is incompatible'.
    ENDIF.
    IF mr_cold->generator_function IS NOT BOUND OR mr_cold->generator_vm IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: generator receiver is incompatible'.
    ENDIF.
    IF mr_cold->generator_state = 3 OR mr_cold->generator_state = 1.
      mr_cold->generator_state = 3.
      RAISE EXCEPTION TYPE zcx_qjs_throw EXPORTING value = input.
    ELSEIF mr_cold->generator_state = 2.
      mr_cold->generator_state = 4.
      TRY.
          DATA(ls_value) = mr_cold->generator_vm->execute(
            function     = mr_cold->generator_function
            resume       = abap_true
            resume_kind  = 2
            resume_value = input ).
        CATCH zcx_qjs_error INTO DATA(lx_generator_error).
          mr_cold->generator_state = 3.
          RAISE EXCEPTION lx_generator_error.
        CATCH zcx_qjs_throw INTO DATA(lx_generator_throw).
          mr_cold->generator_state = 3.
          RAISE EXCEPTION lx_generator_throw.
      ENDTRY.
      DATA(lv_done) = abap_false.
      IF mr_cold->generator_vm->was_suspended( ) = abap_true.
        mr_cold->generator_state = 2.
      ELSE.
        mr_cold->generator_state = 3.
        lv_done = abap_true.
      ENDIF.
      DATA(lo_result) = mo_runtime->create_object( ).
      lo_result->define_property( name = 'value' value = ls_value ).
      lo_result->define_property(
        name = 'done' value = zcl_qjs_value=>new_boolean( lv_done ) ).
      result = zcl_qjs_value=>new_object( lo_result ).
    ELSE.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: generator is already running'.
    ENDIF.
  ENDMETHOD.

  METHOD generator_return.
    IF mr_cold IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: generator receiver is incompatible'.
    ENDIF.
    IF mr_cold->generator_function IS NOT BOUND OR mr_cold->generator_vm IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: generator receiver is incompatible'.
    ENDIF.
    IF mr_cold->generator_state = 4.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: generator is already running'.
    ENDIF.
    DATA(ls_value) = input.
    DATA(lv_done) = abap_true.
    IF mr_cold->generator_state = 2.
      mr_cold->generator_state = 4.
      TRY.
          ls_value = mr_cold->generator_vm->execute(
            function     = mr_cold->generator_function
            resume       = abap_true
            resume_kind  = 1
            resume_value = input ).
        CATCH zcx_qjs_error INTO DATA(lx_generator_error).
          mr_cold->generator_state = 3.
          RAISE EXCEPTION lx_generator_error.
        CATCH zcx_qjs_throw INTO DATA(lx_generator_throw).
          mr_cold->generator_state = 3.
          RAISE EXCEPTION lx_generator_throw.
      ENDTRY.
      IF mr_cold->generator_vm->was_suspended( ) = abap_true.
        mr_cold->generator_state = 2.
        lv_done = abap_false.
      ELSE.
        mr_cold->generator_state = 3.
      ENDIF.
    ELSE.
      mr_cold->generator_state = 3.
    ENDIF.
    DATA(lo_result) = mo_runtime->create_object( ).
    lo_result->define_property( name = 'value' value = ls_value ).
    lo_result->define_property(
      name = 'done' value = zcl_qjs_value=>new_boolean( lv_done ) ).
    result = zcl_qjs_value=>new_object( lo_result ).
  ENDMETHOD.

  METHOD is_generator.
    IF mr_cold IS BOUND.
      result = xsdbool( mr_cold->generator_function IS BOUND ).
    ENDIF.
  ENDMETHOD.

  METHOD initialize_async_generator.
    ensure_cold_state( ).
    CREATE OBJECT mr_cold->async_generator
      EXPORTING runtime = mo_runtime function = function closure = closure
        this_value = this_value arguments = arguments.
  ENDMETHOD.

  METHOD async_generator_enqueue.
    IF mr_cold IS NOT BOUND OR mr_cold->async_generator IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: async generator receiver is incompatible'.
    ENDIF.
    result = mr_cold->async_generator->enqueue( kind = kind input = input ).
  ENDMETHOD.

  METHOD is_async_generator.
    IF mr_cold IS BOUND.
      result = xsdbool( mr_cold->async_generator IS BOUND ).
    ENDIF.
  ENDMETHOD.

  METHOD initialize_promise.
    ensure_cold_state( ).
    mr_cold->promise_state = promise_pending.
    CREATE DATA mr_cold->promise_result.
    mr_cold->promise_result->* = zcl_qjs_value=>new_undefined( ).
    IF mr_cold->promise_reactions IS BOUND.
      CLEAR mr_cold->promise_reactions->*.
    ELSE.
      CREATE DATA mr_cold->promise_reactions.
    ENDIF.
    CLEAR mr_cold->promise_handled.
    CLEAR mr_cold->promise_rejection_notified.
  ENDMETHOD.

  METHOD is_promise.
    IF mr_cold IS BOUND.
      result = xsdbool( mr_cold->promise_state <> 0 ).
    ENDIF.
  ENDMETHOD.

  METHOD promise_state.
    IF mr_cold IS BOUND. result = mr_cold->promise_state. ENDIF.
  ENDMETHOD.

  METHOD promise_result.
    IF mr_cold IS BOUND AND mr_cold->promise_result IS BOUND.
      result = mr_cold->promise_result->*.
    ENDIF.
  ENDMETHOD.

  METHOD promise_settle.
    IF mr_cold IS NOT BOUND. RETURN. ENDIF.
    IF mr_cold->promise_state <> promise_pending.
      RETURN.
    ENDIF.
    IF value-tag = zcl_qjs_value=>tag_object AND value-object_ref = me.
      mr_cold->promise_state = promise_rejected.
      IF mo_runtime IS BOUND.
        mr_cold->promise_result->* = mo_runtime->create_error(
          name = 'TypeError' message = 'A promise cannot resolve to itself' ).
      ELSE.
        mr_cold->promise_result->* = zcl_qjs_value=>new_string(
          'TypeError: A promise cannot resolve to itself' ).
      ENDIF.
    ELSEIF rejected = abap_false AND value-tag = zcl_qjs_value=>tag_object.
      DATA lo_adopted_promise TYPE REF TO zcl_qjs_object.
      TRY.
          lo_adopted_promise ?= value-object_ref.
        CATCH cx_sy_move_cast_error.
      ENDTRY.
      IF lo_adopted_promise IS BOUND
          AND lo_adopted_promise->is_promise( ) = abap_true.
        DATA(ls_undefined_handler) = zcl_qjs_value=>new_undefined( ).
        lo_adopted_promise->promise_add_reaction(
          on_fulfilled = ls_undefined_handler on_rejected = ls_undefined_handler
          next_promise = me ).
        RETURN.
      ENDIF.
      DATA ls_then_method TYPE zcl_qjs_value=>ty_value.
      DATA lv_then_failed TYPE abap_bool.
      TRY.
          IF lo_adopted_promise IS BOUND.
            ls_then_method = lo_adopted_promise->get( 'then' ).
          ELSE.
            DATA lo_then_properties TYPE REF TO zif_qjs_property_container.
            TRY.
                lo_then_properties ?= value-object_ref.
              CATCH cx_sy_move_cast_error.
            ENDTRY.
            IF lo_then_properties IS BOUND.
              ls_then_method = lo_then_properties->get_property( 'then' ).
            ELSE.
              ls_then_method = zcl_qjs_value=>new_undefined( ).
            ENDIF.
          ENDIF.
        CATCH zcx_qjs_throw INTO DATA(lx_then_get_throw).
          mr_cold->promise_result->* = lx_then_get_throw->value.
          mr_cold->promise_state = promise_rejected.
          lv_then_failed = abap_true.
        CATCH zcx_qjs_error INTO DATA(lx_then_get_error).
          IF mo_runtime IS BOUND.
            mr_cold->promise_result->* = mo_runtime->create_error_from_reason(
              lx_then_get_error->reason ).
          ELSE.
            mr_cold->promise_result->* = zcl_qjs_value=>new_string(
              lx_then_get_error->reason ).
          ENDIF.
          mr_cold->promise_state = promise_rejected.
          lv_then_failed = abap_true.
      ENDTRY.
      IF lv_then_failed = abap_false AND mo_runtime IS BOUND
          AND mo_runtime->is_callable_value( ls_then_method ) = abap_true.
        mo_runtime->enqueue_thenable_job(
          promise = me thenable = value then_method = ls_then_method ).
        RETURN.
      ELSEIF lv_then_failed = abap_false.
        mr_cold->promise_result->* = value.
        mr_cold->promise_state = promise_fulfilled.
      ENDIF.
    ELSE.
      mr_cold->promise_result->* = value.
      IF rejected = abap_true.
        mr_cold->promise_state = promise_rejected.
      ELSE.
        mr_cold->promise_state = promise_fulfilled.
      ENDIF.
    ENDIF.
    IF mo_runtime IS BOUND.
      LOOP AT mr_cold->promise_reactions->* INTO DATA(ls_reaction).
        mo_runtime->enqueue_promise_job(
          settled_promise = me
          on_fulfilled    = ls_reaction-on_fulfilled
          on_rejected     = ls_reaction-on_rejected
          next_promise    = ls_reaction-next_promise
          next_resolve    = ls_reaction-next_resolve
          next_reject     = ls_reaction-next_reject ).
      ENDLOOP.
      IF mr_cold->promise_state = promise_rejected
          AND mr_cold->promise_handled = abap_false.
        mr_cold->promise_rejection_notified = abap_true.
        mo_runtime->track_promise_rejection(
          promise = me reason = mr_cold->promise_result->* handled = abap_false ).
      ENDIF.
    ENDIF.
    CLEAR mr_cold->promise_reactions->*.
  ENDMETHOD.

  METHOD promise_add_reaction.
    IF mr_cold IS NOT BOUND OR mr_cold->promise_state = 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: Promise method receiver is not a Promise'.
    ENDIF.
    IF mr_cold->promise_state = promise_rejected
        AND mr_cold->promise_handled = abap_false
        AND mr_cold->promise_rejection_notified = abap_true
        AND mo_runtime IS BOUND.
      mo_runtime->track_promise_rejection(
        promise = me reason = mr_cold->promise_result->* handled = abap_true ).
    ENDIF.
    mr_cold->promise_handled = abap_true.
    IF mr_cold->promise_state = promise_pending.
      IF mr_cold->promise_reactions IS NOT BOUND. CREATE DATA mr_cold->promise_reactions. ENDIF.
      APPEND VALUE ty_promise_reaction(
        on_fulfilled = on_fulfilled on_rejected = on_rejected
        next_promise = next_promise next_resolve = next_resolve
        next_reject = next_reject ) TO mr_cold->promise_reactions->*.
    ELSEIF mo_runtime IS BOUND.
      mo_runtime->enqueue_promise_job(
        settled_promise = me on_fulfilled = on_fulfilled
        on_rejected = on_rejected next_promise = next_promise
        next_resolve = next_resolve next_reject = next_reject ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
