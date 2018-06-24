protocol ISearchPresenter {
    func setup()
        
    func selectEvent(with eventId: Int)
    
    func loadMoreEvents()
    
    func forceEventSearching()
    
    func searchEvents(by searchText: String)
    
    func activate()
    
    func prepareSearchParameters(completion: @escaping () -> Void)
}
