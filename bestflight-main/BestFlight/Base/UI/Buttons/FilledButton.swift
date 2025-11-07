import UIKit

class FilledButton: UIButton {

    // MARK: Appearance

    struct Appearance {
        let cornerRadius: CGFloat = 8

        let backgroundColor: UIColor = .accentColor
        let backgroundTouchColor: UIColor = UIColor.accentColor.withAlphaComponent(0.8)
        let backgroundDisabledColor: UIColor = UIColor.normalText.withAlphaComponent(0.8)

        let textColor: UIColor = .accentText
        let textTouchColor = UIColor.normalText.withAlphaComponent(0.7)
        let textDisabledColor = UIColor.normalText.withAlphaComponent(0.7)

        let font: UIFont = .headline1
        let titleInsets: UIEdgeInsets = .init(top: 8, left: 10, bottom: 8, right: 10)
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
        layer.cornerRadius = appearance.cornerRadius
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
        setTitleColor(appearance.textTouchColor, for: .normal)
    }

    private func setDisabledStateStyle() {
        backgroundColor = appearance.backgroundDisabledColor
        setTitleColor(appearance.textDisabledColor, for: .normal)
    }

}
