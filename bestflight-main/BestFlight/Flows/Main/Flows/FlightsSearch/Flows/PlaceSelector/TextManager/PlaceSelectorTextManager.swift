import Foundation

final class PlaceSelectorTextManager: BaseTextManager {
}

extension PlaceSelectorTextManager: PlaceSelectorTextManagerProtocol {
    var searchPlaceholderText: String {
        localizedString(key: "searchCountryPlaceholderText")
    }
}
