protocol IFavoritePresenter {
    func setup(then completion: @escaping () -> Void)
    
    func changeLayoutState()
    
    func setup(cell: EventCollectionViewCell, event: Event)
    
    func saveSelectedEvent(_ event: Event)
}
