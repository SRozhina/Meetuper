import Foundation

class NotificationCenterService: INotificationService {
    let center = NotificationCenter.default
    
    func post(name: NotificationName) {
        center.post(name: Notification.Name(name.rawValue), object: nil)
    }
    
    func addObserver(observer: Any, selector: Selector, name: NotificationName) {
        //could change observer to self as out service has the same lifecycle as presenter
        center.addObserver(observer, selector: selector, name: Notification.Name(name.rawValue), object: nil)
    }
}
