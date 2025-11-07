import Foundation

struct CountryModel: Codable {
    var id: String
    var name: String
    var currencyId: String
    var cities: [CityModel]

    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case currencyId = "CurrencyId"
        case cities = "Cities"
    }
}
