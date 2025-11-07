import Foundation

struct CurrenciesResponseModel: Codable {
    let currencies: [CurrencyModel]

    private enum CodingKeys: String, CodingKey {
        case currencies = "Currencies"
    }
}
