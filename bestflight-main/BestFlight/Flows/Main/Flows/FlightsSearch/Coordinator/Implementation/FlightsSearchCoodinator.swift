import UIKit

final class FlightsSearchCoodinator {

    // MARK: Properties

    private weak var output: FlightsSearchCoordinatorOutput?
    private var navigation: NavigationController?
    private var userSettings: UserSettingsModel?

    private var searchFormInput: FlightSearchFormModuleInput?

    // MARK: Initialization

    init(output: FlightsSearchCoordinatorOutput) {
        self.output = output
    }
}

// MARK: - FlightsSearchCoordinator private methods

private extension FlightsSearchCoodinator {
    func buildFirstModule() -> UIViewController {
        createView(with: .searchForm)
    }

    func createView(with type: FlightSearchModules) -> UIViewController {
        switch type {

        case .searchForm:
            let languagesService = ServiceBuilder.service(type: LanguagesService.self)
            let settingsService = ServiceBuilder.service(type: SettingsService.self)
            let settings = FlightSearchFormSettings(
                moduleOutput: self,
                languagesService: languagesService,
                settingsService: settingsService
            )
            let module = FlightSearchFormAssembly.assemble(settings: settings)
            searchFormInput = module.input
            return module.view

        case .searchResults(let contract):
            guard let userSettings = userSettings else {
                fatalError("User settings is not valid. Check coordinator's starting. Should start with valid user settings model")
            }
            let flightsService = ServiceBuilder.service(type: FlightsService.self)
            let languagesService = ServiceBuilder.service(type: LanguagesService.self)
            let settings = FlightSearchResultsSettings(
                moduleOutput: self,
                contract: contract,
                userSettings: userSettings,
                languagesService: languagesService,
                flightsService: flightsService
            )
            let view = FlightSearchResultsAssembly.assemble(settings: settings)
            return view

        case .placeSelector:
            let placesService = ServiceBuilder.service(type: PlacesService.self)
            let languagesService = ServiceBuilder.service(type: LanguagesService.self)
            let settings = PlaceSelectorSettings(
                moduleOutput: self,
                placesService: placesService,
                languagesService: languagesService
            )
            let view = PlaceSelectorAssembly.assemble(settings: settings)
            return view
        }
    }
}

// MARK: - FlightsSearchCoordinatorInput implementation

extension FlightsSearchCoodinator: FlightsSearchCoordinatorInput {

    func startCoodinator(with userSettings: UserSettingsModel) -> UIViewController {
        let view = buildFirstModule()
        let navigation = NavigationController(rootViewController: view)
        self.navigation = navigation
        self.userSettings = userSettings
        return navigation
    }

    func didUserSettingsChanged(userSettings: UserSettingsModel) {
        self.userSettings = userSettings
        // ... notify all inner module inputs to update user settings
    }
}

// MARK: - FlightSearchFormModuleOutput implementation

extension FlightsSearchCoodinator: FlightSearchFormModuleOutput {
    func didFlightSearchFormSearchRequested(contract: FlightSearchContract) {
        let view = createView(with: .searchResults(contract: contract))
        view.hidesBottomBarWhenPushed = true
        navigation?.pushViewController(view, animated: true)
    }

    func didFlightSearchFormPlaceSelectorRequested() {
        let view = createView(with: .placeSelector)
        let nav = NavigationController(rootViewController: view)
        navigation?.present(nav, animated: true, completion: nil)
    }
}

// MARK: - FlightSearchResultsModuleOutput implementation

extension FlightsSearchCoodinator: FlightSearchResultsModuleOutput {
    func didFinishFlightSearchResultWithClose() {
        let _ = navigation?.popViewController(animated: true)
    }
}

// MARK: - PlaceSelectorModuleOutput implementation

extension FlightsSearchCoodinator: PlaceSelectorModuleOutput {
    func didPlaceSelectorFinishWithClose() {
        navigation?.dismiss(animated: true, completion: nil)
    }
    func didPlaceSelectorFinishWithCountryModel(_ countryModel: CountryModel) {
        searchFormInput?.didPlaceSelectorSelectedPlace(countryModel: countryModel)
        navigation?.dismiss(animated: true, completion: nil)
    }
}
