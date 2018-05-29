protocol ISearchView {    
    
    func setEvents(_ events: [EventCollectionCellViewModel])
    
    func clearEvents()
    
    func toggleProgressIndicator(shown: Bool)
    
    func toggleLayout(value isListLayout: Bool)
}
