import Foundation

// MARK: - MainPreferencesPresenter implementation

final class MainPreferencesPresenter {

    // MARK: Properties

    weak var view: MainPreferencesViewInput?
    private let moduleOutput: MainPreferencesModuleOutput 
    private let settings: MainPreferencesSettings
    private var userSettings: UserSettingsModel

    // MARK: Initializers

    init(
        moduleOutput: MainPreferencesModuleOutput,
        settings: MainPreferencesSettings
    ) {
        self.moduleOutput = moduleOutput
        self.settings = settings
        self.userSettings = settings.userSettings
    }

    private func showItems() {
        view?.showItems(items: [
            .contry(currentCountry: userSettings.country.name),
            .currency(currentCurrency: userSettings.currency.code)
        ])
    }
}

// MARK: - MainPreferencesViewOutput implemenetation

extension MainPreferencesPresenter: MainPreferencesViewOutput {
    func didSelect(cellType: MainPreferencesCellType) {
        switch cellType {
        case .language:
            moduleOutput.didFinishMainPreferencesLanguage()
        case .contry:
            moduleOutput.didFinishMainPreferencesCountry()
        case .currency:
            moduleOutput.didFinishMainPreferencesCurrency()
        }
    }

    func viewIsReady() {
        showItems()
    }
}

// MARK: - MainPreferencesModuleInput implementation

extension MainPreferencesPresenter: MainPreferencesModuleInput {
    func userSettingsUpdated(userSettings: UserSettingsModel) {
        self.userSettings = userSettings
        showItems()
    }

    func shouldUpdate() {
        showItems()
    }
}
