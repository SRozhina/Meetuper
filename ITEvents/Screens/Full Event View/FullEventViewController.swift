import UIKit
import SafariServices

class FullEventViewController: UIViewController, IFullEventView {
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    private let descriptionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.isHidden = true
        return stackView
    }()
    private weak var showMoreEventsView: ShowMoreEventsView!
    
    var presenter: IFullEventPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setup()
    }
    
    func createEventView(with event: EventViewModel, isSimilar: Bool) {
        let eventView = EventView.initiateAndSetup(with: event,
                                                   eventURLOpener: self,
                                                   isSimilar: isSimilar)
        let stackViewToAddEvent: UIStackView = isSimilar ? descriptionsStackView : stackView
        stackViewToAddEvent.addArrangedSubview(eventView)
    }
    
    func createShowMoreEventsButton(for eventsCount: Int) {
        showMoreEventsView = ShowMoreEventsView.initiateAndSetup(with: eventsCount, collapsed: true)
        showMoreEventsView.addMoreEventsRequestObserver(self, selector: #selector(moreEventsRequested))
        stackView.addArrangedSubview(showMoreEventsView)
        stackView.addArrangedSubview(descriptionsStackView)
    }
    
    @objc
    private func moreEventsRequested() {
        showMoreEventsView.isEnable = false
        
        presenter.requestSimilarEvents().then {
            self.expandOrCollapseEvents()
            
            if !self.descriptionsStackView.isHidden {
                self.scrollView.layoutIfNeeded()
                let scrollOffsetPoint = CGPoint(x: 0, y: self.getScrollYOffset())
                self.scrollView.setContentOffset(scrollOffsetPoint, animated: true)
            }
            
            self.showMoreEventsView.isEnable = true
            self.showMoreEventsView.updateTitle(for: self.descriptionsStackView.isHidden)
        }
    }
    
    private func getScrollYOffset() -> CGFloat {
        let descriptionHeight = descriptionsStackView.frame.height
        let stackViewHeight = stackView.frame.height
        let viewHeight = view.frame.height
        if descriptionHeight > viewHeight {
            return stackViewHeight - descriptionHeight
        } else if stackViewHeight > viewHeight {
            return scrollView.contentSize.height - scrollView.bounds.size.height
        }
        return 0
    }
    
    private func expandOrCollapseEvents() {
        UIView.animate(withDuration: 0.3) {
            self.descriptionsStackView.isHidden = !self.descriptionsStackView.isHidden
        }
    }
}

extension FullEventViewController: IEventURLOpener {
    func open(url: URL) {
        let safariWebView = SFSafariViewController(url: url)
        present(safariWebView, animated: true, completion: nil)
    }
}
