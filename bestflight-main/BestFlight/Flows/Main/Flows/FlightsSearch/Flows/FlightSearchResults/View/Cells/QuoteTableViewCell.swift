import UIKit

final class QuoteTableViewCell: UITableViewCell {

    // MARK: Appearance

    private struct Appearance {
        let containerInsets: UIEdgeInsets = .init(top: 8, left: 16, bottom: 8, right: 16)
        let containerBackgroundColor: UIColor = .fieldBackground
        let containerBorderColor: UIColor = .fieldBorder
        let containerBorderWidth: CGFloat = 1.0
        let containerBorderRadius: CGFloat = 16
        let containerSpacing: CGFloat = 8

        let titleFont: UIFont = .headline1
        let titleColor: UIColor = .headlineText
        let legFont: UIFont = .headline0
        let legColor: UIColor = .normalText

        let summaryFont: UIFont = .headline1
        let summaryColor: UIColor = .normalText

        let dateFont: UIFont = .headline2
        let dateColor: UIColor = .normalText
    }
    private let appearance = Appearance()

    // MARK: UI properties

    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = appearance.containerBackgroundColor
        view.layer.borderColor = appearance.containerBorderColor.cgColor
        view.layer.borderWidth = appearance.containerBorderWidth
        view.layer.cornerRadius = appearance.containerBorderRadius
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = appearance.containerSpacing
        return stackView
    }()

    private lazy var titleFromLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = appearance.titleFont
        label.textColor = appearance.titleColor
        return label
    }()

    private lazy var titleToLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = appearance.titleFont
        label.textColor = appearance.titleColor
        return label
    }()

    private lazy var fromLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = appearance.legFont
        label.textColor = appearance.legColor
        return label
    }()

    private lazy var toLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = appearance.legFont
        label.textColor = appearance.legColor
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = appearance.dateFont
        label.textColor = appearance.dateColor
        return label
    }()

    private lazy var summaryLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = appearance.summaryFont
        label.textColor = appearance.summaryColor
        return label
    }()

    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        contentView.addSubview(containerView)
        containerView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(titleFromLabel)
        containerStackView.addArrangedSubview(fromLabel)
        containerStackView.addArrangedSubview(titleToLabel)
        containerStackView.addArrangedSubview(toLabel)
        containerStackView.addArrangedSubview(dateLabel)
        containerStackView.addArrangedSubview(summaryLabel)
    }

    private func makeConstraints() {
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(appearance.containerInsets)
        }

        containerStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(appearance.containerInsets)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleFromLabel.text = nil
        fromLabel.text = nil
        titleToLabel.text = nil
        toLabel.text = nil
        dateLabel.text = nil
        summaryLabel.text = nil
    }
}

extension QuoteTableViewCell {
    func configure(with contract: QuoteTableViewCellContract) {
        titleFromLabel.text = contract.fromCaptionText
        fromLabel.text = contract.fromValueText

        titleToLabel.text = contract.toCaptionText
        toLabel.text = contract.toValueText

        summaryLabel.text = contract.summaryText
        dateLabel.text = contract.dateText
    }
}
