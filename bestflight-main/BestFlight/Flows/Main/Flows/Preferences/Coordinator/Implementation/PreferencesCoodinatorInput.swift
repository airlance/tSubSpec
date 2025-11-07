import UIKit

protocol PreferencesCoodinatorInput {
    func startCoordinator(with userSettings: UserSettingsModel) -> UIViewController
}
