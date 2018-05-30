import Foundation

class FavoritePresenter: IFavoritePresenter {
    let view: IFavoriveView!
    let eventStorage: IEventsStorage!
    var selectedEventService: ISelectedEventService!
    let userSettingsService: IUserSettingsService!
    let dateFormatterService: IDateFormatterService!
    private var userSettings: UserSettings!
    private var events: [Event] = []
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
        
        eventStorage.fetchFavoriteEvents(then: { fetchedEvents, total in
            self.events = fetchedEvents
            self.eventsTotal = total
            let eventViewModels = fetchedEvents.map(self.createViewModel)
            self.view.setEvents(eventViewModels)
        })
    }
    
    func selectEvent(with eventId: Int) {
        selectedEventService.selectedEvent = events.first(where: { $0.id == eventId })
    }
    
    func updateViewSettings() {
        let userSettings = userSettingsService.fetchSettings()
        view.toggleLayout(value: userSettings.isListLayoutSelected)
    }
    
    private func createViewModel(event: Event) -> EventCollectionCellViewModel {
        return EventCollectionCellViewModel(id: event.id,
                                            title: event.title,
                                            shortDate: self.dateFormatterService.formatDate(for: event.dateInterval, shortVersion: true),
                                            longDate: self.dateFormatterService.formatDate(for: event.dateInterval, shortVersion: false),
                                            image: event.image)
    }
}
