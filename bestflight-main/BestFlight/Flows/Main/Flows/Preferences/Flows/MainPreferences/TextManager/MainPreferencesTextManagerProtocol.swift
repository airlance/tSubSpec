import Foundation

protocol MainPreferencesTextManagerProtocol: class {
    var title: String { get }

    var preferencesLanguage: String { get }
    var preferencesCountry: String { get }
    var preferencesCurrency: String { get }
}
