protocol ISearchPresenter {
    func setup()
    
    func activate()
    
    func selectEvent(with eventId: Int)
    
    func searchBy(text: String, tags: [Tag])
}
