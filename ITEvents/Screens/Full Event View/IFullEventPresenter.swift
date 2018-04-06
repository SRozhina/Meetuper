protocol IFullEventPresenter {
    func setup()
    
    func requestSimilarEvents(completion: @escaping () -> Void)
}
