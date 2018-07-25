import XCTest
@testable import ITEvents

class SearchParametersServiceMock: ISearchParametersService {
    var selectedTags: [Tag] = []
    var otherTags: [Tag] = []
    
    private let notificationCenter = NotificationCenter()

    func updateTags(selectedTags: [Tag], otherTags: [Tag]) {
        self.selectedTags = selectedTags
        self.otherTags = otherTags
        
        notificationCenter.post(name: .TagsChangedInMock, object: nil)
    }
    
    func addTagsChangedObserver(_ observer: Any, selector: Selector) {
        notificationCenter.addObserver(observer, selector: selector, name: .TagsChangedInMock, object: nil)
    }
}

extension Notification.Name {
    fileprivate static let TagsChangedInMock = Notification.Name("TagsChangedInMock")
}
