protocol IFavoritePresenter {
    func setup(then completion: @escaping () -> Void)
    
    func changeLayoutState()
        
    func selectEvent(_ event: Event)
}
