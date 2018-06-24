import Foundation

class SearchParametersPresenter: ISearchParametersPresenter {
    let view: ISearchParametersView!
    var searchParametersService: ISearchParametersService!
    private var selectedTags: [Tag] = []
    private var otherTags: [Tag] = []
    
    init(view: ISearchParametersView,
         searchParametersService: ISearchParametersService) {
        self.view = view
        self.searchParametersService = searchParametersService
    }
    
    func saveSettings() {
        searchParametersService.selectedTags = selectedTags
        searchParametersService.otherTags = otherTags
        
        NotificationCenter.default.post(name: .SearchSettingsChanged, object: nil)
    }
    
    func setup() {
        selectedTags = searchParametersService.selectedTags
        otherTags = searchParametersService.otherTags
        view.fill(with: selectedTags, otherTags: otherTags)
    }
    
    func deselectTag(_ tag: Tag) {
        guard let tagIndex = selectedTags.firstIndex(of: tag) else { return }
        let removedTag = selectedTags.remove(at: tagIndex)
        otherTags.append(removedTag)
    }
    
    func selectTag(_ tag: Tag) {
        guard let tagIndex = otherTags.firstIndex(of: tag) else { return }
        let selectedTag = otherTags.remove(at: tagIndex)
        selectedTags.append(selectedTag)
    }
}
