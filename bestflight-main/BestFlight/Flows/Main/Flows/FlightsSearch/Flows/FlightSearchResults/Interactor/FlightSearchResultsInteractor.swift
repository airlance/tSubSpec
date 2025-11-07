import Foundation

// MARK: - FlightSearchResultsInteractor implementation 

final class FlightSearchResultsInteractor {

    // MARK: Properties

    weak var output: FlightSearchResultsInteractorOutput?
    private let languagesService: LanguagesServiceProtocol
    private let flightsService: FlightsServiceProtocol

    // MARK: Initialization

    init(flightsService: FlightsServiceProtocol, languagesService: LanguagesServiceProtocol) {
        self.flightsService = flightsService
        self.languagesService = languagesService
    }
}

// MARK: - FlightSearchResultsInteractorInput implementation

extension FlightSearchResultsInteractor: FlightSearchResultsInteractorInput {
    func obtainSearchResults(with contract: FlightSearchContract, userSettings: UserSettingsModel) {
        let quotesContract = QuotesContract(
            marketCountry: userSettings.country,
            marketCurrency: userSettings.currency,
            language: languagesService.obtainCurrentLanguage(),
            fromCountry: contract.fromCountry,
            toCountry: contract.toCountry,
            date: contract.date
        )
        flightsService.obtainQuotes(contract: quotesContract) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.output?.didObtainQuotes(model: response)
                
            case .failure(let error):
                self?.output?.didNotObtainQuotes(with: error)
            }
        }
    }
}
