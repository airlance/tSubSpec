import Foundation

struct LanguageModel: Equatable {
    let identifier: String
    let title: String

    init() {
        identifier = ""
        title = ""
    }

    init(identifier: String, title: String) {
        self.identifier = identifier
        self.title = title
    }

    var localeIdentifier: String {
        identifier.replacingOccurrences(of: "-", with: "_")
    }
}
