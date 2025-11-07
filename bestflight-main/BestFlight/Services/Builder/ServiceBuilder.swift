import Foundation

class ServiceBuilder {

    // MARK: Fabric methods

    static func service<T>(type: T.Type) -> T {
        let networkService = NetworkService()
        let someService: T?
        switch type {
        case is PlacesService.Type:
            someService = PlacesService(networkService: networkService) as? T
        case is LocalisationService.Type:
            someService = LocalisationService(networkService: networkService) as? T
        case is LanguagesService.Type:
            someService = LanguagesService.shared as? T
        case is FlightsService.Type:
            someService = FlightsService(networkService: networkService) as? T
        case is SettingsService.Type:
            someService = SettingsService() as? T
        default:
            someService = nil
        }
        guard let targetService = someService else {
            fatalError("Unexpected service type")
        }
        return targetService
    }

}
