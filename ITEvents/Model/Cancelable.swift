import Promises

enum CancelableErrors: Error {
    case canceled
}

class Cancelable<T> {
    let promise: Promise<T>
    var canceled = false
    
    init(promise: Promise<T>) {
        self.promise = promise
    }
    
    func cancel() {
        if canceled {
            return
        }
        
        promise.reject(CancelableErrors.canceled)
        canceled = true
    }
}
