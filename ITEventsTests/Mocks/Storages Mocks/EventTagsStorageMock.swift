@testable import ITEvents
import Promises

class EventTagsStorageMock: IEventTagsStorage {
    var tags: [Tag] = []
    
    init(tags: [Tag] = []) {
        self.tags = tags
    }
    
    func fetchTags() -> Promise<[Tag]> {
        return Promise(tags)
    }
}
