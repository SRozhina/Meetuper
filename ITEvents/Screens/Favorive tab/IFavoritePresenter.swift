protocol IFavoritePresenter {
    func setup()
    
    func toggleLayoutState()
    
    func selectEvent(with eventId: Int)
    
    func storeLayoutState()
}
