import Foundation

protocol FlightSearchResultsTextManagerProtocol: BaseTextManagerProtocol {
    var title: String { get }
    var fromText: String { get }
    var toText: String { get }
}
