import Foundation

protocol MainPreferencesModuleInput: class {
    func shouldUpdate()
    func userSettingsUpdated(userSettings: UserSettingsModel)
}
