import Foundation

// MARK: - FlightSearchResultsPresenter implementation

final class FlightSearchResultsPresenter {

    // MARK: Properties

    weak var view: FlightSearchResultsViewInput?
    private let interactor: FlightSearchResultsInteractorInput
    private let moduleOutput: FlightSearchResultsModuleOutput 
    private let settings: FlightSearchResultsSettings
    private let textManager: FlightSearchResultsTextManagerProtocol
    private let contract: FlightSearchContract

    // MARK: Initializers

    init(
        moduleOutput: FlightSearchResultsModuleOutput,
        interactor: FlightSearchResultsInteractorInput,
        settings: FlightSearchResultsSettings,
        textManager: FlightSearchResultsTextManagerProtocol
    ) {
        self.interactor = interactor
        self.moduleOutput = moduleOutput
        self.settings = settings
        self.textManager = textManager
        self.contract = settings.contract
    }

    private func handleError(error: NetworkError) {
        let errorText: String
        switch error {
        case .custom(_, let message):
            errorText = message
        case .emptyData, .failedDataDecoding, .invalidParameters, .invalidRequest:
            errorText = textManager.defaultErrorText
        }
        view?.showError(title: textManager.errorTitleText, text: errorText, actionText: textManager.okText, actionHandler: {
            self.moduleOutput.didFinishFlightSearchResultWithClose()
        })
    }
}

// MARK: - FlightSearchResultsInteractorOutput implementation

extension FlightSearchResultsPresenter: FlightSearchResultsInteractorOutput {
    func didObtainQuotes(model: QuotesResponseModel) {
        // Remaping places model into dictionary with placeId -> place
        // Complexity is O(N), but in next map operations it will take O(1)
        let places: [Int: QuotePlaceModel] = Dictionary(uniqueKeysWithValues: model.places.map {($0.placeId, $0)} )
        let carriers: [Int: QuoteCarrierModel] = Dictionary(uniqueKeysWithValues: model.carriers.map {($0.carrierId, $0)} )

        // Mapping quote models into view models
        let viewModels = model.quotes.compactMap { (quote) -> QuoteViewModel? in
            guard
                let sourcePlace = places[quote.outboundLeg.originId],
                let destinationPlace = places[quote.outboundLeg.destinationId]
            else {
                return nil
            }
            let targetCarriers = quote.outboundLeg.carrierIds.compactMap { carriers[$0] }
            return QuoteViewModel(
                from: quote,
                sourcePlace: sourcePlace,
                place: destinationPlace,
                carriers: targetCarriers,
                currency: settings.userSettings.currency
            )
        }

        DispatchQueue.main.async {
            self.view?.hideLoader()
            self.view?.showItems(items: viewModels)
        }
    }

    func didNotObtainQuotes(with error: NetworkError) {
        DispatchQueue.main.async {
            self.view?.hideLoader()
            self.handleError(error: error)
        }
    }
}

// MARK: - FlightSearchResultsViewOutput implemenetation

extension FlightSearchResultsPresenter: FlightSearchResultsViewOutput {
    func viewIsReady() {
        view?.showLoader()
        interactor.obtainSearchResults(
            with: contract,
            userSettings: settings.userSettings
        )
    }
}

// MARK: - FlightSearchResultsModuleInput implementation

extension FlightSearchResultsPresenter: FlightSearchResultsModuleInput {
}
