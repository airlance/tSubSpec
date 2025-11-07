import Foundation

protocol NetworkServiceProtocol {
    func makeRequest<T: Decodable>(type: T.Type, api: NetworkService.API, request: NetworkRequest, completion: @escaping (Result<T, NetworkError>) -> Void)
    func makeRequest<T: Decodable>(type: T.Type, request: NetworkRequest, completion: @escaping (Result<T, NetworkError>) -> Void)
}
