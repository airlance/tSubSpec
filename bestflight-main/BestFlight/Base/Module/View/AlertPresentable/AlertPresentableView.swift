import UIKit

protocol AlertPresentableView: class {
    func showError(title: String, text: String, actionText: String, actionHandler: (() -> Void)?)
    func showError(title: String, text: String, actionText: String)
}

extension AlertPresentableView where Self: UIViewController {

    func showError(title: String, text: String, actionText: String) {
        showError(title: title, text: text, actionText: actionText, actionHandler: nil)
    }

    func showError(title: String, text: String, actionText: String, actionHandler: (() -> Void)?) {
        let action = UIAlertAction(title: actionText, style: .default) { (_) in
            actionHandler?()
        }
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}
