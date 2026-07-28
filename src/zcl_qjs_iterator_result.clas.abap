CLASS zcl_qjs_iterator_result DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_qjs_property_container.
    METHODS constructor
      IMPORTING done TYPE abap_bool
        value        TYPE zcl_qjs_value=>ty_value
        prototype    TYPE REF TO zcl_qjs_object OPTIONAL.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_property,
      kind  TYPE i,
      name  TYPE string,
      value TYPE zcl_qjs_value=>ty_value,
      END OF ty_property.
    TYPES ty_properties TYPE HASHED TABLE OF ty_property
      WITH UNIQUE KEY kind name.
    DATA ms_done TYPE zcl_qjs_value=>ty_value.
    DATA ms_value TYPE zcl_qjs_value=>ty_value.
    DATA mv_done_deleted TYPE abap_bool.
    DATA mv_value_deleted TYPE abap_bool.
    DATA mt_properties TYPE ty_properties.
    DATA mo_prototype TYPE REF TO zcl_qjs_object.
ENDCLASS.

CLASS zcl_qjs_iterator_result IMPLEMENTATION.
  METHOD constructor.
    ms_done = zcl_qjs_value=>new_boolean( done ).
    ms_value = value.
    mo_prototype = prototype.
  ENDMETHOD.

  METHOD zif_qjs_property_container~get_property.
    IF name = 'done' AND mv_done_deleted = abap_false.
      result = ms_done.
      RETURN.
    ELSEIF name = 'value' AND mv_value_deleted = abap_false.
      result = ms_value.
      RETURN.
    ENDIF.
    READ TABLE mt_properties WITH TABLE KEY kind = 0 name = name
      INTO DATA(ls_property).
    IF sy-subrc = 0.
      result = ls_property-value.
    ELSEIF mo_prototype IS BOUND.
      result = mo_prototype->get( name ).
    ELSE.
      result = zcl_qjs_value=>new_undefined( ).
    ENDIF.
  ENDMETHOD.

  METHOD zif_qjs_property_container~set_property.
    IF name = 'done'.
      ms_done = value.
      mv_done_deleted = abap_false.
      RETURN.
    ELSEIF name = 'value'.
      ms_value = value.
      mv_value_deleted = abap_false.
      RETURN.
    ENDIF.
    DATA(ls_property) = VALUE ty_property( kind = 0 name = name value = value ).
    DELETE TABLE mt_properties WITH TABLE KEY kind = 0 name = name.
    INSERT ls_property INTO TABLE mt_properties.
  ENDMETHOD.

  METHOD zif_qjs_property_container~delete_property.
    result = abap_true.
    IF name = 'done'.
      mv_done_deleted = abap_true.
    ELSEIF name = 'value'.
      mv_value_deleted = abap_true.
    ELSE.
      DELETE TABLE mt_properties WITH TABLE KEY kind = 0 name = name.
    ENDIF.
  ENDMETHOD.

  METHOD zif_qjs_property_container~get_symbol_property.
    DATA(lv_name) = CONV string( identity ).
    CONDENSE lv_name NO-GAPS.
    READ TABLE mt_properties WITH TABLE KEY kind = 1 name = lv_name
      INTO DATA(ls_property).
    IF sy-subrc = 0.
      result = ls_property-value.
    ELSEIF mo_prototype IS BOUND.
      result = mo_prototype->get_symbol( identity ).
    ELSE.
      result = zcl_qjs_value=>new_undefined( ).
    ENDIF.
  ENDMETHOD.

  METHOD zif_qjs_property_container~set_symbol_property.
    DATA(lv_name) = CONV string( identity ).
    CONDENSE lv_name NO-GAPS.
    DATA(ls_property) = VALUE ty_property(
      kind = 1 name = lv_name value = value ).
    DELETE TABLE mt_properties WITH TABLE KEY kind = 1 name = lv_name.
    INSERT ls_property INTO TABLE mt_properties.
  ENDMETHOD.

  METHOD zif_qjs_property_container~delete_symbol_property.
    DATA(lv_name) = CONV string( identity ).
    CONDENSE lv_name NO-GAPS.
    DELETE TABLE mt_properties WITH TABLE KEY kind = 1 name = lv_name.
    result = abap_true.
  ENDMETHOD.
ENDCLASS.
