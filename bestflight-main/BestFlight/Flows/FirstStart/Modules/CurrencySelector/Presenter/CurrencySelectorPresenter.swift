import Foundation

// MARK: - CurrencySelectorPresenter implementation

final class CurrencySelectorPresenter {

    // MARK: Properties

    weak var view: CurrencySelectorViewInput?
    private let interactor: CurrencySelectorInteractorInput
    private let moduleOutput: CurrencySelectorModuleOutput 
    private let settings: CurrencySelectorSettings
    private let textManager: CurrencySelectorTextManagerProtocol

    // MARK: Items

    private var models: [CurrencyModel] = []
    private var selectedItem: MarketCurrencyViewModel?

    // MARK: Initializers

    init(
        moduleOutput: CurrencySelectorModuleOutput,
        interactor: CurrencySelectorInteractorInput,
        settings: CurrencySelectorSettings,
        textManager: CurrencySelectorTextManagerProtocol
    ) {
        self.interactor = interactor
        self.moduleOutput = moduleOutput
        self.settings = settings
        self.textManager = textManager
        if let model = settings.selectedModel {
            selectedItem = MarketCurrencyViewModel(with: model, selected: false)
        }
    }
}

// MARK: - CurrencySelectorPresenter helpers

private extension CurrencySelectorPresenter {
    private func showModels(models: [CurrencyModel]) {
        let items = models.map {
            MarketCurrencyViewModel(
                with: $0,
                selected: $0.code == selectedItem?.identifier
            )
        }
        view?.showItems(items: items)
    }

    private func modelFrom(viewModel: MarketCurrencyViewModel?) -> CurrencyModel? {
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

// MARK: - CurrencySelectorInteractorOutput implementation

extension CurrencySelectorPresenter: CurrencySelectorInteractorOutput {
    func didObtainCurrencies(currencies: [CurrencyModel]) {
        models = currencies.sorted(by: { $0.code < $1.code })
        DispatchQueue.main.async {
            self.view?.hideLoading()
            self.view?.endRefreshing()
            self.showModels(models: self.models)
        }
    }

    func didNotObtainCurrencies(with error: NetworkError) {
        DispatchQueue.main.async {
            self.view?.hideLoading()
            self.view?.endRefreshing()
            self.handleError(error: error)
        }
    }
}

// MARK: - CurrencySelectorViewOutput implemenetation

extension CurrencySelectorPresenter: CurrencySelectorViewOutput {

    func viewIsReady() {
        selectedItem != nil ? view?.setContinueButtonEnabled() : view?.setContinueButtonDisabled()
        view?.showLoading()
        interactor.obtainCurrencies()
    }

    func shouldRefresh() {
        interactor.obtainCurrencies()
    }

    func didSelectCurrency(model: MarketCurrencyViewModel) {
        if selectedItem?.identifier == model.identifier {
            selectedItem = nil
            view?.setContinueButtonDisabled()
        } else {
            selectedItem = model
            view?.setContinueButtonEnabled()
        }
        showModels(models: models)
        moduleOutput.didCurrencySelectorSelectCurrency(model: modelFrom(viewModel: selectedItem))
    }

    func didContinueButtonPress() {
        guard let model = modelFrom(viewModel: selectedItem) else {
            return
        }
        moduleOutput.didCurrencySelectorFinish(model: model)
    }
}

// MARK: - CurrencySelectorModuleInput implementation

extension CurrencySelectorPresenter: CurrencySelectorModuleInput {
}
