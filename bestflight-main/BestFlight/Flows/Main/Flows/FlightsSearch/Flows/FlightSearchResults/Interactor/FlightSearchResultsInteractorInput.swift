import Foundation

protocol FlightSearchResultsInteractorInput {
    func obtainSearchResults(with contract: FlightSearchContract, userSettings: UserSettingsModel)
}
