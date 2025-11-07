import Foundation

final class FlightSearchResultsTextManager: BaseTextManager {

}

// MARK: - FlightSearchResultsTextManagerProtocol implementation

extension FlightSearchResultsTextManager: FlightSearchResultsTextManagerProtocol {
    var title: String {
        localizedString(key: "searchResultsTitle")
    }

    var fromText: String {
        localizedString(key: "searchResultsFrom")
    }

    var toText: String {
        localizedString(key: "searchResultsTo")
    }
}
