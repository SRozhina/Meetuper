import UIKit

class EventCollectionViewCommon: NSObject, IEventCollectionViewCommon {
    private var selectedEventAction: ((IndexPath) -> Void)?
    private var lastCellWillDisplayAction: ((IndexPath) -> Void)?
    private var events = [EventCollectionCellViewModel]()
    private var isListLayoutSelected: Bool = true
    private var loadInProgress: Bool = true
    private var viewWidth: CGFloat!
    
    init(viewWidth: CGFloat,
         selectedEventAction: ((IndexPath) -> Void)? = nil,
         lastCellWillDisplayAction: ((IndexPath) -> Void)? = nil) {
        self.viewWidth = viewWidth
        self.selectedEventAction = selectedEventAction
        self.lastCellWillDisplayAction = lastCellWillDisplayAction
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = events[indexPath.row]
        if isListLayoutSelected {
            let cell: ListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setup(with: event)
            return cell
        }
        let cell: GridCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setup(with: event)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter,
                                                                         withReuseIdentifier: "Footer",
                                                                         for: indexPath) as! EventsCollectionViewFooter
            if loadInProgress {
                footer.showFooter()
            } else {
                footer.hideFooter()
            }
            return footer
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return loadInProgress
            ? CGSize(width: viewWidth, height: 50)
            : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return isListLayoutSelected
            ? CGSize(width: viewWidth - 20, height: 80)
            : CGSize(width: (viewWidth - 40) / 2, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.isUserInteractionEnabled = false
        selectedEventAction?(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        lastCellWillDisplayAction?(indexPath)
    }
    
    func setEvents(_ newEvents: [EventCollectionCellViewModel]) {
        self.events = newEvents
    }
    
    func toggleLoadingProgressState(_ value: Bool) {
        loadInProgress = value
    }
    
    func toggleLayout(value isListLayout: Bool) {
        if isListLayoutSelected == isListLayout { return }
        isListLayoutSelected = isListLayout
    }
    
    func getLoadingState() -> Bool {
        return loadInProgress
    }
    
    //Do not know how to name it
    func getLayoutState() -> Bool {
        return isListLayoutSelected
    }
}

protocol IEventCollectionViewCommon: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func setEvents(_ newEvents: [EventCollectionCellViewModel])
    
    func toggleLoadingProgressState(_ value: Bool)
    
    func toggleLayout(value isListLayout: Bool)
    
    func getLoadingState() -> Bool
    
    func getLayoutState() -> Bool
}