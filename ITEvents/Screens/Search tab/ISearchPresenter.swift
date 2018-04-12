protocol ISearchPresenter {
    func setup()
    
    func setupBeforeViewAppear(then completion: (() -> Void)?)
    
    func selectEvent(with eventId: Int)
}
