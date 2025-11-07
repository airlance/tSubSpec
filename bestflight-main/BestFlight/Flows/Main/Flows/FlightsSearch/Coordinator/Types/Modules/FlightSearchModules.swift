import Foundation

enum FlightSearchModules {
    case searchForm
    case searchResults(contract: FlightSearchContract)
    case placeSelector
}
