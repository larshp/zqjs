CLASS zcl_qjs_atoms DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        max_atoms TYPE i DEFAULT 4096
      RAISING
        zcx_qjs_error.

    METHODS intern
      IMPORTING
        text          TYPE string
      RETURNING
        VALUE(result) TYPE int8
      RAISING
        zcx_qjs_error.

    METHODS get_text
      IMPORTING
        atom          TYPE int8
      RETURNING
        VALUE(result) TYPE string
      RAISING
        zcx_qjs_error.

    METHODS count
      RETURNING
        VALUE(result) TYPE i.

    METHODS clear_dynamic.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_entry,
        text TYPE string,
        atom TYPE int8,
      END OF ty_entry.
    TYPES ty_entries TYPE HASHED TABLE OF ty_entry WITH UNIQUE KEY text.

    DATA mt_entries TYPE ty_entries.
    DATA mv_max_atoms TYPE i.
    DATA mv_next_atom TYPE int8.
ENDCLASS.

CLASS zcl_qjs_atoms IMPLEMENTATION.
  METHOD constructor.
    IF max_atoms <= 0.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING
          reason = 'Atom limit must be positive'.
    ENDIF.
    mv_max_atoms = max_atoms.
    mv_next_atom = 1.
  ENDMETHOD.

  METHOD intern.
    DATA ls_entry TYPE ty_entry.
    READ TABLE mt_entries WITH TABLE KEY text = text INTO ls_entry.
    IF sy-subrc = 0.
      result = ls_entry-atom.
      RETURN.
    ENDIF.
    IF lines( mt_entries ) >= mv_max_atoms.
      RAISE EXCEPTION TYPE zcx_qjs_error
        EXPORTING
          reason = 'JavaScript atom budget exhausted'.
    ENDIF.
    ls_entry-text = text.
    ls_entry-atom = mv_next_atom.
    INSERT ls_entry INTO TABLE mt_entries.
    result = mv_next_atom.
    mv_next_atom = mv_next_atom + 1.
  ENDMETHOD.

  METHOD get_text.
    DATA ls_entry TYPE ty_entry.
    LOOP AT mt_entries INTO ls_entry.
      IF ls_entry-atom = atom.
        result = ls_entry-text.
        RETURN.
      ENDIF.
    ENDLOOP.
    RAISE EXCEPTION TYPE zcx_qjs_error
      EXPORTING
        reason = 'Unknown JavaScript atom'.
  ENDMETHOD.

  METHOD count.
    result = lines( mt_entries ).
  ENDMETHOD.

  METHOD clear_dynamic.
    CLEAR mt_entries.
    mv_next_atom = 1.
  ENDMETHOD.
ENDCLASS.
