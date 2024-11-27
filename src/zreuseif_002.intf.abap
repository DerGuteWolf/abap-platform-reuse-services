INTERFACE zreuseif_002
  PUBLIC .

  CONSTANTS : sender_email_adress         TYPE  string VALUE 'noreply+abapcloud@sap.corp',
              receiver_email_adress       TYPE  string VALUE 'andre.fischer@sap.com',
              package_name                TYPE if_chdo_object_tools_rel=>tv_cddevclass VALUE 'ZREUSE_SERVICES_002',
              change_document_object_name TYPE if_chdo_object_tools_rel=>ty_cdobjectcl VALUE 'ZREUSE_SO_002'.

ENDINTERFACE.
