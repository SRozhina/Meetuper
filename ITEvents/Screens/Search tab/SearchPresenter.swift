import Foundation

class SearchPresenter: ISearchPresenter {    
    let view: ISearchView!
    let eventDataService: IEventsDataService!
    var selectedEventService: ISelectedEventService!
    let userSettingsService: IUserSettingsService!
    let dateFormatterService: IDateFormatterService!
    private var events: [Event] = []
    private var eventViewModels: [EventCollectionCellViewModel] = []
    private var isListLayoutCurrent: Bool!
    private var searchEventsDebounced: ((Bool) -> Void)!
    private var searchText: String = ""
    private var searchTags: [Tag] = []
    private var eventsTotal = 0
    
    init(view: ISearchView,
         eventDataService: IEventsDataService,
         selectedEventService: ISelectedEventService,
         userSettingsService: IUserSettingsService,
         dateFormatterService: IDateFormatterService) {
        self.view = view
        self.eventDataService = eventDataService
        self.selectedEventService = selectedEventService
        self.userSettingsService = userSettingsService
        self.dateFormatterService = dateFormatterService
        
        //TODO implement request cancelation
        searchEventsDebounced = debounce(
            delay: DispatchTimeInterval.seconds(2),
            queue: DispatchQueue.main,
            action: searchEventDebouncedAction
        )
    }
    
    func setup() {
        searchEventDebouncedAction()
    }
    
    func selectEvent(with eventId: Int) {
        selectedEventService.selectedEvent = events.first { $0.id == eventId }
    }

    func searchMoreEvents() {
        if eventsTotal == events.count {
            return
        }
        
        view.toggleProgressIndicator(shown: true)
        
        eventDataService.searchEvents(indexRange: events.count..<events.count + 10,
                                      searchText: searchText,
                                      searchTags: searchTags,
                                      then: { self.eventSearchCompletedAction($0, total: $1) })
    }
    
    func forceEventSearching() {
        view.clearEvents()
        searchEventsDebounced(false)
    }
    
    func searchEvents(by newSearchText: String, and newSearchTags: [Tag]) {
        searchText = newSearchText
        searchTags = newSearchTags
        view.clearEvents()
        searchEventsDebounced(true)
    }
    
    private func searchEventDebouncedAction() {
        view.toggleProgressIndicator(shown: true)
        
        events.removeAll()
        eventViewModels.removeAll()
         
        eventDataService.searchEvents(indexRange: 0..<10,
                                      searchText: searchText,
                                      searchTags: searchTags,
                                      then: { self.eventSearchCompletedAction($0, total: $1) })
    }
    
    private func eventSearchCompletedAction(_ fetchedEvents: [Event], total: Int) {
        self.eventsTotal = total
        
        self.events.append(contentsOf: fetchedEvents)
        self.eventViewModels.append(contentsOf: fetchedEvents.map(self.createEventViewModel))
        
        self.view.setEvents(self.eventViewModels)
        self.view.toggleProgressIndicator(shown: false)
    }
    
    private func createEventViewModel(event: Event) -> EventCollectionCellViewModel {
        return EventCollectionCellViewModel(id: event.id,
                                            title: event.title,
                                            shortDate: self.dateFormatterService.formatDate(for: event.dateInterval, shortVersion: true),
                                            longDate: self.dateFormatterService.formatDate(for: event.dateInterval, shortVersion: false),
                                            image: event.image)
    }
}
