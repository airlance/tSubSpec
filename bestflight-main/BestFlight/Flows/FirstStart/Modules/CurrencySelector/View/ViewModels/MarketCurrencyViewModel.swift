import Foundation

struct MarketCurrencyViewModel {

    let selected: Bool
    let identifier: String
    let title: String

    init(with model: CurrencyModel, selected: Bool) {
        self.selected = selected
        self.identifier = model.code
        self.title = "\(model.code) (\(model.symbol))"
    }
}
