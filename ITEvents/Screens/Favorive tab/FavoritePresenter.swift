import Foundation

class FavoritePresenter: IFavoritePresenter {
    var view: IFavoriveView!
    var eventDataService: IEventsDataService!
    var selectedEventService: ISelectedEventService!
    private var isListLayoutSelected = true
    
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
        view.toggleListLayout(to: isListLayoutSelected)
    }
    
    func toggleLayoutState() {
        isListLayoutSelected = !isListLayoutSelected
        view.toggleListLayout(to: isListLayoutSelected)
    }
    
    func selectEvent(_ event: Event) {
        selectedEventService.selectedEvent = event
    }
    
}
