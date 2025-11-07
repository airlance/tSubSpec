import UIKit

class NavigationController: UINavigationController {

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        navigationBar.isTranslucent = false
    }
}
