import Foundation

struct CityModel: Codable {
    var id: String
    var name: String
    var singleAirportCity: Bool
    var countryId: String
    var location: String
    var iataCode: String?
    var airports: [AirportModel]

    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case singleAirportCity = "SingleAirportCity"
        case countryId = "CountryId"
        case location = "Location"
        case iataCode = "IataCode"
        case airports = "Airports"
    }
}
