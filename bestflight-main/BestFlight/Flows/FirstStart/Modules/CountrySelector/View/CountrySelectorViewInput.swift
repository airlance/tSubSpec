import Foundation

protocol CountrySelectorViewInput: SelectorViewInput, AlertPresentableView {
    func showItems(items: [MarketCountryViewModel])
}
