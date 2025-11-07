import Foundation

protocol PlaceSelectorInteractorOutput: class {
    func didObtainPlaces(places: GeographyResponseModel)
    func didNotObtainPlaces(with error: NetworkError)
}
