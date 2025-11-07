import UIKit

public class ListableStackView: UIView {

    // MARK: UI properties

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        return scrollView
    }()

    private lazy var contentView: UIView = {
        UIView(frame: .zero)
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    // MARK: Public properties

    public var spacing: CGFloat = 0.0 {
        didSet {
            stackView.spacing = spacing
        }
    }

    public var arrangedSubviews: [UIView] {
        stackView.arrangedSubviews
    }

    // MARK: Lifecycle

    public override init(frame: CGRect) {
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
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
    }

    private func makeConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }

        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.centerY.equalToSuperview().priority(.high)
        }
    }

}

public extension ListableStackView {
    func addArrangedSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }

    func removeArrangedSubview(_ view: UIView) {
        stackView.removeArrangedSubview(view)
        view.removeFromSuperview()
    }

    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { removeArrangedSubview($0) }
    }
}

