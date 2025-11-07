import UIKit

final class CurrencySelectorAssembly {

    static func assemble(settings: CurrencySelectorSettings) -> UIViewController {
        let textManager = CurrencySelectorTextManager(languageService: settings.languagesService)
        let interactor = CurrencySelectorInteractor(
            localisationService: settings.localisationService
        )

        let presenter = CurrencySelectorPresenter(
            moduleOutput: settings.moduleOutput,
            interactor: interactor,
            settings: settings,
            textManager: textManager
        )
        
        let view = CurrencySelectorViewController(
            presenter: presenter,
            textManager: textManager
        )
        
        presenter.view = view
        interactor.output = presenter
        textManager.observer = view
        
        return view
    }
}
