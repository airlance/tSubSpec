import Foundation

protocol PreferencesCoordinatorOutput: class {
    func didChangeUserSettings(userSettings: UserSettingsModel)
}
