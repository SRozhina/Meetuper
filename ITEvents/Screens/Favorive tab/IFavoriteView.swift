import DisplaySwitcher

protocol IFavoriveView {
    func setEvents(_ events: [Event])
        
    func setLayoutState(to value: Bool)
    
    func setButtonRotation(to value: Bool)
}
