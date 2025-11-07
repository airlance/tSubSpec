import Foundation

class Utils {

    /// Returns application's display name
    static var applicationDisplayName: String {
        (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? ""
    }
}
