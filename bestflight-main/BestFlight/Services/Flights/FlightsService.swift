import Foundation

final class FlightsService: BaseNetworkService {
    // MARK: Declarations

    private enum Endpoint: String {
        case quotes = "browsequotes/v1.0/{country}/{currency}/{locale}/{from}/{to}/{date}"
    }
}

// MARK: - FlightsServiceProtocol implementation

extension FlightsService: FlightsServiceProtocol {
    func obtainQuotes(contract: QuotesContract, completion: @escaping (Result<QuotesResponseModel, NetworkError>) -> Void) {
        let date = contract.date?.string(format: "yyyy-MM-dd") ?? "anytime"
        let path = Endpoint.quotes.rawValue
            .replacingOccurrences(of: "{country}", with: contract.marketCountry.code)
            .replacingOccurrences(of: "{currency}", with: contract.marketCurrency.code)
            .replacingOccurrences(of: "{locale}", with: contract.language.identifier)
            .replacingOccurrences(of: "{from}", with: contract.fromCountry.id)
            .replacingOccurrences(of: "{to}", with: contract.toCountry.id)
            .replacingOccurrences(of: "{date}", with: date)
        let request = NetworkRequest(
            path: path,
            method: .GET,
            params: nil
        )

        networkService.makeRequest(type: QuotesResponseModel.self, request: request) { (result) in
            completion(result)
        }
    }
}
