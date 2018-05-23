protocol ISearchView {    
    
    func setEvents(_ events: [EventCollectionCellViewModel])
    
    func clearEvents()
    
    func toggleProgressIndicator(shown: Bool)
    
    func setLayout(to isListLayout: Bool)
}
