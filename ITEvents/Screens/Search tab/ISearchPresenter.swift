protocol ISearchPresenter {
    func setup()
    
    func activate()
    
    func selectEvent(with eventId: Int)
        
    func loadEventsBlock(for text: String, tags: [Tag], isAdditional: Bool, then completion: (() -> Void)?)
}
