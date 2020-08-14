@AbapCatalog.sqlViewName: 'ZTRAVEL_USP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@UI.headerInfo.typeName: 'Travel'
@UI.headerInfo.typeNamePlural: 'Travels'
@EndUserText.label: 'Travel view - CDS data model'
//@AbapCatalog.dataMaintenance: #ALLOWED
define root view ZI_TRAVEL_U_SP
  as select from /dmo/travel as Travel
  association [0..1] to ZI_Agency_U_SP   as _Agency   on $projection.AgencyID = _Agency.AgencyID
  association [0..1] to ZI_Customer_U_SP as _Customer on $projection.CustomerID = _Customer.CustomerID
  association [0..1] to I_Currency       as _Currency on $projection.CurrencyCode = _Currency.Currency
{
      @UI.facet: [ { purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label:'Travel', position: 10 } ]
      @UI: { lineItem: [ { position: 10, label: 'Travel ID' } ] }
      @UI.selectionField: [ { position: 10 } ]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @EndUserText.quickInfo: 'Travel Identification for Customer.'
  key Travel.travel_id     as TravelID,

      @UI: { lineItem: [ { position: 20, label: 'Agency ID' } ] , identification:[ { position: 20, label: 'Agency ID' } ]  }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_Agency_U_SP', element: 'AgencyID' } }]
      @UI.selectionField: [ { position: 20 } ]
      @ObjectModel.text.association:'_Agency'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @EndUserText.label: 'Agency ID'
      Travel.agency_id     as AgencyID,

      @UI: { lineItem: [ { position: 30 , label: 'Customer Number' } ] ,identification:[ { position: 30, label: 'Customer Number' } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CUSTOMER_U_SP', element: 'CustomerID' } }]
      @UI.selectionField: [ { position: 30 } ]
      @ObjectModel.text.association:'_Customer'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @EndUserText.label: 'Customer Number'
      Travel.customer_id   as CustomerID,

      @UI: { lineItem: [ { position: 40 , label: 'Start Date' } ],  identification:[ { position: 40 } ]  }
      Travel.begin_date    as BeginDate,

      @UI: { lineItem: [ { position: 41,  label: 'End Date' } ],  identification:[ { position: 40 } ] }
      Travel.end_date      as EndDate,

      @UI: { identification:[ { position: 42, label: 'Booking Fee' } ] }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Travel.booking_fee   as BookingFee,

      @UI: { identification:[ { position: 43, label: 'Total Price' } ] }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Travel.total_price   as TotalPrice,

      @Semantics.currencyCode: true
      Travel.currency_code as CurrencyCode,

      @UI: { identification:[ { position: 45, label: 'Comment' } ] }
      Travel.description   as Memo,


      @UI: { lineItem: [ { position: 50, label: 'Travel Status'} ],
      identification:[ { position: 50, label: 'Travel Status' } ] }
      Travel.status        as Status,
      /* Associations */
      _Agency,
      _Customer,
      _Currency
}
