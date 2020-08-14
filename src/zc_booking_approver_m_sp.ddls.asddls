@EndUserText.label: 'Booking projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
  headerInfo: { typeName: 'Booking',
                typeNamePlural: 'Bookings',
                title: { type: #STANDARD, value: 'BookingID' }
  }
}

@Search.searchable: true

define view entity ZC_BOOKING_APPROVER_M_SP
  as projection on ZI_BOOKING_M_SP
{
      @UI.facet: [ { id:            'Booking',
                     purpose:       #STANDARD,
                     type:          #IDENTIFICATION_REFERENCE,
                     label:         'Booking',
                     position:      10 }]

      @Search.defaultSearchElement: true
  key travel_id     as TravelID,

      @UI: { lineItem:       [ { position: 20, importance: #HIGH } ],
             identification: [ { position: 20 } ] }

      @Search.defaultSearchElement: true
  key booking_id    as BookingID,

      @UI: { lineItem:       [ { position: 30, importance: #HIGH } ],
             identification: [ { position: 30 } ] }
      booking_date  as BookingDate,

      @UI: { lineItem:       [ { position: 40, importance: #HIGH } ],
             identification: [ { position: 40 } ],
             selectionField: [{ position: 10 }]
              }
      @Search.defaultSearchElement: true
      customer_id   as CustomerID,

      @UI: { lineItem:       [ { position: 50, importance: #HIGH } ],
             identification: [ { position: 50 } ] }
      @ObjectModel.text.element: ['CarrierName']
      carrier_id    as CarrierID,
      _Carrier.Name as CarrierName,

      @UI: { lineItem:       [ { position: 60, importance: #HIGH } ],
             identification: [ { position: 60 } ] }
      connection_id as ConnectionID,


      @UI: { lineItem:       [ { position: 70, importance: #HIGH } ],
             identification: [ { position: 70 } ] }
      flight_date   as FlightDate,

      @UI: { lineItem:       [ { position: 80, importance: #HIGH } ],
             identification: [ { position: 80 } ] }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price  as FlightPrice,

      currency_code as CurrencyCode,

      @UI.hidden: true
      lastchangedat as LastChangedAt, -- Take over from parent

      /* Associations */
      _Travel : redirected to parent ZC_Travel_Approver_M_SP,
      _Customer,
      _Carrier

}
