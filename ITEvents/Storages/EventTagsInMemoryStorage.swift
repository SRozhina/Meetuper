import Promises

class EventTagsInMemoryStorage: IEventTagsStorage {
    func fetchTags() -> Promise<[Tag]> {
        let tags = [
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
        return Promise<[Tag]> { fulfill, _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                fulfill(tags)
            }
        }
        
    }
}
