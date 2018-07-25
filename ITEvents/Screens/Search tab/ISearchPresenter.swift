protocol ISearchPresenter {
    func setup()
        
    func selectEvent(with eventId: Int)
    
    func loadMoreEvents()
    
    func searchEvents(by searchText: String)
    
    func activate()
    
    func prepareSearchParameters(completion: @escaping () -> Void)
}
