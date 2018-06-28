import Foundation

class SearchParametersPresenter: ISearchParametersPresenter {
    let view: ISearchParametersView!
    var searchParametersService: ISearchParametersService!
    let notificationService: INotificationService!
    private var selectedTags: [Tag] = []
    private var otherTags: [Tag] = []
    
    init(view: ISearchParametersView,
         searchParametersService: ISearchParametersService,
         notificationService: INotificationService) {
        self.view = view
        self.searchParametersService = searchParametersService
        self.notificationService = notificationService
    }
    
    func saveSettings() {
        //Maybe add check if tags were changed then only post notification and remove this check from presenter
        searchParametersService.selectedTags = selectedTags.sorted { $0.name < $1.name }
        searchParametersService.otherTags = otherTags.sorted { $0.name < $1.name }
        
        notificationService.post(name: "SearchSettingsChanged")
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
