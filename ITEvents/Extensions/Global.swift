import DisplaySwitcher

func createDisplaySwitcherLayout(forList: Bool, viewWidth: CGFloat) -> DisplaySwitchLayout {
    let listLayoutCellStaticHeihgt: CGFloat = 85
    let gridLayoutCellStaticHeight: CGFloat = 190
    if forList {
        return DisplaySwitchLayout(staticCellHeight: listLayoutCellStaticHeihgt,
                                   nextLayoutStaticCellHeight: gridLayoutCellStaticHeight,
                                   layoutState: .list,
                                   cellPadding: CGPoint(x: 10, y: 8))
    }
    let gridColumnCount = floor(viewWidth / 168)
    return DisplaySwitchLayout(staticCellHeight: gridLayoutCellStaticHeight,
                               nextLayoutStaticCellHeight: listLayoutCellStaticHeihgt,
                               layoutState: .grid,
                               cellPadding: CGPoint(x: 10, y: 8),
                               gridLayoutCountOfColumns: Int(gridColumnCount))
    
}

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
