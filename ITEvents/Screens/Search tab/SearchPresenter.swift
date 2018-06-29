import Promises

extension Notification.Name {
    static let SearchSettingsChanged = Notification.Name("SEARCH_SETTINGS_CHANGED")
}

class SearchPresenter: ISearchPresenter {    
    let view: ISearchView!
    let eventsStorage: IEventsStorage!
    var selectedEventService: ISelectedEventService!
    let userSettingsService: IUserSettingsService!
    let dateFormatterService: IDateFormatterService!
    let tagsStorage: IEventTagsStorage!
    var searchParametersService: ISearchParametersService!
    private var events: [Event] = []
    private var eventViewModels: [EventCollectionCellViewModel] = []
    private var isListLayoutCurrent: Bool!
    private var searchEventsDebounced: ((Bool) -> Void)!
    private var searchText: String = ""
    private var searchTags: [Tag] = []
    private var eventsTotal = -1
    private var searchCancelation: Cancelable<EventsResult>?
    
    init(view: ISearchView,
         eventsStorage: IEventsStorage,
         selectedEventService: ISelectedEventService,
         userSettingsService: IUserSettingsService,
         dateFormatterService: IDateFormatterService,
         tagsStorage: IEventTagsStorage,
         searchParametersService: ISearchParametersService) {
        self.view = view
        self.eventsStorage = eventsStorage
        self.selectedEventService = selectedEventService
        self.userSettingsService = userSettingsService
        self.dateFormatterService = dateFormatterService
        self.tagsStorage = tagsStorage
        self.searchParametersService = searchParametersService
        
        searchEventsDebounced = debounce(
            delay: DispatchTimeInterval.seconds(1),
            queue: DispatchQueue.main,
            action: searchEvents
        )
    }
    
    func setup() {
        searchEvents()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(settingsChanged),
                                               name: .SearchSettingsChanged,
                                               object: nil)
    }
    
    @objc
    private func settingsChanged() {
        searchEvents(by: searchParametersService.selectedTags)
    }
    
    func activate() {
        //TODO implement notifying about layout changes when settings are ready
        let userSettings = userSettingsService.fetchSettings()
        view.toggleLayout(value: userSettings.isListLayoutSelected)
    }
    
    func selectEvent(with eventId: Int) {
        selectedEventService.selectedEvent = events.first { $0.id == eventId }
    }
    
    func prepareSearchParameters(completion: @escaping () -> Void) {
        let selectedTags = searchParametersService.selectedTags
        let otherTags = searchParametersService.otherTags
        if selectedTags.isEmpty && otherTags.isEmpty {
            tagsStorage.fetchTags().then { tags in
                self.searchParametersService.otherTags = tags
                completion()
            }
        } else {
            completion()
        }
        
    }

    func loadMoreEvents() {
        if eventsTotal == events.count {
            return
        }
        
        searchCancelation = loadBatchEvents()
    }
    
    func forceEventSearching() {
        clearViewEvents()
        searchEventsDebounced(false)
    }
    
    func searchEvents(by newSearchText: String) {
        if searchText == newSearchText { return }
        searchText = newSearchText
        clearViewEvents()
        searchEventsDebounced(true)
    }
    
    private func searchEvents(by newSearchTags: [Tag]) {
        if searchTags == newSearchTags { return }
        searchTags = newSearchTags
        clearViewEvents()
        searchEventsDebounced(true)
    }
    
    private func searchEvents() {
        events.removeAll()
        eventViewModels.removeAll()
        
        searchCancelation?.cancel()
        searchCancelation = loadBatchEvents()
    }
    
    private func loadBatchEvents() -> Cancelable<EventsResult> {
        view.showLoadingIndicator()
        
        let cancelablePromise = eventsStorage.searchEvents(indexRange: events.count..<events.count + 10,
                                                           searchText: searchText,
                                                           searchTags: searchTags)
        cancelablePromise.promise.then(appendEvents)
        
        return cancelablePromise
    }
    
    private func clearViewEvents() {
        view.showLoadingIndicator()
        view.hideBackgroundView()
        view.clearEvents()
    }
    
    private func appendEvents(_ eventsResult: EventsResult) {
        eventsTotal = eventsResult.totalEventsCount
        
        events.append(contentsOf: eventsResult.events)
        eventViewModels.append(contentsOf: eventsResult.events.map(createEventViewModel))
        
        view.hideLoadingIndicator()
        if eventsResult.events.isEmpty { view.showBackgroundView() }
        
        view.setEvents(self.eventViewModels)
        view.hideLoadingIndicator()
    }
    
    private func createEventViewModel(event: Event) -> EventCollectionCellViewModel {
        return EventCollectionCellViewModel(id: event.id,
                                            title: event.title,
                                            shortDate: self.dateFormatterService.formatDate(for: event.dateInterval, shortVersion: true),
                                            longDate: self.dateFormatterService.formatDate(for: event.dateInterval, shortVersion: false),
                                            image: event.image)
    }
}
