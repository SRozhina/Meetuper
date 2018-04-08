protocol IFullEventView {
    func createEventView(with event: EventViewModel, isSimilar: Bool)
    
    func createShowMoreEventsButton(for eventsCount: Int)
}
