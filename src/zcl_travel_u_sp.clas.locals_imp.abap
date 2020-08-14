CLASS lhc_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE travel.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE travel.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE travel.

    METHODS read FOR READ
      IMPORTING keys FOR READ travel RESULT result.

    METHODS set_status_booked FOR MODIFY
      IMPORTING keys FOR ACTION travel~set_status_booked RESULT result.

    TYPES:
      tt_travel_update TYPE TABLE FOR UPDATE zi_travel_u_SP.

    METHODS:_fill_travel_inx
      IMPORTING is_travel_update     TYPE LINE OF tt_travel_update
      RETURNING VALUE(rs_travel_inx) TYPE /dmo/if_flight_legacy=>ts_travel_inx.

ENDCLASS.

CLASS lhc_travel IMPLEMENTATION.

  METHOD create.

    DATA lt_messages   TYPE /dmo/if_flight_legacy=>tt_message.
    DATA ls_travel_in  TYPE /dmo/travel.
    DATA ls_travel_out TYPE /dmo/travel.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_travel_create>).

      ls_travel_in = CORRESPONDING #( <fs_travel_create> MAPPING FROM ENTITY USING CONTROL ).


      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_CREATE'
        EXPORTING
          is_travel   = CORRESPONDING /dmo/if_flight_legacy=>ts_travel_in( ls_travel_in )
        IMPORTING
          es_travel   = ls_travel_out
          et_messages = lt_messages.



      IF lt_messages IS INITIAL.
        INSERT VALUE #( %cid = <fs_travel_create>-%cid  travelid = ls_travel_out-travel_id )
                       INTO TABLE mapped-travel.
      ELSE.


      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD delete.

    DATA lt_messages TYPE /dmo/if_flight_legacy=>tt_message.
    DATA ls_travel   TYPE /dmo/if_flight_legacy=>ts_travel_key.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_travel_delete>).
      IF <fs_travel_delete>-travelid IS INITIAL OR <fs_travel_delete>-travelid = ''.
        ls_travel-travel_id = mapped-travel[ %cid = <fs_travel_delete>-%cid_ref ]-travelid.
      ELSE.
        ls_travel-travel_id = <fs_travel_delete>-travelid.
      ENDIF.

      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_DELETE'
        EXPORTING
          iv_travel_id = ls_travel-travel_id
        IMPORTING
          et_messages  = lt_messages.

      LOOP AT lt_messages TRANSPORTING NO FIELDS WHERE msgty = 'E' OR msgty = 'A'.
        INSERT VALUE #( %cid = <fs_travel_delete>-%cid_ref travelid = <fs_travel_delete>-travelid )
        INTO TABLE failed-travel.
        RETURN.
      ENDLOOP.

    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA lt_messages    TYPE /dmo/if_flight_legacy=>tt_message.
    DATA ls_travel      TYPE /dmo/travel.
    DATA ls_travelx TYPE /dmo/if_flight_legacy=>ts_travel_inx. "refers to x structure (> BAPIs)

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_travel_update>).

      ls_travel = CORRESPONDING #( <fs_travel_update> MAPPING FROM ENTITY ).

      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_UPDATE'
        EXPORTING
          is_travel   = CORRESPONDING /dmo/if_flight_legacy=>ts_travel_in( ls_travel )
          is_travelx  = _fill_travel_inx( <fs_travel_update> )
        IMPORTING
          et_messages = lt_messages.

*      /dmo/cl_travel_auxiliary=>handle_travel_messages(
*        EXPORTING
*          iv_cid       = <fs_travel_update>-%cid_ref
*          iv_travel_id = <fs_travel_update>-travelid
*          it_messages  = lt_messages
*        CHANGING
*          failed   = failed-travel
*          reported = reported-travel ).

    ENDLOOP.
  ENDMETHOD.

  METHOD _fill_travel_inx.

    CLEAR rs_travel_inx.
    rs_travel_inx-travel_id = is_travel_update-TravelID.

    rs_travel_inx-agency_id     = xsdbool( is_travel_update-%control-agencyid     = if_abap_behv=>mk-on ).
    rs_travel_inx-customer_id   = xsdbool( is_travel_update-%control-customerid   = if_abap_behv=>mk-on ).
    rs_travel_inx-begin_date    = xsdbool( is_travel_update-%control-begindate    = if_abap_behv=>mk-on ).
    rs_travel_inx-end_date      = xsdbool( is_travel_update-%control-enddate      = if_abap_behv=>mk-on ).
    rs_travel_inx-booking_fee   = xsdbool( is_travel_update-%control-bookingfee   = if_abap_behv=>mk-on ).
    rs_travel_inx-total_price   = xsdbool( is_travel_update-%control-totalprice   = if_abap_behv=>mk-on ).
    rs_travel_inx-currency_code = xsdbool( is_travel_update-%control-currencycode = if_abap_behv=>mk-on ).
    rs_travel_inx-description   = xsdbool( is_travel_update-%control-memo         = if_abap_behv=>mk-on ).
    rs_travel_inx-status        = xsdbool( is_travel_update-%control-status       = if_abap_behv=>mk-on ).
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD set_status_booked.

    DATA lt_messages TYPE /dmo/if_flight_legacy=>tt_message.
    DATA ls_travel_out TYPE /dmo/travel.

    CLEAR result.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_travel_set_status_booked>).
      DATA(lv_travelid) = <fs_travel_set_status_booked>-travelid.

      IF lv_travelid IS INITIAL OR lv_travelid = ''.
        lv_travelid = mapped-travel[ %cid = <fs_travel_set_status_booked>-%cid_ref ]-travelid.
      ENDIF.

      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_SET_BOOKING'
        EXPORTING
          iv_travel_id = lv_travelid
        IMPORTING
          et_messages  = lt_messages.

      IF lt_messages IS INITIAL.
        APPEND VALUE #( travelid        = lv_travelid
                        %param-travelid = lv_travelid )
               TO result.
      ELSE.
        LOOP AT lt_messages TRANSPORTING NO FIELDS WHERE msgty = 'E' OR msgty = 'A'.
          INSERT VALUE #( %cid = <fs_travel_set_status_booked>-%cid_ref travelid = <fs_travel_set_status_booked>-travelid ) INTO TABLE failed-travel.
          RETURN.
        ENDLOOP.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.

CLASS lsc_ZI_TRAVEL_U_SP DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_TRAVEL_U_SP IMPLEMENTATION.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD finalize.
  ENDMETHOD.

  METHOD save.

    CALL FUNCTION '/DMO/FLIGHT_TRAVEL_SAVE'.
  ENDMETHOD.

ENDCLASS.
