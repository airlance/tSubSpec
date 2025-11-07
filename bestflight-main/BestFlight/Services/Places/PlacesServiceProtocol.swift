import Foundation

protocol PlacesServiceProtocol: class {
    func obtainGeography(completion: @escaping (Result<GeographyResponseModel, NetworkError>) -> Void)
}
