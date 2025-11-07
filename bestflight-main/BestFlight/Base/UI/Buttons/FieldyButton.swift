import UIKit

class FieldyButton: UIButton {

    // MARK: Appearance

    struct Appearance {
        let borderWidth: CGFloat = 1
        let borderColor: UIColor = .fieldBorder
        let borderRadius: CGFloat = 8

        let backgroundColor: UIColor = .fieldBackground
        let backgroundTouchColor = UIColor.fieldBackground.withAlphaComponent(0.7)
        let backgroundDisabledColor = UIColor.fieldBackground.withAlphaComponent(0.7)

        let textColor: UIColor = .fieldText
        let textDisabledColor = UIColor.fieldText.withAlphaComponent(0.7)

        let font: UIFont = .headline1
        let titleInsets: UIEdgeInsets = .init(top: 4, left: 16, bottom: 4, right: 16)
    }
    private let appearance = Appearance()

    // MARK: Properties

    override var isEnabled: Bool {
        didSet {
            isEnabled ? setNormalStateStyle() : setDisabledStateStyle()
        }
    }

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

    private func setupUI() {
        titleEdgeInsets = appearance.titleInsets
        titleLabel?.font = appearance.font
        layer.borderColor = appearance.borderColor.cgColor
        layer.borderWidth = appearance.borderWidth
        layer.cornerRadius = appearance.borderRadius
        layer.masksToBounds = true
        setNormalStateStyle()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setTouchStateStyle()
        super.touchesBegan(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setNormalStateStyle()
        super.touchesEnded(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        setNormalStateStyle()
        super.touchesCancelled(touches, with: event)
    }

    private func setNormalStateStyle() {
        backgroundColor = appearance.backgroundColor
        setTitleColor(appearance.textColor, for: .normal)
    }

    private func setTouchStateStyle() {
        backgroundColor = appearance.backgroundTouchColor
        setTitleColor(appearance.textColor, for: .normal)
    }

    private func setDisabledStateStyle() {
        backgroundColor = appearance.backgroundDisabledColor
        setTitleColor(appearance.textDisabledColor, for: .normal)
    }

}
