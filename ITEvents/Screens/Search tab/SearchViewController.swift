import UIKit
import DisplaySwitcher
import Reusable

class SearchViewController: UIViewController, ISearchView, ITabBarItemSelectable {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var presenter: ISearchPresenter!
    private var events = [EventCollectionCellViewModel]()
    
    private var layout: DisplaySwitchLayout!
    private var layoutState: LayoutState!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        presenter.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.isUserInteractionEnabled = true
    }
    
    func toggleLayout(for isList: Bool) {
        layout = createDisplaySwitcherLayout(forList: isList, viewWidth: view.frame.width)
        collectionView.collectionViewLayout = layout
        layoutState = isList ? .list : .grid
    }
    
    func setEvents(_ events: [EventCollectionCellViewModel]) {
        self.events = events
        collectionView.reloadData()
    }
    
    func handleSelection() {
        presenter.activate()
        self.collectionView.reloadData()
    }
    
    private func registerNibs() {
        collectionView.register(cellType: EventCollectionViewCell.self)
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return getEventCollectionViewCell(collectionView,
                                              cellForItemAt: indexPath,
                                              event: events[indexPath.row],
                                              layoutState: layoutState)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.isUserInteractionEnabled = false
        presenter.selectEvent(with: events[indexPath.row].id)
        self.performSegue(withIdentifier: "Search_OpenEvent", sender: nil)
    }
    
}
