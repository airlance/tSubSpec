import Foundation

protocol FlightSearchResultsViewInput: AlertPresentableView {
    func setupInitialState()
    func showLoader()
    func hideLoader()
    func showItems(items: [QuoteViewModel])
}
