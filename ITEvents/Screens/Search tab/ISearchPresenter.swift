protocol ISearchPresenter {
    func setup()
    
    func activate()
    
    func selectEvent(with eventId: Int)
    
    func searchEvents(by text: String, and tags: [Tag], isDelayNeeded: Bool)
    
    func loadEventsBlock(for text: String, tags: [Tag], then completion: @escaping () -> Void)
}
