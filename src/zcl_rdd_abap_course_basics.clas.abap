CLASS zcl_rdd_abap_course_basics DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    INTERFACES zif_abap_course_basics.
ENDCLASS.


CLASS zcl_rdd_abap_course_basics IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

*Task 1. Hello World:
*Implement method zif_abap_course_basics~hello_world which receives name as input and returns
* a message with the name and the system user id:“Hello IV_NAME, your system user is <system user id>.”
*The system user id should be fetched from the internal session properties - “sy-uname”.
********************************************************************************************************

    DATA message TYPE STRING.

    message = me->zif_abap_course_basics~hello_world( iv_name = 'Radka' ).

    out->write( message ).

*Task 2. Calculator:
*Implement method zif_abap_course_basics~calculator which receives 2 numbers and an operator (+, -, *, /)
*and returns the result of calculation <param1> <operator> <param2>
********************************************************************************************************

    DATA result TYPE i.

    TRY.

        result = me->zif_abap_course_basics~calculator(
                                                        iv_first_number = 5
                                                        iv_second_number = 4
                                                        iv_operator = '*' ).
        out->write( result ).
      CATCH cx_sy_zerodivide.
        out->write(  `Error: Division by zero is not defined!` ).
      CATCH cx_abap_invalid_value.
        out->write(  `Error: Not a valid operation!` ).
   ENDTRY.

*Task 3. Fizz Buzz:
*Implement method zif_abap_course_basics~fizz_buzz that returns a string with the numbers from 1 to 100.
*But for multiples of three writes “Fizz” instead of the number and for the multiples of five writes “Buzz”.
*For numbers which are multiples of both three and five it writes “FizzBuzz”.
***********************************************************************************************************

   DATA(sequence) = me->zif_abap_course_basics~fizz_buzz(  ).

   out->write( sequence ).

*Task 4. Date Parsing:
*Implement method zif_abap_course_basics~date_parsing that receives a string, containing a date, formatted in one of two ways:
*With written month: 12 April 2017
*With number for month: 12 4 2017
*Parse this string and return a date variable with the result
*****************************************************************************************************************************

    DATA date TYPE d.

    date = me->zif_abap_course_basics~date_parsing( '12 April 2017' ).

    out->write( date ).

*Task 5. Scrabble Score:
*Implement method zif_abap_course_basics~scrabble_score that receives a string and returns it’s
*Scrabble score. Use the letter position in English alphabet as score value. A=1 , B-2, etc...
***********************************************************************************************

    DATA(score) = me->zif_abap_course_basics~scrabble_score( 'RADKA' ).

    out->write( score ).

*Task 6. Current date and time:
*Implement method zif_abap_course_basics~get_current_date_time that returns the current date and time as timestamp.
*Use statement GET TIME STAMP FIELD DATA(lv_timestamp) to read the current time.
*******************************************************************************************************************

    DATA(result_ts) = me->zif_abap_course_basics~get_current_date_time( ).

*    out->write( |{ result_ts TIMESTAMP = ISO } | ).

*Task 7. Internal Tables:
*Implement method zif_abap_course_basics~internal_tables that covers the following requirements.
*Create new database table name ZTRAVEL_### (Replace ### with your identification).
*Copy database /dmo/travel table structure to ZTRAVEL_###.
*Execute the following code:
*SELECT * FROM ZTRAVEL_### INTO TABLE @DATA(lt_ztravel).
*    DELETE ZTRAVEL_### FROM TABLE @lt_ztravel.
*    COMMIT WORK AND WAIT.
*
*    INSERT ZTRAVEL_### FROM
*  ( SELECT FROM /dmo/travel
*      FIELDS uuid( )          AS travel_uuid,
*             travel_id        AS travel_id,
*             agency_id        AS agency_id,
*             customer_id      AS customer_id,
*             begin_date       AS begin_date,
*             end_date         AS end_date,
*             booking_fee      AS booking_fee,
*             total_price      AS total_price,
*             currency_code    AS currency_code,
*             description      AS description,
*             CASE status
*           WHEN 'B' THEN  'A'  " ACCEPTED
*           WHEN 'X'  THEN 'X' " CANCELLED
*               ELSE 'O'         " open
*          END                 AS overall_status,
*             createdby        AS createdby,
*             createdat        AS createdat,
*             lastchangedby    AS last_changed_by,
*             lastchangedat    AS last_changed_at
*      ORDER BY travel_id ).
*
*    COMMIT WORK AND WAIT.
*
*Method must skip this step if ZTRAVEL_### is not empty!
*Select all records in table ZTRAVEL_### into an internal table. Do not use any other OpenSQL. Execute the following operations on the internal table:
*•   The method should export a table containing all travels(TRAVEL_ID) for agency ( AGENCY_ID) 070001 with booking fee of 20 JPY (BOOKING_FEE CURRENCY_CODE)
*•   The method should export a table containing all travels with a price (TOTAL_PRICE) higher than 2000 USD. Hint: Currencies are convertible
*•   Delete all rows of the internal table with prices not in Euro, sort them by cheapest price and earliest date.
*•   Export a table containing the TRAVEL_ID of the first ten rows to screen.
*************************************************************************************************************************************************************

    DATA et1 TYPE zif_abap_course_basics=>ltty_travel_id.
    DATA et2 TYPE zif_abap_course_basics=>ltty_travel_id.
    DATA et3 TYPE zif_abap_course_basics=>ltty_travel_id.

    me->zif_abap_course_basics~internal_tables(
      IMPORTING
        et_travel_ids_task7_1 = et1
        et_travel_ids_task7_2 = et2
        et_travel_ids_task7_3 = et3 ).

*    LOOP AT et1 INTO DATA(row1).
*        out->write( data = row1
*                    name = `Task 7.1:` ).
*    ENDLOOP.
*
*    LOOP AT et2 INTO DATA(row2).
*        out->write( data = row2
*                    name = `Task 7.2:` ).
*    ENDLOOP.
*
*    LOOP AT et3 INTO DATA(row3).
*        out->write( data = row3
*                    name = `Task 7.3 and 7.4:` ).
*    ENDLOOP.

  ENDMETHOD.

  METHOD zif_abap_course_basics~calculator.

    CASE iv_operator.
        WHEN '+'.
            rv_result = iv_first_number + iv_second_number.
        WHEN '-'.
            rv_result = iv_first_number - iv_second_number.
        WHEN '*'.
            rv_result = iv_first_number * iv_second_number.
        WHEN '/'.
            IF iv_second_number = 0. " Exceptions not used due to missing RAISING in the interface
*                RAISE EXCEPTION TYPE cx_sy_zerodivide.
            ELSE.
                rv_result = iv_first_number / iv_second_number.
            ENDIF.
        WHEN OTHERS. " Exceptions not used due to missing RAISING in the interface
*            RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDCASE.
  ENDMETHOD.

  METHOD zif_abap_course_basics~date_parsing.

    DATA(day) = segment( val = iv_date sep = ` ` index = 1 ).
    DATA(month_text) = segment( val = iv_date sep = ` ` index = 2 ).
    DATA(year) = segment( val = iv_date sep = ` ` index = 3 ).

    CASE month_text.
        WHEN 'January'.
            month_text = '1'.
        WHEN 'February'.
            month_text = '2'.
        WHEN 'March'.
            month_text = '3'.
        WHEN 'April'.
            month_text = '4'.
        WHEN 'May'.
            month_text = '5'.
        WHEN 'June'.
            month_text = '6'.
        WHEN 'July'.
            month_text = '7'.
        WHEN 'August'.
            month_text = '8'.
        WHEN 'September'.
            month_text = '9'.
        WHEN 'October'.
            month_text = '10'.
        WHEN 'November'.
            month_text = '11'.
        WHEN 'December'.
            month_text = '12'.
        WHEN OTHERS. "do nothing
    ENDCASE.

    rv_result = CONV d( |{ year }{ month_text WIDTH = 2  PAD = '0' ALIGN = RIGHT }{ day WIDTH = 2  PAD = '0' ALIGN = RIGHT }| ).

  ENDMETHOD.

  METHOD zif_abap_course_basics~fizz_buzz.

    CONSTANTS max_count TYPE i VALUE 100.

    DATA word TYPE STRING.

    rv_result = ''.

    DO max_count TIMES.

        CLEAR word.

        IF sy-index mod 3 = 0 AND sy-index mod 5 = 0.
            word = 'FizzBuzz'.
        ELSEIF sy-index mod 5 = 0.
            word = 'Buzz'.
        ELSEIF sy-index mod 3 = 0.
            word = 'Fizz'.
        ELSE.
            word = sy-index.
        ENDIF.

        rv_result = rv_result && word && | |.

    ENDDO.


  ENDMETHOD.

  METHOD zif_abap_course_basics~get_current_date_time.
    GET TIME STAMP FIELD rv_result.
  ENDMETHOD.

  METHOD zif_abap_course_basics~hello_world.
    rv_result = |Hello { iv_name }, your system user is { sy-uname }.|.
  ENDMETHOD.

  METHOD zif_abap_course_basics~internal_tables.

    DATA lt_ztravel TYPE TABLE OF ZTRAVEL_RDD.
    DATA ls_travel TYPE ztravel_rdd.
    DATA lv_counter TYPE i.

    SELECT * FROM ZTRAVEL_RDD INTO TABLE @lt_ztravel.

    IF lt_ztravel IS INITIAL.

        DELETE ZTRAVEL_RDD FROM TABLE @lt_ztravel.

        INSERT ZTRAVEL_RDD FROM (
            SELECT FROM /dmo/travel
            FIELDS uuid( )          AS travel_uuid,
                travel_id        AS travel_id,
                agency_id        AS agency_id,
                customer_id      AS customer_id,
                begin_date       AS begin_date,
                end_date         AS end_date,
                booking_fee      AS booking_fee,
                total_price      AS total_price,
                currency_code    AS currency_code,
                description      AS description,
            CASE status
                WHEN 'B' THEN  'A'  " ACCEPTED
                WHEN 'X'  THEN 'X' " CANCELLED
                ELSE 'O'         " open
            END                 AS overall_status,
                createdby        AS createdby,
                createdat        AS createdat,
                lastchangedby    AS last_changed_by,
                lastchangedat    AS last_changed_at
        ORDER BY travel_id ).

        COMMIT WORK AND WAIT.

    ENDIF.

    LOOP AT lt_ztravel INTO ls_travel
                       WHERE agency_id = '070001'
                       AND CURRENCY_CODE = 'JPY'
                       AND BOOKING_FEE = 20.

        APPEND VALUE #( travel_id = ls_travel-travel_id ) TO et_travel_ids_task7_1.

    ENDLOOP.

    CLEAR ls_travel.

    LOOP AT lt_ztravel INTO ls_travel
                       WHERE TOTAL_PRICE > 2000
                       AND CURRENCY_CODE = 'USD'.

        APPEND VALUE #( travel_id = ls_travel-travel_id ) TO et_travel_ids_task7_2.

    ENDLOOP.

    CLEAR ls_travel.

    DELETE lt_ztravel WHERE currency_code <> 'EUR'.
    SORT lt_ztravel BY total_price ASCENDING begin_date ASCENDING.

    lv_counter = 0.

    LOOP AT lt_ztravel INTO ls_travel.

        APPEND VALUE #( travel_id = ls_travel-travel_id ) TO et_travel_ids_task7_3.

        lv_counter = lv_counter + 1.

        IF lv_counter = 10.
            EXIT.
        ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD zif_abap_course_basics~open_sql.
  ENDMETHOD.

  METHOD zif_abap_course_basics~scrabble_score.

    CONSTANTS correction TYPE i VALUE 64. " 64 = 65 - 1, 'ASCII' = 65 in ASCII

    DATA score TYPE i VALUE 0.
    DATA current_letter TYPE c LENGTH 1.
    DATA word TYPE String.
    DATA offset TYPE i.

    word = to_upper( iv_word ).

    DO strlen( word ) TIMES.

        offset = sy-index - 1.

        current_letter = substring( val = word off = offset len = 1 ).

        CASE current_letter.
          WHEN 'A'. score += 1.
          WHEN 'B'. score += 2.
          WHEN 'C'. score += 3.
          WHEN 'D'. score += 4.
          WHEN 'E'. score += 5.
          WHEN 'F'. score += 6.
          WHEN 'G'. score += 7.
          WHEN 'H'. score += 8.
          WHEN 'I'. score += 9.
          WHEN 'J'. score += 10.
          WHEN 'K'. score += 11.
          WHEN 'L'. score += 12.
          WHEN 'M'. score += 13.
          WHEN 'N'. score += 14.
          WHEN 'O'. score += 15.
          WHEN 'P'. score += 16.
          WHEN 'Q'. score += 17.
          WHEN 'R'. score += 18.
          WHEN 'S'. score += 19.
          WHEN 'T'. score += 20.
          WHEN 'U'. score += 21.
          WHEN 'V'. score += 22.
          WHEN 'W'. score += 23.
          WHEN 'X'. score += 24.
          WHEN 'Y'. score += 25.
          WHEN 'Z'. score += 26.
          WHEN OTHERS. " do nothing
        ENDCASE.

    ENDDO.

    rv_result = score.

  ENDMETHOD.
ENDCLASS.
