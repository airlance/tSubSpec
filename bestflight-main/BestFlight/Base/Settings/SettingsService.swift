import Foundation

// MARK: - SettingsService implementation

/// Incapsulates settings service subsystem
/// - Note: In future userDefaults may be replaced with another user preferences storage subsystem (i.e. with database)
class SettingsService {

    // MARK: Properties

    private lazy var userDefaults: UserDefaults = {
        UserDefaults.standard
    }()
}

// MARK: - SettingsServiceProtocol implementation

extension SettingsService: SettingsServiceProtocol {
    func getValue(for key: String) -> Any? {
        userDefaults.value(forKey: key)
    }

    func setValue(for key: String, value: Any?) {
        userDefaults.set(value, forKey: key)
    }
}
