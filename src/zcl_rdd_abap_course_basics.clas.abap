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
  ENDMETHOD.

  METHOD zif_abap_course_basics~open_sql.
  ENDMETHOD.

  METHOD zif_abap_course_basics~scrabble_score.

    CONSTANTS correction TYPE i VALUE 64. " 64 = 65 - 1, 'ASCII' = 65 in ASCII

    DATA score TYPE i VALUE 0.
    DATA current_letter TYPE c LENGTH 1.
    DATA word TYPE String.
    DATA offset TYPE i.
    DATA number TYPE i.

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
