import Foundation

// MARK: - LanguageSelectorInteractor implementation 

final class LanguageSelectorInteractor {

    // MARK: Properties

    weak var output: LanguageSelectorInteractorOutput?
    var languagesService: LanguagesServiceProtocol

    init(languagesService: LanguagesServiceProtocol) {
        self.languagesService = languagesService
    }
}

// MARK: - LanguageSelectorInteractorInput implementation

extension LanguageSelectorInteractor: LanguageSelectorInteractorInput {
    func currentLanguage() -> LanguageModel {
        languagesService.obtainCurrentLanguage()
    }

    func obtainLanguages() -> [LanguageModel] {
        languagesService.obtainLanguages()
    }

    func setCurrentLanguage(language: LanguageModel) {
        languagesService.setLanguage(from: language)
    }
}
