import Foundation

// MARK: - LanguageSelectorTextManager implementation

class LanguageSelectorTextManager: BaseTextManager {

    // MARK: Initialization

    override init(languageService: LanguagesServiceProtocol) {
        super.init(languageService: languageService)
    }

}

// MARK: - LanguageSelectorTextManagerProtocol implementation

extension LanguageSelectorTextManager: LanguageSelectorTextManagerProtocol {

    var selectLanguageText: String {
        localizedString(key: "selectLanguage")
    }

    var selectLanguageDescriptionText: String {
        localizedString(key: "selectLanguageDescription")
    }

    var continueButton: String {
        localizedString(key: "continueButton")
    }

}
