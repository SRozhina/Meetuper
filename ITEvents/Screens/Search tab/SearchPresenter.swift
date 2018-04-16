class SearchPresenter: ISearchPresenter {
    let view: ISearchView!
    let eventDataService: IEventsDataService!
    var selectedEventService: ISelectedEventService!
    let userSettingsService: IUserSettingsService!
    let dateFormatterService: IDateFormatterService!
    private var events: [Event]!
    private var isListLayoutCurrent: Bool!
    
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
    }
    
    func setup() {
        activate()
        
        eventDataService.fetchEvents(indexRange: 0..<10, then: { fetchedEvents in
            self.handleNewFetchedEvents(fetchedEvents, isAdditional: false)
        })
    }
    
    func activate() {
        let settings = userSettingsService.fetchSettings()
        if isListLayoutCurrent == settings.isListLayoutSelected { return }
        isListLayoutCurrent = settings.isListLayoutSelected
        view.toggleLayout(for: settings.isListLayoutSelected)
    }
    
    func selectEvent(with eventId: Int) {
        selectedEventService.selectedEvent = events.first(where: { $0.id == eventId })
    }
    
    func searchBy(text: String, tags: [Tag]) {
        if text == "" && tags.isEmpty {
            eventDataService.fetchEvents(indexRange: 0..<10) { fetchedEvents in
                self.handleNewFetchedEvents(fetchedEvents, isAdditional: false)
            }
            return
        }
        eventDataService.searchEvents(indexRange: 0..<10, text: text, tags: tags, then: { fetchedEvents in
            self.handleNewFetchedEvents(fetchedEvents, isAdditional: false)
        })
        
    }
    
    func loadEventsBlock(for text: String, tags: [Tag], then completion: @escaping () -> Void) {
        let range: Range<Int> = events.count..<events.count + 10
        if text == "" && tags.isEmpty {
            eventDataService.fetchEvents(indexRange: range) { fetchedEvents in
                self.handleNewFetchedEvents(fetchedEvents, isAdditional: true)
                completion()
            }
            return
        }
        eventDataService.searchEvents(indexRange: range, text: text, tags: tags, then: { fetchedEvents in
            self.handleNewFetchedEvents(fetchedEvents, isAdditional: true)
            completion()
        })
    }
    
    private func handleNewFetchedEvents(_ fetchedEvents: [Event], isAdditional: Bool) {
        if isAdditional {
            events.append(contentsOf: fetchedEvents)
        } else {
            events = fetchedEvents
        }
        let eventCollectionCellViewModels = makeEventCollectionCellViewModelsFrom(events: events)
        view.setEvents(eventCollectionCellViewModels)
    }
    
    private func makeEventCollectionCellViewModelsFrom(events: [Event]) -> [EventCollectionCellViewModel] {
        return events.map {
            EventCollectionCellViewModel(id: $0.id,
                                         title: $0.title,
                                         shortDate: self.dateFormatterService.formatDate(for: $0.dateInterval, shortVersion: true),
                                         longDate: self.dateFormatterService.formatDate(for: $0.dateInterval, shortVersion: false),
                                         image: $0.image)
        }
    }
}
