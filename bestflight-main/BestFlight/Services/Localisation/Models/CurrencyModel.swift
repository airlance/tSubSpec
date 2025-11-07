import Foundation

struct CurrencyModel: Codable {
    let code: String
    let symbol: String
    let thousandsSeparator: String
    let decimalSeparator: String
    let symbolOnLeft: Bool
    let spaceBetweenAmountAndSymbol: Bool
    let roundingCoefficient: Int
    let decimalDigits: Int

    private enum CodingKeys: String, CodingKey {
        case code = "Code"
        case symbol = "Symbol"
        case thousandsSeparator = "ThousandsSeparator"
        case decimalSeparator = "DecimalSeparator"
        case symbolOnLeft = "SymbolOnLeft"
        case spaceBetweenAmountAndSymbol = "SpaceBetweenAmountAndSymbol"
        case roundingCoefficient = "RoundingCoefficient"
        case decimalDigits = "DecimalDigits"
    }
}

extension CurrencyModel {
    func format(number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = code
        formatter.currencySymbol = symbol
        formatter.decimalSeparator = decimalSeparator
        formatter.groupingSeparator = thousandsSeparator
        formatter.currencySymbol = symbol
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
}
