import UIKit

final class FlightSearchResultsAssembly {

    static func assemble(settings: FlightSearchResultsSettings) -> UIViewController {
        let textManager = FlightSearchResultsTextManager(
            languageService: settings.languagesService
        )
        let interactor = FlightSearchResultsInteractor(
            flightsService: settings.flightsService,
            languagesService: settings.languagesService
        )

        let presenter = FlightSearchResultsPresenter(
            moduleOutput: settings.moduleOutput,
            interactor: interactor,
            settings: settings,
            textManager: textManager
        )
        
        let view = FlightSearchResultsViewController(
            presenter: presenter,
            textManager: textManager
        )
        
        presenter.view = view
        interactor.output = presenter
        textManager.observer = view
        
        return view
    }
}
