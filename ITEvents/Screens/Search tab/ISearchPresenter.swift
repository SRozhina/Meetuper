protocol ISearchPresenter {
    func setup()
    
    func activate()
    
    func selectEvent(with eventId: Int)
    
    func searchBy(text: String, tags: [Tag])
    
    func loadEventsBlock(for text: String, tags: [Tag], then completion: @escaping () -> Void)
}
