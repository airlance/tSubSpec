import Foundation

protocol PlaceSelectorViewInput: AlertPresentableView {
    func setupInitialState()
    func showLoading()
    func hideLoading()
    func showPlaces(places: [PlaceCountryViewModel])
    func setSearchFocus()
}
