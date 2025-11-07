import Foundation

protocol CurrencySelectorInteractorOutput: class {
    func didObtainCurrencies(currencies: [CurrencyModel])
    func didNotObtainCurrencies(with error: NetworkError)
}
