import Foundation

protocol IEventTagsStorage {
    func fetchTags(then completion: @escaping ([Tag]) -> Void)
}
