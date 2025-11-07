import Foundation

protocol FlightSearchFormTextManagerProtocol: BaseTextManagerInput {
    var doneButton: String { get }
    var cancelButton: String { get }
    var title: String { get }
    var fromText: String { get }
    var fromPlaceholderText: String { get }
    var toText: String { get }
    var toPlaceholderText: String { get }
    var datePickerTitleText: String { get }
    var dateText: String { get }
    var dateAnyText: String { get }
    var searchButtonText: String { get }
}
