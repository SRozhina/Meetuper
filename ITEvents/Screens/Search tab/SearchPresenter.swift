import Foundation

class SearchPresenter: ISearchPresenter {
    let view: ISearchView!
    let eventStorage: IEventsStorage!
    var selectedEventService: ISelectedEventService!
    let userSettingsService: IUserSettingsService!
    let dateFormatterService: IDateFormatterService!
    private var events: [Event]!
    private var isListLayoutCurrent: Bool!
    
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
    }
    
    func setup() {
        activate()
        
        eventStorage.fetchEvents(then: { fetchedEvents in
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
        eventStorage.searchEvents(by: text, and: tags, then: { fetchedEvents in
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
