import Foundation

struct QuotesResponseModel: Codable {
    let quotes: [QuotePriceModel]
    let places: [QuotePlaceModel]
    let carriers: [QuoteCarrierModel]

    private enum CodingKeys: String, CodingKey {
        case quotes = "Quotes"
        case places = "Places"
        case carriers = "Carriers"
    }
}
