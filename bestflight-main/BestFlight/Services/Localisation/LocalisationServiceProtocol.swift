import Foundation

protocol LocalisationServiceProtocol: class {
    func obtainCountries(contract: MarketCountriesContract, completion: @escaping (Result<MarketCountriesResponseModel, NetworkError>) -> Void)
    func obtainCurrencies(completion: @escaping (Result<CurrenciesResponseModel, NetworkError>) -> Void)
}
