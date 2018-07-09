import Promises

protocol IFullEventPresenter {
    func setup()
    
    func requestSimilarEvents() -> Promise<Void>
}
