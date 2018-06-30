import Foundation

protocol ISearchParametersService {
    var selectedTags: [Tag] { get }
    var otherTags: [Tag] { get }
    
    func updateTags(selectedTags: [Tag], otherTags: [Tag])
    func addTagsChangedObserver(_ observer: Any, selector: Selector)
}
