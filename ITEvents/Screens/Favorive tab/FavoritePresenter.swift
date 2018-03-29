import Foundation

class FavoritePresenter: IFavoritePresenter {
    var view: IFavoriveView!
    var eventDataService: IEventsDataService!
    var dateFormatterService: IDateFormatterService!
    var selectedEventService: ISelectedEventService!
    private var isListLayout = true
    
    init(view: IFavoriveView,
         eventDataService: IEventsDataService,
         dateFormatterService: IDateFormatterService,
         selectedEventService: ISelectedEventService) {
        self.view = view
        self.eventDataService = eventDataService
        self.dateFormatterService = dateFormatterService
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
    
    func setup(cell: EventCollectionViewCell, event: Event) {
        view.setup(cell: cell, withLayout: isListLayout, event: event, dateFormatterService: dateFormatterService)
    }
    
    func saveSelectedEvent(_ event: Event) {
        selectedEventService.selectedEvent = event
    }
    
}
