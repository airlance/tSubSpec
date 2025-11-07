import UIKit

final class PreferencesCoordinator {

    // MARK: Properties

    private weak var output: PreferencesCoordinatorOutput?
    private var navigation: NavigationController?
    private var userSettings: UserSettingsModel?

    // MARK: Module inputs

    weak var mainPreferencesModuleInput: MainPreferencesModuleInput?

    // MARK: Initialization

    init(output: PreferencesCoordinatorOutput) {
        self.output = output
    }
}

// MARK: - PreferencesCoordinator private methods

private extension PreferencesCoordinator {

    func buildFirstModule() -> UIViewController {
        createView(with: .preferencesList)
    }

    func createView(with type: PreferencesModules) -> UIViewController {
        switch type {
        case .preferencesList:
            guard let userSettings = userSettings else {
                fatalError("User settings is unavailable")
            }
            let languagesService = ServiceBuilder.service(type: LanguagesService.self)
            let settings = MainPreferencesSettings(moduleOutput: self, languagesService: languagesService, userSettings: userSettings)
            let module = MainPreferencesAssembly.assemble(settings: settings)
            mainPreferencesModuleInput = module.input
            return module.view
        case .language:
            let settings = LanguageSelectorSettings(moduleOutput: self)
            let view = LanguageSelectorAssembly.assemble(settings: settings)
            return view
        case .currency:
            let languagesService = ServiceBuilder.service(type: LanguagesService.self)
            let localisationService = ServiceBuilder.service(type: LocalisationService.self)
            let settings = CurrencySelectorSettings(
                moduleOutput: self,
                languagesService: languagesService,
                localisationService: localisationService,
                selectedModel: userSettings?.currency
            )
            let view = CurrencySelectorAssembly.assemble(settings: settings)
            return view
        case .country:
            let languagesService = ServiceBuilder.service(type: LanguagesService.self)
            let localisationService = ServiceBuilder.service(type: LocalisationService.self)
            let settings = CountrySelectorSettings(
                moduleOutput: self,
                languagesService: languagesService,
                localisationService: localisationService,
                selectedModel: userSettings?.country
            )
            let view = CountrySelectorAssembly.assemble(settings: settings)
            return view
        }
    }
}

// MARK: - PreferencesCoodinatorInput implementation

extension PreferencesCoordinator: PreferencesCoodinatorInput {

    func startCoordinator(with userSettings: UserSettingsModel) -> UIViewController {
        self.userSettings = userSettings
        let view = buildFirstModule()
        let navigation = NavigationController(rootViewController: view)
        self.navigation = navigation
        return navigation
    }
    
}

// MARK: - MainPreferencesModuleOutput implementation

extension PreferencesCoordinator: MainPreferencesModuleOutput {
    func didFinishMainPreferencesLanguage() {
        let view = createView(with: .language)
        view.hidesBottomBarWhenPushed = true
        navigation?.pushViewController(view, animated: true)
    }

    func didFinishMainPreferencesCountry() {
        let view = createView(with: .country)
        view.hidesBottomBarWhenPushed = true
        navigation?.pushViewController(view, animated: true)
    }

    func didFinishMainPreferencesCurrency() {
        let view = createView(with: .currency)
        view.hidesBottomBarWhenPushed = true
        navigation?.pushViewController(view, animated: true)
    }

}

// MARK: - LanguageSelectorModuleOutput implementation

extension PreferencesCoordinator: LanguageSelectorModuleOutput {
    func didFinishLanguageSelector() {
        // let _ = navigation?.popViewController(animated: true)
        // mainPreferencesModuleInput?.shouldUpdate()
    }
}

// MARK: - CurrencySelectorModuleOutput implementation

extension PreferencesCoordinator: CurrencySelectorModuleOutput {
    func didCurrencySelectorFinish(model: CurrencyModel) {
        guard var settings = userSettings else {
            return
        }
        settings.currency = model
        userSettings = settings
        output?.didChangeUserSettings(userSettings: settings)
        mainPreferencesModuleInput?.userSettingsUpdated(userSettings: settings)
        let _ = navigation?.popViewController(animated: true)
    }

    func didCurrencySelectorSelectCurrency(model: CurrencyModel?) {
        // Non permanent selection is not interesting
    }
}

// MARK: - CountrySelectorModuleOutput implementation

extension PreferencesCoordinator: CountrySelectorModuleOutput {
    func didCountrySelectorSelectCountry(model: MarketCountryModel?) {
        // Non permanent selection is not interesting
    }

    func didCountrySelectorFinish(model: MarketCountryModel) {
        guard var settings = userSettings else {
            return
        }
        settings.country = model
        userSettings = settings
        output?.didChangeUserSettings(userSettings: settings)
        mainPreferencesModuleInput?.userSettingsUpdated(userSettings: settings)
        let _ = navigation?.popViewController(animated: true)
    }
}
