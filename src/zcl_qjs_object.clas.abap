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
    TYPES ty_symbol_ids TYPE STANDARD TABLE OF int8 WITH DEFAULT KEY.
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
      IMPORTING identity TYPE int8
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS reflect_get
      IMPORTING name TYPE string receiver TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS reflect_get_symbol
      IMPORTING identity TYPE int8 receiver TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS reflect_set
      IMPORTING name TYPE string value TYPE zcl_qjs_value=>ty_value
        receiver TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS reflect_set_symbol
      IMPORTING identity TYPE int8 value TYPE zcl_qjs_value=>ty_value
        receiver TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS set_symbol
      IMPORTING identity TYPE int8 value TYPE zcl_qjs_value=>ty_value
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
      IMPORTING identity TYPE int8 value TYPE zcl_qjs_value=>ty_value
        writable TYPE abap_bool DEFAULT abap_true
        enumerable TYPE abap_bool DEFAULT abap_true
        configurable TYPE abap_bool DEFAULT abap_true
      RAISING zcx_qjs_error.
    METHODS define_symbol_accessor
      IMPORTING identity TYPE int8 getter TYPE zcl_qjs_value=>ty_value
        setter TYPE zcl_qjs_value=>ty_value
        enumerable TYPE abap_bool DEFAULT abap_false
        configurable TYPE abap_bool DEFAULT abap_false
      RAISING zcx_qjs_error.
    METHODS delete
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS delete_symbol
      IMPORTING identity TYPE int8
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_own
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_property
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_own_symbol
      IMPORTING identity TYPE int8
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_symbol_property
      IMPORTING identity TYPE int8
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS add_private_field
      IMPORTING identity TYPE int8 value TYPE zcl_qjs_value=>ty_value
        writable TYPE abap_bool DEFAULT abap_true
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_private_field
      IMPORTING identity TYPE int8
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS get_private_field
      IMPORTING identity TYPE int8 receiver TYPE zcl_qjs_value=>ty_value OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS set_private_field
      IMPORTING identity TYPE int8 value TYPE zcl_qjs_value=>ty_value
        receiver TYPE zcl_qjs_value=>ty_value OPTIONAL
      RETURNING VALUE(result) TYPE abap_bool
      RAISING zcx_qjs_error.
    METHODS add_private_accessor
      IMPORTING identity TYPE int8 getter TYPE zcl_qjs_value=>ty_value
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
      IMPORTING identity TYPE int8
      RETURNING VALUE(result) TYPE ty_own_property.
    METHODS set_element IMPORTING index TYPE int8 value TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
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
      getter TYPE zcl_qjs_value=>ty_value,
      setter TYPE zcl_qjs_value=>ty_value,
      cell TYPE REF TO zcl_qjs_cell,
    END OF ty_property.
    TYPES ty_properties TYPE HASHED TABLE OF ty_property WITH UNIQUE KEY name.
    TYPES: BEGIN OF ty_symbol_property,
      identity TYPE int8,
      value TYPE zcl_qjs_value=>ty_value,
      getter TYPE zcl_qjs_value=>ty_value,
      setter TYPE zcl_qjs_value=>ty_value,
      accessor TYPE abap_bool,
      writable TYPE abap_bool,
      enumerable TYPE abap_bool,
      configurable TYPE abap_bool,
      insertion_order TYPE i,
    END OF ty_symbol_property.
    TYPES ty_symbol_properties TYPE HASHED TABLE OF ty_symbol_property
      WITH UNIQUE KEY identity.
    TYPES: BEGIN OF ty_private_field,
      identity TYPE int8,
      value TYPE zcl_qjs_value=>ty_value,
      writable TYPE abap_bool,
      accessor TYPE abap_bool,
      getter TYPE zcl_qjs_value=>ty_value,
      setter TYPE zcl_qjs_value=>ty_value,
    END OF ty_private_field.
    TYPES ty_private_fields TYPE HASHED TABLE OF ty_private_field
      WITH UNIQUE KEY identity.
    DATA mt_properties TYPE ty_properties.
    DATA mt_symbol_properties TYPE ty_symbol_properties.
    DATA mt_private_fields TYPE ty_private_fields.
    DATA mv_next_symbol_order TYPE i.
    DATA mo_prototype TYPE REF TO zcl_qjs_object.
    DATA mv_is_array TYPE abap_bool.
    DATA mv_extensible TYPE abap_bool VALUE abap_true.
    TYPES ty_collection_entries TYPE STANDARD TABLE OF ty_collection_entry
      WITH DEFAULT KEY.
    DATA mv_collection_kind TYPE i.
    DATA mt_collection_entries TYPE ty_collection_entries.
    DATA mo_iterator_collection TYPE REF TO zcl_qjs_object.
    DATA mv_iterator_kind TYPE i.
    DATA mv_iterator_index TYPE i.
    DATA mv_iterator_source_kind TYPE i.
    DATA ms_iterator_string TYPE zcl_qjs_value=>ty_value.
    DATA mo_generator_function TYPE REF TO zcl_qjs_function.
    DATA mo_generator_closure TYPE REF TO zcl_qjs_closure.
    DATA mo_generator_vm TYPE REF TO zcl_qjs_vm.
    DATA ms_generator_this TYPE zcl_qjs_value=>ty_value.
    DATA mt_generator_arguments TYPE zif_qjs_callable=>ty_arguments.
    DATA mv_generator_state TYPE i.
    DATA mo_async_generator TYPE REF TO zcl_qjs_async_generator.
    TYPES: BEGIN OF ty_promise_reaction,
      on_fulfilled TYPE zcl_qjs_value=>ty_value,
      on_rejected TYPE zcl_qjs_value=>ty_value,
      next_promise TYPE REF TO zcl_qjs_object,
      next_resolve TYPE zcl_qjs_value=>ty_value,
      next_reject TYPE zcl_qjs_value=>ty_value,
    END OF ty_promise_reaction.
    TYPES ty_promise_reactions TYPE STANDARD TABLE OF ty_promise_reaction
      WITH DEFAULT KEY.
    DATA mv_promise_state TYPE i.
    DATA ms_promise_result TYPE zcl_qjs_value=>ty_value.
    DATA mt_promise_reactions TYPE ty_promise_reactions.
    DATA mv_promise_handled TYPE abap_bool.
    DATA mv_promise_rejection_notified TYPE abap_bool.
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
      IMPORTING identity TYPE int8 receiver TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS set_symbol_with_receiver
      IMPORTING identity TYPE int8 value TYPE zcl_qjs_value=>ty_value
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
ENDCLASS.

CLASS zcl_qjs_object IMPLEMENTATION.
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
    DATA ls_property TYPE ty_property.
    IF mv_is_array = abap_true AND name = 'length'.
      IF mv_length <= 2147483647.
        result = zcl_qjs_value=>new_int( CONV i( mv_length ) ).
      ELSE.
        result = zcl_qjs_value=>new_finite( CONV f( mv_length ) ).
      ENDIF.
      RETURN.
    ENDIF.
    READ TABLE mt_properties WITH TABLE KEY name = name INTO ls_property.
    IF sy-subrc = 0.
      DATA(ls_descriptor) = mo_shape->lookup( name ).
      IF ls_descriptor-accessor = abap_true.
        IF ls_property-getter-tag = zcl_qjs_value=>tag_undefined.
          result = zcl_qjs_value=>new_undefined( ).
        ELSE.
          result = invoke_callable(
            callable = ls_property-getter this_value = receiver ).
        ENDIF.
      ELSE.
        IF ls_property-cell IS BOUND.
          result = ls_property-cell->get( ).
        ELSE.
          result = ls_property-value.
        ENDIF.
      ENDIF.
    ELSEIF mo_prototype IS BOUND.
      result = mo_prototype->get_with_receiver( name = name receiver = receiver ).
    ELSE.
      result = zcl_qjs_value=>new_undefined( ).
    ENDIF.
  ENDMETHOD.

  METHOD set.
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
        IF ls_property-getter-tag = zcl_qjs_value=>tag_undefined.
          result = zcl_qjs_value=>new_undefined( ).
        ELSE.
          result = invoke_callable(
            callable = ls_property-getter this_value = receiver ).
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
        IF ls_existing-setter-tag = zcl_qjs_value=>tag_undefined.
          raise_error( name = 'TypeError' message = 'property has no setter' ).
        ENDIF.
        DATA lt_setter_arguments TYPE zif_qjs_callable=>ty_arguments.
        APPEND value TO lt_setter_arguments.
        DATA(ls_ignored) = invoke_callable(
          callable = ls_existing-setter this_value = receiver
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
        IF ls_existing-setter-tag = zcl_qjs_value=>tag_undefined.
          RETURN.
        ENDIF.
        DATA lt_setter_arguments TYPE zif_qjs_callable=>ty_arguments.
        APPEND value TO lt_setter_arguments.
        DATA(ls_ignored) = invoke_callable(
          callable = ls_existing-setter this_value = receiver
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
          AND ls_length_value-number_kind = zcl_qjs_value=>number_neg_zero.
        lv_new_length = 0.
      ELSEIF ls_length_value-tag = zcl_qjs_value=>tag_number
          AND ls_length_value-number_kind = zcl_qjs_value=>number_finite
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
    DATA ls_descriptor TYPE zcl_qjs_shape=>ty_descriptor.
    ls_descriptor = mo_shape->lookup( name ).
    IF ls_descriptor-found = abap_true.
      READ TABLE mt_properties WITH TABLE KEY name = name INTO DATA(ls_existing).
      IF ls_descriptor-accessor = abap_true.
        IF ls_existing-setter-tag = zcl_qjs_value=>tag_undefined.
          raise_error( name = 'TypeError' message = 'property has no setter' ).
        ENDIF.
        DATA lt_setter_arguments TYPE zif_qjs_callable=>ty_arguments.
        APPEND value TO lt_setter_arguments.
        DATA(ls_ignored) = invoke_callable(
          callable = ls_existing-setter this_value = receiver
          arguments = lt_setter_arguments ).
        RETURN.
      ELSEIF ls_descriptor-writable = abap_false.
        raise_error( name = 'TypeError' message = 'property is not writable' ).
      ELSEIF receiver-object_ref = me.
        IF ls_existing-cell IS BOUND.
          ls_existing-cell->set( value ).
        ELSE.
          ls_existing-value = value.
        ENDIF.
        DELETE TABLE mt_properties WITH TABLE KEY name = name.
        INSERT ls_existing INTO TABLE mt_properties.
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
      READ TABLE mt_properties WITH TABLE KEY name = name INTO DATA(ls_existing).
      IF ls_descriptor-accessor = abap_true.
        IF ls_existing-setter-tag = zcl_qjs_value=>tag_undefined.
          RETURN.
        ENDIF.
        DATA lt_setter_arguments TYPE zif_qjs_callable=>ty_arguments.
        APPEND value TO lt_setter_arguments.
        DATA(ls_ignored) = invoke_callable(
          callable = ls_existing-setter this_value = receiver
          arguments = lt_setter_arguments ).
        result = abap_true.
        RETURN.
      ELSEIF ls_descriptor-writable = abap_false.
        RETURN.
      ELSEIF receiver-object_ref = me.
        IF ls_existing-cell IS BOUND.
          ls_existing-cell->set( value ).
        ELSE.
          ls_existing-value = value.
        ENDIF.
        DELETE TABLE mt_properties WITH TABLE KEY name = name.
        INSERT ls_existing INTO TABLE mt_properties.
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
            left = ls_old_accessor-getter right = getter ) = abap_false
          OR zcl_qjs_value=>strict_equal(
            left = ls_old_accessor-setter right = setter ) = abap_false.
        raise_error( name = 'TypeError' message = 'property is not configurable' ).
      ENDIF.
    ENDIF.
    mo_shape = mo_shape->transition(
      name = name writable = abap_false enumerable = enumerable
      configurable = configurable accessor = abap_true ).
    DATA ls_property TYPE ty_property.
    ls_property-name = name.
    ls_property-getter = getter.
    ls_property-setter = setter.
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
            left = ls_old_property-getter right = getter ) = abap_false
          OR zcl_qjs_value=>strict_equal(
            left = ls_old_property-setter right = setter ) = abap_false.
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
    ls_property-getter = getter.
    ls_property-setter = setter.
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
    TRY.
        lo_closure ?= callable-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_closure IS BOUND.
      result = lo_closure->invoke(
        this_value = this_value arguments = arguments ).
      RETURN.
    ENDIF.
    TRY.
        lo_callable ?= callable-object_ref.
      CATCH cx_sy_move_cast_error.
        raise_error( name = 'TypeError' message = 'accessor is not callable' ).
    ENDTRY.
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
    DATA ls_field TYPE ty_private_field.
    READ TABLE mt_private_fields WITH TABLE KEY identity = identity
      TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      RETURN.
    ENDIF.
    ls_field-identity = identity.
    ls_field-value = value.
    ls_field-writable = writable.
    INSERT ls_field INTO TABLE mt_private_fields.
    result = abap_true.
  ENDMETHOD.

  METHOD has_private_field.
    READ TABLE mt_private_fields WITH TABLE KEY identity = identity
      TRANSPORTING NO FIELDS.
    result = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.

  METHOD get_private_field.
    READ TABLE mt_private_fields WITH TABLE KEY identity = identity
      INTO DATA(ls_field).
    IF sy-subrc = 0.
      IF ls_field-accessor = abap_true.
        IF ls_field-getter-tag = zcl_qjs_value=>tag_undefined.
          raise_error(
            name = 'TypeError' message = 'private accessor has no getter' ).
        ENDIF.
        result = invoke_callable(
          callable = ls_field-getter this_value = receiver ).
      ELSE.
        result = ls_field-value.
      ENDIF.
    ELSE.
      result = zcl_qjs_value=>new_undefined( ).
    ENDIF.
  ENDMETHOD.

  METHOD set_private_field.
    FIELD-SYMBOLS <field> TYPE ty_private_field.
    READ TABLE mt_private_fields WITH TABLE KEY identity = identity
      ASSIGNING <field>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    IF <field>-accessor = abap_true.
      IF <field>-setter-tag = zcl_qjs_value=>tag_undefined.
        RETURN.
      ENDIF.
      DATA lt_private_setter_args TYPE zif_qjs_callable=>ty_arguments.
      APPEND value TO lt_private_setter_args.
      DATA(ls_private_setter_result) = invoke_callable(
        callable = <field>-setter this_value = receiver
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
    FIELD-SYMBOLS <field> TYPE ty_private_field.
    READ TABLE mt_private_fields WITH TABLE KEY identity = identity
      ASSIGNING <field>.
    IF sy-subrc = 0.
      IF <field>-accessor = abap_false.
        RETURN.
      ENDIF.
      IF getter-tag <> zcl_qjs_value=>tag_undefined.
        <field>-getter = getter.
      ENDIF.
      IF setter-tag <> zcl_qjs_value=>tag_undefined.
        <field>-setter = setter.
      ENDIF.
      result = abap_true.
      RETURN.
    ENDIF.
    DATA ls_accessor TYPE ty_private_field.
    ls_accessor-identity = identity.
    ls_accessor-accessor = abap_true.
    ls_accessor-getter = getter.
    ls_accessor-setter = setter.
    INSERT ls_accessor INTO TABLE mt_private_fields.
    result = abap_true.
  ENDMETHOD.

  METHOD own_property_count.
    result = mo_shape->property_count( ) + lines( mt_symbol_properties ).
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
    result-getter = ls_property-getter.
    result-setter = ls_property-setter.
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
    result-getter = ls_property-getter.
    result-setter = ls_property-setter.
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
    set( name = lv_name value = value ).
    IF index >= mv_length AND index >= 0 AND index < lv_max_array_length.
      mv_length = index + 1.
    ENDIF.
  ENDMETHOD.

  METHOD get_element.
    DATA lv_name TYPE string.
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
  ENDMETHOD.

  METHOD own_property_names.
    result = mo_shape->names( ).
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
    mv_collection_kind = kind.
    CLEAR mt_collection_entries.
  ENDMETHOD.

  METHOD collection_kind.
    result = mv_collection_kind.
  ENDMETHOD.

  METHOD collection_key_equal.
    result = zcl_qjs_value=>strict_equal( left = left right = right ).
    IF result = abap_false
        AND left-tag = zcl_qjs_value=>tag_number
        AND right-tag = zcl_qjs_value=>tag_number
        AND left-number_kind = zcl_qjs_value=>number_nan
        AND right-number_kind = zcl_qjs_value=>number_nan.
      result = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD collection_size.
    LOOP AT mt_collection_entries INTO DATA(ls_entry).
      IF ls_entry-deleted = abap_false.
        result = result + 1.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD collection_slots.
    result = lines( mt_collection_entries ).
  ENDMETHOD.

  METHOD collection_get.
    LOOP AT mt_collection_entries INTO DATA(ls_entry).
      IF ls_entry-deleted = abap_false AND collection_key_equal(
          left = ls_entry-key right = key ) = abap_true.
        result = ls_entry.
        result-found = abap_true.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD collection_set_entry.
    LOOP AT mt_collection_entries ASSIGNING FIELD-SYMBOL(<ls_entry>).
      IF <ls_entry>-deleted = abap_false AND collection_key_equal(
          left = <ls_entry>-key right = key ) = abap_true.
        <ls_entry>-value = value.
        RETURN.
      ENDIF.
    ENDLOOP.
    DATA ls_entry TYPE ty_collection_entry.
    ls_entry-key = key.
    ls_entry-value = value.
    APPEND ls_entry TO mt_collection_entries.
  ENDMETHOD.

  METHOD collection_delete.
    LOOP AT mt_collection_entries ASSIGNING FIELD-SYMBOL(<ls_entry>).
      IF <ls_entry>-deleted = abap_false AND collection_key_equal(
          left = <ls_entry>-key right = key ) = abap_true.
        <ls_entry>-deleted = abap_true.
        result = abap_true.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD collection_clear.
    LOOP AT mt_collection_entries ASSIGNING FIELD-SYMBOL(<ls_entry>).
      <ls_entry>-deleted = abap_true.
    ENDLOOP.
  ENDMETHOD.

  METHOD collection_entry_at.
    READ TABLE mt_collection_entries INDEX index INTO result.
    IF sy-subrc = 0.
      result-found = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD initialize_iterator.
    mo_iterator_collection = collection.
    mv_iterator_kind = kind.
    mv_iterator_index = 1.
    mv_iterator_source_kind = 1.
  ENDMETHOD.

  METHOD initialize_array_iterator.
    mo_iterator_collection = array.
    mv_iterator_kind = kind.
    mv_iterator_index = 0.
    mv_iterator_source_kind = 2.
  ENDMETHOD.

  METHOD initialize_string_iterator.
    ms_iterator_string = value.
    mv_iterator_kind = iterator_values.
    mv_iterator_index = 0.
    mv_iterator_source_kind = 3.
  ENDMETHOD.

  METHOD iterator_next.
    IF mv_iterator_source_kind = 2 AND mo_iterator_collection IS BOUND.
      DATA(ls_length_value) = mo_iterator_collection->get( 'length' ).
      DATA(lv_length) = CONV int8( 0 ).
      IF ls_length_value-tag = zcl_qjs_value=>tag_int.
        lv_length = ls_length_value-int_value.
      ENDIF.
      IF mv_iterator_index < lv_length.
        result-found = abap_true.
        result-key = zcl_qjs_value=>new_int( mv_iterator_index ).
        result-value = mo_iterator_collection->get_element(
          CONV int8( mv_iterator_index ) ).
        mv_iterator_index = mv_iterator_index + 1.
        RETURN.
      ENDIF.
      CLEAR mo_iterator_collection.
      CLEAR mv_iterator_source_kind.
      RETURN.
    ELSEIF mv_iterator_source_kind = 3
        AND ms_iterator_string-tag = zcl_qjs_value=>tag_string.
      IF mv_iterator_index < ms_iterator_string-string_ref->length( ).
        result-found = abap_true.
        result-key = zcl_qjs_value=>new_int( mv_iterator_index ).
        DATA(lv_first_code) = ms_iterator_string-string_ref->code_unit_value_at(
          mv_iterator_index ).
        DATA(lv_width) = 1.
        IF lv_first_code >= 55296 AND lv_first_code <= 56319
            AND mv_iterator_index + 1 < ms_iterator_string-string_ref->length( ).
          DATA(lv_second_index) = mv_iterator_index + 1.
          DATA(lv_second_code) =
            ms_iterator_string-string_ref->code_unit_value_at( lv_second_index ).
          IF lv_second_code >= 56320 AND lv_second_code <= 57343.
            lv_width = 2.
          ENDIF.
        ENDIF.
        DATA(lv_string_source) = ms_iterator_string-string_ref->as_string( ).
        DATA lv_iterator_value TYPE string.
        lv_iterator_value = lv_string_source+mv_iterator_index(lv_width).
        result-value = zcl_qjs_value=>new_string( lv_iterator_value ).
        mv_iterator_index = mv_iterator_index + lv_width.
        RETURN.
      ENDIF.
      CLEAR ms_iterator_string.
      CLEAR mv_iterator_source_kind.
      RETURN.
    ENDIF.
    WHILE mv_iterator_source_kind = 1 AND mo_iterator_collection IS BOUND
        AND mv_iterator_index <= mo_iterator_collection->collection_slots( ).
      result = mo_iterator_collection->collection_entry_at( mv_iterator_index ).
      mv_iterator_index = mv_iterator_index + 1.
      IF result-found = abap_true AND result-deleted = abap_false.
        RETURN.
      ENDIF.
    ENDWHILE.
    CLEAR result.
    CLEAR mo_iterator_collection.
    CLEAR mv_iterator_source_kind.
  ENDMETHOD.

  METHOD iterator_kind.
    result = mv_iterator_kind.
  ENDMETHOD.

  METHOD initialize_generator.
    IF function IS NOT BOUND OR closure IS NOT BOUND OR mo_runtime IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'Generator requires an active function and runtime'.
    ENDIF.
    mo_generator_function = function.
    mo_generator_closure = closure.
    ms_generator_this = this_value.
    mt_generator_arguments = arguments.
    CREATE OBJECT mo_generator_vm
      EXPORTING runtime = mo_runtime limits = mo_runtime->get_limits( ).
    mv_generator_state = 1.
  ENDMETHOD.

  METHOD generator_next.
    IF mo_generator_function IS NOT BOUND OR mo_generator_vm IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: generator receiver is incompatible'.
    ENDIF.
    DATA ls_value TYPE zcl_qjs_value=>ty_value.
    DATA lv_done TYPE abap_bool.
    IF mv_generator_state = 3.
      ls_value = zcl_qjs_value=>new_undefined( ).
      lv_done = abap_true.
    ELSEIF mv_generator_state = 2.
      mv_generator_state = 4.
      TRY.
          ls_value = mo_generator_vm->execute(
            function     = mo_generator_function
            resume       = abap_true
            resume_value = input ).
        CATCH zcx_qjs_error INTO DATA(lx_generator_resume).
          mv_generator_state = 3.
          RAISE EXCEPTION lx_generator_resume.
        CATCH zcx_qjs_throw INTO DATA(lx_generator_resume_throw).
          mv_generator_state = 3.
          RAISE EXCEPTION lx_generator_resume_throw.
      ENDTRY.
      IF mo_generator_vm->was_suspended( ) = abap_true.
        mv_generator_state = 2.
      ELSE.
        mv_generator_state = 3.
        lv_done = abap_true.
      ENDIF.
    ELSEIF mv_generator_state = 1.
      mv_generator_state = 4.
      TRY.
          ls_value = mo_generator_vm->execute(
            function          = mo_generator_function
            initial_closure   = mo_generator_closure
            initial_this      = ms_generator_this
            initial_arguments = mt_generator_arguments ).
        CATCH zcx_qjs_error INTO DATA(lx_generator_start).
          mv_generator_state = 3.
          RAISE EXCEPTION lx_generator_start.
        CATCH zcx_qjs_throw INTO DATA(lx_generator_start_throw).
          mv_generator_state = 3.
          RAISE EXCEPTION lx_generator_start_throw.
      ENDTRY.
      IF mo_generator_vm->was_suspended( ) = abap_true.
        mv_generator_state = 2.
      ELSE.
        mv_generator_state = 3.
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
    IF mo_generator_function IS NOT BOUND OR mo_generator_vm IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: generator receiver is incompatible'.
    ENDIF.
    IF mv_generator_state = 3 OR mv_generator_state = 1.
      mv_generator_state = 3.
      RAISE EXCEPTION TYPE zcx_qjs_throw EXPORTING value = input.
    ELSEIF mv_generator_state = 2.
      mv_generator_state = 4.
      TRY.
          DATA(ls_value) = mo_generator_vm->execute(
            function     = mo_generator_function
            resume       = abap_true
            resume_kind  = 2
            resume_value = input ).
        CATCH zcx_qjs_error INTO DATA(lx_generator_error).
          mv_generator_state = 3.
          RAISE EXCEPTION lx_generator_error.
        CATCH zcx_qjs_throw INTO DATA(lx_generator_throw).
          mv_generator_state = 3.
          RAISE EXCEPTION lx_generator_throw.
      ENDTRY.
      DATA(lv_done) = abap_false.
      IF mo_generator_vm->was_suspended( ) = abap_true.
        mv_generator_state = 2.
      ELSE.
        mv_generator_state = 3.
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
    IF mo_generator_function IS NOT BOUND OR mo_generator_vm IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: generator receiver is incompatible'.
    ENDIF.
    IF mv_generator_state = 4.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: generator is already running'.
    ENDIF.
    DATA(ls_value) = input.
    DATA(lv_done) = abap_true.
    IF mv_generator_state = 2.
      mv_generator_state = 4.
      TRY.
          ls_value = mo_generator_vm->execute(
            function     = mo_generator_function
            resume       = abap_true
            resume_kind  = 1
            resume_value = input ).
        CATCH zcx_qjs_error INTO DATA(lx_generator_error).
          mv_generator_state = 3.
          RAISE EXCEPTION lx_generator_error.
        CATCH zcx_qjs_throw INTO DATA(lx_generator_throw).
          mv_generator_state = 3.
          RAISE EXCEPTION lx_generator_throw.
      ENDTRY.
      IF mo_generator_vm->was_suspended( ) = abap_true.
        mv_generator_state = 2.
        lv_done = abap_false.
      ELSE.
        mv_generator_state = 3.
      ENDIF.
    ELSE.
      mv_generator_state = 3.
    ENDIF.
    DATA(lo_result) = mo_runtime->create_object( ).
    lo_result->define_property( name = 'value' value = ls_value ).
    lo_result->define_property(
      name = 'done' value = zcl_qjs_value=>new_boolean( lv_done ) ).
    result = zcl_qjs_value=>new_object( lo_result ).
  ENDMETHOD.

  METHOD is_generator.
    result = xsdbool( mo_generator_function IS BOUND ).
  ENDMETHOD.

  METHOD initialize_async_generator.
    CREATE OBJECT mo_async_generator
      EXPORTING runtime = mo_runtime function = function closure = closure
        this_value = this_value arguments = arguments.
  ENDMETHOD.

  METHOD async_generator_enqueue.
    IF mo_async_generator IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: async generator receiver is incompatible'.
    ENDIF.
    result = mo_async_generator->enqueue( kind = kind input = input ).
  ENDMETHOD.

  METHOD is_async_generator.
    result = xsdbool( mo_async_generator IS BOUND ).
  ENDMETHOD.

  METHOD initialize_promise.
    mv_promise_state = promise_pending.
    ms_promise_result = zcl_qjs_value=>new_undefined( ).
    CLEAR mt_promise_reactions.
    CLEAR mv_promise_handled.
    CLEAR mv_promise_rejection_notified.
  ENDMETHOD.

  METHOD is_promise.
    result = xsdbool( mv_promise_state <> 0 ).
  ENDMETHOD.

  METHOD promise_state.
    result = mv_promise_state.
  ENDMETHOD.

  METHOD promise_result.
    result = ms_promise_result.
  ENDMETHOD.

  METHOD promise_settle.
    IF mv_promise_state <> promise_pending.
      RETURN.
    ENDIF.
    IF value-tag = zcl_qjs_value=>tag_object AND value-object_ref = me.
      mv_promise_state = promise_rejected.
      IF mo_runtime IS BOUND.
        ms_promise_result = mo_runtime->create_error(
          name = 'TypeError' message = 'A promise cannot resolve to itself' ).
      ELSE.
        ms_promise_result = zcl_qjs_value=>new_string(
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
            lo_then_properties = value-property_ref.
            IF lo_then_properties IS NOT BOUND.
              TRY.
                  lo_then_properties ?= value-object_ref.
                CATCH cx_sy_move_cast_error.
              ENDTRY.
            ENDIF.
            IF lo_then_properties IS BOUND.
              ls_then_method = lo_then_properties->get_property( 'then' ).
            ELSE.
              ls_then_method = zcl_qjs_value=>new_undefined( ).
            ENDIF.
          ENDIF.
        CATCH zcx_qjs_throw INTO DATA(lx_then_get_throw).
          ms_promise_result = lx_then_get_throw->value.
          mv_promise_state = promise_rejected.
          lv_then_failed = abap_true.
        CATCH zcx_qjs_error INTO DATA(lx_then_get_error).
          IF mo_runtime IS BOUND.
            ms_promise_result = mo_runtime->create_error_from_reason(
              lx_then_get_error->reason ).
          ELSE.
            ms_promise_result = zcl_qjs_value=>new_string(
              lx_then_get_error->reason ).
          ENDIF.
          mv_promise_state = promise_rejected.
          lv_then_failed = abap_true.
      ENDTRY.
      IF lv_then_failed = abap_false AND mo_runtime IS BOUND
          AND mo_runtime->is_callable_value( ls_then_method ) = abap_true.
        mo_runtime->enqueue_thenable_job(
          promise = me thenable = value then_method = ls_then_method ).
        RETURN.
      ELSEIF lv_then_failed = abap_false.
        ms_promise_result = value.
        mv_promise_state = promise_fulfilled.
      ENDIF.
    ELSE.
      ms_promise_result = value.
      IF rejected = abap_true.
        mv_promise_state = promise_rejected.
      ELSE.
        mv_promise_state = promise_fulfilled.
      ENDIF.
    ENDIF.
    IF mo_runtime IS BOUND.
      LOOP AT mt_promise_reactions INTO DATA(ls_reaction).
        mo_runtime->enqueue_promise_job(
          settled_promise = me
          on_fulfilled    = ls_reaction-on_fulfilled
          on_rejected     = ls_reaction-on_rejected
          next_promise    = ls_reaction-next_promise
          next_resolve    = ls_reaction-next_resolve
          next_reject     = ls_reaction-next_reject ).
      ENDLOOP.
      IF mv_promise_state = promise_rejected
          AND mv_promise_handled = abap_false.
        mv_promise_rejection_notified = abap_true.
        mo_runtime->track_promise_rejection(
          promise = me reason = ms_promise_result handled = abap_false ).
      ENDIF.
    ENDIF.
    CLEAR mt_promise_reactions.
  ENDMETHOD.

  METHOD promise_add_reaction.
    IF mv_promise_state = 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING reason = 'TypeError: Promise method receiver is not a Promise'.
    ENDIF.
    IF mv_promise_state = promise_rejected
        AND mv_promise_handled = abap_false
        AND mv_promise_rejection_notified = abap_true
        AND mo_runtime IS BOUND.
      mo_runtime->track_promise_rejection(
        promise = me reason = ms_promise_result handled = abap_true ).
    ENDIF.
    mv_promise_handled = abap_true.
    IF mv_promise_state = promise_pending.
      APPEND VALUE ty_promise_reaction(
        on_fulfilled = on_fulfilled on_rejected = on_rejected
        next_promise = next_promise next_resolve = next_resolve
        next_reject = next_reject ) TO mt_promise_reactions.
    ELSEIF mo_runtime IS BOUND.
      mo_runtime->enqueue_promise_job(
        settled_promise = me on_fulfilled = on_fulfilled
        on_rejected = on_rejected next_promise = next_promise
        next_resolve = next_resolve next_reject = next_reject ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
