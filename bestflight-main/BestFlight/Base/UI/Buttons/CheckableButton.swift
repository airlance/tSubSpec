import UIKit

class CheckableButton: UIButton {

    // MARK: Appearance

    struct Appearance {
        let borderRadius: CGFloat = 8
        let borderWidth: CGFloat = 1
        let color: UIColor = .normalText
        let selectedColor: UIColor = .accentColor
        let touchColor: UIColor = UIColor.accentColor.withAlphaComponent(0.7)
        let font: UIFont = .headline1
        let titleInsets: UIEdgeInsets = .init(top: 8, left: 32, bottom: 8, right: 32)
    }
    private let appearance = Appearance()

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height += appearance.titleInsets.top + appearance.titleInsets.bottom
        size.width += appearance.titleInsets.left + appearance.titleInsets.right
        return size
    }

    override var isSelected: Bool {
        didSet {
            isSelected ? setupSelectedState() : setupUnselectedState()
        }
    }

    private func setupUI() {
        titleEdgeInsets = appearance.titleInsets
        titleLabel?.font = appearance.font
        setTitleColor(appearance.color, for: .normal)
        layer.cornerRadius = appearance.borderRadius
        layer.borderColor = appearance.color.cgColor
        layer.borderWidth = appearance.borderWidth
        layer.masksToBounds = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setupSelectedState()
        super.touchesBegan(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSelected ? setupSelectedState() : setupUnselectedState()
        super.touchesEnded(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSelected ? setupSelectedState() : setupUnselectedState()
        super.touchesCancelled(touches, with: event)
    }

    // MARK: Private methods

    private func setupUnselectedState() {
        layer.borderColor = appearance.color.cgColor
        setTitleColor(appearance.color, for: .normal)
    }

    private func setupSelectedState() {
        layer.borderColor = appearance.touchColor.cgColor
        setTitleColor(appearance.touchColor, for: .normal)
    }

}
