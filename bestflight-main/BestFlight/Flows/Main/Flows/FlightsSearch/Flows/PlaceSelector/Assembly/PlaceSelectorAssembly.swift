import UIKit

final class PlaceSelectorAssembly {

    static func assemble(settings: PlaceSelectorSettings) -> UIViewController {
        let textManager = PlaceSelectorTextManager(languageService: settings.languagesService)
        let interactor = PlaceSelectorInteractor(
            placesService: settings.placesService
        )

        let presenter = PlaceSelectorPresenter(
            moduleOutput: settings.moduleOutput,
            interactor: interactor,
            settings: settings,
            textManager: textManager
        )
        
        let view = PlaceSelectorViewController(
            presenter: presenter,
            textManager: textManager
        )
        
        presenter.view = view
        interactor.output = presenter
        textManager.observer = view
        
        return view
    }
}
