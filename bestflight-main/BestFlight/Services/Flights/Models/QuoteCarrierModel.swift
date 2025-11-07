import Foundation

struct QuoteCarrierModel: Codable {
    let carrierId: Int
    let name: String

    private enum CodingKeys: String, CodingKey {
        case carrierId = "CarrierId"
        case name = "Name"
    }
}

