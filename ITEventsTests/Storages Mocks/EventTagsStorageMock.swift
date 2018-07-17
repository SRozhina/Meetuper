@testable import ITEvents
import Promises

class EventTagsStorageMock: IEventTagsStorage {
    var tags: [Tag] = []
    
    init(tags: [Tag] = []) {
        if !tags.isEmpty {
            self.tags = tags
            return
        }
        self.tags = [
            Tag(id: 1, name: "JavaScript"),
            Tag(id: 2, name: "iOS"),
            Tag(id: 3, name: "Android"),
            Tag(id: 4, name: "Python"),
            Tag(id: 5, name: "php"),
            Tag(id: 6, name: "Dart"),
            Tag(id: 7, name: "CSS"),
            Tag(id: 8, name: "Go"),
            Tag(id: 9, name: "Frontend")
        ]
    }
    
    func fetchTags() -> Promise<[Tag]> {
        return Promise(tags)
    }
}
