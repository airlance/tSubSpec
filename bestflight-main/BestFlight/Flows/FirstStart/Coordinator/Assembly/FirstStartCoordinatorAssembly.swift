import Foundation

final class FirstStartCoordinatorAssembly {
    static func assembly(output: FirstStartCoordinatorOutput) -> FirstStartCoordinatorInput {
        FirstStartCoordinator(output: output)
    }
}
