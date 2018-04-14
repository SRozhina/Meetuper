import UIKit

protocol ITabBarItemSelectable {
    func handleSelection()
}

class EventsTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let navigationController = viewController as? UINavigationController,
            let searchView  = navigationController.viewControllers.first as? ITabBarItemSelectable {
            searchView.handleSelection()
        }
        return true
    }
}
