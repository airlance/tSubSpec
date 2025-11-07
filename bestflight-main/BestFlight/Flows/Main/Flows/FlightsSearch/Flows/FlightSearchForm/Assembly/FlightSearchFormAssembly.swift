import UIKit

final class FlightSearchFormAssembly {

    static func assemble(settings: FlightSearchFormSettings) -> (view: UIViewController, input: FlightSearchFormModuleInput) {
        let settingsManager = FlightSearchSettingsManager(settingsService: settings.settingsService)
        let textManager = FlightSearchFormTextManager(languageService: settings.languagesService)

        let interactor = FlightSearchFormInteractor(
            settingsManager: settingsManager
        )

        let presenter = FlightSearchFormPresenter(
            moduleOutput: settings.moduleOutput,
            interactor: interactor,
            settings: settings,
            textManager: textManager
        )
        
        let view = FlightSearchFormViewController(
            presenter: presenter,
            textManager: textManager
        )

        presenter.view = view
        interactor.output = presenter
        textManager.observer = view
        
        return (view, presenter)
    }
}
