import Foundation

// MARK: - CurrencySelectorInteractor implementation 

final class CurrencySelectorInteractor {

    // MARK: Properties

    weak var output: CurrencySelectorInteractorOutput?
    private let localisationService: LocalisationServiceProtocol

    // MARK: Initialization

    init(localisationService: LocalisationServiceProtocol) {
        self.localisationService = localisationService
    }
}

// MARK: - CurrencySelectorInteractorInput implementation

extension CurrencySelectorInteractor: CurrencySelectorInteractorInput {
    func obtainCurrencies() {
        localisationService.obtainCurrencies { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.output?.didObtainCurrencies(currencies: response.currencies)
            case .failure(let error):
                self?.output?.didNotObtainCurrencies(with: error)
            }
        }
    }
}
