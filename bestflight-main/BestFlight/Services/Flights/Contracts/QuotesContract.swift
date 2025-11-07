import Foundation

struct QuotesContract {
    let marketCountry: MarketCountryModel
    let marketCurrency: CurrencyModel
    let language: LanguageModel
    let fromCountry: CountryModel
    let toCountry: CountryModel
    let date: Date?
}
