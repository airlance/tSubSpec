import Foundation

class MainCoordinatorAssembly {
    static func assembly(output: MainCoordinatorOutput, languageService: LanguagesServiceProtocol) -> MainCoordinator {
        let textManager = MainCoordinatorTextManager(languageService: languageService)
        let coordinator = MainCoordinator(output: output, textManager: textManager)

        textManager.observer = coordinator
        return coordinator
    }
}
