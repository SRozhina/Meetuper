import Foundation

class FavoritePresenter: IFavoritePresenter {
    let view: IFavoriveView!
    let eventStorage: IEventsStorage!
    var selectedEventService: ISelectedEventService!
    let userSettingsService: IUserSettingsService!
    let dateFormatterService: IDateFormatterService!
    private var userSettings: UserSettings!
    private var events: [Event] = []
    private var eventViewModels: [EventCollectionCellViewModel] = []
    private var eventsTotal = 0
    
    init(view: IFavoriveView,
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
        updateViewSettings()
        
        eventStorage.fetchFavoriteEvents(indexRange: 0..<10, then: appendEvents)
    }
    
    func selectEvent(with eventId: Int) {
        selectedEventService.selectedEvent = events.first(where: { $0.id == eventId })
    }
    
    func updateViewSettings() {
        let userSettings = userSettingsService.fetchSettings()
        view.toggleLayout(value: userSettings.isListLayoutSelected)
    }
    
    func loadMoreEvents() {
        if eventsTotal == events.count {
            return
        }
        
        view.toggleProgressIndicator(shown: true)
        
        eventStorage.fetchFavoriteEvents(indexRange: events.count..<events.count + 10,
                                         then: self.appendEvents)
    }
    
    private func appendEvents(_ fetchedEvents: [Event], total: Int) {
        self.eventsTotal = total
        
        self.events.append(contentsOf: fetchedEvents)
        self.eventViewModels.append(contentsOf: fetchedEvents.map(createEventViewModel))
        
        self.view.setEvents(self.eventViewModels)
        self.view.toggleProgressIndicator(shown: false)
    }
    
    private func createEventViewModel(event: Event) -> EventCollectionCellViewModel {
        return EventCollectionCellViewModel(id: event.id,
                                            title: event.title,
                                            shortDate: self.dateFormatterService.formatDate(for: event.dateInterval, shortVersion: true),
                                            longDate: self.dateFormatterService.formatDate(for: event.dateInterval, shortVersion: false),
                                            image: event.image)
    }
}
