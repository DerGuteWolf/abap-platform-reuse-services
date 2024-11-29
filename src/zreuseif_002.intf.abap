INTERFACE zreuseif_002
  PUBLIC .

  CONSTANTS : sender_email_adress            TYPE  string VALUE 'noreply+abapcloud@sap.corp',
              receiver_email_adress          TYPE  string VALUE 'andre.fischer@sap.com',
              package_name                   TYPE if_chdo_object_tools_rel=>tv_cddevclass VALUE 'ZREUSE_SERVICES_002',
              nr_range_interval              TYPE cl_numberrange_runtime=>nr_interval  VALUE '01',
              nr_range_object                TYPE cl_numberrange_runtime=>nr_object VALUE 'ZREUSES002',
              change_document_object_name    TYPE if_chdo_object_tools_rel=>ty_cdobjectcl VALUE 'ZREUSE_SO_002',
              change_document_hdr_tab_name   TYPE char30 VALUE 'ZREUSE_HEAD_002',
              change_document_item_tab_name  TYPE char30 VALUE 'ZREUSE_ITEM_002',
              change_document_object_gen_cls TYPE char30 VALUE 'ZCL_ZREUSE_SO_002_CHDO'
              .

ENDINTERFACE.
