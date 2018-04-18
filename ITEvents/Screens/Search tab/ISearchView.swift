protocol ISearchView {    
    func toggleLayout(for isList: Bool)
    
    func setEvents(_ events: [EventCollectionCellViewModel])
    
    func insertEvents(_ fetchedEvents: [EventCollectionCellViewModel], at indexes: [Int])
}
