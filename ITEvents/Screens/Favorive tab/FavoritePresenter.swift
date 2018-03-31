import Foundation

class FavoritePresenter: IFavoritePresenter {
    var view: IFavoriveView!
    var eventDataService: IEventsDataService!
    var selectedEventService: ISelectedEventService!
    private var isListLayout = true
    
    init(view: IFavoriveView,
         eventDataService: IEventsDataService,
         selectedEventService: ISelectedEventService) {
        self.view = view
        self.eventDataService = eventDataService
        self.selectedEventService = selectedEventService
    }
    
    func setup(then completion: @escaping () -> Void) {
        eventDataService.fetchEvents { fetchedEvents in
            self.view.setEvents(fetchedEvents)
            completion()
        }
        view.setButtonRotation(to: isListLayout)
        view.setLayoutState(to: isListLayout)
    }
    
    func changeLayoutState() {
        isListLayout = !isListLayout
        view.setLayoutState(to: isListLayout)
        view.setButtonRotation(to: isListLayout)
    }
    
    func selectEvent(_ event: Event) {
        selectedEventService.selectedEvent = event
    }
    
}
