import Foundation

protocol MainPreferencesModuleOutput: class {
    func didFinishMainPreferencesLanguage()
    func didFinishMainPreferencesCountry()
    func didFinishMainPreferencesCurrency()
}
