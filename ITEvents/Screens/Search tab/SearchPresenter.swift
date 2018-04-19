import Foundation

class SearchPresenter: ISearchPresenter {    
    let view: ISearchView!
    let eventDataService: IEventsDataService!
    var selectedEventService: ISelectedEventService!
    let userSettingsService: IUserSettingsService!
    let dateFormatterService: IDateFormatterService!
    private var events: [Event]!
    private var isListLayoutCurrent: Bool!
    private var fetchEventsDebounced: ((String, [Tag], Bool) -> Void)!
    
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
        
        //        eventDataService.fetchEvents(then: { fetchedEvents in
        //            let eventCollectionCellViewModels = self.events.map { self.createEventCollectionCellViewModel(event: $0)}
        //            self.events = fetchedEvents
        //            self.view.setEvents(eventCollectionCellViewModels)
        //        }
        eventDataService.fetchEvents(indexRange: 0..<10, then: { fetchedEvents in
            self.handleNewFetchedEvents(fetchedEvents, isAdditional: false)
        })
    }
    
    func activate() {
        let settings = userSettingsService.fetchSettings()
        if isListLayoutCurrent == settings.isListLayoutSelected { return }
        isListLayoutCurrent = settings.isListLayoutSelected
        view.toggleLayout(for: settings.isListLayoutSelected)
        fetchEventsDebounced = debounce(
            delay: DispatchTimeInterval.seconds(2),
            queue: DispatchQueue.main,
            action: searchEvents
        )
    }
    
    func selectEvent(with eventId: Int) {
        selectedEventService.selectedEvent = events.first(where: { $0.id == eventId })
    }
    
    func searchEvents(by text: String, and tags: [Tag], isDelayNeeded: Bool) {
        //        eventDataService.searchEvents(by: text, and: tags, then: { fetchedEvents in
        //            self.events = fetchedEvents
        //            let eventCollectionCellViewModels = self.events.map { self.createEventCollectionCellViewModel(event: $0)}
        //            self.view.setEvents(eventCollectionCellViewModels)
        //        }
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
    
    private func createEventCollectionCellViewModel(event: Event) -> EventCollectionCellViewModel {
        return EventCollectionCellViewModel(id: event.id,
                                            title: event.title,
                                            shortDate: self.dateFormatterService.formatDate(for: event.dateInterval, shortVersion: true),
                                            longDate: self.dateFormatterService.formatDate(for: event.dateInterval, shortVersion: false),
                                            image: event.image)
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
        let eventCollectionCellViewModels = events.map { self.createEventCollectionCellViewModel(event: $0)}
        view.setEvents(eventCollectionCellViewModels)
    }
}
