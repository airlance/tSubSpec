import Foundation

protocol CountrySelectorModuleOutput: class {
    func didCountrySelectorSelectCountry(model: MarketCountryModel?)
    func didCountrySelectorFinish(model: MarketCountryModel)
}
