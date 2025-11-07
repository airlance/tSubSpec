import Foundation

final class MainCoordinatorTextManager: BaseTextManager {
}

extension MainCoordinatorTextManager: MainCoordinatorTextManagerProtocol {
    var flightSearchText: String {
        localizedString(key: "flightSearchTabText")
    }

    var preferencesText: String {
        localizedString(key: "preferencesTabText")
    }
}
