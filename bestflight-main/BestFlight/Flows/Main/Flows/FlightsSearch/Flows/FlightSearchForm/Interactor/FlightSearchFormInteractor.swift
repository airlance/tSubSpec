import Foundation

// MARK: - FlightSearchFormInteractor implementation 

final class FlightSearchFormInteractor {

    // MARK: Properties

    weak var output: FlightSearchFormInteractorOutput?
    private let settingsManager: FlightSearchSettingsManagerProtocol

    // MARK: Initialization

    init(settingsManager: FlightSearchSettingsManagerProtocol) {
        self.settingsManager = settingsManager
    }
}

// MARK: - FlightSearchFormInteractorInput implementation

extension FlightSearchFormInteractor: FlightSearchFormInteractorInput {
    func obtainFromCountry() -> CountryModel? {
        settingsManager.loadFromCountry()
    }

    func obtainToCountry() -> CountryModel? {
        settingsManager.loadToCountry()
    }

    func obtainDate() -> Date? {
        settingsManager.loadDate()
    }

    func saveFromCountry(country: CountryModel) {
        settingsManager.saveFromCountry(country: country)
    }

    func saveToCountry(country: CountryModel) {
        settingsManager.saveToCountry(country: country)
    }

    func saveDate(date: Date) {
        settingsManager.saveDate(date: date)
    }
}
