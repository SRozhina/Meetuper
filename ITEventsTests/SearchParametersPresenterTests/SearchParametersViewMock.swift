@testable import ITEvents

class SearchParametersViewMock: ISearchParametersView {
    var selectedTags: [Tag] = []
    var otherTags: [Tag] = []
    var fillCallsCount = 0

    func fill(with selectedTags: [Tag], otherTags: [Tag]) {
        fillCallsCount += 1
        self.selectedTags = selectedTags
        self.otherTags = otherTags
    }
}
