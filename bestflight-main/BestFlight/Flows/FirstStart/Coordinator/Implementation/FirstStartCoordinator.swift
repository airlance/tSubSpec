import UIKit

// MARK: - FirstStartCoordinator implementation

final class FirstStartCoordinator {

    // MARK: Properties

    private weak var output: FirstStartCoordinatorOutput?
    private var navigation: NavigationController?

    // MARK: Stored properties from flow modules

    private var selectedCountry: MarketCountryModel?
    private var selectedCurrency: CurrencyModel?

    // MARK: Initialization

    init(output: FirstStartCoordinatorOutput) {
        self.output = output
    }

}

// MARK: - FirstStartCoordinator private helpers

private extension FirstStartCoordinator {
    private func buildFirstModule() -> UIViewController {
        createView(module: .languageSelector)
    }

    private func createView(module: FirstStartModules) -> UIViewController {
        switch module {
        case .languageSelector:
            let settings = LanguageSelectorSettings(moduleOutput: self)
            let view = LanguageSelectorAssembly.assemble(settings: settings)
            return view
        case .initial:
            let languagesService = ServiceBuilder.service(type: LanguagesService.self)
            let settings = InitialSettings(
                moduleOutput: self,
                languagesService: languagesService
            )
            let view = InitialAssembly.assemble(settings: settings)
            return view
        case .countrySelector:
            let localisationService = ServiceBuilder.service(type: LocalisationService.self)
            let languagesService = ServiceBuilder.service(type: LanguagesService.self)
            let settings = CountrySelectorSettings(
                moduleOutput: self,
                languagesService: languagesService,
                localisationService: localisationService,
                selectedModel: selectedCountry
            )
            let view = CountrySelectorAssembly.assemble(settings: settings)
            return view
        case .currencySelector:
            let localisationService = ServiceBuilder.service(type: LocalisationService.self)
            let languagesService = ServiceBuilder.service(type: LanguagesService.self)
            let settings = CurrencySelectorSettings(
                moduleOutput: self,
                languagesService: languagesService,
                localisationService: localisationService,
                selectedModel: selectedCurrency
            )
            let view = CurrencySelectorAssembly.assemble(settings: settings)
            return view
        }
    }
}

// MARK: - FirstStartCoordinatorInput implementation

extension FirstStartCoordinator: FirstStartCoordinatorInput {
    func startCoordinator() -> UIViewController {
        let view = buildFirstModule()
        let navigation = NavigationController(rootViewController: view)
        self.navigation = navigation
        return navigation
    }

    private func finishCoordinator() {
        guard
            let country = selectedCountry,
            let currency = selectedCurrency
        else {
            fatalError("FirstStartCoordinator complete incorrectly")
        }
        let contract = FirstStartCoordinatorCompletionContract(
            country: country,
            currency: currency
        )
        output?.didFistStartFlowCompleted(contract: contract)
    }
}

// MARK: - CurrencySelectorModuleOutput

extension FirstStartCoordinator: CurrencySelectorModuleOutput {
    func didCurrencySelectorFinish(model: CurrencyModel) {
        finishCoordinator()
    }

    func didCurrencySelectorSelectCurrency(model: CurrencyModel?) {
        selectedCurrency = model
    }
}

// MARK: - CountrySelectorModuleOutput

extension FirstStartCoordinator: CountrySelectorModuleOutput {
    func didCountrySelectorFinish(model: MarketCountryModel) {
        let view = createView(module: .currencySelector)
        navigation?.pushViewController(view, animated: true)
    }

    func didCountrySelectorSelectCountry(model: MarketCountryModel?) {
        selectedCountry = model
    }
}

// MARK: - InitialModuleOutput implementation

extension FirstStartCoordinator: InitialModuleOutput {
    func didFinishInitialWithContinue() {
        let view = createView(module: .countrySelector)
        navigation?.pushViewController(view, animated: true)
    }
}

// MARK: - LanguageSelectorModuleOutput implementation

extension FirstStartCoordinator: LanguageSelectorModuleOutput {
    func didFinishLanguageSelector() {
        let view = createView(module: .initial)
        navigation?.pushViewController(view, animated: true)
    }
}

