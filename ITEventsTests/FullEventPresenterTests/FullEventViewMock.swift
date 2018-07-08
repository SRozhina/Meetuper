@testable import ITEvents

class FullEventViewMock: IFullEventView {
    var showMoreEventsButtonCount = 0
    var similarEventsCount = 0
    var createdViewsCount = 0
    var eventViewModel: EventViewModel!
    
    func createEventView(with event: EventViewModel, isSimilar: Bool) {
        eventViewModel = event
        createdViewsCount += 1
    }
    
    func createShowMoreEventsButton(for eventsCount: Int) {
        showMoreEventsButtonCount += 1
        self.similarEventsCount = eventsCount
    }
}
