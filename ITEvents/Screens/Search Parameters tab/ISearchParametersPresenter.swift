protocol ISearchParametersPresenter {
    func setup()
    
    func deselectTag(_ tag: Tag)
    
    func selectTag(_ tag: Tag)
    
    func saveSettings()
}
