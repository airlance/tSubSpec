import Foundation

// MARK: - SettingsKeyProtocol declaration

protocol SettingsKeyProtocol: class {
    var prefix: String { get }
    func obtainKey(from rawKey: String) -> String
}

// MARK: - Protocol default implementation

extension SettingsKeyProtocol {
    func obtainKey(from rawKey: String) -> String {
        prefix + rawKey.firstUpperCased
    }
}
