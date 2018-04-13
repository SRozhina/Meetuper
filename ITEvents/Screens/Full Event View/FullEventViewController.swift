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
    var presenter: IFullEventPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setup()
    }
    
    func createEventView(with event: EventViewModel, isSimilar: Bool) {
        let eventView = EventView.initiateAndSetup(with: event,
                                                   sourceOpenAction: openAction,
                                                   isSimilar: isSimilar)
        let stackViewToAddEvent: UIStackView = isSimilar ? descriptionsStackView : stackView
        stackViewToAddEvent.addArrangedSubview(eventView)
    }
    
    func createShowMoreEventsButton(for eventsCount: Int) {
        let showMoreEvents = ShowMoreEventsView.initiateAndSetup(with: eventsCount,
                                                                 showOrHideEventsAction: showMoreButtonTapped)
        stackView.addArrangedSubview(showMoreEvents)
        stackView.addArrangedSubview(descriptionsStackView)
    }
    
    private func showMoreButtonTapped(completion: @escaping () -> Void) {
        presenter.requestSimilarEvents {
            self.expandOrCollapseEvents()
            
            if !self.descriptionsStackView.isHidden {
                self.scrollView.layoutIfNeeded()
                let scrollOffsetPoint = CGPoint(x: 0, y: self.getScrollYOffset())
                self.scrollView.setContentOffset(scrollOffsetPoint, animated: true)
            }
            
            completion()
        }
    }
    
    private func getScrollYOffset() -> CGFloat {
        let descriptionHeight = descriptionsStackView.frame.height
        let stackViewHeight = stackView.frame.height
        let viewHeight = view.frame.height
        let mainEventHeight = stackViewHeight - descriptionHeight
        if descriptionHeight > viewHeight {
            return mainEventHeight
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
    
    private func openAction(url: URL) {
        let safariWebView = SFSafariViewController(url: url)
        present(safariWebView, animated: true, completion: nil)
    }
}
