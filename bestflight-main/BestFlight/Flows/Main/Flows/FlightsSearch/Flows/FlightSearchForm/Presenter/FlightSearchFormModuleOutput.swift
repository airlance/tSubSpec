import Foundation

protocol FlightSearchFormModuleOutput: class {
    func didFlightSearchFormPlaceSelectorRequested()
    func didFlightSearchFormSearchRequested(contract: FlightSearchContract)
}
