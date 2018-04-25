import UIKit
import DisplaySwitcher
import Reusable

class SearchViewController: UIViewController, ISearchView, ITabBarItemSelectable {
    var presenter: ISearchPresenter!

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicatorViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var events = [EventCollectionCellViewModel]()

    private var layout: DisplaySwitchLayout!
    private var layoutState: LayoutState!
    private var loadInProgress: Bool = true
    private var searchText: String { return searchBar.text ?? "" }
    private var searchTags: [Tag] = []
    private let footerHeight: CGFloat = 50

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        presenter.setup()
        collectionView.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
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
        //it should be in another place or I should rename the method but I don't know! Help me! You're the best in renaming and refactoring! I love you!
        loadInProgress = false
        if self.events.count == events.count {
            let yOffset = collectionView.contentSize.height - footerHeight > collectionView.bounds.height
                            ? collectionView.contentSize.height - collectionView.bounds.height - footerHeight
                            : 0
            collectionView.contentOffset.y = yOffset
        }
        
        self.events = events
        collectionView.reloadData()
    }
    
    func handleSelection() {
        presenter.activate()
        collectionView.reloadData()
    }
    
    private func registerNibs() {
        collectionView.register(cellType: EventCollectionViewCell.self)
    }
    
    private func prepareCollectioViewForNewSearchResults() {
        events = []
        loadInProgress = true
        collectionView.contentOffset.y = 0
        collectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionElementKindSectionFooter,
                withReuseIdentifier: "Footer", for: indexPath) as! EventsCollectionViewFooter
            if loadInProgress {
                footer.showFooter(withHeight: footerHeight)
            } else {
                footer.hideFooter()
            }
            return footer
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchParameters = SearchParameters(text: searchText, tags: searchTags)
        prepareCollectioViewForNewSearchResults()
        searchBar.resignFirstResponder()
        presenter.searchEvents(by: searchParameters, isDelayNeeded: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchParameters = SearchParameters(text: searchText, tags: searchTags)
        prepareCollectioViewForNewSearchResults()
        presenter.searchEvents(by: searchParameters, isDelayNeeded: true)
    }
}

extension SearchViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
            loadInProgress = true
            collectionView.reloadData()
            let searchParameters = SearchParameters(text: searchText, tags: searchTags)
            presenter.searchEvents(by: searchParameters, isDelayNeeded: true)
        }
    }
}
