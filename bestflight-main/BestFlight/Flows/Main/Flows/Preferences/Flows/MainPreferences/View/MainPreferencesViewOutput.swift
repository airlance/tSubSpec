import Foundation

protocol MainPreferencesViewOutput {
    func viewIsReady()
    func didSelect(cellType: MainPreferencesCellType)
}
