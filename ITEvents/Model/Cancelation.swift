typealias CancelationFunc = () -> Void

class Cancelation {
    var canceled = false
    var cancelation: CancelationFunc?
    
    init(cancelation: CancelationFunc? = nil) {
        self.cancelation = cancelation
    }
    
    func cancel() {
        if canceled {
            return
        }
        canceled = true
        cancelation?()
    }
}
