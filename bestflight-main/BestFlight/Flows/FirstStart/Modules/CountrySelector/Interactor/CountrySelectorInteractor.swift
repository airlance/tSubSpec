import Foundation

// MARK: - CountrySelectorInteractor implementation 

final class CountrySelectorInteractor {

    // MARK: Properties

    weak var output: CountrySelectorInteractorOutput?
    private let languagesService: LanguagesServiceProtocol
    private let localisationService: LocalisationServiceProtocol

    // MARK: Initialization

    init(localisationService: LocalisationServiceProtocol, languagesService: LanguagesServiceProtocol) {
        self.localisationService = localisationService
        self.languagesService = languagesService
    }
}

// MARK: - CountrySelectorInteractorInput implementation

extension CountrySelectorInteractor: CountrySelectorInteractorInput {
    func obtainCountries() {
        let contract = MarketCountriesContract(locale: languagesService.obtainCurrentLanguage().identifier)
        localisationService.obtainCountries(contract: contract) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.output?.didObtainCountries(countries: response.countries)
            case .failure(let error):
                self?.output?.didNotObtainCountries(with: error)
            }
        }
    }
}
