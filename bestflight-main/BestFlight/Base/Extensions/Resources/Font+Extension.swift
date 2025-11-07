import UIKit

// MARK: - Fabric methods

extension UIFont {

    private static func regular(with size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .regular)
    }

    private static func bold(with size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .bold)
    }

    private static func semibold(with size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .semibold)
    }

}

// MARK: - Component style fonts

extension UIFont {

    // MARK: Headline

    static var headline0: UIFont { return bold(with: 24) }
    static var headline1: UIFont { return bold(with: 18) }
    static var headline2: UIFont { return bold(with: 14) }

    // MARK: Body

    static var body: UIFont { return regular(with: 14) }

}
