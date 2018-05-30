import Foundation

// https://gist.github.com/simme/b78d10f0b29325743a18c905c5512788
func debounce(delay: DispatchTimeInterval,
              queue: DispatchQueue = .main,
              action: @escaping (() -> Void)
    ) -> (Bool) -> Void {
    var currentWorkItem: DispatchWorkItem?
    return { isDelayNeeded in
        currentWorkItem?.cancel()
        currentWorkItem = DispatchWorkItem { action() }
        let deadline = DispatchTime.now() + (isDelayNeeded ? delay : DispatchTimeInterval.seconds(0))
        queue.asyncAfter(deadline: deadline, execute: currentWorkItem!)
    }
}
