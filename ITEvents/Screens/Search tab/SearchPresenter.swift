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
        
        eventDataService.fetchFavoriteEvents(then: { fetchedEvents in
            self.events = fetchedEvents
            let eventCollectionCellViewModels = self.makeEventCollectionCellViewModelsFrom(events: self.events)
            self.view.setEvents(eventCollectionCellViewModels)
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
        if text == "" {
            eventDataService.fetchEvents(indexRange: 0..<20) { fetchedEvents in
                self.transfrom(fetchedEvents: fetchedEvents)
            }
            return
        }
        eventDataService.searchEvents(indexRange: 0..<20, text: text, tags: tags, then: { fetchedEvents in
            self.transfrom(fetchedEvents: fetchedEvents)
        })
        
    }
    
    private func transfrom(fetchedEvents: [Event]) {
        events = fetchedEvents
        let eventCollectionCellViewModels = makeEventCollectionCellViewModelsFrom(events: fetchedEvents)
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
