import Foundation

struct FlightSearchResultsSettings {
    let moduleOutput: FlightSearchResultsModuleOutput
    let contract: FlightSearchContract
    let userSettings: UserSettingsModel
    let languagesService: LanguagesServiceProtocol
    let flightsService: FlightsServiceProtocol
}
