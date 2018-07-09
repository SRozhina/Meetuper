import XCTest
@testable import ITEvents

class SearchParametersServiceMock: ISearchParametersService {
    var selectedTags: [Tag] = []
    var otherTags: [Tag] = []
    
    func updateTags(selectedTags: [Tag], otherTags: [Tag]) {
        self.selectedTags = selectedTags
        self.otherTags = otherTags
    }
    
    func addTagsChangedObserver(_ observer: Any, selector: Selector) { }
}
