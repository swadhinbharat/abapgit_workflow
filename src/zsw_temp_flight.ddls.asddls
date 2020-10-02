@AbapCatalog.sqlViewName: 'ZSWTMPFLGHT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight'
define view ZSW_TEMP_FLIGHT as select from /dmo/flight {
    ///DMO/FLIGHT
    key carrier_id,
    key connection_id,
    key flight_date,
    price,
    currency_code,
    plane_type_id,
    seats_max,
    seats_occupied
}
