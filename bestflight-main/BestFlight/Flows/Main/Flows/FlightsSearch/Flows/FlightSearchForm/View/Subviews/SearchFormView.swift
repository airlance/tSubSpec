import UIKit

protocol SearchFormViewDelegate: class {
    func didFromFieldActivated(view: SearchFormView)
    func didToFieldActivated(view: SearchFormView)
    func didDateFieldActivated(view: SearchFormView)
    func didSearchButtonPress(view: SearchFormView)
}

final class SearchFormView: UIView {

    // MARK: Appearance

    private struct Appearance {
        let backgroundColor: UIColor = .accentBackground
        let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        let containerCornerRadius: CGFloat = 16
        let containerSpacing: CGFloat = 16
        let formSpacing: CGFloat = 8

        let formLabelFont: UIFont = .headline1
        let formLabelColor: UIColor = .normalText
        let formFieldBackground: UIColor = .normalBackground
        let formFieldColor: UIColor = .normalText
        let formFieldFont: UIFont = .headline1

        let searchButtonInsets: UIEdgeInsets = .init(top: 24, left: 0, bottom: 0, right: 0)
    }
    private let appearance = Appearance()

    // MARK: Properties

    weak var delegate: SearchFormViewDelegate?

    // MARK: UI Properties

    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = appearance.backgroundColor
        view.layer.cornerRadius = appearance.containerCornerRadius
        return view
    }()

    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.spacing = appearance.containerSpacing
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var searchButton: FilledButton = {
        let button = FilledButton(frame: .zero)
        button.addTarget(self, action: #selector(didSearchPressed), for: .touchUpInside)
        return button
    }()

    private lazy var searchButtonContainer: UIView = {
        UIView(frame: .zero)
    }()

    private lazy var fromLabel: UILabel = {
        makeFormLabel()
    }()

    private lazy var fromField: FieldyButton = {
        makeFormField(target: self, clickhandler: #selector(didFromPressed))
    }()

    private lazy var toLabel: UILabel = {
        makeFormLabel()
    }()

    private lazy var toField: FieldyButton = {
        makeFormField(target: self, clickhandler: #selector(didToPressed))
    }()

    private lazy var dateLabel: UILabel = {
        makeFormLabel()
    }()

    private lazy var dateField: FieldyButton = {
        makeFormField(target: self, clickhandler: #selector(didDatePressed))
    }()

    private func makeFormField(target: Any?, clickhandler: Selector) -> FieldyButton {
        let button = FieldyButton()
        button.addTarget(target, action: clickhandler, for: .touchUpInside)
        return button
    }

    private func makeFormLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.font = appearance.formLabelFont
        label.textColor = appearance.formLabelColor
        return label
    }

    private func makeLineStack(with views: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.spacing = appearance.formSpacing
        return stackView
    }

    // MARK: Lifecycle

    override init(frame: CGRect) {
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
        addSubview(containerView)
        containerView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(makeLineStack(with: [fromLabel, fromField]))
        containerStackView.addArrangedSubview(makeLineStack(with: [toLabel, toField]))
        containerStackView.addArrangedSubview(makeLineStack(with: [dateLabel, dateField]))
        searchButtonContainer.addSubview(searchButton)
        containerStackView.addArrangedSubview(searchButtonContainer)
    }

    private func makeConstraints() {
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(appearance.insets)
        }

        containerStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(appearance.insets)
        }

        searchButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(appearance.searchButtonInsets)
        }
    }
}

// MARK: - SearchFormView handlers

private extension SearchFormView {
    @objc func didFromPressed() {
        delegate?.didFromFieldActivated(view: self)
    }

    @objc func didToPressed() {
        delegate?.didToFieldActivated(view: self)
    }

    @objc func didDatePressed() {
        delegate?.didDateFieldActivated(view: self)
    }

    @objc func didSearchPressed() {
        delegate?.didSearchButtonPress(view: self)
    }
}

// MARK: - Public setters

extension SearchFormView {
    func setToText(_ text: String) {
        toLabel.text = text
    }

    func setFromText(_ text: String) {
        fromLabel.text = text
    }

    func setDateText(_ text: String) {
        dateLabel.text = text
    }

    func setSearchButtonText(_ text: String) {
        searchButton.setTitle(text, for: .normal)
    }

    func setSearchButtonEnabled(_ enabled: Bool) {
        searchButton.isEnabled = enabled
    }

    func setFromFieldText(_ text: String) {
        fromField.setTitle(text, for: .normal)
    }

    func setToFieldText(_ text: String) {
        toField.setTitle(text, for: .normal)
    }

    func setDateFieldText(_ text: String) {
        dateField.setTitle(text, for: .normal)
    }
}

