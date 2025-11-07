import UIKit


final class PlaceCountryTableViewCell: UITableViewCell {

    // MARK: Appearance

    private struct Appearance {
        let titleFont: UIFont = .headline1
        let titleColor: UIColor = .normalText
        let titleInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }
    private let appearance = Appearance()

    // MARK: UI properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = appearance.titleFont
        label.textColor = appearance.titleColor
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
        contentView.addSubview(titleLabel)
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(appearance.titleInsets)
        }
    }

    // MARK: COnfiguration

    func configure(with contract: PlaceCountryTableViewCellContract) {
        titleLabel.text = contract.title
    }
}
