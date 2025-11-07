import Foundation

protocol PlaceSelectorModuleOutput: class {
    func didPlaceSelectorFinishWithClose()
    func didPlaceSelectorFinishWithCountryModel(_ countryModel: CountryModel)
}
