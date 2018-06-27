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
    private var eventsTotal = -1
    //TODO implement service
    private var favoriteTags: [Tag] = []
    
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
        loadBatchEvents()
    }
    
    func selectEvent(with eventId: Int) {
        selectedEventService.selectedEvent = events.first(where: { $0.id == eventId })
    }
    
    func activate() {
        //TODO implement notifying about layout changes when settings are ready
        let userSettings = userSettingsService.fetchSettings()
        view.toggleLayout(value: userSettings.isListLayoutSelected)
    }
    
    func loadMoreEvents() {
        if eventsTotal == events.count {
            return
        }
        
        loadBatchEvents()
    }
    
    private func loadBatchEvents() {
        view.showLoadingIndicator()
        
        eventStorage.searchEvents(indexRange: events.count..<events.count + 10,
                                      searchText: "",
                                      searchTags: favoriteTags)
            .promise.then(appendEvents)
    }
    
    private func appendEvents(_ eventsResult: EventsResult) {
        eventsTotal = eventsResult.totalEventsCount
        
        events.append(contentsOf: eventsResult.events)
        eventViewModels.append(contentsOf: eventsResult.events.map(createEventViewModel))
        
        view.setEvents(eventViewModels)
        view.hideLoadingIndicator()
    }
    
    private func createEventViewModel(event: Event) -> EventCollectionCellViewModel {
        return EventCollectionCellViewModel(id: event.id,
                                            title: event.title,
                                            shortDate: dateFormatterService.formatDate(for: event.dateInterval, shortVersion: true),
                                            longDate: dateFormatterService.formatDate(for: event.dateInterval, shortVersion: false),
                                            image: event.image)
    }
}
