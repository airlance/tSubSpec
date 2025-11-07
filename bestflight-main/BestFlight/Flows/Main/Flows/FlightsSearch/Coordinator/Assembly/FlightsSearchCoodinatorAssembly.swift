import Foundation

final class FlightsSearchCoodinatorAssembly {
    static func assembly(output: FlightsSearchCoordinatorOutput) -> FlightsSearchCoodinator {
        FlightsSearchCoodinator(output: output)
    }
}
