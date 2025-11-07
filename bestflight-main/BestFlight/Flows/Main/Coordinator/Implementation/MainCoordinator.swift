import UIKit

// MARK: - MainCoordinator implementation

class MainCoordinator {

    // MARK: Declarations

    enum TabItem: CaseIterable {
        case flightSearch
        case preferences
    }

    // MARK: Appearance
    private struct Appearance {
        let flightSearchImage = UIImage.Tabs.flightSearchTab
        let preferencesImage = UIImage.Tabs.preferencesTab
    }
    private let appearance = Appearance()

    // MARK: Properties

    private let textManager: MainCoordinatorTextManagerProtocol
    private weak var output: MainCoordinatorOutput?
    private var tabController: UITabBarController?
    private var userSettings: UserSettingsModel?
    private var tabItems: [TabItem: UIViewController] = [:]

    // MARK: Child flows

    private lazy var flightsSearchCoordinator: FlightsSearchCoordinatorInput = {
        FlightsSearchCoodinatorAssembly.assembly(output: self)
    }()

    private lazy var preferencesCoordinator: PreferencesCoodinatorInput = {
        PreferencesCoodinatorAssembly.assembly(output: self)
    }()

    // MARK: Initialization

    init(output: MainCoordinatorOutput, textManager: MainCoordinatorTextManagerProtocol) {
        self.output = output
        self.textManager = textManager
    }
}

// MARK: - MainCoordinator private methods

private extension MainCoordinator {

}

// MARK: - MainCoordinatorInput implementation

extension MainCoordinator: MainCoordinatorInput {
    func didUserSettingsChanged(userSettings: UserSettingsModel) {
        self.userSettings = userSettings
        flightsSearchCoordinator.didUserSettingsChanged(userSettings: userSettings)
    }

    func startCoordinator(with userSettings: UserSettingsModel) -> UIViewController {

        // User settings

        self.userSettings = userSettings

        // Target flows

        let flighsSearchFlow = flightsSearchCoordinator.startCoodinator(with: userSettings)
        let preferencesFlow = preferencesCoordinator.startCoordinator(with: userSettings)

        // Making tab bar items

        tabItems = [
            .flightSearch: flighsSearchFlow,
            .preferences: preferencesFlow
        ]

        // Building tab bar controller

        let tabController = UITabBarController(nibName: nil, bundle: nil)
        self.tabController = tabController
        tabController.viewControllers = TabItem.allCases.compactMap { tabItems[$0] }
        self.languageChanged()

        return tabController
    }
}

// MARK: - LanguageObservable implementation

extension MainCoordinator: LanguageObservable {
    func languageChanged() {
        tabItems.forEach { (pair) in
            switch pair.key {
            case .flightSearch:
                pair.value.tabBarItem.image = appearance.flightSearchImage
                pair.value.tabBarItem.title = textManager.flightSearchText
            case .preferences:
                pair.value.tabBarItem.image = appearance.preferencesImage
                pair.value.tabBarItem.title = textManager.preferencesText
            }
        }
    }
}

// MARK: - FlightsSearchCoordinatorOutput implementation

extension MainCoordinator: FlightsSearchCoordinatorOutput {

}

// MARK: - PreferencesCoordinatorOutput implementation

extension MainCoordinator: PreferencesCoordinatorOutput {
    func didChangeUserSettings(userSettings: UserSettingsModel) {
        output?.didChangeUserSettings(userSettings: userSettings)
        flightsSearchCoordinator.didUserSettingsChanged(userSettings: userSettings)
    }
}

