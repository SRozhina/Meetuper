@testable import ITEvents

class FullEventViewMock: IFullEventView {
    var showMoreEventsButtonCount = 0
    var similarEventsViewsCount = 0
    var createdViewsCount = 0
    var eventViewModel: EventViewModel!
    
    func createEventView(with event: EventViewModel, isSimilar: Bool) {
        if isSimilar {
            similarEventsViewsCount += 1
        } else {
            createdViewsCount += 1
        }
        eventViewModel = event
    }
    
    func createShowMoreEventsButton(for eventsCount: Int) {
        showMoreEventsButtonCount += 1
    }
}
