import Foundation

typealias DebouncedAction = () -> Void
typealias DebouncedFunction = (_ isDelayNeeded: Bool) -> Void

class Debouncer: IDebouncer {
    func debounce(delay: DispatchTimeInterval,
                  queue: DispatchQueue = .main,
                  action: @escaping DebouncedAction) -> DebouncedFunction {
        var currentWorkItem: DispatchWorkItem?
        return { isDelayNeeded in
            currentWorkItem?.cancel()
            currentWorkItem = DispatchWorkItem {
                action()
            }
            let deadline = DispatchTime.now() + (isDelayNeeded ? delay : DispatchTimeInterval.seconds(0))
            queue.asyncAfter(deadline: deadline, execute: currentWorkItem!)
        }
    }
}
