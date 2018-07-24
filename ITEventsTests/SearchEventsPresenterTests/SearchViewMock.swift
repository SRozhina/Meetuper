@testable import ITEvents

class SearchViewMock: ISearchView {
    var loadingIndicatorShownCount = 0
    var loadingIndicatorHidedCount = 0
    var backgroundViewShownCount = 0
    var backgroundViewHidedCount = 0
    var toggleLayoutCallsCount = 0
    var setEventsCount = 0
    var eventsCleanedCount = 0
    var eventViweModels: [EventCollectionCellViewModel] = []
    
    func setEvents(_ events: [EventCollectionCellViewModel]) {
        eventViweModels = events
        setEventsCount += 1
    }
    
    func clearEvents() {
        eventViweModels = []
        eventsCleanedCount += 1
    }
    
    func showLoadingIndicator() { loadingIndicatorShownCount += 1 }
    
    func hideLoadingIndicator() { loadingIndicatorHidedCount += 1 }
    
    func showBackgroundView() { backgroundViewShownCount += 1 }
    
    func hideBackgroundView() { backgroundViewHidedCount += 1 }
    
    func toggleLayout(value isListLayout: Bool) { toggleLayoutCallsCount += 1 }
}
