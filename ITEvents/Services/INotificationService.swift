import Foundation

protocol INotificationService {
    func post(name: Notification.Name)
    func addObserver(observer: Any, selector: Selector, name: Notification.Name)
}
