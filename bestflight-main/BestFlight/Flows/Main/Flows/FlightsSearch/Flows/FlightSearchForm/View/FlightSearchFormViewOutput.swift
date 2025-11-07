import Foundation

protocol FlightSearchFormViewOutput {
    func viewIsReady()
    func didFromFieldPressed()
    func didToFieldPressed()
    func didDatePicked(date: Date?)
    func didSearchButtonPressed()
}
