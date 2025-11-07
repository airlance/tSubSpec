import Foundation

struct OutboundLegModel: Codable {
    let carrierIds: [Int]
    let originId: Int
    let destinationId: Int
    let departureDate: String

    private enum CodingKeys: String, CodingKey {
        case carrierIds = "CarrierIds"
        case originId = "OriginId"
        case destinationId = "DestinationId"
        case departureDate = "DepartureDate"
    }
}

struct QuotePriceModel: Codable {
    let quoteId: Int
    let minPrice: Int
    let direct: Bool
    let outboundLeg: OutboundLegModel

    private enum CodingKeys: String, CodingKey {
        case quoteId = "QuoteId"
        case minPrice = "MinPrice"
        case direct = "Direct"
        case outboundLeg = "OutboundLeg"
    }
}
