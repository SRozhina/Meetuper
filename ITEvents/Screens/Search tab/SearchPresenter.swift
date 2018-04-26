import Foundation

class SearchPresenter: ISearchPresenter {
    let view: ISearchView!
    let eventDataService: IEventsStorage!
    var selectedEventService: ISelectedEventService!
    let userSettingsService: IUserSettingsService!
    let dateFormatterService: IDateFormatterService!
    private var events: [Event]!
    private var isListLayoutCurrent: Bool!
    
    init(view: ISearchView,
         eventDataService: IEventsStorage,
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
        
        eventDataService.fetchEvents(then: { fetchedEvents in
            self.events = fetchedEvents
            let eventCollectionCellViewModels = self.events.map { self.createEventCollectionCellViewModel(event: $0)}
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
    
    func searchEvents(by text: String, and tags: [Tag], isDelayNeeded: Bool) {
        eventDataService.searchEvents(by: text, and: tags, then: { fetchedEvents in
            self.events = fetchedEvents
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
