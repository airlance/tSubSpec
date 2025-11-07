import UIKit

final class CountrySelectorAssembly {

    static func assemble(settings: CountrySelectorSettings) -> UIViewController {
        let languageService = settings.languagesService
        let textManager = CountrySelectorTextManager(languageService: languageService)
        let interactor = CountrySelectorInteractor(
            localisationService: settings.localisationService,
            languagesService: languageService
        )

        let presenter = CountrySelectorPresenter(
            moduleOutput: settings.moduleOutput,
            interactor: interactor,
            settings: settings,
            textManager: textManager
        )
        
        let view = CountrySelectorViewController(
            presenter: presenter,
            textManager: textManager
        )
        
        presenter.view = view
        interactor.output = presenter
        textManager.observer = view
        
        return view
    }
}
