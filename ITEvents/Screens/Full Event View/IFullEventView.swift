protocol IFullEventView {
    func createEventView(with event: Event, using dateFormatterService: IDateFormatterService, isSimilar: Bool)
    func createAddShowMoreEventsButton(for eventsCount: Int)
    
}
