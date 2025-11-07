import Foundation

protocol LanguagesServiceProtocol: class {
    func setLanguage(from model: LanguageModel)
    func obtainLocalizedString(for key: String) -> String
    func obtainCurrentLanguage() -> LanguageModel
    func obtainLanguages() -> [LanguageModel]
}
