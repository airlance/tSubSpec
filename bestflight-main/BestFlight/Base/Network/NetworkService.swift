import Foundation

// MARK: - NetworkService implementation

class NetworkService {

    // MARK: Declarations

    enum API {
        case standard

        var networkApi: NetworkAPI {
            switch self {
            case .standard:
                return NetworkAPI(
                    host: "https://partners.api.skyscanner.net/apiservices/",
                    key: "prtl6749387986743898559646983194"
                )
            }
        }
    }

    static let memoryCacheSize = 1 * 1024 * 1024 // 1 MBs
    static let diskCacheSize = 20 * 1024 * 1024 // 20 MBs

    // MARK: Properties

    private lazy var session: URLSession = {
        let urlCache = URLCache(
            memoryCapacity: NetworkService.memoryCacheSize,
            diskCapacity: NetworkService.diskCacheSize,
            diskPath: nil
        )
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataDontLoad
        configuration.urlCache = urlCache
        let session = URLSession(configuration: configuration)
        return session
    }()

    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    private func buildURL(from api: NetworkAPI, and request: NetworkRequest) -> URL? {
        let url: URL?
        switch request.method {
        case .GET:
            var components = URLComponents(string: api.apiAddress + request.path)
            components?.queryItems = []
            request.params?.forEach { (pair) in
                guard let value = pair.value as? String else {
                    return
                }
                components?.queryItems?.append(URLQueryItem(name: pair.key, value: value))
            }
            url = components?.url
        default:
            url = URL(string: api.apiAddress + request.path)
        }
        return url
    }
}

// MARK: - NetworkServiceProtocol implementation

extension NetworkService: NetworkServiceProtocol {

    func makeRequest<T: Decodable>(type: T.Type, request: NetworkRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        makeRequest(type: type, api: .standard, request: request, completion: completion)
    }

    func makeRequest<T: Decodable>(type: T.Type, api: API, request: NetworkRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {

        // Injecting apiKey into request parameters
        var request = request
        if request.params == nil { request.params = [:] }
        request.params?["apiKey"] = api.networkApi.apiKey

        // Building url for request
        guard let url = buildURL(from: api.networkApi, and: request) else {
            completion(.failure(.invalidRequest))
            return
        }


        var taskRequest = URLRequest(url: url)
        taskRequest.cachePolicy = .returnCacheDataElseLoad
        taskRequest.httpMethod = request.method.rawValue
        taskRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        switch request.method {
        case .POST:
            if let params = request.params {
                do {
                    taskRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                } catch let error {
                    completion(.failure(.invalidParameters(description: error.localizedDescription)))
                    return
                }
            }
        default:
            break
        }

        let task = session.dataTask(with: taskRequest) { [weak self] (data, response, error) in
            guard let self = self else { return }

            // Networking stack error
            if let error = error {
                completion(.failure(.custom(code: 0, message: error.localizedDescription)))
                return
            }

            // No data
            guard let data = data else  {
                completion(.failure(.emptyData))
                return
            }

            // Checking backend error is received
            if let errorModel = try? self.jsonDecoder.decode(NetworkErrorResponse.self, from: data){
                completion(.failure(.custom(code: errorModel.code, message: errorModel.message)))
                return
            }

            // Everything is good. Expecting required model
            do {
                let model = try self.jsonDecoder.decode(type, from: data)
                completion(.success(model))
            } catch let exception {
                completion(.failure(.failedDataDecoding(description: exception.localizedDescription)))
            }
        }
        task.resume()
    }
}
