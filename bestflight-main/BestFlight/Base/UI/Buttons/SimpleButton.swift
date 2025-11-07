import UIKit

class SimpleButton: UIButton {

    // MARK: Appearance

    struct Appearance {
        let borderWidth: CGFloat = 3
        let color: UIColor = .accentColor
        let touchColor: UIColor = UIColor.accentColor.withAlphaComponent(0.7)
        let disabledColor: UIColor = UIColor.normalText.withAlphaComponent(0.7)

        let font: UIFont = .headline0
        let titleInsets: UIEdgeInsets = .init(top: 8, left: 32, bottom: 8, right: 32)
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
        setTitleColor(appearance.color, for: .normal)
        layer.borderColor = appearance.color.cgColor
        layer.borderWidth = appearance.borderWidth
        layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
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
        layer.borderColor = appearance.color.cgColor
        setTitleColor(appearance.color, for: .normal)
    }

    private func setTouchStateStyle() {
        layer.borderColor = appearance.touchColor.cgColor
        setTitleColor(appearance.touchColor, for: .normal)
    }

    private func setDisabledStateStyle() {
        layer.borderColor = appearance.disabledColor.cgColor
        setTitleColor(appearance.disabledColor, for: .normal)
    }

}
