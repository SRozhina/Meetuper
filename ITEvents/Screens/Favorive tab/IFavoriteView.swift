protocol IFavoriveView {
    func setEvents(_ events: [EventCollectionCellViewModel])
    
    func toggleLayout(value isListLayout: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
}
