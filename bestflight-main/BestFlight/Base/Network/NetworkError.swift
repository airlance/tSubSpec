import Foundation

/// Describes network error model

enum NetworkError: Error {
    case invalidRequest
    case invalidParameters(description: String)
    case emptyData
    case failedDataDecoding(description: String)
    case custom(code: Int, message: String)
}
