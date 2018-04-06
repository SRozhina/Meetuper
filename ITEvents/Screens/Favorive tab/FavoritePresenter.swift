import Foundation

class FavoritePresenter: IFavoritePresenter {
    var view: IFavoriveView!
    var eventDataService: IEventsDataService!
    var selectedEventService: ISelectedEventService!
    var userSettingsService: IUserSettingsService!
    private var userSettings: UserSettings!
    
    init(view: IFavoriveView,
         eventDataService: IEventsDataService,
         selectedEventService: ISelectedEventService,
         userSettingsService: IUserSettingsService) {
        self.view = view
        self.eventDataService = eventDataService
        self.selectedEventService = selectedEventService
        self.userSettingsService = userSettingsService
    }
    
    func setup() {
        userSettings = userSettingsService.fetchSettings()
        self.view.toggleListLayout(to: userSettings.isListLayoutSelected)
        
        self.eventDataService.fetchEvents(then: { fetchedEvents in
            self.view.setEvents(fetchedEvents)
        })
    }
    
    func toggleLayoutState() {
        userSettings.isListLayoutSelected = !userSettings.isListLayoutSelected
        view.toggleListLayout(to: userSettings.isListLayoutSelected)
    }
    
    func selectEvent(_ event: Event) {
        selectedEventService.selectedEvent = event
    }
    
    func storeLayoutState() {
        userSettingsService.save(settings: userSettings)
    }
}
