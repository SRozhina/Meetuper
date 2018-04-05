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
    
    func setup(then completion: @escaping () -> Void) {
        userSettingsService.fetchSettings { settings in
            self.userSettings = settings
        }
        eventDataService.fetchEvents { fetchedEvents in
            self.view.setEvents(fetchedEvents)
            completion()
        }
        view.toggleListLayout(to: userSettings.isListLayoutSelected)
    }
    
    func toggleLayoutState() {
        userSettings.isListLayoutSelected = !userSettings.isListLayoutSelected
        view.toggleListLayout(to: userSettings.isListLayoutSelected)
    }
    
    func selectEvent(_ event: Event) {
        selectedEventService.selectedEvent = event
    }
    
    func saveStateBeforeDisappear(isListLayoutSelected: Bool) {
        userSettings.isListLayoutSelected = isListLayoutSelected
        userSettingsService.save(settings: userSettings)
    }
}
