class FullEventPresenter: IFullEventPresenter {
    var selectedEventService: ISelectedEventService!
    var dateFormatterService: IDateFormatterService!
    var similarEventsService: ISimilarEventsStorage!
    var view: IFullEventView!
    private var event: Event!
    private var similarEvents: [Event]?
    
    init(view: IFullEventView,
         selectedEventService: ISelectedEventService,
         dateFormatterService: IDateFormatterService,
         similarEventsService: ISimilarEventsStorage) {
        self.selectedEventService = selectedEventService
        self.dateFormatterService = dateFormatterService
        self.similarEventsService = similarEventsService
        self.view = view
    }
    
    func setup() {
        event = selectedEventService.selectedEvent!
        let eventViewModel = createEventViewModel(from: event)
        view.createEventView(with: eventViewModel, isSimilar: false)
        if event.similarEventsCount == 0 { return }
        view.createShowMoreEventsButton(for: event.similarEventsCount)
    }
    
    func requestSimilarEvents(completion: @escaping () -> Void) {
        if similarEvents != nil {
            completion()
            return
        }
        
        similarEventsService.fetchSimilarEvents(for: event.id) { events in
            self.similarEvents = events
            if !events.isEmpty {
                self.createSimilarEventViews(from: events)
                completion()
            }
        }
    }
    
    private func createSimilarEventViews(from similarEvents: [Event]) {
        for similarEvent in similarEvents {
            let eventViewModel = createEventViewModel(from: similarEvent)
            self.view.createEventView(with: eventViewModel, isSimilar: true)
        }
    }
    
    private func createEventViewModel(from event: Event) -> EventViewModel {
        return EventViewModel(id: event.id,
                              title: event.title,
                              date: dateFormatterService.formatDate(for: event.dateInterval,
                                                                    shortVersion: false),
                              image: event.image,
                              address: event.address,
                              city: event.city,
                              country: event.country,
                              description: event.description,
                              tags: event.tags,
                              sourceName: event.source?.name,
                              url: event.url)
    }
}
