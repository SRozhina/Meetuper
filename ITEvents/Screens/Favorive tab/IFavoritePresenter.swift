protocol IFavoritePresenter {
    func setup()
    
    func toggleLayoutState()
    
    func selectEvent(_ event: Event)
    
    func storeLayoutState()
}
