import UIKit

// MARK: - MainPreferencesViewController implementation 

final class MainPreferencesViewController: UIViewController {

    // MARK: Appearance

    struct Appearance {
        let backgroundColor: UIColor = .normalBackground
        let rowHeight: CGFloat = 60
    }
    private let appearance = Appearance()
    private var types: [MainPreferencesCellType] = []

    // MARK: Properties

    private let presenter: MainPreferencesViewOutput
    private let textManager: MainPreferencesTextManagerProtocol

    // MARK: UI properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = appearance.rowHeight
        tableView.register(cellClass: UITableViewCell.self)
        tableView.tableFooterView = UIView()
        return tableView
    }()

    // MARK: Life cycle

    init(presenter: MainPreferencesViewOutput, textManager: MainPreferencesTextManagerProtocol) {
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
    }

    private func makeConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottomMargin.equalToSuperview()
        }
    }

}

// MARK: - MainPreferencesViewInput implementation

extension MainPreferencesViewController: MainPreferencesViewInput {
    func setupInitialState() {
    }

    func showItems(items: [MainPreferencesCellType]) {
        self.types = items
        self.tableView.reloadData()
    }
}

// MARK: - LanguageObservable implementation

extension MainPreferencesViewController: LanguageObservable {
    func languageChanged() {
        title = textManager.title
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource implementation

extension MainPreferencesViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        types.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = types[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        switch type {
        case .language(let current):
            cell.textLabel?.text = textManager.preferencesLanguage
            cell.detailTextLabel?.text = current
        case .contry(let current):
            cell.textLabel?.text = textManager.preferencesCountry
            cell.detailTextLabel?.text = current
        case .currency(let current):
            cell.textLabel?.text = textManager.preferencesCurrency
            cell.detailTextLabel?.text = current
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = types[indexPath.row]
        presenter.didSelect(cellType: type)
    }
}
