import Foundation

struct PlaceCityViewModel {

    let identifier: String
    let name: String

    init(with model: CityModel) {
        self.identifier = model.id
        self.name = model.name
    }
}
