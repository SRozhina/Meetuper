class FullEventPresenter: IFullEventPresenter {
    var selectedEventService: ISelectedEventService!
    var dateFormatterService: IDateFormatterService!
    var similarEventsService: ISimilarEventsDataService!
    var view: IFullEventView!
    private var event: Event!
    private var similarEvents: [Event]?
    
    init(view: IFullEventView,
         selectedEventService: ISelectedEventService,
         dateFormatterService: IDateFormatterService,
         similarEventsService: ISimilarEventsDataService) {
        self.selectedEventService = selectedEventService
        self.dateFormatterService = dateFormatterService
        self.similarEventsService = similarEventsService
        self.view = view
    }
    
    func setup() {
        event = selectedEventService.selectedEvent!
        view.createEventView(with: event, using: dateFormatterService, isSimilar: false)
        if event.similarEventsCount == 0 { return }
        view.createAddShowMoreEventsButton(for: event.similarEventsCount)
    }
    
    func updateSimilarEvents(completion: @escaping () -> Void) {
        if similarEvents != nil {
            completion()
            return
        }
        
        similarEventsService.fetchSimilarEvents(for: event.id) { events in
            self.similarEvents = events
            if let similarEvents = self.similarEvents, !similarEvents.isEmpty {
                self.createSimilarEventViews()
                completion()
            }
        }
    }
    
    private func createSimilarEventViews() {
        for similarEvent in similarEvents! {
            self.view.createEventView(with: similarEvent, using: self.dateFormatterService, isSimilar: true)
        }
    }
}
