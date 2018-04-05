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
    private var isSimilarEventsCollapsed: Bool {
        get { return descriptionsStackView.isHidden }
        set { descriptionsStackView.isHidden = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setup()
    }
    
    func createEventView(with event: Event, using dateFormatterService: IDateFormatterService, isSimilar: Bool) {
        let eventView = EventView.initiateAndSetup(with: event,
                                                   using: dateFormatterService,
                                                   sourceOpenAction: openAction, isSimilar: isSimilar)
        if isSimilar {
            descriptionsStackView.addArrangedSubview(eventView)
            return
        }
        stackView.addArrangedSubview(eventView)
    }
    
    func createAddShowMoreEventsButton(for eventsCount: Int) {
        let showMoreEvents = ShowMoreEventsView.initiateAndSetup(with: eventsCount,
                                                                 showOrHideEventsAction: showMoreButtonTapped)
        stackView.addArrangedSubview(showMoreEvents)
        stackView.addArrangedSubview(descriptionsStackView)
    }
    
    private func showMoreButtonTapped(completion: @escaping () -> Void) {
        let scrollYOffset = stackView.frame.height
        presenter.updateSimilarEvents {
            self.expandOrCollapseEvents()
            if !self.isSimilarEventsCollapsed {
                self.scrollView.setContentOffset(CGPoint(x: 0, y: scrollYOffset), animated: true)
            }
            completion()
        }
    }
    
    private func expandOrCollapseEvents() {
        if !isSimilarEventsCollapsed {
            UIView.animate(withDuration: 0.3) {
                self.isSimilarEventsCollapsed = !self.isSimilarEventsCollapsed
            }
            return
        }
        isSimilarEventsCollapsed = !isSimilarEventsCollapsed
    }
    
    private func openAction(url: URL) {
        let safariWebView = SFSafariViewController(url: url)
        present(safariWebView, animated: true, completion: nil)
    }
}
