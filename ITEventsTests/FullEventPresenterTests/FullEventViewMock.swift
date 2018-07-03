@testable import ITEvents

class FullEventViewMock: IFullEventView, IFullEventViewMock {
    var eventViewCreated = false
    var showMoreEventsButtonCreated = false
    
    func createEventView(with event: EventViewModel, isSimilar: Bool) {
        eventViewCreated = true
    }
    
    func createShowMoreEventsButton(for eventsCount: Int) {
        showMoreEventsButtonCreated = true
    }
}
