@EndUserText.label: 'Change documents'
define custom entity ZREUSEI_CHANGE_DOCUMENTS_002

{

  key salesorder_id     : abap.char(6) ;
  customer_id           : zreuse_customer_id_002;
  payment_method        : abap.char(25);
  @Semantics.amount.currencyCode : 'currency_code'
  amount_excl_vat       : abap.curr(15,2);
  @Semantics.amount.currencyCode : 'currency_code'
  amount_vat            : abap.curr(15,2);
  @Semantics.amount.currencyCode : 'currency_code'
  total_amount          : zreuse_total_amount_002;
  currency_code         : zreuse_currency_code_002;
  description           : abap.char(255);
  overall_status        : zreuse_overall_status_002;
//  attachment            : abap.rawstring(0);
//  mime_type             : abap.char(128);
//  file_name             : abap.char(128);
  created_at            : abp_creation_tstmpl;
  created_by            : abp_creation_user;
  last_changed_by       : abp_lastchange_user;
  last_changed_at       : abp_lastchange_tstmpl;
  local_last_changed_at : abp_locinst_lastchange_tstmpl;

  
}
