import Foundation

extension String {

    /// Returns source string with first uppercased character
    var firstUpperCased: String {
        var currentValue = self
        guard let first = currentValue.first else {
            return self
        }
        currentValue.removeFirst()
        return String(first.uppercased()) + currentValue
    }
    
}
