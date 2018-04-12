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
        setupBeforeViewAppear()
        
        eventDataService.fetchEvents(then: { fetchedEvents in
            self.events = fetchedEvents
            let eventViewModels = fetchedEvents.map {
                EventCollectionCellViewModel(id: $0.id,
                                       title: $0.title,
                                       shortDate: self.dateFormatterService.formatDate(for: $0.dateInterval, shortVersion: true),
                                       longDate: self.dateFormatterService.formatDate(for: $0.dateInterval, shortVersion: false),
                                       image: $0.image)
            }
            self.view.setEvents(eventViewModels)
        })
    }
    
    func setupBeforeViewAppear(then completion: (() -> Void)? = nil) {
        let isListLayoutSelected = userSettingsService.fetchSettings().isListLayoutSelected
        if isListLayoutCurrent == isListLayoutSelected { return }
        isListLayoutCurrent = isListLayoutSelected
        view.setLayoutState(for: isListLayoutSelected)
        view.setupCollectionViewLayout(for: isListLayoutSelected)
        completion?()
    }
    
    func selectEvent(with eventId: Int) {
        selectedEventService.selectedEvent = events.first(where: { $0.id == eventId })
    }
}
