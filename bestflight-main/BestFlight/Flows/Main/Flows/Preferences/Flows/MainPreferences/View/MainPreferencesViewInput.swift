import Foundation

protocol MainPreferencesViewInput: class {
    func setupInitialState()
    func showItems(items: [MainPreferencesCellType])
}
