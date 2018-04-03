protocol IFavoritePresenter {
    func setup(then completion: @escaping () -> Void)
    
    func toggleLayoutState()
        
    func selectEvent(_ event: Event)
}
