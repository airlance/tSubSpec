import Foundation

protocol LanguageObservable: class {
    func languageChanged()
}

protocol BaseTextManagerInput: class {
    func currentLanguage() -> LanguageModel
}

class BaseTextManager {

    // MARK: Properties

    weak var observer: LanguageObservable?
    private let languagesService: LanguagesServiceProtocol

    // MARK: Initialization

    init(languageService: LanguagesServiceProtocol) {
        self.languagesService = languageService
        subscribeLanguageChanged()
    }

    private func subscribeLanguageChanged() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(languageChanged),
            name: LanguagesService.languageChangedNotification,
            object: nil
        )
    }

    @objc private func languageChanged() {
        observer?.languageChanged()
    }

    // MARK: Helper methods

    func localizedString(key: String) -> String {
        languagesService.obtainLocalizedString(for: key)
    }

}

// MARK: - BaseTextManagerProtocol implementation

extension BaseTextManager: BaseTextManagerProtocol {
    var okText: String {
        localizedString(key: "okText")
    }

    var errorTitleText: String {
        localizedString(key: "errorTitleText")
    }

    var defaultErrorText: String {
        localizedString(key: "defaultErrorText")
    }
}

// MARK: - BaseTextManagerInput implementation

extension BaseTextManager: BaseTextManagerInput {
    func currentLanguage() -> LanguageModel {
        languagesService.obtainCurrentLanguage()
    }
}
