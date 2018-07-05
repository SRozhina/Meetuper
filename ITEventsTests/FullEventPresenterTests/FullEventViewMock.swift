@testable import ITEvents

class FullEventViewMock: IFullEventView {
    var eventViewCreated = false
    var showMoreEventsButtonCreated = false
    var eventsCount = 0
    var createdViewCount = 0
    
    func createEventView(with event: EventViewModel, isSimilar: Bool) {
        eventViewCreated = true
        createdViewCount += 1
    }
    
    func createShowMoreEventsButton(for eventsCount: Int) {
        showMoreEventsButtonCreated = true
        self.eventsCount = eventsCount
    }
}
