import Foundation

protocol FlightSearchFormInteractorInput {
    func obtainFromCountry() -> CountryModel?
    func obtainToCountry() -> CountryModel?
    func obtainDate() -> Date?
    func saveFromCountry(country: CountryModel)
    func saveToCountry(country: CountryModel)
    func saveDate(date: Date)
}
