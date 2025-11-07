import Foundation

// MARK: - NavigationCustomizable declaration

protocol NavigationCustomizable: class {
    func shouldHideNavigationBar() -> Bool
    func shouldPopBack() -> Bool
}

