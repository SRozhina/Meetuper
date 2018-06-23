protocol ISearchParametersPresenter {
    func setup()
    
    func removeTag(with title: String)
    
    func selectTag(with title: String)
    
    func parametersSelectionFinished()
}
