import Foundation

class FavoritePresenter: IFavoritePresenter {
    let view: IFavoriveView!
    let eventDataService: IEventsDataService!
    var selectedEventService: ISelectedEventService!
    let userSettingsService: IUserSettingsService!
    let dateFormatterService: IDateFormatterService!
    private var userSettings: UserSettings!
    private var events: [Event]!
    
    init(view: IFavoriveView,
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
        userSettings = userSettingsService.fetchSettings()
        view.toggleListLayout(to: userSettings.isListLayoutSelected)
        
        eventDataService.fetchFavoriteEvents(then: { fetchedEvents in
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
    
    func toggleLayoutState() {
        userSettings.isListLayoutSelected = !userSettings.isListLayoutSelected
        view.toggleListLayout(to: userSettings.isListLayoutSelected)
        userSettingsService.save(settings: userSettings)
    }
    
    func selectEvent(with eventId: Int) {
        selectedEventService.selectedEvent = events.first(where: { $0.id == eventId })
    }
}
