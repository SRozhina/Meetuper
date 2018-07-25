import Foundation
@testable import ITEvents

class DebouncerMock: IDebouncer {
    func debounce(delay: DispatchTimeInterval, // not used
                  queue: DispatchQueue,
                  action: @escaping DebouncedAction) -> DebouncedFunction {
        return { isDelayNeeded in
            action()
        }
    }
}
