CLASS zreuse_cl_generate_pdf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor.

    DATA error_message_initialization TYPE string READ-ONLY.

    METHODS generate_pdf
      IMPORTING iv_value      TYPE string
      EXPORTING my_pdf        TYPE xstring
                error_message TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA : service_definition  TYPE if_fp_fdp_api=>ty_service_definition VALUE 'ZREUSEUI_SALESORDER_002_ADS',
           leading_entity_name TYPE string VALUE 'ZREUSEI_SALESORDER_002_ADS',
           template_form_name  TYPE string VALUE 'ZREUSEUI_SALESORDER_002_ADS',


           lt_keys             TYPE if_fp_fdp_api=>tt_select_keys,

           lo_fdp_util         TYPE REF TO if_fp_fdp_api,
           lo_store            TYPE REF TO zREUSEcl_fp_tmpl_store_client,
           xsd_schema          TYPE xstring,
           ls_template         TYPE zREUSEcl_fp_tmpl_store_client=>ty_template_body.

ENDCLASS.



CLASS ZREUSE_CL_GENERATE_PDF IMPLEMENTATION.


  METHOD constructor.

    "Initialize Template Store Client (using custom comm scenario)
    TRY.
        lo_store = NEW zREUSEcl_fp_tmpl_store_client(
          iv_service_instance_name = 'ZADSTEMPLSTORE'
          iv_use_destination_service = abap_false
        ).

        lo_store->get_schema_by_name( iv_form_name =  template_form_name ).

        "Initialize class with service definition
        lo_fdp_util = cl_fp_fdp_services=>get_instance(
                              iv_service_definition = service_definition
                              iv_root_node = leading_entity_name
*                              iv_max_depth          = 5
                            ).

        lo_store->get_schema_by_name( iv_form_name =  template_form_name ). " 'DemoForm'  ). "DSAG_DEMO' ).

        xsd_schema = lo_fdp_util->get_xsd(  ).

        DATA(lv_xsd_base64)  = cl_web_http_utility=>encode_x_base64( xsd_schema ).
        DATA(lv_xsd_decoded) = cl_web_http_utility=>decode_base64( lv_xsd_base64 ).

        "Get initial select keys for service
        lt_keys     = lo_fdp_util->get_keys( ).

        ls_template = lo_store->get_template_by_name(
          iv_get_binary     = abap_true

          iv_form_name      = template_form_name " 'DemoForm'
          iv_template_name  = template_form_name  "'DemoTemplate'
        ).

      CATCH  cx_fp_fdp_error   INTO DATA(forms_processing_exception).
        error_message_initialization = forms_processing_exception->get_text(  ).

      CATCH zcx_fp_tmpl_store_error INTO DATA(template_store_error).
        IF template_store_error->mv_http_status_code = 404.
          "Upload service definition
          TRY.
              lo_store->set_schema(
                iv_form_name =  template_form_name "'ZREUSEUI_SALESORDER_002' "'DemoForm'
                is_data = VALUE #( note = '' schema_name = 'schema' xsd_schema = xsd_schema  )
              ).
            CATCH zcx_fp_tmpl_store_error  INTO DATA(template_store_error_2).
              error_message_initialization = template_store_error->get_text(  ).
          ENDTRY.
        ELSE.
          error_message_initialization = template_store_error->get_text(  ).
        ENDIF.

        error_message_initialization = template_store_error->get_text(  ).
    ENDTRY.

    "initialization failed

    IF error_message_initialization IS NOT INITIAL.
    ENDIF.

  ENDMETHOD.


  METHOD generate_pdf.

    lt_keys[ name = 'SALESORDERID' ]-value = iv_value.

    TRY.
        "if draft is used is_active_entity = '00' has to be set
        DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).

        DATA(lv_xsd_base64)  = cl_web_http_utility=>encode_x_base64( lv_xml ).
        DATA(lv_xsd_decoded) = cl_web_http_utility=>decode_base64( lv_xsd_base64 ).

      CATCH cx_fp_fdp_error INTO DATA(fdp_error).
        "handle exception
        error_message = fdp_error->get_text(  ).
        EXIT.
    ENDTRY.

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
                  ev_pdf          = my_pdf
*    ev_pages        =
*    ev_trace_string =
              ).
      CATCH cx_fp_ads_util INTO DATA(ads_util_exception).
        "handle exception
        error_message = ads_util_exception->get_text(  ).
    ENDTRY.


  ENDMETHOD.
ENDCLASS.
