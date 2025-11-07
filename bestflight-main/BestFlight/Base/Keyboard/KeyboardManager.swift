import UIKit

protocol KeyboardManagerDelegate: class {
    func keyboardWillShow(_ manager: KeyboardManager, frame: CGRect, animationDuration: TimeInterval)
    func keyboardWillHide(_ manager: KeyboardManager, animationDuration: TimeInterval)
    func keyboardWillChangeFrame(_ manager: KeyboardManager, frame: CGRect)
}

extension KeyboardManagerDelegate {
    func keyboardWillShow(_ manager: KeyboardManager, frame: CGRect, animationDuration: TimeInterval) {}
    func keyboardWillHide(_ manager: KeyboardManager, animationDuration: TimeInterval) {}
    func keyboardWillChangeFrame(_ manager: KeyboardManager, frame: CGRect) {}
}

final class KeyboardManager {

    // MARK: Properties

    weak var delegate: KeyboardManagerDelegate?

    // MARK: Initialization

    init() {
        setupKeyboardObservers()
    }

    private func setupKeyboardObservers() {
        let center = NotificationCenter.default
        center.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        center.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        center.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    private func obtainKeyboardAnimationDuration(from notification: Notification) -> TimeInterval {
        guard let durationValue = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return .zero
        }
        return TimeInterval(durationValue.doubleValue)
    }

    private func obtainKeyboardFrame(from notification: Notification) -> CGRect {
        guard let frameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return .zero
        }
        return frameValue.cgRectValue
    }
}

// MARK: - Handlers

private extension KeyboardManager {
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardFrame = obtainKeyboardFrame(from: notification)
        let animationDuration = obtainKeyboardAnimationDuration(from: notification)
        delegate?.keyboardWillShow(self, frame: keyboardFrame, animationDuration: animationDuration)
    }

    @objc func keyboardWillHide(notification: Notification) {
        let animationDuration = obtainKeyboardAnimationDuration(from: notification)
        delegate?.keyboardWillHide(self, animationDuration: animationDuration)
    }

    @objc func keyboardWillChangeFrame(notification: Notification) {
        let keyboardFrame = obtainKeyboardFrame(from: notification)
        delegate?.keyboardWillChangeFrame(self, frame: keyboardFrame)
    }
}
