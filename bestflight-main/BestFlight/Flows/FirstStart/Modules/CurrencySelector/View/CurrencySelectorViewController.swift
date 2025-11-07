import UIKit

// MARK: - CurrencySelectorViewController implementation

final class CurrencySelectorViewController: SelectorViewController {

    // MARK: Properties

    private let presenter: CurrencySelectorViewOutput
    private let textManager: CurrencySelectorTextManagerProtocol
    private var items: [MarketCurrencyViewModel] = []

    // MARK: Lifecycle

    init(presenter: CurrencySelectorViewOutput, textManager: CurrencySelectorTextManagerProtocol) {
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
        tableView.register(cellClass: CurrencyTableViewCell.self)
    }
}

extension CurrencySelectorViewController: CurrencySelectorViewInput {
    func showItems(items: [MarketCurrencyViewModel]) {
        self.items = items
        tableView.reloadData()
    }}

// MARK: - LanguageObservable implementation

extension CurrencySelectorViewController: LanguageObservable {
    func languageChanged() {
        title = textManager.title
        continueButton.setTitle(textManager.continueButton, for: .normal)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource implementation

extension CurrencySelectorViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeue(cellClass: CurrencyTableViewCell.self, forIndexPath: indexPath)
        let contract = CurrencyTableViewCellContract(
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
        presenter.didSelectCurrency(model: item)
    }
}
