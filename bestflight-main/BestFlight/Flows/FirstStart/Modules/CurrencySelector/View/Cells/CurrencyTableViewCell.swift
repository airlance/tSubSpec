import UIKit

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// TODO: Make base class for checkable title table view cell
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
class CurrencyTableViewCell: UITableViewCell {
    // MARK: Appearance

    private struct Appearance {
        let insets: UIEdgeInsets = .init(top: 8, left: 16, bottom: 8, right: 16)
        let spacing: CGFloat = 16

        let checkMarkImage = UIImage.Common.checkmark
        let checkMarkSize: CGSize = .init(width: 30, height: 30)

        let countryTitleFont: UIFont = .headline1
        let countryTitleColor: UIColor = .normalText
        let countryTitleSelectedColor: UIColor = .accentColor
    }
    private let appearance = Appearance()

    // MARK: UI properties

    private lazy var checkMarkImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.isHidden = true
        imageView.image = appearance.checkMarkImage
        return imageView
    }()

    private lazy var countryTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = appearance.countryTitleFont
        label.textColor = appearance.countryTitleColor
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
        contentView.addSubview(checkMarkImageView)
        contentView.addSubview(countryTitleLabel)
    }

    private func makeConstraints() {
        checkMarkImageView.snp.makeConstraints { (make) in
            make.size.equalTo(appearance.checkMarkSize)
            make.leading.equalToSuperview().inset(appearance.insets.left)
            make.top.greaterThanOrEqualToSuperview().inset(appearance.insets.top)
            make.bottom.lessThanOrEqualToSuperview().inset(appearance.insets.bottom)
            make.centerY.equalToSuperview()
        }

        countryTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(checkMarkImageView.snp.trailing).offset(appearance.spacing)
            make.trailing.equalToSuperview().inset(appearance.insets.right)
            make.top.greaterThanOrEqualToSuperview().inset(appearance.insets.top)
            make.bottom.lessThanOrEqualToSuperview().inset(appearance.insets.bottom)
            make.centerY.equalToSuperview()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setUncheckedState()
    }
}

// MARK: - CurrencyTableViewCell configuring

extension CurrencyTableViewCell {
    func configure(with contract: CurrencyTableViewCellContract) {
        contract.checked ? setCheckedState() : setUncheckedState()
        countryTitleLabel.text = contract.title
    }
}

// MARK: - CurrencyTableViewCell private methods

private extension CurrencyTableViewCell {
    private func setCheckedState() {
        checkMarkImageView.isHidden = false
        countryTitleLabel.textColor = appearance.countryTitleSelectedColor
    }

    private func setUncheckedState() {
        checkMarkImageView.isHidden = true
        countryTitleLabel.textColor = appearance.countryTitleColor
    }
}

