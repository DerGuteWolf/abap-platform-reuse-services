CLASS zreusecl_del_change_docs_002 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZREUSECL_DEL_CHANGE_DOCS_002 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*    DATA lv_objectclass   TYPE if_chdo_object_tools_rel=>ty_cdobjectcl .
*    DATA lv_objectid  TYPE cl_chdo_write_tools=>ty_cdobjectv VALUE '9990001'.
*    DATA lv_changenr  TYPE cl_chdo_write_tools=>ty_cdchangenr VALUE '0000000001'.
    DATA lr_err TYPE REF TO cx_chdo_delete_error.

*    ).

    DATA: lv_is_authorized TYPE abap_bool.
    TRY.
        " iv_object : Change document object name
        " it_activity : Activity to be checked. Possible values '01' = create,
        "                                                       '02' = change,
        "                                                       '03' = read,
        "                                                       '06' = delete
        " it_devclass : package name of change document object
        cl_chdo_object_tools_rel=>if_chdo_object_tools_rel~check_authorization(
          EXPORTING
            iv_object        = zreuseif_002=>change_document_object_name
            iv_activity      = '06'
            iv_devclass      = zreuseif_002=>package_name
          RECEIVING
            rv_is_authorized = lv_is_authorized
        ).
    ENDTRY.

    IF lv_is_authorized IS INITIAL.
      out->write( |Exception occurred: authorization error.| ).
    ELSE.
      out->write( |Activity can be performed on the change document object.| ).
    ENDIF.




    TRY.


        cl_chdo_read_tools=>changedocument_read(
          EXPORTING
            i_objectclass    = zreuseif_002=>change_document_object_name  " change document object name
*          it_objectid      =
*          i_date_of_change =
*          i_time_of_change =
*          i_date_until     =
*          i_time_until     =
*          it_username      =
*          it_read_options  =
          IMPORTING
            et_cdredadd_tab  = DATA(rt_cdredadd)    " result returned in table
        ).

        DATA(lo_instance) = cl_chdo_delete_tools=>get_instance( ).

*        LOOP AT rt_cdredadd INTO DATA(rs_cdredadd).

          lo_instance->if_chdo_delete_tools~changedocument_delete(
            EXPORTING
              i_objectclass                 = zreuseif_002=>change_document_object_name
*              i_objectid                    = rs_cdredadd-objectid "lv_objectid
*              i_changenumber                = rs_cdredadd-changenr "lv_changenr
              i_with_commit                 = abap_true
            IMPORTING
              e_number_of_deleted_headers   = DATA(ls_headers)
              e_number_of_deleted_positions = DATA(ls_positions)
              e_number_of_deleted_uids      = DATA(ls_uids)
              e_number_of_deleted_strings   = DATA(ls_strings)
          ).

          out->write( |deleted { ls_headers } header entries| ).
          out->write( |deleted { ls_positions } positions| ).



*        ENDLOOP.

      CATCH cx_chdo_delete_error INTO lr_err.
*   error handling for deletion
        out->write( lr_err->get_text(  ) ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
