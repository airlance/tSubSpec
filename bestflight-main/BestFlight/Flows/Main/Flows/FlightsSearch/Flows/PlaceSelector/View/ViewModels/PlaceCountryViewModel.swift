import Foundation

struct PlaceCountryViewModel {

    let identifier: String
    let name: String
    let cities: [PlaceCityViewModel]

    init(with model: CountryModel) {
        self.identifier = model.id
        self.name = model.name
        self.cities = model.cities.map { PlaceCityViewModel(with: $0) }
    }
}
