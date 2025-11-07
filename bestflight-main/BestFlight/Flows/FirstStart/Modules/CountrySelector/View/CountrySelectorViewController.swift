import UIKit

// MARK: - CountrySelectorViewController implementation 

final class CountrySelectorViewController: SelectorViewController {

    // MARK: Properties

    private let presenter: CountrySelectorViewOutput
    private let textManager: CountrySelectorTextManagerProtocol
    private var items: [MarketCountryViewModel] = []

    // MARK: Lifecycle

    init(presenter: CountrySelectorViewOutput, textManager: CountrySelectorTextManagerProtocol) {
        self.presenter = presenter
        self.textManager = textManager
        super.init(presenter: presenter)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        languageChanged()
        presenter.viewIsReady()
    }

    override func setupTableView(for tableView: UITableView) {
        super.setupTableView(for: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellClass: CountryTableViewCell.self)
    }
}

extension CountrySelectorViewController: LanguageObservable {
    func languageChanged() {
        title = textManager.title
        continueButton.setTitle(textManager.continueButton, for: .normal)
    }
}

// MARK: - CountrySelectorViewInput implementation

extension CountrySelectorViewController: CountrySelectorViewInput {
    func showItems(items: [MarketCountryViewModel]) {
        self.items = items
        self.tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource implementation

extension CountrySelectorViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeue(cellClass: CountryTableViewCell.self, forIndexPath: indexPath)
        let contract = CountryTableViewCellContract(
            checked: item.selected,
            title: item.title
        )
        cell.selectionStyle = .none
        cell.configure(with: contract)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        presenter.didSelectCountry(model: item)
    }
}
