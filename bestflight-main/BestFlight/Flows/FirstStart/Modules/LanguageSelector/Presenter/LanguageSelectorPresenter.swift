import Foundation

// MARK: - LanguageSelectorPresenter implementation

final class LanguageSelectorPresenter {

    // MARK: Properties

    weak var view: LanguageSelectorViewInput?
    private let interactor: LanguageSelectorInteractorInput
    private let moduleOutput: LanguageSelectorModuleOutput 
    private let settings: LanguageSelectorSettings

    // MARK: Initializers

    init(
        moduleOutput: LanguageSelectorModuleOutput,
        interactor: LanguageSelectorInteractorInput,
        settings: LanguageSelectorSettings
    ) {
        self.interactor = interactor
        self.moduleOutput = moduleOutput
        self.settings = settings
    }

    // MARK: Private helpers

    private func resetLanguagesView() {
        let currentLanguage = interactor.currentLanguage()
        let languages = interactor.obtainLanguages().map {
            LanguageViewModel(
                title: $0.title,
                identifier: $0.identifier,
                selected: currentLanguage == $0
            )
        }
        view?.showLanguages(languages)
    }
}

// MARK: - LanguageSelectorInteractorOutput implementation

extension LanguageSelectorPresenter: LanguageSelectorInteractorOutput {
    func viewIsReady() {
        resetLanguagesView()
    }

    func didPressLanguage(with identifier: String) {
        guard let language = interactor.obtainLanguages().first(where: { $0.identifier == identifier }) else {
            return
        }
        interactor.setCurrentLanguage(language: language)
        resetLanguagesView()
    }

    func didPressContinue() {
        moduleOutput.didFinishLanguageSelector()
    }
}

// MARK: - LanguageSelectorViewOutput implemenetation

extension LanguageSelectorPresenter: LanguageSelectorViewOutput {
}

// MARK: - LanguageSelectorModuleInput implementation

extension LanguageSelectorPresenter: LanguageSelectorModuleInput {
}
