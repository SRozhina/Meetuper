class SearchParametersService: ISearchParametersService {
    var selectedTags: [Tag] = [] {
        didSet {
            selectedTags = selectedTags.sorted { $0.name < $1.name }
        }
    }
    var otherTags: [Tag] = [] {
        didSet {
            otherTags = otherTags.sorted { $0.name < $1.name }
        }
    }
}
