import Foundation

struct NetworkAPI {

    // MARK: Initialization

    init(host: String, key: String) {
        self.apiAddress = host
        self.apiKey = key
    }

    // MARK: Properties

    var apiAddress: String
    var apiKey: String
}
