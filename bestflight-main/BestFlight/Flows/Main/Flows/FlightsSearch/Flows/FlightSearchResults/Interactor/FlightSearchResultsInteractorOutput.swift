import Foundation

protocol FlightSearchResultsInteractorOutput: class {
    func didObtainQuotes(model: QuotesResponseModel)
    func didNotObtainQuotes(with error: NetworkError)
}
