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
