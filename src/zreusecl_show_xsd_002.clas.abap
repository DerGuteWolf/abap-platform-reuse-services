CLASS zreusecl_show_xsd_002 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZREUSECL_SHOW_XSD_002 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    CONSTANTS : service_definition  TYPE if_fp_fdp_api=>ty_service_definition VALUE 'ZREUSEUI_SALESORDER_002_ADS',
                leading_entity_name TYPE string VALUE 'ZREUSEI_SALESORDER_002_ADS'.

*    DATA service_definition   TYPE sxco_srvd_object_name   . "TYPE if_fp_fdp_api=>ty_service_definition .

*    service_definition = 'ZREUSEUI_SALESORDER_002_ADS' . "'ZREUSEUI_SalesOrder_002'.

    "Initiate data service from definition

    TRY.
        DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance(
                              iv_service_definition =  service_definition
                               iv_root_node = leading_entity_name
                            )  .

        DATA(lv_xsd) = lo_fdp_util->get_xsd(  ).

        DATA(lv_xsd_base64)  = cl_web_http_utility=>encode_x_base64( lv_xsd ).
        DATA(lv_xsd_decoded) = cl_web_http_utility=>decode_base64( lv_xsd_base64 ).

        out->write( lv_xsd_decoded ).

      CATCH cx_fp_fdp_error INTO DATA(xsd_error).
        "handle exception
        out->write( xsd_error->get_text(  ) ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
