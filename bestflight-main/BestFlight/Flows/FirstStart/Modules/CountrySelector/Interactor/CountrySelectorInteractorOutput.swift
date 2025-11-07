import Foundation

protocol CountrySelectorInteractorOutput: class {
    func didObtainCountries(countries: [MarketCountryModel])
    func didNotObtainCountries(with error: NetworkError)
}
