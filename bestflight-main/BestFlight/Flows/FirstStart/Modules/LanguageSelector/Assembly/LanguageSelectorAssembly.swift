import UIKit

final class LanguageSelectorAssembly {

    static func assemble(settings: LanguageSelectorSettings) -> UIViewController {
        let languagesService = LanguagesService.shared
        let textManager = LanguageSelectorTextManager(languageService: languagesService)
        let interactor = LanguageSelectorInteractor(
            languagesService: languagesService
        )

        let presenter = LanguageSelectorPresenter(
            moduleOutput: settings.moduleOutput,
            interactor: interactor,
            settings: settings
        )
        
        let view = LanguageSelectorViewController(
            presenter: presenter,
            textManager: textManager
        )
        
        presenter.view = view
        interactor.output = presenter
        textManager.observer = view
        
        return view
    }
}
