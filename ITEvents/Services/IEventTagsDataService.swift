import Foundation

protocol IEventTagsDataService {
    func fetchTags(then completion: @escaping ([Tag]) -> Void)
}
