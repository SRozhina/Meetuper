import Foundation

protocol IDebouncer {
    func debounce(delay: DispatchTimeInterval,
                  queue: DispatchQueue,
                  action: @escaping DebouncedAction) -> DebouncedFunction
}
