@EndUserText.label: 'Booking supplement projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: { headerInfo: { typeName:       'Booking Supplement',
                     typeNamePlural: 'Booking Supplements',
                     title:          { type: #STANDARD,
                                       label: 'Booking Supplement',
                                       value: 'BookingSupplementID' } } }
@Search.searchable: true

define view entity ZSW_C_BOOKSUPPL_PROCESSOR_M
  as projection on ZSW_I_BookSuppl_M
{
      @UI.facet: [ { id:              'BookingSupplement',
                     purpose:         #STANDARD,
                     type:            #IDENTIFICATION_REFERENCE,
                     label:           'Booking Supplement',
                     position:        10 }  ]

      @Search.defaultSearchElement: true
  key travel_id                   as TravelID,

      @Search.defaultSearchElement: true
  key booking_id                  as BookingID,

      @UI: { lineItem:       [ { position: 10, importance: #HIGH } ],
             identification: [ { position: 10 } ] }
  key booking_supplement_id       as BookingSupplementID,

      @UI: { lineItem:       [ { position: 20, importance: #HIGH } ],
             identification: [ { position: 20 } ] }
      @Consumption.valueHelpDefinition: [ {entity: {name: '/DMO/I_SUPPLEMENT', element: 'SupplementID' } ,
                                           additionalBinding: [ { localElement: 'Price',  element: 'Price' },
                                                                { localElement: 'CurrencyCode', element: 'CurrencyCode' }] }]
      @ObjectModel.text.element: ['SupplementDescription']
      supplement_id               as SupplementID,
      _SupplementText.Description as SupplementDescription : localized,

      @UI: { lineItem:       [ { position: 30, importance: #HIGH } ],
             identification: [ { position: 30 } ] }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                       as Price,

      @Consumption.valueHelpDefinition: [{entity: {name: 'I_Currency', element: 'Currency' }}]
      currency_code               as CurrencyCode,

      @UI.hidden: true
      last_changed_at             as LastChangedAt,

      /* Associations */
      _Travel  : redirected to ZSW_C_Travel_Processor_M,
      _Booking : redirected to parent ZSW_C_Booking_Processor_M,
      _SupplementText
}
