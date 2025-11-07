import Foundation

protocol CountrySelectorViewOutput: SelectorViewOutput {
    func viewIsReady()
    func didSelectCountry(model: MarketCountryViewModel)
}
