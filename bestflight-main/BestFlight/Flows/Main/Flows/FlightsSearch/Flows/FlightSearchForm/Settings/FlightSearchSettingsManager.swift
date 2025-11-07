import Foundation

class FlightSearchSettingsManager {

    // MARK: Declarations

    var prefix: String { "searchForm" }
    enum SettingKey: String {
        case fromCountry
        case toCountry
        case date
    }

    // MARK: Properties

    private let settingsService: SettingsServiceProtocol

    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        return encoder
    }()

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    // MARK: Initialization

    init(settingsService: SettingsServiceProtocol) {
        self.settingsService = settingsService
    }
}

// MARK: - FlightSearchSettingsManagerProtocol implementation

extension FlightSearchSettingsManager: FlightSearchSettingsManagerProtocol {
    func saveFromCountry(country: CountryModel) {
        let key = obtainKey(from: SettingKey.fromCountry.rawValue)
        guard let data = try? encoder.encode(country) else {
            return
        }
        settingsService.setValue(for: key, value: data)
    }

    func saveToCountry(country: CountryModel) {
        let key = obtainKey(from: SettingKey.toCountry.rawValue)
        guard let data = try? encoder.encode(country) else {
            return
        }
        settingsService.setValue(for: key, value: data)
    }

    func saveDate(date: Date) {
        let key = obtainKey(from: SettingKey.date.rawValue)
        settingsService.setValue(for: key, value: date)
    }

    func loadFromCountry() -> CountryModel? {
        let key = obtainKey(from: SettingKey.fromCountry.rawValue)
        guard
            let data = settingsService.getValue(for: key) as? Data,
            let model = try? decoder.decode(CountryModel.self, from: data)
        else {
            return nil
        }
        return model
    }

    func loadToCountry() -> CountryModel? {
        let key = obtainKey(from: SettingKey.toCountry.rawValue)
        guard
            let data = settingsService.getValue(for: key) as? Data,
            let model = try? decoder.decode(CountryModel.self, from: data)
        else {
            return nil
        }
        return model
    }

    func loadDate() -> Date? {
        let key = obtainKey(from: SettingKey.date.rawValue)
        return settingsService.getValue(for: key) as? Date
    }


}
