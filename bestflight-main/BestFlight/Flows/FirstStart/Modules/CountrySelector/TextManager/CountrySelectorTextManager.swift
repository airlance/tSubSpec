import Foundation

class CountrySelectorTextManager: BaseTextManager {

    // MARK: Initialization

    override init(languageService: LanguagesServiceProtocol) {
        super.init(languageService: languageService)
    }
}

extension CountrySelectorTextManager: CountrySelectorTextManagerProtocol {
    var title: String {
        localizedString(key: "countrySelectorTitle")
    }

    var continueButton: String {
        localizedString(key: "continueButton")
    }
}
