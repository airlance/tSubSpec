import Foundation

final class PlacesService: BaseNetworkService {

    // MARK: Declarations

    enum Endpoint: String {
        case geo = "geo/v1.0/"
    }
}

extension PlacesService: PlacesServiceProtocol {
    func obtainGeography(completion: @escaping (Result<GeographyResponseModel, NetworkError>) -> Void) {
        let request = NetworkRequest(
            path: Endpoint.geo.rawValue,
            method: .GET,
            params: nil
        )

        networkService.makeRequest(type: GeographyResponseModel.self, request: request) { (result) in
            switch result {
            case .success(let geography):
                completion(.success(geography))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
