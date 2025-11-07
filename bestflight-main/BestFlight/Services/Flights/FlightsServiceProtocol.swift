import Foundation

protocol FlightsServiceProtocol: class {
    func obtainQuotes(contract: QuotesContract, completion: @escaping (Result<QuotesResponseModel, NetworkError>) -> Void)
}
