import Foundation

class MainPreferencesTextManager: BaseTextManager {
}

// MARK: - MainPreferencesTextManagerProtocol implementation

extension MainPreferencesTextManager: MainPreferencesTextManagerProtocol {
    var preferencesLanguage: String {
        localizedString(key: "preferencesLanguage")
    }

    var preferencesCountry: String {
        localizedString(key: "preferencesCountry")
    }

    var preferencesCurrency: String {
        localizedString(key: "preferencesCurrency")
    }

    var title: String {
        localizedString(key: "preferencesTitle")
    }
}
