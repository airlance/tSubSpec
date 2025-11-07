import UIKit

protocol FlightsSearchCoordinatorInput: class {
    func startCoodinator(with userSettings: UserSettingsModel) -> UIViewController
    func didUserSettingsChanged(userSettings: UserSettingsModel)
}
