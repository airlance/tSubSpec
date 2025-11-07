import Foundation

// MARK: - FlightSearchFormPresenter implementation

final class FlightSearchFormPresenter {

    // MARK: Declarations

    private enum PlaceSelectorContext {
        case none
        case from
        case to
    }

    // MARK: Appearance
    private struct Appearance {
        let dateFormat = "dd.MM.yyyy"
    }
    private let appearance = Appearance()

    // MARK: Properties

    weak var view: FlightSearchFormViewInput?
    private let interactor: FlightSearchFormInteractorInput
    private let moduleOutput: FlightSearchFormModuleOutput 
    private let settings: FlightSearchFormSettings
    private let textManager: FlightSearchFormTextManagerProtocol

    private var placeSelectorContext: PlaceSelectorContext = .none
    private var fromCountryModel: CountryModel?
    private var toCountryModel: CountryModel?
    private var date: Date?

    // MARK: Initializers

    init(
        moduleOutput: FlightSearchFormModuleOutput,
        interactor: FlightSearchFormInteractorInput,
        settings: FlightSearchFormSettings,
        textManager: FlightSearchFormTextManagerProtocol
    ) {
        self.interactor = interactor
        self.moduleOutput = moduleOutput
        self.settings = settings
        self.textManager = textManager
    }
}

// MARK: - FlightSearchFormPresenter private methods

private extension FlightSearchFormPresenter {
    private func updateUI() {
        var searchEnabled = true
        if let fromCountry = fromCountryModel {
            view?.setFromFieldText(fromCountry.name)
        } else {
            searchEnabled = false
            view?.setFromFieldText(textManager.fromPlaceholderText)
        }

        if let toCountry = toCountryModel {
            view?.setToFieldText(toCountry.name)
        } else {
            searchEnabled = false
            view?.setToFieldText(textManager.toPlaceholderText)
        }

        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = appearance.dateFormat
            view?.setDateFieldText(formatter.string(from: date))
        } else {
            view?.setDateFieldText(textManager.dateAnyText)
        }

        view?.setSearchButtonEnabled(searchEnabled)
    }
}

// MARK: - FlightSearchFormInteractorOutput implementation

extension FlightSearchFormPresenter: FlightSearchFormInteractorOutput {
}

// MARK: - FlightSearchFormViewOutput implemenetation

extension FlightSearchFormPresenter: FlightSearchFormViewOutput {
    func didFromFieldPressed() {
        placeSelectorContext = .from
        moduleOutput.didFlightSearchFormPlaceSelectorRequested()
    }

    func didToFieldPressed() {
        placeSelectorContext = .to
        moduleOutput.didFlightSearchFormPlaceSelectorRequested()
    }

    func didDatePicked(date: Date?) {
        if let date = date {
            self.interactor.saveDate(date: date)
        }
        self.date = date
        updateUI()
    }

    func didSearchButtonPressed() {
        guard
            let fromCountry = fromCountryModel,
            let toCountry = toCountryModel
        else {
            return
        }

        let contract = FlightSearchContract(
            fromCountry: fromCountry,
            toCountry: toCountry,
            date: date
        )
        moduleOutput.didFlightSearchFormSearchRequested(contract: contract)
    }

    func viewIsReady() {
        fromCountryModel = interactor.obtainFromCountry()
        toCountryModel = interactor.obtainToCountry()
        date = interactor.obtainDate()

        updateUI()
    }
}

// MARK: - FlightSearchFormModuleInput implementation

extension FlightSearchFormPresenter: FlightSearchFormModuleInput {
    func didPlaceSelectorSelectedPlace(countryModel: CountryModel) {

        // Prefilling contract models

        switch placeSelectorContext {
        case .from:
            fromCountryModel = countryModel
            interactor.saveFromCountry(country: countryModel)
        case .to:
            toCountryModel = countryModel
            interactor.saveToCountry(country: countryModel)
        case .none:
            // WTF???
            break
        }

        // Updating UI
        updateUI()
    }
}
