@testable import ITEvents

class SearchParametersMockViewController: ISearchParametersView, ISearchParametersViewMock {
    var selectedTags: [Tag] = []
    var otherTags: [Tag] = []

    func fill(with selectedTags: [Tag], otherTags: [Tag]) {
        self.selectedTags = selectedTags
        self.otherTags = otherTags
    }
}
