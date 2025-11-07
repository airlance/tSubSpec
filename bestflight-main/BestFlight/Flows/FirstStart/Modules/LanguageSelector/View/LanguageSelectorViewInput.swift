import Foundation

protocol LanguageSelectorViewInput: class {
    func setupInitialState()
    func showLanguages(_ languages: [LanguageViewModel])
}
