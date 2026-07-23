CLASS zcl_qjs_for_in_iterator DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_next,
        done  TYPE abap_bool,
        value TYPE zcl_qjs_value=>ty_value,
      END OF ty_next.

    METHODS constructor
      IMPORTING source TYPE zcl_qjs_value=>ty_value
      RAISING zcx_qjs_error.
    METHODS next
      RETURNING VALUE(result) TYPE ty_next.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_entry,
        name  TYPE string,
        owner TYPE REF TO zcl_qjs_object,
      END OF ty_entry.
    TYPES ty_entries TYPE STANDARD TABLE OF ty_entry WITH DEFAULT KEY.
    TYPES ty_seen_names TYPE HASHED TABLE OF string WITH UNIQUE KEY table_line.

    DATA mt_entries TYPE ty_entries.
    DATA mv_index TYPE i.
ENDCLASS.

CLASS zcl_qjs_for_in_iterator IMPLEMENTATION.
  METHOD constructor.
    DATA lo_object TYPE REF TO zcl_qjs_object.
    DATA lo_closure TYPE REF TO zcl_qjs_closure.
    DATA lt_names TYPE zcl_qjs_shape=>ty_names.
    DATA lt_seen TYPE ty_seen_names.
    DATA ls_entry TYPE ty_entry.
    DATA ls_property TYPE zcl_qjs_object=>ty_own_property.
    DATA lv_string_index TYPE i.
    DATA lv_name TYPE string.

    IF source-tag = zcl_qjs_value=>tag_string.
      DO strlen( source-string_ref->as_string( ) ) TIMES.
        lv_string_index = sy-index - 1.
        lv_name = lv_string_index.
        CONDENSE lv_name NO-GAPS.
        ls_entry-name = lv_name.
        CLEAR ls_entry-owner.
        APPEND ls_entry TO mt_entries.
      ENDDO.
      RETURN.
    ENDIF.

    IF source-tag <> zcl_qjs_value=>tag_object.
      RETURN.
    ENDIF.
    TRY.
        lo_object ?= source-object_ref.
      CATCH cx_sy_move_cast_error.
        TRY.
            lo_closure ?= source-object_ref.
            lo_object = lo_closure->get_property_storage( ).
          CATCH cx_sy_move_cast_error.
            RETURN.
        ENDTRY.
    ENDTRY.

    WHILE lo_object IS BOUND.
      lt_names = lo_object->own_property_names( ).
      LOOP AT lt_names INTO lv_name.
        INSERT lv_name INTO TABLE lt_seen.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
        ls_property = lo_object->get_own_property( lv_name ).
        IF ls_property-found = abap_true
            AND ls_property-enumerable = abap_true.
          ls_entry-name = lv_name.
          ls_entry-owner = lo_object.
          APPEND ls_entry TO mt_entries.
        ENDIF.
      ENDLOOP.
      lo_object = lo_object->get_prototype( ).
    ENDWHILE.
  ENDMETHOD.

  METHOD next.
    DATA ls_entry TYPE ty_entry.
    DATA ls_property TYPE zcl_qjs_object=>ty_own_property.
    result-done = abap_true.
    result-value = zcl_qjs_value=>new_undefined( ).
    WHILE mv_index < lines( mt_entries ).
      mv_index = mv_index + 1.
      READ TABLE mt_entries INDEX mv_index INTO ls_entry.
      IF ls_entry-owner IS BOUND.
        ls_property = ls_entry-owner->get_own_property( ls_entry-name ).
        IF ls_property-found = abap_false
            OR ls_property-enumerable = abap_false.
          CONTINUE.
        ENDIF.
      ENDIF.
      result-done = abap_false.
      result-value = zcl_qjs_value=>new_string( ls_entry-name ).
      RETURN.
    ENDWHILE.
  ENDMETHOD.
ENDCLASS.
