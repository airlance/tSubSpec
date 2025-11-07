import UIKit

final class AppCoordinator {

    // MARK: Declarations

    enum LaunchMode {
        case undefined
        case firstStart
        case main
    }

    // MARK: Appearance
    private struct Appearance {
        let transitionDuration: TimeInterval = 0.3
    }
    private let appearance = Appearance()

    // MARK: Properties

    private var launchMode: LaunchMode = .undefined
    private let settingsManager: AppSettingsManagerProtocol
    private let window: UIWindow

    private var userSettings: UserSettingsModel?

    // MARK: Coordinators

    private lazy var firstStartFlow: FirstStartCoordinatorInput = {
        FirstStartCoordinatorAssembly.assembly(output: self)
    }()

    private lazy var mainFlow: MainCoordinatorInput = {
        MainCoordinatorAssembly.assembly(
            output: self,
            languageService: ServiceBuilder.service(type: LanguagesService.self)
        )
    }()

    // MARK: Initializers

    init(with window: UIWindow, settings: AppSettingsManagerProtocol) {
        self.window = window
        self.settingsManager = settings
        setupLaunchMode()
    }

    private func setupLaunchMode() {
        // Checking application is first launched
        // And have valid saved user settings
        // Else send to first start flow
        guard let userSettings = settingsManager.getApplicationUserSettings() else {
            launchMode = .firstStart
            return
        }

        // Everything alright, moving to main
        self.userSettings = userSettings
        launchMode = .main
    }

    // MARK: Public methods

    public func startApplication() {
        let module: UIViewController?
        switch launchMode {
        case .undefined:
            module = nil

        case .firstStart:
            // Starting flow
            module = firstStartFlow.startCoordinator()

        case .main:
            // Main flow only if user settings are correct
            // Elsewhere starting first start flow to
            if let userSettings = userSettings {
                module = mainFlow.startCoordinator(with: userSettings)
            } else {
                module = firstStartFlow.startCoordinator()
            }
        }
        guard let targetModule = module else {
            return
        }
        window.rootViewController = targetModule
        window.makeKeyAndVisible()
    }
}

// MARK: - FirstStartCoordinatorOutput implementation

extension AppCoordinator: FirstStartCoordinatorOutput {
    func didFistStartFlowCompleted(contract: FirstStartCoordinatorCompletionContract) {
        let userSettings = UserSettingsModel(
            country: contract.country,
            currency: contract.currency
        )

        // Saving settings into storage
        self.userSettings = userSettings
        self.settingsManager.setApplicationUserSettings(userSettings)

        // Moving to the next flow
        let mainView = mainFlow.startCoordinator(with: userSettings)
        window.rootViewController = mainView
        UIView.transition(
            with: window,
            duration: appearance.transitionDuration,
            options: .transitionFlipFromRight,
            animations: nil
        )
    }
}

// MARK: - MainCoordinatorOutput implementation

extension AppCoordinator: MainCoordinatorOutput {
    func didChangeUserSettings(userSettings: UserSettingsModel) {
        self.userSettings = userSettings
        self.settingsManager.setApplicationUserSettings(userSettings)
    }
}
