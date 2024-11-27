CLASS zreusecl_get_change_docs_002 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
    INTERFACES if_oo_adt_classrun.

    TYPES:
      t_change_documents TYPE STANDARD TABLE OF ZREUSEI_CDREDADd_002 WITH  EMPTY KEY .

    DATA:
      change_documents TYPE t_change_documents READ-ONLY .

    METHODS get_change_documents
      IMPORTING
        it_objectid            TYPE cl_chdo_read_tools=>tt_r_objectid
      RETURNING
        VALUE(changedocuments) TYPE t_change_documents .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZREUSECL_GET_CHANGE_DOCS_002 IMPLEMENTATION.


  METHOD get_change_documents.

    DATA: rt_cdredadd TYPE cl_chdo_read_tools=>tt_cdredadd_tab,
          lr_err      TYPE REF TO cx_chdo_read_error.

    TRY.
        cl_chdo_read_tools=>changedocument_read(
          EXPORTING
           i_objectclass    = 'ZREUSE_SO_002'  " change document object name
           it_objectid      = it_objectid
          IMPORTING
            et_cdredadd_tab  = rt_cdredadd    " result returned in table
        ).

        MOVE-CORRESPONDING rt_cdredadd TO changedocuments.

      CATCH cx_chdo_read_error INTO lr_err.
*        ASSERT 1 = 2.
*              out->write( |Exception occurred: { lr_err->get_text( ) }| ).
    ENDTRY.

    "
*    products = VALUE #(
*    ( Product = 'ZPRINTER01' ProductText = 'Printer Professional ABC' Price = '500.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'ST'  )
*    ( Product = 'ZPRINTER02' ProductText = 'Printer Platinum' Price = '800.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'ST'  )
*    ( Product = 'D001' ProductText = 'Mobile Phone' Price = '850.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'ST'  )
*    ( Product = 'D002' ProductText = 'Table PC' Price = '900.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'ST'  )
*    ( Product = 'D003' ProductText = 'Office Table' Price = '599.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'ST'  )
*    ( Product = 'D004' ProductText = 'Office Chair' Price = '449.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'ST'  )
*    ( Product = 'D005' ProductText = 'Developer Notebook' Price = '3150.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'ST'  )
*    ( Product = 'D006' ProductText = 'Mouse' Price = '79.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'ST'  )
*    ( Product = 'D007' ProductText = 'Headset' Price = '159.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'ST'  )
*    ( Product = 'D008' ProductText = 'Keyboard' Price = '39.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'ST'  )
*     ).
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA: rt_cdredadd TYPE cl_chdo_read_tools=>tt_cdredadd_tab,
          lr_err      TYPE REF TO cx_chdo_read_error,
          lt_objectid TYPE cl_chdo_read_tools=>tt_r_objectid,
          ls_objectid TYPE cl_chdo_read_tools=>ty_r_objectid_line.

    TRY.

        ls_objectid-low = 'trt05'.
        ls_objectid-sign = 'I'.
        ls_objectid-option = 'EQ'.

        APPEND ls_objectid TO lt_objectid.


        DATA(test) = get_change_documents( it_objectid = lt_objectid ).

        MOVE-CORRESPONDING test TO rt_cdredadd.
*
*        cl_chdo_read_tools=>changedocument_read(
*          EXPORTING
*            i_objectclass    = 'ZREUSE_SO_002'  " change document object name
**          it_objectid      =
**          i_date_of_change =
**          i_time_of_change =
**          i_date_until     =
**          i_time_until     =
**          it_username      =
**          it_read_options  =
*          IMPORTING
*            et_cdredadd_tab  = rt_cdredadd    " result returned in table
*        ).

        DATA(num_of_lines) = lines( rt_cdredadd ).
        out->write( |lines: { num_of_lines }| ).
        LOOP AT rt_cdredadd INTO DATA(rs_cdredadd).
          out->write( rs_cdredadd ).
        ENDLOOP.

      CATCH cx_chdo_read_error INTO lr_err.
        out->write( |Exception occurred: { lr_err->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    DATA business_data TYPE STANDARD TABLE OF ZREUSEI_CDREDADd_002.
    DATA business_data_line TYPE ZREUSEI_CDREDADd_002 .
    DATA(skip)    = io_request->get_paging( )->get_offset( ).
    DATA(requested_fields)  = io_request->get_requested_elements( ).
    DATA(sort_order)    = io_request->get_sort_elements( ).

    DATA lt_objectid TYPE cl_chdo_read_tools=>tt_r_objectid.
    DATA ls_objectid TYPE cl_chdo_read_tools=>ty_r_objectid_line.





    TRY.
        DATA(filter_condition) = io_request->get_filter( )->get_as_sql_string( ).
        DATA(filter_condition_ranges) = io_request->get_filter( )->get_as_ranges( ).

        READ TABLE filter_condition_ranges WITH KEY name = 'OBJECTID'
           INTO DATA(filter_condition_objectid).

        LOOP AT filter_condition_objectid-range INTO DATA(low_value).
          " ls_objectid-low = filter_condition_objectid-range[ 1 ]-low.
          ls_objectid-low = low_value-low.
          ls_objectid-option = 'EQ'.
          ls_objectid-sign = 'I'.
          APPEND ls_objectid TO lt_objectid.
        ENDLOOP.

        business_data = get_change_documents( lt_objectid )

        .


        SELECT *
*           objectclas , objectid, changenr ,
*                 username, tabname, tabkey
*                 ,
*                 fname,
*                  ftext,
*                  OUTLEN,
*                  f_old,
*                   f_new,
*                   ext_keylen

         FROM @business_data AS implementation_types
           WHERE (filter_condition) INTO TABLE @business_data.

           loop at business_data ASSIGNING FIELD-SYMBOL(<business_data>).
             CONVERT DATE <business_data>-udate TIME <business_data>-utime INTO TIME STAMP <business_data>-utimestamp
             TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
           ENDLOOP.

        io_response->set_total_number_of_records( lines( business_data ) ).
        io_response->set_data( business_data ).
      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).
        DATA(exception_t100_key) = cl_message_helper=>get_latest_t100_exception( exception )->t100key.
        ASSERT 1 = 2.
*    RAISE EXCEPTION TYPE zdmo_cx_rap_gen_custom_entity
*        EXPORTING
*          textid   = VALUE scx_t100key( msgid = exception_t100_key-msgid
*          msgno = exception_t100_key-msgno
*          attr1 = exception_t100_key-attr1
*          attr2 = exception_t100_key-attr2
*          attr3 = exception_t100_key-attr3
*          attr4 = exception_t100_key-attr4 )
*    previous = exception.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
