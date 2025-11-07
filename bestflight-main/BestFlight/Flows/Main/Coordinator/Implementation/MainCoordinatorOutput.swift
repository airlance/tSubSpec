import Foundation

protocol MainCoordinatorOutput: class {
    func didChangeUserSettings(userSettings: UserSettingsModel)
}
