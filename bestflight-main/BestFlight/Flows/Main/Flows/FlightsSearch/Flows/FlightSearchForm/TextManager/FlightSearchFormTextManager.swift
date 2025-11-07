import Foundation

final class FlightSearchFormTextManager: BaseTextManager {
}

extension FlightSearchFormTextManager: FlightSearchFormTextManagerProtocol {
    var doneButton: String {
        localizedString(key: "doneButton")
    }

    var cancelButton: String {
        localizedString(key: "cancelButton")
    }

    var fromPlaceholderText: String {
        localizedString(key: "fromLPlaceholderText")
    }

    var toPlaceholderText: String {
        localizedString(key: "toPlaceholderText")
    }

    var datePickerTitleText: String {
        localizedString(key: "datePickerTitleText")
    }

    var dateAnyText: String {
        localizedString(key: "dateAnyText")
    }

    var fromText: String {
        localizedString(key: "fromText")
    }

    var toText: String {
        localizedString(key: "toText")
    }

    var dateText: String {
        localizedString(key: "dateText")
    }

    var title: String {
        localizedString(key: "flightSearchTabText")
    }

    var searchButtonText: String {
        localizedString(key: "searchButtonText")
    }
}


