import Foundation

class SearchPresenter: ISearchPresenter {    
    let view: ISearchView!
    let eventDataService: IEventsDataService!
    var selectedEventService: ISelectedEventService!
    let userSettingsService: IUserSettingsService!
    let dateFormatterService: IDateFormatterService!
    private var events: [Event] = []
    private var isListLayoutCurrent: Bool!
    private var searchEventsDebounced: ((SearchParameters, Bool) -> Void)!
    private var searchText: String = ""
    
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
        activate()
        let parameters = SearchParameters(text: "", tags: [])
        searchEventDebouncedAction(by: parameters)
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
    
    func searchEvents(by parameters: SearchParameters, isDelayNeeded: Bool) {
        searchEventsDebounced(parameters, isDelayNeeded)
    }
    
    private func searchEventDebouncedAction(by parameters: SearchParameters) {
        if searchText != parameters.text {
            events.removeAll()
            searchText = parameters.text
        }
        let range: Range<Int> = events.count..<events.count + 10
        eventDataService.searchEvents(indexRange: range, parameters: parameters, then: { fetchedEvents in
            self.events.append(contentsOf: fetchedEvents)
            //Could change the code to appent (not replace) events in View so we will create less models?
            let eventCollectionCellViewModels = self.events.map { self.createEventCollectionCellViewModel(event: $0)}
            self.view.setEvents(eventCollectionCellViewModels)
        })
    }
    
    private func createEventCollectionCellViewModel(event: Event) -> EventCollectionCellViewModel {
        return EventCollectionCellViewModel(id: event.id,
                                            title: event.title,
                                            shortDate: self.dateFormatterService.formatDate(for: event.dateInterval, shortVersion: true),
                                            longDate: self.dateFormatterService.formatDate(for: event.dateInterval, shortVersion: false),
                                            image: event.image)
    }
}
