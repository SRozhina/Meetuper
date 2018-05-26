import UIKit
import Reusable

class SearchViewController: UIViewController, ISearchView {
    
    var presenter: ISearchPresenter!

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var events = [EventCollectionCellViewModel]()

    private var isList: Bool!
    private var loadInProgress: Bool = true
    private var searchText: String { return searchBar.text ?? "" }
    private var searchTags: [Tag] = []
    private let footerHeight: CGFloat = 50

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        presenter.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        presenter.updateViewSettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.isUserInteractionEnabled = true
    }
    
    func toggleLayout(value isListLayout: Bool) {
        if isList != isListLayout {
            isList = isListLayout
            collectionView.reloadData()
        }
    }
    
    func clearEvents() {
        loadInProgress = true
        setEvents([])
    }
    
    func setEvents(_ events: [EventCollectionCellViewModel]) {
        self.events = events
        collectionView.reloadData()
    }
    
    func toggleProgressIndicator(shown: Bool) {
        loadInProgress = shown
        collectionView.reloadData()
    }
    
    private func registerNibs() {
        collectionView.register(cellType: ListCollectionViewCell.self)
        collectionView.register(cellType: GridCollectionViewCell.self)
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = events[indexPath.row]
        if isList {
            let cell: ListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setup(with: event)
            return cell
        }
        let cell: GridCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setup(with: event)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return isList
            ? CGSize(width: view.frame.width - 20, height: 80)
            : CGSize(width: (view.frame.width - 40) / 2, height: 180)
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
            ? CGSize(width: view.frame.width, height: footerHeight)
            : CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastEventIndex = events.count - 1
        if indexPath.row == lastEventIndex && !loadInProgress {
            DispatchQueue.main.async {
                self.presenter.searchMoreEvents()
            }
            
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() //remove keyboard
        
        presenter.forceEventSearching()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchEvents(by: searchText, and: searchTags)
    }
}
