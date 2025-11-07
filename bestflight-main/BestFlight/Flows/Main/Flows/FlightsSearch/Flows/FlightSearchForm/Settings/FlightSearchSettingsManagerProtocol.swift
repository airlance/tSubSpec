import Foundation

protocol FlightSearchSettingsManagerProtocol: SettingsKeyProtocol {
    func saveFromCountry(country: CountryModel)
    func saveToCountry(country: CountryModel)
    func saveDate(date: Date)
    func loadFromCountry() -> CountryModel?
    func loadToCountry() -> CountryModel?
    func loadDate() -> Date?
}
