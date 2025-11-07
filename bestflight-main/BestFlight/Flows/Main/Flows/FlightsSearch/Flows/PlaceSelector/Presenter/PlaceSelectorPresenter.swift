import Foundation

// MARK: - PlaceSelectorPresenter implementation

final class PlaceSelectorPresenter {

    // MARK: Properties

    weak var view: PlaceSelectorViewInput?
    private let interactor: PlaceSelectorInteractorInput
    private let moduleOutput: PlaceSelectorModuleOutput 
    private let settings: PlaceSelectorSettings
    private let textManager: PlaceSelectorTextManagerProtocol
    private var countries: [CountryModel] = []
    private var viewModels: [PlaceCountryViewModel] = []
    private var filterQuery: String = ""

    // MARK: Initializers

    init(
        moduleOutput: PlaceSelectorModuleOutput,
        interactor: PlaceSelectorInteractorInput,
        settings: PlaceSelectorSettings,
        textManager: PlaceSelectorTextManagerProtocol
    ) {
        self.interactor = interactor
        self.moduleOutput = moduleOutput
        self.settings = settings
        self.textManager = textManager
    }
}

// MARK: - PlaceSelectorPresenter helpers

private extension PlaceSelectorPresenter {
    private func showItems() {
        let filtered = filterQuery.isEmpty ? viewModels : viewModels.filter { $0.name.contains(filterQuery) }
        view?.showPlaces(places: filtered)
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
            self.moduleOutput.didPlaceSelectorFinishWithClose()
        })
    }
}

// MARK: - PlaceSelectorInteractorOutput implementation

extension PlaceSelectorPresenter: PlaceSelectorInteractorOutput {
    func didObtainPlaces(places: GeographyResponseModel) {
        let countries = places.continents.reduce([]) { $0 + $1.countries }
        let viewModels = countries.lazy
            .sorted { $0.name < $1.name }
            .map { PlaceCountryViewModel(with: $0) }

        self.countries = countries
        self.viewModels = viewModels

        DispatchQueue.main.async {
            self.view?.hideLoading()
            self.showItems()
        }
    }

    func didNotObtainPlaces(with error: NetworkError) {
        DispatchQueue.main.async {
            self.view?.hideLoading()
            self.handleError(error: error)
        }
    }
}

// MARK: - PlaceSelectorViewOutput implemenetation

extension PlaceSelectorPresenter: PlaceSelectorViewOutput {
    func viewIsReady() {
        view?.setSearchFocus()
        view?.showLoading()
        interactor.obtainPlaces()
    }

    func didClosePressed() {
        moduleOutput.didPlaceSelectorFinishWithClose()
    }

    func didSelectPlace(viewModel: PlaceCountryViewModel) {
        guard let model = countries.first(where: { $0.id == viewModel.identifier }) else {
            return
        }
        moduleOutput.didPlaceSelectorFinishWithCountryModel(model)
    }

    func didSearchFieldChanged(_ text: String) {
        filterQuery = text
        showItems()
    }
}

// MARK: - PlaceSelectorModuleInput implementation

extension PlaceSelectorPresenter: PlaceSelectorModuleInput {
}
