import Foundation

struct AirportModel: Codable {
    var id: String
    var name: String
    var cityId: String
    var countryId: String
    var location: String

    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case countryId = "CountryId"
        case cityId = "CityId"
        case location = "Location"
    }
}
