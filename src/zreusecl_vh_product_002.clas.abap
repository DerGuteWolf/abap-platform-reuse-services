CLASS zreusecl_vh_product_002 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .

    TYPES:
      t_products TYPE STANDARD TABLE OF zreusei_vh_product_002   WITH  EMPTY KEY .

    DATA:
      producty TYPE t_products READ-ONLY .

    METHODS get_products
      RETURNING
        VALUE(products) TYPE t_products .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZREUSECL_VH_PRODUCT_002 IMPLEMENTATION.


  METHOD get_products.
    "
    products = VALUE #(
    ( Product = 'ZPRINTER01' ProductText = 'Printer Professional ABC' Price = '500.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'EA'  )
    ( Product = 'ZPRINTER02' ProductText = 'Printer Platinum' Price = '800.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'EA'  )
    ( Product = 'D001' ProductText = 'Mobile Phone' Price = '850.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'EA'  )
    ( Product = 'D002' ProductText = 'Table PC' Price = '900.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'EA'  )
    ( Product = 'D003' ProductText = 'Office Table' Price = '599.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'EA'  )
    ( Product = 'D004' ProductText = 'Office Chair' Price = '449.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'EA'  )
    ( Product = 'D005' ProductText = 'Developer Notebook' Price = '3150.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'EA'  )
    ( Product = 'D006' ProductText = 'Mouse' Price = '79.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'EA'  )
    ( Product = 'D007' ProductText = 'Headset' Price = '159.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'EA'  )
    ( Product = 'D008' ProductText = 'Keyboard' Price = '39.00 ' Currency = 'EUR' ProductGroup = 'L001' BaseUnit = 'EA'  )
     ).
  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    DATA business_data TYPE TABLE OF zreusei_vh_product_002.
    DATA business_data_line TYPE zreusei_vh_product_002 .
    DATA(skip)    = io_request->get_paging( )->get_offset( ).
    DATA(requested_fields)  = io_request->get_requested_elements( ).
    DATA(sort_order)    = io_request->get_sort_elements( ).
    TRY.
        DATA(filter_condition) = io_request->get_filter( )->get_as_sql_string( ).
        business_data = get_products(  ).
        SELECT * FROM @business_data AS implementation_types
           WHERE (filter_condition) INTO TABLE @business_data.
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
