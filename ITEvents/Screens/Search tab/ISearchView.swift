protocol ISearchView {
    func setupCollectionViewLayout(for isList: Bool)
    
    func setLayoutState(for isList: Bool)
    
    func setEvents(_ events: [EventCollectionCellViewModel])
}
