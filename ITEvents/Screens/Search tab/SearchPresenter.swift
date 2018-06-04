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
    private var eventsTotal = -1
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
        searchEventDebouncedAction()
    }
    
    func activate() {
        //TODO implement notifying about layout changes when settings are ready
        let userSettings = userSettingsService.fetchSettings()
        view.toggleLayout(value: userSettings.isListLayoutSelected)
    }
    
    func selectEvent(with eventId: Int) {
        selectedEventService.selectedEvent = events.first { $0.id == eventId }
    }

    func loadMoreEvents() {
        if eventsTotal == events.count {
            return
        }
        
        loadBatchEvents()
    }
    
    func forceEventSearching() {
        clearViewEvents()
        searchEventsDebounced(false)
    }
    
    func searchEvents(by newSearchText: String, and newSearchTags: [Tag]) {
        searchText = newSearchText
        searchTags = newSearchTags
        clearViewEvents()
        searchEventsDebounced(true)
    }
    
    private func searchEventDebouncedAction() {
        
        events.removeAll()
        eventViewModels.removeAll()
        
        searchCancelation?.cancel()
        loadBatchEvents()
    }
    
    private func loadBatchEvents() {
        view.showLoadingIndicator()
        
        _ = eventStorage.searchEvents(indexRange: events.count..<events.count + 10,
                                      searchText: searchText,
                                      searchTags: searchTags,
                                      then: appendEvents)
    }
    
    private func clearViewEvents() {
        view.showLoadingIndicator()
        view.clearEvents()
    }
    
    private func appendEvents(_ fetchedEvents: [Event], total: Int) {
        self.eventsTotal = total
        
        self.events.append(contentsOf: fetchedEvents)
        self.eventViewModels.append(contentsOf: fetchedEvents.map(createEventViewModel))
        
        self.view.setEvents(self.eventViewModels)
        self.view.hideLoadingIndicator()
    }
    
    private func createEventViewModel(event: Event) -> EventCollectionCellViewModel {
        return EventCollectionCellViewModel(id: event.id,
                                            title: event.title,
                                            shortDate: self.dateFormatterService.formatDate(for: event.dateInterval, shortVersion: true),
                                            longDate: self.dateFormatterService.formatDate(for: event.dateInterval, shortVersion: false),
                                            image: event.image)
    }
}
