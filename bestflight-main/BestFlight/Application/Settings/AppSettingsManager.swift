import Foundation

// MARK: - AppSettingsManager implementation

class AppSettingsManager {

    // MARK: Declarations

    var prefix: String { "application" }
    enum SettingKey: String {
        case firstStart
        case userSettings
    }

    // MARK: Properties

    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        return encoder
    }()

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    private let settingsService: SettingsServiceProtocol

    // MARK: Initialization

    init(settingsService: SettingsServiceProtocol) {
        self.settingsService = settingsService
    }
}

// MARK: - AppSettingsManagerProtocol implementation

extension AppSettingsManager: AppSettingsManagerProtocol {
    func setApplicationUserSettings(_ settings: UserSettingsModel) {
        let key = obtainKey(from: SettingKey.userSettings.rawValue)
        guard let data = try? encoder.encode(settings) else {
            return
        }
        settingsService.setValue(for: key, value: data)
    }

    func getApplicationUserSettings() -> UserSettingsModel? {
        let key = obtainKey(from: SettingKey.userSettings.rawValue)
        guard
            let data = settingsService.getValue(for: key) as? Data,
            let model = try? decoder.decode(UserSettingsModel.self, from: data)
        else {
            return nil
        }
        return model
    }
}
