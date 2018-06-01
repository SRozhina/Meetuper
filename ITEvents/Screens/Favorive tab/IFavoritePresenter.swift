protocol IFavoritePresenter {
    func setup()
        
    func selectEvent(with eventId: Int)
    
    func activate()
    
    func loadMoreEvents()
}
