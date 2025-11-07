import Foundation

protocol SettingsServiceProtocol: class {
    func setValue(for key: String, value: Any?)
    func getValue(for key: String) -> Any?
}
