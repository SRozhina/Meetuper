import Foundation

class FavoritePresenter: IFavoritePresenter {
    var view: IFavoriveView!
    var eventDataService: IEventsDataService!
    var selectedEventService: ISelectedEventService!
    var userSettingsService: IUserSettingsService!
    var dateFormatterService: IDateFormatterService!
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
        self.view.toggleListLayout(to: userSettings.isListLayoutSelected)
        
        self.eventDataService.fetchEvents(then: { fetchedEvents in
            self.events = fetchedEvents
            let eventViewModels = fetchedEvents.map({
                FavoriteEventViewModel(id: $0.id,
                                       title: $0.title,
                                       shortDate: self.dateFormatterService.formatDate(for: $0.dateInterval, shortVersion: true),
                                       longDate: self.dateFormatterService.formatDate(for: $0.dateInterval, shortVersion: false),
                                       image: $0.image)
            })
            self.view.setEvents(eventViewModels)
        })
    }
    
    func toggleLayoutState() {
        userSettings.isListLayoutSelected = !userSettings.isListLayoutSelected
        view.toggleListLayout(to: userSettings.isListLayoutSelected)
    }
    
    func selectEvent(with eventId: Int) {
        let eventIndex = events.index(where: {$0.id == eventId })!
        selectedEventService.selectedEvent = events[eventIndex]
    }
    
    func storeLayoutState() {
        userSettingsService.save(settings: userSettings)
    }
}
