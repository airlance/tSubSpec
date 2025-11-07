import Foundation

struct MarketCountryModel: Codable {
    let code: String
    let name: String

    private enum CodingKeys: String, CodingKey {
        case code = "Code"
        case name = "Name"
    }
}
