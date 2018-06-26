import Foundation

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
    private var searchCancelation: Cancelation?
    
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
    
    @objc private func settingsChanged() {
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
            tagsStorage.fetchTags { tags in
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
        
        loadBatchEvents()
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
        loadBatchEvents()
    }
    
    private func loadBatchEvents() {
        view.showLoadingIndicator()
        
        _ = eventsStorage.searchEvents(indexRange: events.count..<events.count + 10,
                                       searchText: searchText,
                                       searchTags: searchTags,
                                       then: appendEvents)
    }
    
    private func clearViewEvents() {
        view.showLoadingIndicator()
        view.hideBackgroundView()
        view.clearEvents()
    }
    
    private func appendEvents(_ fetchedEvents: [Event], total: Int) {
        eventsTotal = total
        
        events.append(contentsOf: fetchedEvents)
        eventViewModels.append(contentsOf: fetchedEvents.map(createEventViewModel))
        
        view.hideLoadingIndicator()
        if eventViewModels.isEmpty { view.showBackgroundView() }
        view.setEvents(eventViewModels)
    }
    
    private func createEventViewModel(event: Event) -> EventCollectionCellViewModel {
        return EventCollectionCellViewModel(id: event.id,
                                            title: event.title,
                                            shortDate: self.dateFormatterService.formatDate(for: event.dateInterval, shortVersion: true),
                                            longDate: self.dateFormatterService.formatDate(for: event.dateInterval, shortVersion: false),
                                            image: event.image)
    }
}
