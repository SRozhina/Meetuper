import Foundation

class SearchPresenter: ISearchPresenter {    
    let view: ISearchView!
    let eventStorage: IEventsStorage!
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
    private var searchCancelation: Cancelation?
    
    init(view: ISearchView,
         eventStorage: IEventsStorage,
         selectedEventService: ISelectedEventService,
         userSettingsService: IUserSettingsService,
         dateFormatterService: IDateFormatterService) {
        self.view = view
        self.eventStorage = eventStorage
        self.selectedEventService = selectedEventService
        self.userSettingsService = userSettingsService
        self.dateFormatterService = dateFormatterService
        
        searchEventsDebounced = debounce(
            delay: DispatchTimeInterval.seconds(2),
            queue: DispatchQueue.main,
            action: searchEventDebouncedAction
        )
    }
    
    func setup() {
        updateViewSettings()
        searchEventDebouncedAction()
    }
    
    func updateViewSettings() {
        let userSettings = userSettingsService.fetchSettings()
        view.toggleLayout(value: userSettings.isListLayoutSelected)
    }
    
    func selectEvent(with eventId: Int) {
        selectedEventService.selectedEvent = events.first { $0.id == eventId }
    }

    func searchMoreEvents() {
        if eventsTotal == events.count {
            return
        }
        
        view.toggleProgressIndicator(shown: true)
        
        _ = eventStorage.searchEvents(indexRange: events.count..<events.count + 10,
                                  searchText: searchText,
                                  searchTags: searchTags,
                                  then: self.appendFoundEvents)
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
        
        searchCancelation?.cancel()
        searchCancelation = eventStorage.searchEvents(indexRange: 0..<10,
                                                      searchText: searchText,
                                                      searchTags: searchTags,
                                                      then: self.appendFoundEvents)
    }
    
    private func appendFoundEvents(_ fetchedEvents: [Event], total: Int) {
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
