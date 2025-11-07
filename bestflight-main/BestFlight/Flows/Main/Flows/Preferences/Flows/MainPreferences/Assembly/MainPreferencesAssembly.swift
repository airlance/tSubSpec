import UIKit

final class MainPreferencesAssembly {

    static func assemble(settings: MainPreferencesSettings) -> (view: UIViewController, input: MainPreferencesModuleInput) {
        let textManager = MainPreferencesTextManager(languageService: settings.languagesService)

        let presenter = MainPreferencesPresenter(
            moduleOutput: settings.moduleOutput,
            settings: settings
        )
        
        let view = MainPreferencesViewController(
            presenter: presenter,
            textManager: textManager
        )
        
        presenter.view = view
        textManager.observer = view
        
        return (view, presenter)
    }
}
