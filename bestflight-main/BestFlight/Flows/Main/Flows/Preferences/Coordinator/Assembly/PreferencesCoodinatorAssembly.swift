import Foundation

final class PreferencesCoodinatorAssembly {
    static func assembly(output: PreferencesCoordinatorOutput) -> PreferencesCoordinator {
        PreferencesCoordinator(output: output)
    }
}
