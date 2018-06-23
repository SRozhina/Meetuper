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
    
    func parametersSelectionFinished() {
        searchParametersService.selectedTags = selectedTags
        searchParametersService.otherTags = otherTags
    }
    
    func setup() {
        selectedTags = searchParametersService.selectedTags
        otherTags = searchParametersService.otherTags
        view.fillTagListViews(with: selectedTags, otherTags: otherTags)
    }
    
    func removeTag(with title: String) {
        guard let tagIndex = selectedTags.firstIndex(where: { $0.name == title }) else { return }
        let removedTag = selectedTags.remove(at: tagIndex)
        otherTags.append(removedTag)
    }
    
    func selectTag(with title: String) {
        guard let tagIndex = otherTags.firstIndex(where: { $0.name == title }) else { return }
        let selectedTag = otherTags.remove(at: tagIndex)
        selectedTags.append(selectedTag)
    }
}
