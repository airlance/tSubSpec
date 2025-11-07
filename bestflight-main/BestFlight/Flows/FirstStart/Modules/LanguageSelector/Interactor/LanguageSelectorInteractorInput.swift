import Foundation

protocol LanguageSelectorInteractorInput {
    func currentLanguage() -> LanguageModel
    func obtainLanguages() -> [LanguageModel]
    func setCurrentLanguage(language: LanguageModel)
}
