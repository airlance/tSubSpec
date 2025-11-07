import Foundation

struct CurrencySelectorSettings {
    let moduleOutput: CurrencySelectorModuleOutput
    let languagesService: LanguagesServiceProtocol
    let localisationService: LocalisationServiceProtocol
    let selectedModel: CurrencyModel?
}
