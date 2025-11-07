import MaterialComponents.MaterialActivityIndicator

public class LoaderView: UIView {

    // MARK: Declarations

    static let defaultSize = CGSize(width: 30, height: 30)

    // MARK: Properties

    private lazy var loadingView: MDCActivityIndicator = {
        let activityIndicator = MDCActivityIndicator()
        activityIndicator.indicatorMode = .indeterminate
        activityIndicator.cycleColors = [.accentColor]
        return activityIndicator
    }()

    // MARK: Lifecycle

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        self.addSubview(loadingView)
    }

    private func makeConstraints() {
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: Public methods

    public func startAnimating() {
        loadingView.startAnimating()
    }

    public func stopAnimating() {
        loadingView.stopAnimating()
    }

    public func setColor(_ color: UIColor) {
        loadingView.cycleColors = [color]
    }
}
