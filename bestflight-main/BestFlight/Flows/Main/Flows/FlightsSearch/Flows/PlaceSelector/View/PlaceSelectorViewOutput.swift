import Foundation

protocol PlaceSelectorViewOutput {
    func viewIsReady()
    func didClosePressed()
    func didSearchFieldChanged(_ text: String)
    func didSelectPlace(viewModel: PlaceCountryViewModel)
}
