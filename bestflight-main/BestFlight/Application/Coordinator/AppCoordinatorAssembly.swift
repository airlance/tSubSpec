import UIKit

final class AppCoordinatorAssembly {

    static func assembly(for window: UIWindow?) -> AppCoordinator {
        guard let window = window else {
            fatalError("Failed to start application - UIWindow reference is undefined")
        }
        let settingsService = SettingsService()
        let appSettingsManager = AppSettingsManager(settingsService: settingsService)
        let coordinator = AppCoordinator(with: window, settings: appSettingsManager)
        return coordinator
    }

}
