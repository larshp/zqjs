CLASS zcl_qjs_object DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
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
    METHODS get
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS set IMPORTING name TYPE string value TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS define_property
      IMPORTING name TYPE string value TYPE zcl_qjs_value=>ty_value
        writable TYPE abap_bool DEFAULT abap_true
        enumerable TYPE abap_bool DEFAULT abap_true
        configurable TYPE abap_bool DEFAULT abap_true
      RAISING zcx_qjs_error.
    METHODS define_accessor
      IMPORTING name TYPE string getter TYPE zcl_qjs_value=>ty_value
        setter TYPE zcl_qjs_value=>ty_value
        enumerable TYPE abap_bool DEFAULT abap_false
        configurable TYPE abap_bool DEFAULT abap_false
      RAISING zcx_qjs_error.
    METHODS delete
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_own
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS has_property
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
    METHODS own_property_count RETURNING VALUE(result) TYPE i.
    METHODS get_prototype RETURNING VALUE(result) TYPE REF TO zcl_qjs_object.
    METHODS get_descriptor
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_shape=>ty_descriptor.
    METHODS get_own_property
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE ty_own_property.
    METHODS set_element IMPORTING index TYPE int8 value TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS get_element
      IMPORTING index TYPE int8
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS is_array RETURNING VALUE(result) TYPE abap_bool.
    METHODS set_array_length IMPORTING length TYPE int8 RAISING zcx_qjs_error.
    METHODS own_keys RETURNING VALUE(result) TYPE zcl_qjs_shape=>ty_names.
    METHODS own_property_names RETURNING VALUE(result) TYPE zcl_qjs_shape=>ty_names.
    METHODS set_prototype IMPORTING prototype TYPE REF TO zcl_qjs_object OPTIONAL
      RAISING zcx_qjs_error.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_property,
      name TYPE string,
      value TYPE zcl_qjs_value=>ty_value,
      getter TYPE zcl_qjs_value=>ty_value,
      setter TYPE zcl_qjs_value=>ty_value,
    END OF ty_property.
    TYPES ty_properties TYPE HASHED TABLE OF ty_property WITH UNIQUE KEY name.
    DATA mt_properties TYPE ty_properties.
    DATA mo_prototype TYPE REF TO zcl_qjs_object.
    DATA mv_is_array TYPE abap_bool.
    DATA mv_length TYPE int8.
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
    METHODS invoke_callable
      IMPORTING callable TYPE zcl_qjs_value=>ty_value
        this_value TYPE zcl_qjs_value=>ty_value
        arguments TYPE zif_qjs_callable=>ty_arguments OPTIONAL
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS raise_error IMPORTING name TYPE string message TYPE string.
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
        result = ls_property-value.
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

  METHOD set_with_receiver.
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
        ls_existing-value = value.
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

  METHOD define_property.
    DATA ls_descriptor TYPE zcl_qjs_shape=>ty_descriptor.
    ls_descriptor = mo_shape->lookup( name ).
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
    ls_property-value = value.
    DELETE TABLE mt_properties WITH TABLE KEY name = name.
    INSERT ls_property INTO TABLE mt_properties.
  ENDMETHOD.

  METHOD define_accessor.
    DATA(ls_descriptor) = mo_shape->lookup( name ).
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
    DATA(ls_descriptor) = mo_shape->lookup( name ).
    IF ls_descriptor-found = abap_true AND ls_descriptor-configurable = abap_false.
      result = abap_false.
      RETURN.
    ENDIF.
    DELETE TABLE mt_properties WITH TABLE KEY name = name.
    mo_shape = mo_shape->without( name ).
    result = abap_true.
  ENDMETHOD.

  METHOD has_own.
    result = mo_shape->lookup( name )-found.
  ENDMETHOD.

  METHOD has_property.
    result = has_own( name ).
    IF result = abap_false AND mo_prototype IS BOUND.
      result = mo_prototype->has_property( name ).
    ENDIF.
  ENDMETHOD.

  METHOD own_property_count.
    result = mo_shape->property_count( ).
  ENDMETHOD.

  METHOD get_prototype.
    result = mo_prototype.
  ENDMETHOD.

  METHOD get_descriptor.
    result = mo_shape->lookup( name ).
  ENDMETHOD.

  METHOD get_own_property.
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
    result-value = ls_property-value.
    result-getter = ls_property-getter.
    result-setter = ls_property-setter.
    result-writable = ls_descriptor-writable.
    result-enumerable = ls_descriptor-enumerable.
    result-configurable = ls_descriptor-configurable.
  ENDMETHOD.

  METHOD set_element.
    DATA lv_name TYPE string.
    lv_name = index.
    CONDENSE lv_name NO-GAPS.
    set( name = lv_name value = value ).
    IF index >= mv_length.
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
    IF mv_is_array = abap_false OR length < 0.
      raise_error( name = 'RangeError' message = 'invalid array length' ).
    ENDIF.
    mv_length = length.
  ENDMETHOD.

  METHOD own_keys.
    result = mo_shape->names( enumerable_only = abap_true ).
  ENDMETHOD.

  METHOD own_property_names.
    result = mo_shape->names( ).
  ENDMETHOD.

  METHOD set_prototype.
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
ENDCLASS.
