CLASS zreuse_cl_execute_fdp_delete DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZREUSE_CL_EXECUTE_FDP_DELETE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


    DATA: lt_keys            TYPE if_fp_fdp_api=>tt_select_keys.
    DATA: ls_keys            LIKE LINE OF lt_keys.
    DATA sales_order_id TYPE string VALUE '5'.


    CONSTANTS : service_definition  TYPE if_fp_fdp_api=>ty_service_definition VALUE 'ZREUSEUI_SALESORDER_002_ADS',
                leading_entity_name TYPE string VALUE 'ZREUSEI_SALESORDER_002_ADS',
*                template_form_name  TYPE string VALUE 'ZREUSEUI_SALESORDER_002_ADS'.
              template_form_name  TYPE string VALUE  'ZREUSE_AF_001'.

    TRY.
        "Initialize Template Store Client (using custom comm scenario)

*        DATA template TYPE string.
*
*        template = 'ZREUSEUI_SALESORDER_002'.

        DATA(lo_store) = NEW zreusecl_fp_tmpl_store_client(
          iv_service_instance_name = 'ZADSTEMPLSTORE'
          iv_use_destination_service = abap_false
        ).

        out->write( 'Template Store Client initialized' ).

        "Initialize class with service definition
        DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance(
                              iv_service_definition = service_definition
                              iv_root_node = leading_entity_name
*                              iv_max_depth          = 5
                            ).

        out->write( 'Dataservice initialized' ).

        TRY.
            DATA(rt_forms) = lo_store->list_forms( ).

            Out->write( 'Forms in store' ).

            LOOP AT rt_forms INTO DATA(rs_form).
              out->write( rs_form-form_name ).
            ENDLOOP.

          CATCH zcx_fp_tmpl_store_error INTO DATA(list_form_exc).
            out->write( list_form_exc->get_text(  ) ).
        ENDTRY.
        TRY.
            lo_store->get_schema_by_name( iv_form_name =  template_form_name ). " 'DemoForm'  ). "DSAG_DEMO' ).
            out->write( | template { template_form_name } found|  ).
          CATCH zcx_fp_tmpl_store_error INTO DATA(lo_tmpl_error).
            out->write( |{ template_form_name } not found in store | ).

            IF lo_tmpl_error->mv_http_status_code = 404.
              "Upload service definition
              lo_store->set_schema(
                iv_form_name =  template_form_name "'ZREUSEUI_SALESORDER_002' "'DemoForm'
                is_data = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util->get_xsd(  )  )
              ).
            ELSE.
              out->write( lo_tmpl_error->get_longtext(  ) ).
            ENDIF.
        ENDTRY.
        "Get initial select keys for service
        lt_keys     = lo_fdp_util->get_keys( ).
        DATA(lt_xsd)     = lo_fdp_util->get_xsd(  ).
*        DATA(lv_xsd_decoded) = cl_web_http_utility=>decode_base64( CONV #( lt_xsd ) ).

        lt_keys[ name = 'SALESORDERID' ]-value = sales_order_id.

*        data test type if_fp_fdp_api=>ts_select_key .
*        test-data_type = 'SDRAFT_FIELDS-ISACTIVEENTITY'.
**
*        test-value = '21'.
*        test-name = 'ISACTIVEENTITY'.
*        append test to lt_keys.



        DATA(ls_template) = lo_store->get_template_by_name(
          iv_get_binary     = abap_true

          iv_form_name      = template_form_name " 'DemoForm'
          iv_template_name  = template_form_name  "'DemoTemplate'
        ).
        out->write( 'Form Template retrieved' ).

        DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
        out->write( 'Service data retrieved' ).
        TRY.
            cl_fp_ads_util=>render_pdf(
              EXPORTING
                iv_xml_data     = lv_xml
                iv_xdp_layout   = ls_template-xdp_template
                iv_locale       = 'DE'
                is_options      = VALUE #(
                          trace_level = 4 "Use 0 in production environment
                        )
*    is_options      =
              IMPORTING
                ev_pdf          = DATA(my_pdf)
*    ev_pages        =
*    ev_trace_string =
            ).
*CATCH cx_fp_ads_util.

            "create in the transactional buffer
            MODIFY ENTITIES OF ZREUSER_SalesOrderTP_002
              ENTITY SalesOrder
              UPDATE
                 FIELDS (  Attachment FileName MimeType  )
                  WITH VALUE #( ( SalesorderID = sales_order_id
                                  %is_draft   = if_abap_behv=>mk-off

                                  Attachment    = my_pdf
                                  filename = |file_{ Sales_order_ID }.pdf|
                                  MimeType = 'application/pdf'
                              ) )

*      "execute action `rejectTravel`
*        ENTITY travel
*        EXECUTE rejectTravel
*        FROM VALUE #( ( %cid_ref = 'create_travel' %is_draft = instance_state ) )

              MAPPED DATA(mapped)
              FAILED DATA(failed)
              REPORTED DATA(reported).

            "persist changes
            COMMIT ENTITIES
              RESPONSE OF ZREUSER_SalesOrderTP_002
              FAILED DATA(failed_commit)
              REPORTED DATA(reported_commit).

            IF reported_commit IS NOT INITIAL.
              out->write( 'reported and failed commit are not initial' ).
              LOOP AT reported_commit-salesorder INTO DATA(failed_commit_entry).
                out->write( failed_commit_entry-%msg ).
              ENDLOOP.
            ENDIF.


          CATCH cx_fp_ads_util  INTO DATA(ads_util_exception).
            out->write( ads_util_exception->get_text(  ) ).
        ENDTRY.

        EXIT.



        cl_fp_ads_util=>render_4_pq(
          EXPORTING
            iv_locale       = 'en_US'
            iv_pq_name      = 'PRINT_QUEUE'
            iv_xml_data     = lv_xml
            iv_xdp_layout   = ls_template-xdp_template
            is_options      = VALUE #(
              trace_level = 4 "Use 0 in production environment
            )
          IMPORTING
            ev_trace_string = DATA(lv_trace)
            ev_pdl          = DATA(lv_pdf)
        ).
        out->write( 'Output was generated' ).

        cl_print_queue_utils=>create_queue_item_by_data(
          iv_qname = 'PRINT_QUEUE'
          iv_print_data = lv_pdf
          iv_name_of_main_doc = 'DSAG DEMO Output'
        ).
        out->write( 'Output was sent to print queue' ).

      CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error cx_fp_ads_util INTO DATA(lo_err).
        out->write( 'Exception occurred.' ).
        out->write( lo_err->get_text(  ) ).
    ENDTRY.
    out->write( 'Finished processing.' ).
  ENDMETHOD.
ENDCLASS.
