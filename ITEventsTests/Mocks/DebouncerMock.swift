import Foundation
@testable import ITEvents

class DebouncerMock: IDebouncer {
    public let actionQueue: DispatchQueue
    
    init(actionQueue: DispatchQueue) {
        self.actionQueue = actionQueue
    }
    
    func debounce(delay: DispatchTimeInterval, // not used
                  queue: DispatchQueue,
                  action: @escaping DebouncedAction) -> DebouncedFunction {
        var currentWorkItem: DispatchWorkItem?
        return { isDelayNeeded in
            currentWorkItem?.cancel()
            currentWorkItem = DispatchWorkItem {
                action()
            }
            self.actionQueue.async(execute: currentWorkItem!)
        }
    }
}
