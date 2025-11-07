import Foundation

// MARK: - InitialPresenter implementation

final class InitialPresenter {

    // MARK: Properties

    weak var view: InitialViewInput?
    private let interactor: InitialInteractorInput
    private let moduleOutput: InitialModuleOutput 
    private let settings: InitialSettings

    // MARK: Initializers

    init(
        moduleOutput: InitialModuleOutput,
        interactor: InitialInteractorInput,
        settings: InitialSettings
    ) {
        self.interactor = interactor
        self.moduleOutput = moduleOutput
        self.settings = settings
    }
}

// MARK: - InitialInteractorOutput implementation

extension InitialPresenter: InitialInteractorOutput {
    func viewIsReady() {
    }

    func didPressContinueButton() {
        moduleOutput.didFinishInitialWithContinue()
    }
}

// MARK: - InitialViewOutput implemenetation

extension InitialPresenter: InitialViewOutput {
}

// MARK: - InitialModuleInput implementation

extension InitialPresenter: InitialModuleInput {
}
