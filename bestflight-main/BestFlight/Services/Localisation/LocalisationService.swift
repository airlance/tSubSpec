import Foundation

final class LocalisationService: BaseNetworkService {

    // MARK: Declarations

    enum Endpoint: String {
        case markets = "reference/v1.0/countries/{locale}"
        case currencies = "reference/v1.0/currencies"
    }

}

extension LocalisationService: LocalisationServiceProtocol {
    func obtainCountries(contract: MarketCountriesContract, completion: @escaping (Result<MarketCountriesResponseModel, NetworkError>) -> Void) {
        let path = Endpoint.markets.rawValue.replacingOccurrences(of: "{locale}", with: contract.locale)
        let request = NetworkRequest(
            path: path,
            method: .GET,
            params: nil
        )

        networkService.makeRequest(type: MarketCountriesResponseModel.self, request: request) { (result) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func obtainCurrencies(completion: @escaping (Result<CurrenciesResponseModel, NetworkError>) -> Void) {
        let request = NetworkRequest(
            path: Endpoint.currencies.rawValue,
            method: .GET,
            params: nil
        )

        networkService.makeRequest(type: CurrenciesResponseModel.self, request: request) { (result) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
