import Foundation

protocol FlightSearchFormViewInput: class {
    func setupInitialState()
    func setFromFieldText(_ text: String)
    func setToFieldText(_ text: String)
    func setDateFieldText(_ text: String)
    func setSearchButtonEnabled(_ enabled: Bool)
}
