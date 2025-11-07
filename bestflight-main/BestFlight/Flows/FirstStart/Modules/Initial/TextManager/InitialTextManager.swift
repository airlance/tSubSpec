import Foundation

// MARK: - InitialTextManager implementation

class InitialTextManager: BaseTextManager {

    // MARK: Initialization

    override init(languageService: LanguagesServiceProtocol) {
        super.init(languageService: languageService)
    }

}

// MARK: - InitialTextManagerProtocol implementation

extension InitialTextManager: InitialTextManagerProtocol {
    var welcomeText: String {
        localizedString(key: "welcomeText")
    }

    var welcomeDescriptionText: String {
        localizedString(key: "welcomeDescriptionText")
    }

    var continueButton: String {
        localizedString(key: "continueButton")
    }
}
