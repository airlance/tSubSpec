import UIKit

protocol MainCoordinatorInput: class {
    func startCoordinator(with userSettings: UserSettingsModel) -> UIViewController
    func didUserSettingsChanged(userSettings: UserSettingsModel)
}
