import Promises

protocol IEventTagsStorage {
    func fetchTags() -> Promise<[Tag]>
}
