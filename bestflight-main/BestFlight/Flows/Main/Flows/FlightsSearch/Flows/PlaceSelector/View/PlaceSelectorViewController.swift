import UIKit

// MARK: - PlaceSelectorViewController implementation 

final class PlaceSelectorViewController: UIViewController {

    // MARK: Appearance

    private struct Appearance {
        let closeImage = UIImage.Navigation.closeBarButton
    }
    private let appearance = Appearance()

    // MARK: Properties

    private let textManager: PlaceSelectorTextManagerProtocol
    private let presenter: PlaceSelectorViewOutput
    private var items: [PlaceCountryViewModel] = []

    // MARK: UI properties

    private lazy var keyboardManager: KeyboardManager = {
        let keyboardManager = KeyboardManager()
        return keyboardManager
    }()

    private lazy var loaderView: LoaderView = {
        let view = LoaderView(frame: .zero)
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellClass: PlaceCountryTableViewCell.self)
        return tableView
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = self
        return searchBar
    }()

    private lazy var closeBarButton: UIBarButtonItem = {
        UIBarButtonItem(
            image: appearance.closeImage,
            style: .plain,
            target: self,
            action: #selector(closeButtonPress)
        )
    }()

    // MARK: Life cycle

    init(presenter: PlaceSelectorViewOutput, textManager: PlaceSelectorTextManagerProtocol) {
        self.textManager = textManager
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboard()
        languageChanged()
        presenter.viewIsReady()
    }

    private func setupKeyboard() {
        keyboardManager.delegate = self
    }

    private func setupUI() {
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(loaderView)
        navigationItem.leftBarButtonItem = closeBarButton
        navigationItem.titleView = searchBar
    }

    private func makeConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        loaderView.snp.makeConstraints { (make) in
            make.size.equalTo(LoaderView.defaultSize)
            make.center.equalToSuperview()
        }
    }

    @objc private func closeButtonPress() {
        presenter.didClosePressed()
    }
}

// MARK: - PlaceSelectorViewInput implementation

extension PlaceSelectorViewController: PlaceSelectorViewInput {
    func showLoading() {
        loaderView.startAnimating()
    }

    func hideLoading() {
        loaderView.stopAnimating()
    }

    func showPlaces(places: [PlaceCountryViewModel]) {
        self.items = places
        self.tableView.reloadData()
    }

    func setSearchFocus() {
        searchBar.becomeFirstResponder()
    }

    func setupInitialState() {
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource implementation

extension PlaceSelectorViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeue(cellClass: PlaceCountryTableViewCell.self, forIndexPath: indexPath)
        cell.configure(with: PlaceCountryTableViewCellContract(title: item.name))
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        presenter.didSelectPlace(viewModel: item)
    }
}

// MARK: - UISearchBar delegate implementation

extension PlaceSelectorViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.didSearchFieldChanged(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

// MARK: - KeyboardManagerDelegate implementation

extension PlaceSelectorViewController: KeyboardManagerDelegate {
    func keyboardWillShow(_ manager: KeyboardManager, frame: CGRect, animationDuration: TimeInterval) {
        UIView.animate(withDuration: animationDuration) {
            self.tableView.contentInset.bottom = frame.height - self.view.safeAreaInsets.bottom
            self.tableView.scrollIndicatorInsets.bottom = frame.height - self.view.safeAreaInsets.bottom
        }
    }

    func keyboardWillHide(_ manager: KeyboardManager, animationDuration: TimeInterval) {
        UIView.animate(withDuration: animationDuration) {
            self.tableView.contentInset.bottom = self.view.safeAreaInsets.bottom
        }
    }

    func keyboardWillChangeFrame(_ manager: KeyboardManager, frame: CGRect) {
        self.tableView.contentInset.bottom = frame.height - self.view.safeAreaInsets.bottom
        self.tableView.scrollIndicatorInsets.bottom = frame.height - self.view.safeAreaInsets.bottom
    }
}

// MARK: - LanguagesObservable implementation

extension PlaceSelectorViewController: LanguageObservable {
    func languageChanged() {
        searchBar.placeholder = textManager.searchPlaceholderText
    }
}
