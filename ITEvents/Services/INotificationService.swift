import Foundation

protocol INotificationService {
    func post(name: NotificationName)
    func addObserver(observer: Any, selector: Selector, name: NotificationName)
}
