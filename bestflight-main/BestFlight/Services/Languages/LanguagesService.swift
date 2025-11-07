import UIKit

// MARK: - LanguageService implementation

class LanguagesService {

    // MARK: Declarations

    static let languageKey = "language"
    static let languageChangedNotification = Notification.Name(rawValue: "LanguageChangedNotification")

    // MARK: Properties

    static var shared: LanguagesService { return LanguagesService() }
    var currentLanguage = LanguageModel()
    private let notificationCenter: NotificationCenter = {
        NotificationCenter.default
    }()

    // MARK: Initialization

    init() {
        currentLanguage = loadCurrentLanguage()
    }

    // MARK: Private methods

    private func languageModel(with id: String) -> LanguageModel {
        LanguageModel(
            identifier: id,
            title: loadTitleForLanguageIdentifier(id)
        )
    }

    private func loadCurrentLanguage() -> LanguageModel {
        let defaults = UserDefaults.standard
        let currentLanguageId: String
        if let languageKey = defaults.value(forKey: LanguagesService.languageKey) as? String {
            currentLanguageId = languageKey
        } else {
            currentLanguageId = Bundle.main.preferredLocalizations[0]
        }
        let model = languageModel(with: currentLanguageId)
        return model
    }

    private func saveCurrentLanguageIdentifier(_ identifier: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(identifier, forKey: LanguagesService.languageKey)
    }

    private func keyForLanguageIdentifier(_ identifier: String) -> String {
        return "language_\(identifier)"
    }

    private func loadTitleForLanguageIdentifier(_ identifier: String) -> String {
        let languageKey = keyForLanguageIdentifier(identifier)
        return Bundle.main.localizedString(forKey: languageKey, value: nil, table: nil)
    }

    private func signalLanguageWasChanged() {
        let notification = Notification(name: LanguagesService.languageChangedNotification)
        notificationCenter.post(notification)
    }
}

// MARK: - LanguagesServiceProtocol implementation

extension LanguagesService: LanguagesServiceProtocol {
    func setLanguage(from model: LanguageModel) {
        guard model != currentLanguage else {
            return
        }
        currentLanguage = model
        saveCurrentLanguageIdentifier(model.identifier)
        signalLanguageWasChanged()
    }

    func obtainLocalizedString(for key: String) -> String {
        guard
            let path = Bundle.main.path(forResource: currentLanguage.identifier, ofType: "lproj"),
            let bundle = Bundle(path: path)
        else {
            return key
        }
        return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
    }

    func obtainCurrentLanguage() -> LanguageModel {
        return self.currentLanguage
    }

    func obtainLanguages() -> [LanguageModel] {
        Bundle.main.localizations.compactMap {
            guard $0 != "Base" else {
                return nil
            }
            return languageModel(with: $0)
        }
    }
}
