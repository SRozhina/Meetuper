import Foundation

class SearchParametersService: ISearchParametersService {
    private let notificationCenter = NotificationCenter.default
    
    var selectedTags: [Tag] = []
    var otherTags: [Tag] = []
    
    func updateTags(selectedTags: [Tag], otherTags: [Tag]) {
        if self.selectedTags == selectedTags && self.otherTags == otherTags {
            return
        }
        
        self.selectedTags = selectedTags
        self.otherTags = otherTags
        
        notificationCenter.post(name: .TagsChanged, object: nil)
    }
    
    func addTagsChangedObserver(_ observer: Any, selector: Selector) {
        notificationCenter.addObserver(observer, selector: selector, name: .TagsChanged, object: nil)
    }
}

extension Notification.Name {
    public static let TagsChanged = Notification.Name("SearchParametersService_TagsChanged")
}
