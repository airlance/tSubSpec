import Foundation

enum QuotePlaceType: String, Codable {
    case station = "Station"
    case country = "Country"
}

struct QuotePlaceModel: Codable {
    let name: String
    let type: QuotePlaceType
    let placeId: Int
    let skyscannerCode: String
    let iataCode: String?
    let cityName: String?
    let cityId: String?
    let countryName: String?

    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case type = "Type"
        case placeId = "PlaceId"
        case skyscannerCode = "SkyscannerCode"
        case iataCode = "IataCode"
        case cityName = "CityName"
        case cityId = "CityId"
        case countryName = "CountryName"
    }
}
