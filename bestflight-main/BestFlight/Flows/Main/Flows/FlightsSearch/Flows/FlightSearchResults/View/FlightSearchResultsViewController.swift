import UIKit

// MARK: - FlightSearchResultsViewController implementation 

final class FlightSearchResultsViewController: UIViewController {

    // MARK: Appearance

    private struct Appearance {
        let backgroundColor: UIColor = .normalBackground
    }
    private let appearance = Appearance()

    // MARK: Properties

    private let presenter: FlightSearchResultsViewOutput
    private let textManager: FlightSearchResultsTextManagerProtocol
    private var items: [QuoteViewModel] = []

    // MARK: UI properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = appearance.backgroundColor
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellClass: QuoteTableViewCell.self)
        return tableView
    }()

    private lazy var loaderView: LoaderView = {
        let view = LoaderView(frame: .zero)
        return view
    }()

    // MARK: Life cycle

    init(presenter: FlightSearchResultsViewOutput, textManager: FlightSearchResultsTextManagerProtocol) {
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
        view.addSubview(tableView)
        view.addSubview(loaderView)
    }

    private func makeConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        loaderView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(LoaderView.defaultSize)
        }
    }
}

// MARK: - FlightSearchResultsViewInput implementation

extension FlightSearchResultsViewController: FlightSearchResultsViewInput {
    func setupInitialState() {
    }

    func showLoader() {
        loaderView.startAnimating()
    }

    func hideLoader() {
        loaderView.stopAnimating()
    }

    func showItems(items: [QuoteViewModel]) {
        self.items = items
        self.tableView.reloadData()
    }
}

// MARK: - LanguageObservable implementation

extension FlightSearchResultsViewController: LanguageObservable {
    func languageChanged() {
        title = textManager.title
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource implementation

extension FlightSearchResultsViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeue(cellClass: QuoteTableViewCell.self, forIndexPath: indexPath)
        cell.configure(
            with: QuoteTableViewCellContract(
                fromCaptionText: textManager.fromText,
                fromValueText: item.fromText,
                toCaptionText: textManager.toText,
                toValueText: item.toText,
                summaryText: item.summaryText,
                dateText: item.dateText
            )
        )
        cell.selectionStyle = .none
        return cell
    }
}
