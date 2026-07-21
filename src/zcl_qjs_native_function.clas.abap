CLASS zcl_qjs_native_function DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_qjs_callable.
    INTERFACES zif_qjs_constructable.
    INTERFACES zif_qjs_property_container.
    CONSTANTS id_number TYPE i VALUE 1.
    CONSTANTS id_string TYPE i VALUE 2.
    CONSTANTS id_boolean TYPE i VALUE 3.
    CONSTANTS id_object TYPE i VALUE 4.
    CONSTANTS id_array TYPE i VALUE 5.
    CONSTANTS id_is_nan TYPE i VALUE 6.
    CONSTANTS id_math_abs TYPE i VALUE 20.
    CONSTANTS id_math_floor TYPE i VALUE 21.
    CONSTANTS id_math_ceil TYPE i VALUE 22.
    CONSTANTS id_math_max TYPE i VALUE 23.
    CONSTANTS id_math_min TYPE i VALUE 24.
    CONSTANTS id_array_is_array TYPE i VALUE 25.
    CONSTANTS id_object_keys TYPE i VALUE 26.
    CONSTANTS id_object_define_property TYPE i VALUE 27.
    CONSTANTS id_object_get_own_descriptor TYPE i VALUE 28.
    CONSTANTS id_object_create TYPE i VALUE 29.
    CONSTANTS id_object_get_prototype TYPE i VALUE 30.
    CONSTANTS id_object_set_prototype TYPE i VALUE 31.
    CONSTANTS id_object_define_properties TYPE i VALUE 32.
    CONSTANTS id_object_get_own_names TYPE i VALUE 33.
    CONSTANTS id_json_parse TYPE i VALUE 34.
    CONSTANTS id_json_stringify TYPE i VALUE 35.
    CONSTANTS id_error TYPE i VALUE 40.
    CONSTANTS id_type_error TYPE i VALUE 41.
    CONSTANTS id_range_error TYPE i VALUE 42.
    CONSTANTS id_syntax_error TYPE i VALUE 43.
    CONSTANTS id_reference_error TYPE i VALUE 44.
    CONSTANTS id_error_to_string TYPE i VALUE 45.
    METHODS constructor IMPORTING id TYPE i runtime TYPE REF TO zcl_qjs_runtime.
    METHODS get_property
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE zcl_qjs_value=>ty_value.
    METHODS set_property IMPORTING name TYPE string value TYPE zcl_qjs_value=>ty_value.
    METHODS delete_property
      IMPORTING name TYPE string
      RETURNING VALUE(result) TYPE abap_bool.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_property,
      name TYPE string,
      value TYPE zcl_qjs_value=>ty_value,
    END OF ty_property.
    TYPES ty_properties TYPE HASHED TABLE OF ty_property WITH UNIQUE KEY name.
    DATA mv_id TYPE i.
    DATA mo_runtime TYPE REF TO zcl_qjs_runtime.
    DATA mt_properties TYPE ty_properties.
    METHODS is_callable
      IMPORTING value TYPE zcl_qjs_value=>ty_value
      RETURNING VALUE(result) TYPE abap_bool.
ENDCLASS.

CLASS zcl_qjs_native_function IMPLEMENTATION.
  METHOD constructor.
    mv_id = id.
    mo_runtime = runtime.
  ENDMETHOD.

  METHOD get_property.
    DATA ls_property TYPE ty_property.
    READ TABLE mt_properties WITH TABLE KEY name = name INTO ls_property.
    IF sy-subrc = 0.
      result = ls_property-value.
    ELSE.
      result = zcl_qjs_value=>new_undefined( ).
    ENDIF.
  ENDMETHOD.

  METHOD set_property.
    DATA ls_property TYPE ty_property.
    ls_property-name = name.
    ls_property-value = value.
    DELETE TABLE mt_properties WITH TABLE KEY name = name.
    INSERT ls_property INTO TABLE mt_properties.
  ENDMETHOD.

  METHOD delete_property.
    DELETE TABLE mt_properties WITH TABLE KEY name = name.
    result = abap_true.
  ENDMETHOD.

  METHOD is_callable.
    DATA lo_closure TYPE REF TO zcl_qjs_closure.
    DATA lo_callable TYPE REF TO zif_qjs_callable.
    result = abap_false.
    IF value-tag <> zcl_qjs_value=>tag_object.
      RETURN.
    ENDIF.
    TRY.
        lo_closure ?= value-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    TRY.
        lo_callable ?= value-object_ref.
      CATCH cx_sy_move_cast_error.
    ENDTRY.
    IF lo_closure IS BOUND OR lo_callable IS BOUND.
      result = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD zif_qjs_property_container~get_property.
    result = get_property( name ).
  ENDMETHOD.

  METHOD zif_qjs_property_container~set_property.
    set_property( name = name value = value ).
  ENDMETHOD.

  METHOD zif_qjs_property_container~delete_property.
    result = delete_property( name ).
  ENDMETHOD.

  METHOD zif_qjs_callable~call.
    DATA ls_argument TYPE zcl_qjs_value=>ty_value.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    DATA lv_index TYPE int8.
    DATA ls_number TYPE zcl_qjs_value=>ty_value.
    DATA ls_best TYPE zcl_qjs_value=>ty_value.
    DATA lv_first TYPE abap_bool VALUE abap_true.
    DATA lt_names TYPE zcl_qjs_shape=>ty_names.
    DATA lv_name TYPE string.
    DATA lv_error_name TYPE string.
    DATA lv_error_message TYPE string.
    DATA lv_to_string_property TYPE string VALUE 'toString'.
    DATA lv_error_separator TYPE string VALUE ': '.
    READ TABLE arguments INDEX 1 INTO ls_argument.
    CASE mv_id.
      WHEN id_number.
        IF sy-subrc = 0.
          result = zcl_qjs_number=>to_number( ls_argument ).
        ELSE.
          result = zcl_qjs_value=>new_int( 0 ).
        ENDIF.
      WHEN id_string.
        IF sy-subrc = 0.
          result = zcl_qjs_value=>new_string( zcl_qjs_value=>to_string( ls_argument ) ).
        ELSE.
          result = zcl_qjs_value=>new_string( '' ).
        ENDIF.
      WHEN id_boolean.
        IF sy-subrc = 0.
          result = zcl_qjs_value=>new_boolean( zcl_qjs_value=>to_boolean( ls_argument ) ).
        ELSE.
          result = zcl_qjs_value=>new_boolean( abap_false ).
        ENDIF.
      WHEN id_object.
        IF sy-subrc = 0 AND ls_argument-tag = zcl_qjs_value=>tag_object.
          result = ls_argument.
        ELSE.
          lo_object = mo_runtime->create_object( ).
          result = zcl_qjs_value=>new_object( lo_object ).
        ENDIF.
      WHEN id_array.
        lo_object = mo_runtime->create_array( ).
        IF lines( arguments ) = 1 AND ls_argument-tag = zcl_qjs_value=>tag_int
            AND ls_argument-int_value >= 0.
          lo_object->set_array_length( CONV int8( ls_argument-int_value ) ).
        ELSE.
          lv_index = 0.
          LOOP AT arguments INTO ls_argument.
            lo_object->set_element( index = lv_index value = ls_argument ).
            lv_index = lv_index + 1.
          ENDLOOP.
        ENDIF.
        result = zcl_qjs_value=>new_object( lo_object ).
      WHEN id_is_nan.
        IF sy-subrc <> 0.
          result = zcl_qjs_value=>new_boolean( abap_true ).
        ELSE.
          ls_argument = zcl_qjs_number=>to_number( ls_argument ).
          result = zcl_qjs_value=>new_boolean(
            xsdbool( ls_argument-tag = zcl_qjs_value=>tag_number
              AND ls_argument-number_kind = zcl_qjs_value=>number_nan ) ).
        ENDIF.
      WHEN id_math_abs.
        IF sy-subrc <> 0.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
        ELSE.
          ls_number = zcl_qjs_number=>to_number( ls_argument ).
          IF ls_number-number_kind = zcl_qjs_value=>number_neg_inf.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
          ELSEIF ls_number-number_kind = zcl_qjs_value=>number_neg_zero.
            result = zcl_qjs_value=>new_finite( 0 ).
          ELSEIF ls_number-number_kind = zcl_qjs_value=>number_finite
              AND ls_number-float_value < 0.
            result = zcl_qjs_value=>new_finite( 0 - ls_number-float_value ).
          ELSE.
            result = ls_number.
          ENDIF.
        ENDIF.
      WHEN id_math_floor OR id_math_ceil.
        IF sy-subrc <> 0.
          result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_nan ).
        ELSE.
          ls_number = zcl_qjs_number=>to_number( ls_argument ).
          IF ls_number-number_kind <> zcl_qjs_value=>number_finite.
            result = ls_number.
          ELSEIF mv_id = id_math_floor.
            result = zcl_qjs_value=>new_finite( floor( ls_number-float_value ) ).
          ELSE.
            result = zcl_qjs_value=>new_finite( ceil( ls_number-float_value ) ).
          ENDIF.
        ENDIF.
      WHEN id_math_max OR id_math_min.
        LOOP AT arguments INTO ls_argument.
          ls_number = zcl_qjs_number=>to_number( ls_argument ).
          IF ls_number-number_kind = zcl_qjs_value=>number_nan.
            result = ls_number.
            RETURN.
          ENDIF.
          IF lv_first = abap_true.
            ls_best = ls_number.
            lv_first = abap_false.
          ELSEIF mv_id = id_math_max.
            IF zcl_qjs_number=>less_than( left = ls_best right = ls_number ) = abap_true
                OR ( zcl_qjs_number=>equal( left = ls_best right = ls_number ) = abap_true
                  AND ls_best-number_kind = zcl_qjs_value=>number_neg_zero
                  AND ls_number-number_kind = zcl_qjs_value=>number_finite ).
              ls_best = ls_number.
            ENDIF.
          ELSEIF zcl_qjs_number=>less_than(
              left = ls_number right = ls_best ) = abap_true
              OR ( zcl_qjs_number=>equal( left = ls_number right = ls_best ) = abap_true
                AND ls_number-number_kind = zcl_qjs_value=>number_neg_zero ).
            ls_best = ls_number.
          ENDIF.
        ENDLOOP.
        IF lv_first = abap_true.
          IF mv_id = id_math_max.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_neg_inf ).
          ELSE.
            result = zcl_qjs_value=>new_special( zcl_qjs_value=>number_pos_inf ).
          ENDIF.
        ELSE.
          result = ls_best.
        ENDIF.
      WHEN id_array_is_array.
        DATA(lv_is_array) = abap_false.
        IF sy-subrc = 0 AND ls_argument-tag = zcl_qjs_value=>tag_object.
          TRY.
              lo_object ?= ls_argument-object_ref.
              lv_is_array = lo_object->is_array( ).
            CATCH cx_sy_move_cast_error.
          ENDTRY.
        ENDIF.
        result = zcl_qjs_value=>new_boolean( lv_is_array ).
      WHEN id_object_keys.
        IF sy-subrc <> 0 OR ls_argument-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Object.keys requires an object'.
        ENDIF.
        TRY.
            lo_object ?= ls_argument-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Object.keys requires an ordinary object'.
        ENDTRY.
        lt_names = lo_object->own_keys( ).
        lo_object = mo_runtime->create_array( ).
        lv_index = 0.
        LOOP AT lt_names INTO lv_name.
          lo_object->set_element(
            index = lv_index value = zcl_qjs_value=>new_string( lv_name ) ).
          lv_index = lv_index + 1.
        ENDLOOP.
        result = zcl_qjs_value=>new_object( lo_object ).
      WHEN id_object_define_property.
        READ TABLE arguments INDEX 1 INTO DATA(ls_define_target).
        IF sy-subrc <> 0 OR ls_define_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Object.defineProperty target is not an object'.
        ENDIF.
        TRY.
            lo_object ?= ls_define_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Object.defineProperty requires an ordinary object'.
        ENDTRY.
        READ TABLE arguments INDEX 2 INTO DATA(ls_define_key).
        IF sy-subrc <> 0.
          ls_define_key = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lv_define_name) = zcl_qjs_value=>to_string( ls_define_key ).
        READ TABLE arguments INDEX 3 INTO DATA(ls_descriptor_value).
        IF sy-subrc <> 0 OR ls_descriptor_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: property descriptor is not an object'.
        ENDIF.
        DATA lo_descriptor_object TYPE REF TO zcl_qjs_object.
        TRY.
            lo_descriptor_object ?= ls_descriptor_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: property descriptor must be ordinary'.
        ENDTRY.
        DATA(lv_has_getter) = lo_descriptor_object->has_property( 'get' ).
        DATA(lv_has_setter) = lo_descriptor_object->has_property( 'set' ).
        DATA(lv_has_value) = lo_descriptor_object->has_property( 'value' ).
        DATA(lv_has_writable) = lo_descriptor_object->has_property( 'writable' ).
        DATA(lv_has_enumerable) = lo_descriptor_object->has_property( 'enumerable' ).
        DATA(lv_has_configurable) = lo_descriptor_object->has_property( 'configurable' ).
        DATA(ls_existing_descriptor) = lo_object->get_own_property( lv_define_name ).
        IF ( lv_has_getter = abap_true OR lv_has_setter = abap_true )
            AND ( lv_has_value = abap_true OR lv_has_writable = abap_true ).
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: invalid mixed property descriptor'.
        ENDIF.
        DATA(lv_descriptor_enumerable) = abap_false.
        IF lv_has_enumerable = abap_true.
          lv_descriptor_enumerable = zcl_qjs_value=>to_boolean(
            lo_descriptor_object->get( 'enumerable' ) ).
        ELSEIF ls_existing_descriptor-found = abap_true.
          lv_descriptor_enumerable = ls_existing_descriptor-enumerable.
        ENDIF.
        DATA(lv_descriptor_configurable) = abap_false.
        IF lv_has_configurable = abap_true.
          lv_descriptor_configurable = zcl_qjs_value=>to_boolean(
            lo_descriptor_object->get( 'configurable' ) ).
        ELSEIF ls_existing_descriptor-found = abap_true.
          lv_descriptor_configurable = ls_existing_descriptor-configurable.
        ENDIF.
        DATA(lv_accessor_descriptor) = xsdbool(
          lv_has_getter = abap_true OR lv_has_setter = abap_true
          OR ( lv_has_value = abap_false AND lv_has_writable = abap_false
            AND ls_existing_descriptor-found = abap_true
            AND ls_existing_descriptor-accessor = abap_true ) ).
        IF lv_accessor_descriptor = abap_true.
          DATA(ls_descriptor_getter) = zcl_qjs_value=>new_undefined( ).
          DATA(ls_descriptor_setter) = zcl_qjs_value=>new_undefined( ).
          IF lv_has_getter = abap_true.
            ls_descriptor_getter = lo_descriptor_object->get( 'get' ).
            IF ls_descriptor_getter-tag <> zcl_qjs_value=>tag_undefined
                AND is_callable( ls_descriptor_getter ) = abap_false.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: property getter is not callable'.
            ENDIF.
          ELSEIF ls_existing_descriptor-found = abap_true
              AND ls_existing_descriptor-accessor = abap_true.
            ls_descriptor_getter = ls_existing_descriptor-getter.
          ENDIF.
          IF lv_has_setter = abap_true.
            ls_descriptor_setter = lo_descriptor_object->get( 'set' ).
            IF ls_descriptor_setter-tag <> zcl_qjs_value=>tag_undefined
                AND is_callable( ls_descriptor_setter ) = abap_false.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: property setter is not callable'.
            ENDIF.
          ELSEIF ls_existing_descriptor-found = abap_true
              AND ls_existing_descriptor-accessor = abap_true.
            ls_descriptor_setter = ls_existing_descriptor-setter.
          ENDIF.
          lo_object->define_accessor(
            name = lv_define_name getter = ls_descriptor_getter
            setter = ls_descriptor_setter enumerable = lv_descriptor_enumerable
            configurable = lv_descriptor_configurable ).
        ELSE.
          DATA(ls_descriptor_data_value) = zcl_qjs_value=>new_undefined( ).
          IF lv_has_value = abap_true.
            ls_descriptor_data_value = lo_descriptor_object->get( 'value' ).
          ELSEIF ls_existing_descriptor-found = abap_true
              AND ls_existing_descriptor-accessor = abap_false.
            ls_descriptor_data_value = ls_existing_descriptor-value.
          ENDIF.
          DATA(lv_descriptor_writable) = abap_false.
          IF lv_has_writable = abap_true.
            lv_descriptor_writable = zcl_qjs_value=>to_boolean(
              lo_descriptor_object->get( 'writable' ) ).
          ELSEIF ls_existing_descriptor-found = abap_true
              AND ls_existing_descriptor-accessor = abap_false.
            lv_descriptor_writable = ls_existing_descriptor-writable.
          ENDIF.
          lo_object->define_property(
            name = lv_define_name value = ls_descriptor_data_value
            writable = lv_descriptor_writable enumerable = lv_descriptor_enumerable
            configurable = lv_descriptor_configurable ).
        ENDIF.
        result = ls_define_target.
      WHEN id_object_get_own_descriptor.
        READ TABLE arguments INDEX 1 INTO DATA(ls_own_target).
        IF sy-subrc <> 0 OR ls_own_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: descriptor target is not an object'.
        ENDIF.
        TRY.
            lo_object ?= ls_own_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: descriptor target must be ordinary'.
        ENDTRY.
        READ TABLE arguments INDEX 2 INTO DATA(ls_own_key).
        IF sy-subrc <> 0.
          ls_own_key = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        DATA(lv_own_name) = zcl_qjs_value=>to_string( ls_own_key ).
        DATA(ls_own_property) = lo_object->get_own_property( lv_own_name ).
        IF ls_own_property-found = abap_false.
          result = zcl_qjs_value=>new_undefined( ).
        ELSE.
          DATA(lo_descriptor_result) = mo_runtime->create_object( ).
          IF ls_own_property-accessor = abap_true.
            lo_descriptor_result->set(
              name = 'get' value = ls_own_property-getter ).
            lo_descriptor_result->set(
              name = 'set' value = ls_own_property-setter ).
          ELSE.
            lo_descriptor_result->set(
              name = 'value' value = ls_own_property-value ).
            lo_descriptor_result->set(
              name = 'writable' value = zcl_qjs_value=>new_boolean(
                ls_own_property-writable ) ).
          ENDIF.
          lo_descriptor_result->set(
            name = 'enumerable' value = zcl_qjs_value=>new_boolean(
              ls_own_property-enumerable ) ).
          lo_descriptor_result->set(
            name = 'configurable' value = zcl_qjs_value=>new_boolean(
              ls_own_property-configurable ) ).
          result = zcl_qjs_value=>new_object( lo_descriptor_result ).
        ENDIF.
      WHEN id_object_create.
        READ TABLE arguments INDEX 1 INTO DATA(ls_create_prototype).
        IF sy-subrc <> 0 OR ( ls_create_prototype-tag <> zcl_qjs_value=>tag_object
            AND ls_create_prototype-tag <> zcl_qjs_value=>tag_null ).
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Object.create prototype is invalid'.
        ENDIF.
        DATA lo_created_prototype TYPE REF TO zcl_qjs_object.
        IF ls_create_prototype-tag = zcl_qjs_value=>tag_object.
          TRY.
              lo_created_prototype ?= ls_create_prototype-object_ref.
            CATCH cx_sy_move_cast_error.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: Object.create prototype must be ordinary'.
          ENDTRY.
        ENDIF.
        lo_object = mo_runtime->create_object( prototype = lo_created_prototype ).
        result = zcl_qjs_value=>new_object( lo_object ).
        READ TABLE arguments INDEX 2 INTO DATA(ls_create_properties).
        IF sy-subrc = 0 AND ls_create_properties-tag <> zcl_qjs_value=>tag_undefined.
          IF ls_create_properties-tag <> zcl_qjs_value=>tag_object.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Object.create properties are invalid'.
          ENDIF.
          DATA lo_create_properties TYPE REF TO zcl_qjs_object.
          TRY.
              lo_create_properties ?= ls_create_properties-object_ref.
            CATCH cx_sy_move_cast_error.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: Object.create properties must be ordinary'.
          ENDTRY.
          DATA(lt_create_names) = lo_create_properties->own_keys( ).
          DATA lo_define_helper TYPE REF TO zcl_qjs_native_function.
          CREATE OBJECT lo_define_helper
            EXPORTING id = id_object_define_property runtime = mo_runtime.
          LOOP AT lt_create_names INTO DATA(lv_create_name).
            DATA lt_define_arguments TYPE zif_qjs_callable=>ty_arguments.
            CLEAR lt_define_arguments.
            APPEND result TO lt_define_arguments.
            APPEND zcl_qjs_value=>new_string( lv_create_name ) TO lt_define_arguments.
            APPEND lo_create_properties->get( lv_create_name ) TO lt_define_arguments.
            DATA(ls_create_ignored) = lo_define_helper->zif_qjs_callable~call(
              this_value = zcl_qjs_value=>new_undefined( )
              arguments = lt_define_arguments ).
          ENDLOOP.
        ENDIF.
      WHEN id_object_get_prototype.
        READ TABLE arguments INDEX 1 INTO DATA(ls_proto_target).
        IF sy-subrc <> 0 OR ls_proto_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: prototype target is not an object'.
        ENDIF.
        TRY.
            lo_object ?= ls_proto_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: prototype target must be ordinary'.
        ENDTRY.
        DATA(lo_current_proto) = lo_object->get_prototype( ).
        IF lo_current_proto IS BOUND.
          result = zcl_qjs_value=>new_object( lo_current_proto ).
        ELSE.
          result = zcl_qjs_value=>new_null( ).
        ENDIF.
      WHEN id_object_set_prototype.
        READ TABLE arguments INDEX 1 INTO DATA(ls_set_proto_target).
        READ TABLE arguments INDEX 2 INTO DATA(ls_set_proto_value).
        IF ls_set_proto_target-tag <> zcl_qjs_value=>tag_object
            OR ( ls_set_proto_value-tag <> zcl_qjs_value=>tag_object
              AND ls_set_proto_value-tag <> zcl_qjs_value=>tag_null ).
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Object.setPrototypeOf arguments are invalid'.
        ENDIF.
        TRY.
            lo_object ?= ls_set_proto_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: prototype target must be ordinary'.
        ENDTRY.
        DATA lo_new_prototype TYPE REF TO zcl_qjs_object.
        IF ls_set_proto_value-tag = zcl_qjs_value=>tag_object.
          TRY.
              lo_new_prototype ?= ls_set_proto_value-object_ref.
            CATCH cx_sy_move_cast_error.
              RAISE EXCEPTION TYPE zcx_qjs_error
                EXPORTING reason = 'TypeError: prototype value must be ordinary'.
          ENDTRY.
        ENDIF.
        lo_object->set_prototype( lo_new_prototype ).
        result = ls_set_proto_target.
      WHEN id_object_define_properties.
        READ TABLE arguments INDEX 1 INTO DATA(ls_define_many_target).
        READ TABLE arguments INDEX 2 INTO DATA(ls_define_many_source).
        IF ls_define_many_target-tag <> zcl_qjs_value=>tag_object
            OR ls_define_many_source-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Object.defineProperties arguments are invalid'.
        ENDIF.
        DATA lo_define_many_source TYPE REF TO zcl_qjs_object.
        TRY.
            lo_object ?= ls_define_many_target-object_ref.
            lo_define_many_source ?= ls_define_many_source-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Object.defineProperties requires ordinary objects'.
        ENDTRY.
        DATA(lt_define_many_names) = lo_define_many_source->own_keys( ).
        DATA lo_define_many_helper TYPE REF TO zcl_qjs_native_function.
        CREATE OBJECT lo_define_many_helper
          EXPORTING id = id_object_define_property runtime = mo_runtime.
        LOOP AT lt_define_many_names INTO DATA(lv_define_many_name).
          DATA lt_define_many_arguments TYPE zif_qjs_callable=>ty_arguments.
          CLEAR lt_define_many_arguments.
          APPEND ls_define_many_target TO lt_define_many_arguments.
          APPEND zcl_qjs_value=>new_string( lv_define_many_name )
            TO lt_define_many_arguments.
          APPEND lo_define_many_source->get( lv_define_many_name )
            TO lt_define_many_arguments.
          DATA(ls_define_many_ignored) = lo_define_many_helper->zif_qjs_callable~call(
            this_value = zcl_qjs_value=>new_undefined( )
            arguments = lt_define_many_arguments ).
        ENDLOOP.
        result = ls_define_many_target.
      WHEN id_object_get_own_names.
        READ TABLE arguments INDEX 1 INTO DATA(ls_names_target).
        IF sy-subrc <> 0 OR ls_names_target-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: own-property-names target is invalid'.
        ENDIF.
        TRY.
            lo_object ?= ls_names_target-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: own-property-names target must be ordinary'.
        ENDTRY.
        DATA(lt_own_names) = lo_object->own_property_names( ).
        lo_object = mo_runtime->create_array( ).
        lv_index = 0.
        LOOP AT lt_own_names INTO lv_name.
          lo_object->set_element(
            index = lv_index value = zcl_qjs_value=>new_string( lv_name ) ).
          lv_index = lv_index + 1.
        ENDLOOP.
        result = zcl_qjs_value=>new_object( lo_object ).
      WHEN id_json_parse.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        result = zcl_qjs_json=>parse(
          source = zcl_qjs_value=>to_string( ls_argument ) runtime = mo_runtime ).
      WHEN id_json_stringify.
        IF sy-subrc <> 0.
          ls_argument = zcl_qjs_value=>new_undefined( ).
        ENDIF.
        result = zcl_qjs_json=>stringify( ls_argument ).
      WHEN id_error OR id_type_error OR id_range_error OR id_syntax_error
          OR id_reference_error.
        lv_error_name = 'Error'.
        CASE mv_id.
          WHEN id_type_error. lv_error_name = 'TypeError'.
          WHEN id_range_error. lv_error_name = 'RangeError'.
          WHEN id_syntax_error. lv_error_name = 'SyntaxError'.
          WHEN id_reference_error. lv_error_name = 'ReferenceError'.
        ENDCASE.
        CLEAR lv_error_message.
        IF sy-subrc = 0 AND ls_argument-tag <> zcl_qjs_value=>tag_undefined.
          lv_error_message = zcl_qjs_value=>to_string( ls_argument ).
        ENDIF.
        result = mo_runtime->create_error(
          name = lv_error_name message = lv_error_message ).
      WHEN id_error_to_string.
        IF this_value-tag <> zcl_qjs_value=>tag_object.
          RAISE EXCEPTION TYPE zcx_qjs_error
            EXPORTING reason = 'TypeError: Error.prototype.toString receiver is invalid'.
        ENDIF.
        TRY.
            lo_object ?= this_value-object_ref.
          CATCH cx_sy_move_cast_error.
            RAISE EXCEPTION TYPE zcx_qjs_error
              EXPORTING reason = 'TypeError: Error.prototype.toString receiver is invalid'.
        ENDTRY.
        DATA(lv_to_string_name) = zcl_qjs_value=>to_string( lo_object->get( 'name' ) ).
        DATA(lv_to_string_message) = zcl_qjs_value=>to_string(
          lo_object->get( 'message' ) ).
        IF lv_to_string_name IS INITIAL.
          result = zcl_qjs_value=>new_string( lv_to_string_message ).
        ELSEIF lv_to_string_message IS INITIAL.
          result = zcl_qjs_value=>new_string( lv_to_string_name ).
        ELSE.
          result = zcl_qjs_value=>new_string(
            lv_to_string_name && lv_error_separator && lv_to_string_message ).
        ENDIF.
      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Unknown native function'.
    ENDCASE.
  ENDMETHOD.

  METHOD zif_qjs_constructable~construct.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    DATA ls_primitive TYPE zcl_qjs_value=>ty_value.
    CASE mv_id.
      WHEN id_object OR id_array OR id_error OR id_type_error OR id_range_error
          OR id_syntax_error OR id_reference_error.
        result = zif_qjs_callable~call(
          this_value = zcl_qjs_value=>new_undefined( ) arguments = arguments ).
      WHEN id_number OR id_string OR id_boolean.
        ls_primitive = zif_qjs_callable~call(
          this_value = zcl_qjs_value=>new_undefined( ) arguments = arguments ).
        lo_object = runtime->create_object( ).
        lo_object->define_property(
          name = '[[PrimitiveValue]]' value = ls_primitive
          writable = abap_false enumerable = abap_false configurable = abap_false ).
        result = zcl_qjs_value=>new_object( lo_object ).
      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_qjs_error
          EXPORTING reason = 'Native function is not constructable'.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
