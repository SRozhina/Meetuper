protocol ISearchPresenter {
    func setup()
        
    func selectEvent(with eventId: Int)
    
    func searchMoreEvents()
    
    func forceEventSearching()
    
    func searchEvents(by newSearchParameters: SearchParameters)
    
    func updateViewSettings()
}
