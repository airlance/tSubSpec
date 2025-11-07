import Foundation

// MARK: - CountrySelectorPresenter implementation

final class CountrySelectorPresenter {

    // MARK: Properties

    weak var view: CountrySelectorViewInput?
    private let interactor: CountrySelectorInteractorInput
    private let moduleOutput: CountrySelectorModuleOutput 
    private let settings: CountrySelectorSettings
    private let textManager: CountrySelectorTextManagerProtocol

    // MARK: Items

    private var models: [MarketCountryModel] = []
    private var selectedItem: MarketCountryViewModel?

    // MARK: Initializers

    init(
        moduleOutput: CountrySelectorModuleOutput,
        interactor: CountrySelectorInteractorInput,
        settings: CountrySelectorSettings,
        textManager: CountrySelectorTextManagerProtocol
    ) {
        self.interactor = interactor
        self.moduleOutput = moduleOutput
        self.settings = settings
        self.textManager = textManager
        if let selectedModel = settings.selectedModel {
            selectedItem = MarketCountryViewModel(with: selectedModel, selected: false)
        }
    }
}

// MARK: - CountrySelectorPresenter helpers

private extension CountrySelectorPresenter {
    private func showModels(models: [MarketCountryModel]) {
        let items = models.map {
            MarketCountryViewModel(
                with: $0,
                selected: $0.code == selectedItem?.identifier
            )
        }
        view?.showItems(items: items)
    }

    private func modelFrom(viewModel: MarketCountryViewModel?) -> MarketCountryModel? {
        guard let viewModel = viewModel else {
            return nil
        }
        return models.first { $0.code == viewModel.identifier }
    }

    private func handleError(error: NetworkError) {
        let errorText: String
        switch error {
        case .custom(_, let message):
            errorText = message
        case .emptyData, .failedDataDecoding, .invalidParameters, .invalidRequest:
            errorText = textManager.defaultErrorText
        }
        view?.showError(title: textManager.errorTitleText, text: errorText, actionText: textManager.okText)
    }
}

// MARK: - CountrySelectorInteractorOutput implementation

extension CountrySelectorPresenter: CountrySelectorInteractorOutput {
    func didObtainCountries(countries: [MarketCountryModel]) {
        models = countries.sorted(by: { $0.name < $1.name })
        DispatchQueue.main.async {
            self.view?.hideLoading()
            self.view?.endRefreshing()
            self.showModels(models: self.models)
        }
    }

    func didNotObtainCountries(with error: NetworkError) {
        DispatchQueue.main.async {
            self.view?.hideLoading()
            self.view?.endRefreshing()
            self.handleError(error: error)
        }
    }
}

// MARK: - CountrySelectorViewOutput implemenetation

extension CountrySelectorPresenter: CountrySelectorViewOutput {
    func viewIsReady() {
        selectedItem != nil ? view?.setContinueButtonEnabled() : view?.setContinueButtonDisabled()
        view?.showLoading()
        interactor.obtainCountries()
    }
    func shouldRefresh() {
        interactor.obtainCountries()
    }
    func didSelectCountry(model: MarketCountryViewModel) {
        if selectedItem?.identifier == model.identifier {
            selectedItem = nil
            view?.setContinueButtonDisabled()
        } else {
            selectedItem = model
            view?.setContinueButtonEnabled()
        }
        showModels(models: models)
        moduleOutput.didCountrySelectorSelectCountry(model: modelFrom(viewModel: selectedItem))
    }
    func didContinueButtonPress() {
        guard let model = modelFrom(viewModel: selectedItem) else {
            return
        }
        moduleOutput.didCountrySelectorFinish(model: model)
    }
}

// MARK: - CountrySelectorModuleInput implementation

extension CountrySelectorPresenter: CountrySelectorModuleInput {
}
