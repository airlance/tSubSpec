import Foundation

struct ContinentModel: Codable {
    var id: String
    var name: String
    var countries: [CountryModel]

    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case countries = "Countries"
    }
}
