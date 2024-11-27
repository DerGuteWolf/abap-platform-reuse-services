class ZREUSECL_VH_CUSTOMER_002 definition
  public
  final
  create public .

public section.

  interfaces IF_RAP_QUERY_PROVIDER .

  types:
    T_PRODUCTS TYPE STANDARD TABLE OF ZREUSEI_VH_CUSTOMER_002 WITH  EMPTY KEY .

  data:
    PRODUCTY TYPE t_products READ-ONLY .

  methods GET_PRODUCTS
    returning
      value(PRODUCTS) type t_products .
protected section.
private section.
ENDCLASS.



CLASS ZREUSECL_VH_CUSTOMER_002 IMPLEMENTATION.


METHOD GET_PRODUCTS.
"
  products =

  VALUE #(
(   customerid = '000001' firstname = 'Theresia' lastname = 'Buchholm' TITLE = 'Mrs.' STREET = 'Lerchenstr. 82' postalcode = '71116' CITY = 'Gaertringen' countrycode = 'DE' phonenumber = '+49-341-184709'
email = 'theresia.buchholm@flight.example.de'        )
(   customerid = '000002' firstname = 'Johannes' lastname = 'Buchholm' TITLE = 'Mr.' STREET = 'Muehltalstr. 14' postalcode = '68723' CITY = 'Schwetzingen' countrycode = 'DE' phonenumber = '+49-291-299232'
email = 'johannes.buchholm@flight.example.de'        )
(   customerid = '000003' firstname = 'James' lastname = 'Buchholm' TITLE = 'Mr.' STREET = 'Froschstr. 91' postalcode = '90419' CITY = 'Nuernberg' countrycode = 'DE' phonenumber = '+49-601-130850'
email = 'james.buchholm@flight.example.de'        )
(   customerid = '000004' firstname = 'Thomas' lastname = 'Buchholm' TITLE = 'Mr.' STREET = 'Hauptstr. 84' postalcode = '63263' CITY = 'Neu-Isenburg' countrycode = 'DE' phonenumber = '+49-394-339928'
email = 'thomas.buchholm@flight.example.de'        )
(   customerid = '000005' firstname = 'Anna' lastname = 'Buchholm' TITLE = 'Mrs.' STREET = 'Hasnerstrasse 13' postalcode = '4020' CITY = 'Linz' countrycode = 'AT' phonenumber = '+43-957-258037'
email = 'anna.buchholm@flight.example.at'        )
(   customerid = '000006' firstname = 'Uli' lastname = 'Buchholm' TITLE = 'Mrs.' STREET = 'Caspar-David-Friedrich-Str. 97' postalcode = '75757' CITY = 'Elsenz' countrycode = 'DE' phonenumber = '+49-367-156738'
email = 'uli.buchholm@flight.example.de'        )
(   customerid = '000007' firstname = 'Jean-Luc' lastname = 'Buchholm' TITLE = 'Mr.' STREET = 'Lake Shore Drive 92' postalcode = '22334' CITY = 'San Francisco' countrycode = 'US' phonenumber = '+1-848-371606'
email = 'jean-luc.buchholm@flight.example.us'        )
(   customerid = '000008' firstname = 'August' lastname = 'Buchholm' TITLE = 'Mr.' STREET = 'Lerchenstr. 23' postalcode = '64342' CITY = 'Seeheim-Jugenheim' countrycode = 'DE' phonenumber = '+49-184-089871'
email = 'august.buchholm@flight.example.de'        )
(   customerid = '000009' firstname = 'Achim' lastname = 'Buchholm' TITLE = 'Mr.' STREET = 'Stauboernchenstrasse 64' postalcode = '76137' CITY = 'Karlsruhe' countrycode = 'DE' phonenumber = '+49-797-976779'
email = 'achim.buchholm@flight.example.de'        )
(   customerid = '000010' firstname = 'Irmtraut' lastname = 'Buchholm' TITLE = 'Mrs.' STREET = 'Franz-Marc-Str. 31' postalcode = '69207' CITY = 'Kurt' countrycode = 'DE' phonenumber = '+49-417-532827'
email = 'irmtraut.buchholm@flight.example.de'        )

 ).


ENDMETHOD.


METHOD IF_RAP_QUERY_PROVIDER~SELECT.
  DATA business_data TYPE TABLE OF ZREUSEI_VH_CUSTOMER_002.
  DATA business_data_line TYPE ZREUSEI_VH_CUSTOMER_002 .
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
    assert 1 = 2.
*    RAISE EXCEPTION TYPE cx_rap_query_provider
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
