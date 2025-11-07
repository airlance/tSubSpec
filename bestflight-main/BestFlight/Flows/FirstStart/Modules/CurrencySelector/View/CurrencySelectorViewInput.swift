import Foundation

protocol CurrencySelectorViewInput: SelectorViewInput, AlertPresentableView {
    func showItems(items: [MarketCurrencyViewModel])
}
