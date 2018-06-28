import Foundation

protocol INotificationService {
    func post(name: String)
    func addObserver(observer: Any, selector: Selector, name: String)
}
