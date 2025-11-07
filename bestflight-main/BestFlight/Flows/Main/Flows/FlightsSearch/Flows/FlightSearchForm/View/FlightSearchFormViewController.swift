import UIKit
import DatePickerDialog

// MARK: - FlightSearchFormViewController implementation 

final class FlightSearchFormViewController: UIViewController {

    // MARK: Appearance
    private struct Appearance {
        let backgroundColor: UIColor = .normalBackground
    }
    private let appearance = Appearance()

    // MARK: Properties

    private let textManager: FlightSearchFormTextManagerProtocol
    private let presenter: FlightSearchFormViewOutput

    // MARK: UI properties

    private lazy var searchView: SearchFormView = {
        let view = SearchFormView(frame: .zero)
        view.delegate = self
        return view
    }()

    // MARK: Life cycle

    init(presenter: FlightSearchFormViewOutput, textManager: FlightSearchFormTextManagerProtocol) {
        self.presenter = presenter
        self.textManager = textManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        languageChanged()
        presenter.viewIsReady()
    }

    private func setupUI() {
        view.backgroundColor = appearance.backgroundColor
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        view.addSubview(searchView)
    }

    private func makeConstraints() {
        searchView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - FlightSearchFormViewInput implementation

extension FlightSearchFormViewController: FlightSearchFormViewInput {
    func setFromFieldText(_ text: String) {
        searchView.setFromFieldText(text)
    }

    func setToFieldText(_ text: String) {
        searchView.setToFieldText(text)
    }

    func setDateFieldText(_ text: String) {
        searchView.setDateFieldText(text)
    }

    func setSearchButtonEnabled(_ enabled: Bool) {
        searchView.setSearchButtonEnabled(enabled)
    }

    func setupInitialState() {
    }
}

// MARK: - LanguageObservable implementation

extension FlightSearchFormViewController: LanguageObservable {
    func languageChanged() {
        title = textManager.title
        searchView.setDateText(textManager.dateText)
        searchView.setFromText(textManager.fromText)
        searchView.setToText(textManager.toText)
        searchView.setSearchButtonText(textManager.searchButtonText)
    }
}

// MARK: - SearchFormViewDelegate implementation

extension FlightSearchFormViewController: SearchFormViewDelegate {
    func didFromFieldActivated(view: SearchFormView) {
        presenter.didFromFieldPressed()
    }

    func didToFieldActivated(view: SearchFormView) {
        presenter.didToFieldPressed()
    }

    func didDateFieldActivated(view: SearchFormView) {
        let currentDate = Date()
        let picker = DatePickerDialog(locale: Locale(identifier: textManager.currentLanguage().localeIdentifier))
        picker.show(
            textManager.datePickerTitleText,
            doneButtonTitle: textManager.doneButton,
            cancelButtonTitle: textManager.cancelButton,
            defaultDate: currentDate,
            minimumDate: currentDate,
            maximumDate: nil,
            datePickerMode: .date
        ) { [weak self] (selectedDate) in
            self?.presenter.didDatePicked(date: selectedDate)
        }
    }

    func didSearchButtonPress(view: SearchFormView) {
        presenter.didSearchButtonPressed()
    }
}
