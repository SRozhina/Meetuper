import UIKit

typealias SelectedEventCallback = (EventCollectionCellViewModel) -> Void
typealias LastCellWillDisplayActionCallback = () -> Void

class EventCollectionViewHandler: NSObject, IEventCollectionViewHandler {
    private var selectedEventAction: SelectedEventCallback?
    private var lastCellWillDisplayAction: LastCellWillDisplayActionCallback?
    private var events = [EventCollectionCellViewModel]()
    private var viewWidth: CGFloat!
    private var collectionView: UICollectionView!
    
    public private(set) var isListLayoutSelected: Bool = true
    public private(set) var isLoadingIndicatorShown: Bool = true
    
    init(viewWidth: CGFloat,
         collectionView: UICollectionView,
         selectedEventAction: SelectedEventCallback? = nil,
         lastCellWillDisplayAction: LastCellWillDisplayActionCallback? = nil) {
        self.viewWidth = viewWidth
        self.collectionView = collectionView
        self.selectedEventAction = selectedEventAction
        self.lastCellWillDisplayAction = lastCellWillDisplayAction
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = events[indexPath.row]
        
        let eventCell: (UICollectionViewCell & IEventCollectionViewCell) = isListLayoutSelected
            ? collectionView.dequeueReusableCell(for: indexPath) as ListCollectionViewCell
            : collectionView.dequeueReusableCell(for: indexPath) as GridCollectionViewCell
        eventCell.setup(with: event)
        return eventCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter,
                                                                         withReuseIdentifier: "Footer",
                                                                         for: indexPath) as! EventsCollectionViewFooter
            if isLoadingIndicatorShown {
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
        return isLoadingIndicatorShown
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
        let event = events[indexPath.row]
        selectedEventAction?(event)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastEventIndex = events.count - 1
        if indexPath.row == lastEventIndex && !isLoadingIndicatorShown {
            lastCellWillDisplayAction?()
        }
    }
    
    func setEvents(_ newEvents: [EventCollectionCellViewModel]) {
        self.events = newEvents
        collectionView.reloadData()
    }
    
    func showLoadingIndicator() {
        isLoadingIndicatorShown = true
        collectionView.reloadData()
    }
    
    func hideLoadingIndicator() {
        isLoadingIndicatorShown = false
        collectionView.reloadData()
    }
    
    func toggleListLayout(value isListLayout: Bool) {
        if isListLayoutSelected == isListLayout { return }

        isListLayoutSelected = !isListLayoutSelected
        collectionView.reloadData()
    }
}
