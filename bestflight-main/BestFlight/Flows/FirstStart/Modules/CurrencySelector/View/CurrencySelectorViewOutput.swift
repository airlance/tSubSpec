import Foundation

protocol CurrencySelectorViewOutput: SelectorViewOutput {
    func viewIsReady()
    func didSelectCurrency(model: MarketCurrencyViewModel)
}
