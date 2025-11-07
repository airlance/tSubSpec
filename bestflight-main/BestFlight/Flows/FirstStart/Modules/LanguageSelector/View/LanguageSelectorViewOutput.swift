import Foundation

protocol LanguageSelectorViewOutput {
    func viewIsReady()
    func didPressLanguage(with identifier: String)
    func didPressContinue()
}
