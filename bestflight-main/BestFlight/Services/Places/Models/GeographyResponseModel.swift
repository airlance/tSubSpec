import Foundation

struct GeographyResponseModel: Codable {
    var continents: [ContinentModel]

    private enum CodingKeys: String, CodingKey {
        case continents = "Continents"
    }
}
