CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Item~calculateTotalPrice.


ENDCLASS.

CLASS lhc_item IMPLEMENTATION.

  METHOD calculateTotalPrice.

    DATA total_price TYPE ZREUSER_ItemTP_002-Amount.
    CONSTANTS vat TYPE i VALUE 19.
*    " read transfered instances

    "Read all salesorders for the requested items
    " If multiple items of the same salesorder are requested, the salesorder is returned only once.
    READ ENTITIES OF ZREUSER_salesorderTP_002 IN LOCAL MODE
      ENTITY Item BY \_SalesOrder
        FIELDS ( SalesorderID )
        WITH CORRESPONDING #( keys )
      RESULT DATA(salesorders) LINK DATA(item_to_salesorder).

*    "Read all items
    READ ENTITIES OF ZREUSER_salesorderTP_002 IN LOCAL MODE
      ENTITY item
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(items).


    DATA: update TYPE TABLE FOR UPDATE ZREUSER_salesorderTP_002\\item.
    update = CORRESPONDING #( items ).

    LOOP AT update ASSIGNING FIELD-SYMBOL(<update>).
      " calculate total value
      <update>-Amount = <update>-UnitPrice * <update>-Quantity.
      <update>-%control-amount = if_abap_behv=>mk-on.
      <update>-AmountVat = <update>-Amount * vat / 100.
      <update>-%control-amountvat = if_abap_behv=>mk-on.
      <update>-AmountExclVat = <update>-Amount - <update>-AmountVat.
      <update>-%control-AmountExclVat = if_abap_behv=>mk-on.
    ENDLOOP.

    IF update IS NOT INITIAL.
      MODIFY ENTITIES OF ZREUSER_salesorderTP_002 IN LOCAL MODE
      ENTITY item
        UPDATE FROM update.


      " Trigger Re-Calculation on Root Node
      MODIFY ENTITIES OF ZREUSER_salesorderTP_002 IN LOCAL MODE
        ENTITY SalesOrder
          EXECUTE reCalcTotalPrice
            FROM CORRESPONDING  #( salesorders ).
    ENDIF.
  ENDMETHOD.



ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
