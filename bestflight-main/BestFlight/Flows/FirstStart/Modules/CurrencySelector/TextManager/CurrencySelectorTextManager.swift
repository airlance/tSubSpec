import Foundation

class CurrencySelectorTextManager: BaseTextManager {

    // MARK: Initialization

    override init(languageService: LanguagesServiceProtocol) {
        super.init(languageService: languageService)
    }
}

extension CurrencySelectorTextManager: CurrencySelectorTextManagerProtocol {
    var title: String {
        localizedString(key: "currencySelectorTitle")
    }

    var continueButton: String {
        localizedString(key: "continueButton")
    }
}
