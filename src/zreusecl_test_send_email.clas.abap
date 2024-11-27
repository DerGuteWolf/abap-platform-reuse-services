CLASS zreusecl_test_send_email DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZREUSECL_TEST_SEND_EMAIL IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA lv_success TYPE abap_boolean.

    DATA lv_sender TYPE cl_bcs_mail_message=>ty_address.

    DATA lt_receivers TYPE cl_bcs_mail_message=>tyt_recipient.


    lv_sender = zreuseif_002=>sender_email_adress." ##NO_TEXT.

    lt_receivers = VALUE #( ( address = zreuseif_002=>receiver_email_adress ) ).

    TRY.

        DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).


        lo_mail->set_sender( lv_sender ).

        LOOP AT lt_receivers INTO DATA(lv_email_address).
          lo_mail->add_recipient( lv_email_address-address ).
        ENDLOOP.

        lo_mail->set_subject( 'Bonus Calculation Mail' ) ##NO_TEXT.

        lo_mail->set_main( cl_bcs_mail_textpart=>create_instance(

          iv_content      = |<h1>Hello { sy-uname }</h1><p>Your bonus was calculated.</p><p>Please check attached document!</p>|

          iv_content_type = 'text/html'

        ) ) ##NO_TEXT.

*        lo_mail->add_attachment( cl_bcs_mail_textpart=>create_instance(
*
*          iv_content      = |This is your bonus: { i_bonus_calculation-ActualRevenueAmount_V } { i_bonus_calculation-ActualRevenueAmount_C }|
*
*          iv_content_type = 'text/plain'
*
*          iv_filename     = 'Text_Attachment.txt'
*
*        ) ) ##NO_TEXT.

        lo_mail->send( IMPORTING et_status = DATA(lt_status) ).

        out->write( lt_status ).

      CATCH cx_bcs_mail INTO DATA(lx_mail).

        DATA(lx_data) = lx_mail->get_longtext( ).

        out->write( lx_data ).

    ENDTRY.


  ENDMETHOD.
ENDCLASS.
