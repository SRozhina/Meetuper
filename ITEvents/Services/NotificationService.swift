import Foundation

class NotificationCenterService: INotificationService {
    let center = NotificationCenter.default
    
    func post(name: String) {
        center.post(name: Notification.Name(name), object: nil)
    }
    
    func addObserver(observer: Any, selector: Selector, name: String) {
        center.addObserver(observer, selector: selector, name: Notification.Name(name), object: nil)
    }
}
