import Foundation

class NotificationCenterService: INotificationService {
    private let center = NotificationCenter.default
    
    func post(name: Notification.Name) {
        center.post(name: name, object: nil)
    }
    
    func addObserver(observer: Any, selector: Selector, name: Notification.Name) {
        center.addObserver(observer, selector: selector, name: name, object: nil)
    }
}
