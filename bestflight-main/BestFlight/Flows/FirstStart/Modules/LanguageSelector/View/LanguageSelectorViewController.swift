import UIKit
import SnapKit

// MARK: - LanguageSelectorViewController implementation 

final class LanguageSelectorViewController: UIViewController {

    // MARK: Appearance
    struct Appearance {
        let background: UIColor = .normalBackground

        let containerSpacing: CGFloat = 16
        let containerInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)

        let titleFont: UIFont = .headline0
        let titleColor: UIColor = .headlineText
        let titleAlignment: NSTextAlignment = .center
        let titleNumberOfLines = 0

        let descriptionFont: UIFont = .body
        let descriptionColor: UIColor = .normalText
        let descriptionAlignment: NSTextAlignment = .center
        let descriptionNumberOfLines = 0

        let languagesStackSpacing: CGFloat = 16
    }
    private let appearance = Appearance()

    // MARK: Properties

    private let textManager: LanguageSelectorTextManagerProtocol
    private let presenter: LanguageSelectorViewOutput

    // MARK: UI properties

    private lazy var containerStack: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = appearance.containerSpacing
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = appearance.titleAlignment
        label.textColor = appearance.titleColor
        label.font = appearance.titleFont
        label.numberOfLines = appearance.titleNumberOfLines
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = appearance.descriptionAlignment
        label.textColor = appearance.descriptionColor
        label.font = appearance.descriptionFont
        label.numberOfLines = appearance.descriptionNumberOfLines
        return label
    }()

    private lazy var languagesStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = appearance.languagesStackSpacing
        return stackView
    }()

    private lazy var continueButton: SimpleButton = {
        let button = SimpleButton(frame: .zero)
        button.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        return button
    }()

    // MARK: Life cycle

    init(presenter: LanguageSelectorViewOutput, textManager: LanguageSelectorTextManagerProtocol) {
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
        view.backgroundColor = appearance.background
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        view.addSubview(containerStack)
        containerStack.addArrangedSubview(titleLabel)
        containerStack.addArrangedSubview(languagesStackView)
        containerStack.addArrangedSubview(descriptionLabel)
        containerStack.addArrangedSubview(continueButton)
    }

    private func makeConstraints() {
        containerStack.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(appearance.containerInsets.left)
            make.trailing.equalToSuperview().inset(appearance.containerInsets.right)
            make.top.greaterThanOrEqualToSuperview().inset(appearance.containerInsets.top)
            make.bottom.lessThanOrEqualToSuperview().inset(appearance.containerInsets.bottom)
            make.centerY.equalToSuperview()
        }
    }

    private func makeLanguageButton(identifier: String, title: String, selected: Bool) -> CheckableButton {
        let button = CheckableButton(frame: .zero)
        button.setTitle(title, for: .normal)
        button.isSelected = selected
        button.accessibilityIdentifier = identifier
        button.addTarget(self, action: #selector(languageButtonPressed(_:)), for: .touchUpInside)
        return button
    }
}

// MARK: - Handlers

extension LanguageSelectorViewController {
    @objc func languageButtonPressed(_ sender: CheckableButton) {
        guard let languageIdentifier = sender.accessibilityIdentifier else {
            return
        }
        presenter.didPressLanguage(with: languageIdentifier)
    }

    @objc func continueButtonPressed() {
        presenter.didPressContinue()
    }
}

// MARK: - LanguageSelectorViewInput implementation

extension LanguageSelectorViewController: LanguageSelectorViewInput {
    func setupInitialState() {
    }

    func showLanguages(_ languages: [LanguageViewModel]) {
        languagesStackView.arrangedSubviews.forEach {
            languagesStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        languages.forEach {
            let button = makeLanguageButton(
                identifier: $0.identifier,
                title: $0.title,
                selected: $0.selected
            )
            languagesStackView.addArrangedSubview(button)
        }
    }
}

// MARK: - NavigationCustomizable implementation

extension LanguageSelectorViewController: NavigationCustomizable {
    func shouldHideNavigationBar() -> Bool {
        return true
    }

    func shouldPopBack() -> Bool {
        return true
    }
}

// MARK: - Language observable implementation

extension LanguageSelectorViewController: LanguageObservable {
    func languageChanged() {
        titleLabel.text = textManager.selectLanguageText
        descriptionLabel.text = textManager.selectLanguageDescriptionText
        continueButton.setTitle(textManager.continueButton, for: .normal)
    }
}
