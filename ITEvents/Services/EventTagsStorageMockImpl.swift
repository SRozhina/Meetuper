import Foundation

class EventTagsStorageMockImpl: IEventTagsStorage {
    func fetchTags(then completion: @escaping ([Tag]) -> Void) {
        let tags = [
            Tag(id: 1, name: "JavaScript"),
            Tag(id: 2, name: "iOS"),
            Tag(id: 3, name: "Android"),
            Tag(id: 4, name: "Python"),
            Tag(id: 5, name: "php"),
            Tag(id: 6, name: "C#"),
            Tag(id: 7, name: "CSS"),
            Tag(id: 8, name: "Go")
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(tags)
        }
    }
}
