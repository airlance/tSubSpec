import Foundation

protocol CurrencySelectorModuleOutput: class {
    func didCurrencySelectorSelectCurrency(model: CurrencyModel?)
    func didCurrencySelectorFinish(model: CurrencyModel)
}
