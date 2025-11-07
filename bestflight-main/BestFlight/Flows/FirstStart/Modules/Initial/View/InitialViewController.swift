import UIKit

// MARK: - InitialViewController implementation 

final class InitialViewController: UIViewController {

    // MARK: Appearance
    struct Appearance {
        let backgroundColor: UIColor = .normalBackground
        let insets: UIEdgeInsets = .init(top: 30, left: 16, bottom: 16, right: 16)
        let spacing: CGFloat = 24

        let welcomeFont: UIFont = .headline0
        let welcomeColor: UIColor = .headlineText
        let welcomeNumberOfLines = 0

        let welcomeTextFont: UIFont = .body
        let welcomeTextColor: UIColor = .normalText
        let welcomeTextNumberOfLines = 0
    }
    private let appearance = Appearance()

    // MARK: Properties

    private let presenter: InitialViewOutput
    private let textManager: InitialTextManagerProtocol

    // MARK: UI properties

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.spacing = appearance.spacing
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var welcomeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = appearance.welcomeFont
        label.textColor = appearance.welcomeColor
        label.numberOfLines = appearance.welcomeNumberOfLines
        return label
    }()

    private lazy var welcomeTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = appearance.welcomeTextFont
        label.textColor = appearance.welcomeTextColor
        label.numberOfLines = appearance.welcomeTextNumberOfLines
        return label
    }()

    private lazy var continueButton: SimpleButton = {
        let button = SimpleButton(frame: .zero)
        button.addTarget(self, action: #selector(continueButtonPress), for: .touchUpInside)
        return button
    }()

    // MARK: Life cycle

    init(presenter: InitialViewOutput, textManager: InitialTextManagerProtocol) {
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
        presenter.viewIsReady()
        languageChanged()
    }

    private func setupUI() {
        view.backgroundColor = appearance.backgroundColor
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(welcomeLabel)
        stackView.addArrangedSubview(welcomeTextLabel)
        stackView.addArrangedSubview(continueButton)
    }

    private func makeConstraints() {
        stackView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(appearance.insets.left)
            make.trailing.equalToSuperview().inset(appearance.insets.right)
            make.centerY.equalToSuperview()
        }
    }
}

extension InitialViewController {
    @objc func continueButtonPress() {
        presenter.didPressContinueButton()
    }
}

// MARK: - InitialViewInput implementation

extension InitialViewController: InitialViewInput {
    func setupInitialState() {
    }
}

extension InitialViewController: LanguageObservable {
    func languageChanged() {
        title = Utils.applicationDisplayName
        welcomeLabel.text = textManager.welcomeText
        welcomeTextLabel.text = textManager.welcomeDescriptionText
        continueButton.setTitle(textManager.continueButton, for: .normal)
    }
}
