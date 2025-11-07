import Foundation

protocol AppSettingsManagerProtocol: SettingsKeyProtocol {
    func setApplicationUserSettings(_ settings: UserSettingsModel)
    func getApplicationUserSettings() -> UserSettingsModel?
}
