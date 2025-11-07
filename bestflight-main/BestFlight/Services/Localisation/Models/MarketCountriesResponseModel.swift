import Foundation

struct MarketCountriesResponseModel: Codable {
    let countries: [MarketCountryModel]

    private enum CodingKeys: String, CodingKey {
        case countries = "Countries"
    }
}
