import Foundation


/// Describes possible network request methods
enum NetworkRequestMethod: String {
    case GET
    case POST
}

/// Describes network path
struct NetworkRequest {
    var path: String
    var method: NetworkRequestMethod
    var params: [String: Any]?
}
