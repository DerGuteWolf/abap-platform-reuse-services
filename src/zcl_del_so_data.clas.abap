CLASS zcl_del_so_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DEL_SO_DATA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  delete from zreuseite00d_002.
  delete from zreusesal00d_002.
  delete from zreuse_head_002.
  delete from zreuse_item_002.

  COMMIT work.


  ENDMETHOD.
ENDCLASS.
