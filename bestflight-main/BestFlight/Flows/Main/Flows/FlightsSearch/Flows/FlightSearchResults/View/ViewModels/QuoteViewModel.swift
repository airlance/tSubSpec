import Foundation

struct QuoteViewModel {


    private let quote: QuotePriceModel
    private let sourcePlace: QuotePlaceModel
    private let targetPlace: QuotePlaceModel
    private let carriers: [QuoteCarrierModel]
    private let currency: CurrencyModel

    init(from quote: QuotePriceModel, sourcePlace: QuotePlaceModel, place: QuotePlaceModel, carriers: [QuoteCarrierModel], currency: CurrencyModel) {
        self.quote = quote
        self.sourcePlace = sourcePlace
        self.targetPlace = place
        self.carriers = carriers
        self.currency = currency
    }

    var date: Date? {
        Date.fromString(string: quote.outboundLeg.departureDate, format: "yyyy-MM-ddTHH:mm:ss")
    }

    var dateText: String {
        self.date?.string(format: "dd.MM.yyyy") ?? ""
    }

    var fromText: String {
        sourcePlace.name
    }

    var toText: String {
        targetPlace.name
    }

    var summaryText: String {
        currency.format(number: quote.minPrice)
    }
}
