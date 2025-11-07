import UIKit

final class InitialAssembly {

    static func assemble(settings: InitialSettings) -> UIViewController {
        let languageService = settings.languagesService
        let textManager = InitialTextManager(languageService: languageService)
        let interactor = InitialInteractor()

        let presenter = InitialPresenter(
            moduleOutput: settings.moduleOutput,
            interactor: interactor,
            settings: settings
        )
        
        let view = InitialViewController(
            presenter: presenter,
            textManager: textManager
        )
        
        presenter.view = view
        interactor.output = presenter
        textManager.observer = view
        
        return view
    }
}
