@testable import ITEvents

class FavoriteViewMock: IFavoriveView {
    var loadingIndicatorShownCount = 0
    var loadingIndicatorHidedCount = 0
    var setEventsCount = 0
    var eventViweModels: [EventCollectionCellViewModel] = []
    
    func setEvents(_ events: [EventCollectionCellViewModel]) {
        eventViweModels = events
        setEventsCount += 1
    }
    
    func toggleLayout(value isListLayout: Bool) {
        
    }
    
    func showLoadingIndicator() {
        loadingIndicatorShownCount += 1
    }
    
    func hideLoadingIndicator() {
        loadingIndicatorHidedCount += 1
    }
}
