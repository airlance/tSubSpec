import Foundation

struct CountrySelectorSettings {
    let moduleOutput: CountrySelectorModuleOutput
    let languagesService: LanguagesServiceProtocol
    let localisationService: LocalisationServiceProtocol
    let selectedModel: MarketCountryModel?
}
