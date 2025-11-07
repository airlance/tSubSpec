import Foundation

// MARK: - PlaceSelectorInteractor implementation 

final class PlaceSelectorInteractor {

    // MARK: Properties

    weak var output: PlaceSelectorInteractorOutput?
    private let placesService: PlacesServiceProtocol

    // MARK: Initialization

    init(placesService: PlacesServiceProtocol) {
        self.placesService = placesService
    }
}

// MARK: - PlaceSelectorInteractorInput implementation

extension PlaceSelectorInteractor: PlaceSelectorInteractorInput {
    func obtainPlaces() {
        placesService.obtainGeography { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.output?.didObtainPlaces(places: response)
            case .failure(let error):
                self?.output?.didNotObtainPlaces(with: error)
            }
        }
    }
}
