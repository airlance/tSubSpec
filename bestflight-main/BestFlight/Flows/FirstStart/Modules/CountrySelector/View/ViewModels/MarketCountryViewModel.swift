import Foundation

struct MarketCountryViewModel {
    let identifier: String
    let title: String
    let selected: Bool

    init(with model: MarketCountryModel, selected: Bool) {
        self.identifier = model.code
        self.title = model.name
        self.selected = selected
    }
}
