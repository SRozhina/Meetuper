protocol ISearchPresenter {
    func setup()
    
    func activate()
    
    func selectEvent(with eventId: Int)
    
    func searchEvents(by parameters: SearchParameters, isDelayNeeded: Bool)
}
