import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties

    private var coordinator: AppCoordinator?
    var window: UIWindow?

    // MARK: Lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureWindow()
        return true
    }

    private func configureWindow() {
        let coreWindow = UIWindow(frame: UIScreen.main.bounds)
        coordinator = AppCoordinatorAssembly.assembly(for: coreWindow)
        coordinator?.startApplication()
        window = coreWindow
    }
}

