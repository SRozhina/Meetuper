protocol ISearchView {    
    
    func setEvents(_ events: [EventCollectionCellViewModel])
    
    func clearEvents()
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showBackgroundView()
    func hideBackgroundView() 
    
    func toggleLayout(value isListLayout: Bool)
}
