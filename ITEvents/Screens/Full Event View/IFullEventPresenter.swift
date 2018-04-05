protocol IFullEventPresenter {
    func setup()
    func updateSimilarEvents(completion: @escaping () -> Void)
}
