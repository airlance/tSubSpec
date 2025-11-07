import Foundation

protocol InitialTextManagerProtocol: class {
    var welcomeText: String { get }
    var welcomeDescriptionText: String { get }
    var continueButton: String { get }
}
