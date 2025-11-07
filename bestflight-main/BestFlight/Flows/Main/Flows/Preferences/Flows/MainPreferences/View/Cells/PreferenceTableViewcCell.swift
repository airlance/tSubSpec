import UIKit

class PreferenceTableViewcCell: UITableViewCell {

    // MARK: Appearance

    struct Appearance {
        let titleFont: UIFont = .headline1
        let titleColor: UIColor = .normalText

        let valueFont: UIFont = .headline2
        let valueColor: UIColor = .headlineText
    }
    private let appearance = Appearance()

    // MARK: UI properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = appearance.titleFont
        label.textColor = appearance.titleColor
        return label
    }()

    private lazy var valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = appearance.valueFont
        label.textColor = appearance.valueColor
        return label
    }()

    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
