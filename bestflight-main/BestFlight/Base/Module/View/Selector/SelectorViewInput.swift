import Foundation

protocol SelectorViewInput: class {
    func setupInitialState()
    func showLoading()
    func hideLoading()
    func endRefreshing()
    func setContinueButtonEnabled()
    func setContinueButtonDisabled()
}
