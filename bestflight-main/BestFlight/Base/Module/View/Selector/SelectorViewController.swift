import UIKit

// MARK: - SelectorViewController implementation

class SelectorViewController: UIViewController {

    // MARK: Appearance

    private struct Appearance {
        let backgroundColor: UIColor = .normalBackground
        let continueInsets: UIEdgeInsets = .init(top: 8, left: 16, bottom: 8, right: 16)
    }
    private let appearance = Appearance()

    // MARK: Properties

    private let presenter: SelectorViewOutput

    // MARK: UI properties

    private lazy var loaderView: LoaderView = {
        let view = LoaderView(frame: .zero)
        return view
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl(frame: .zero)
        refresh.addTarget(self, action: #selector(shouldRefresh), for: .valueChanged)
        return refresh
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        setupTableView(for: tableView)
        return tableView
    }()

    private lazy var bottomContainer: UIView = {
        UIView(frame: .zero)
    }()

    lazy var continueButton: SimpleButton = {
        let button = SimpleButton(frame: .zero)
        button.addTarget(self, action: #selector(continueButtonPress), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    // MARK: Handlers

    @objc func continueButtonPress(_ sender: SimpleButton) {
        presenter.didContinueButtonPress()
    }

    @objc func shouldRefresh(_ sender: UIRefreshControl) {
        presenter.shouldRefresh()
    }

    // MARK: Lifecycle

    init(presenter: SelectorViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        view.backgroundColor = appearance.backgroundColor
        addSubviews()
        makeConstraints()
    }

    func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(bottomContainer)
        view.addSubview(loaderView)
        bottomContainer.addSubview(continueButton)
    }

    func makeConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomContainer.snp.top)
        }
        bottomContainer.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
        }
        continueButton.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview().inset(appearance.continueInsets)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(appearance.continueInsets)
        }
        loaderView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(LoaderView.defaultSize)
        }
    }

    func setupTableView(for tableView: UITableView) {
        // Must be overriden by child classes
    }
}

// MARK: - SelectorViewInput implementation

extension SelectorViewController: SelectorViewInput {
    func setupInitialState() {
    }

    func showLoading() {
        loaderView.startAnimating()
    }

    func hideLoading() {
        loaderView.stopAnimating()
    }

    func endRefreshing() {
        refreshControl.endRefreshing()
    }

    func setContinueButtonEnabled() {
        continueButton.isEnabled = true
    }

    func setContinueButtonDisabled() {
        continueButton.isEnabled = false
    }
}
