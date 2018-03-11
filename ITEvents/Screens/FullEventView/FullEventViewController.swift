import UIKit
import SafariServices

class FullEventViewController: UIViewController {
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var scrollView: UIScrollView!
    private let descriptionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    private var isSimilarEventsCollapsed: Bool {
        return descriptionsStackView.isHidden
    }
    
    var similarEventsService: ISimilarEventsDataService!
    var dateFormatterService: IDateFormatterService!
    
    var event: Event!
    private var similarEvents: [Event]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventView = EventView.initiateAndSetup(with: event, using: dateFormatterService, sourceOpenAction: openAction)
        stackView.addArrangedSubview(eventView)
        
        if event.similarEventsCount == 0 { return }
        
        let showMoreEvents = ShowMoreEventsView.initiateAndSetup(with: event.similarEventsCount, showOrHideEventsAction: showMoreButtonTapped)
        stackView.addArrangedSubview(showMoreEvents)
    }
    
    private func showMoreButtonTapped(completion: @escaping () -> Void) {
        let scrollYOffset = stackView.frame.height
        updateSimilarEvents {
            self.expandOrCollapseEvents()
            if !self.isSimilarEventsCollapsed {
                self.scrollView.setContentOffset(CGPoint(x: 0, y: scrollYOffset), animated: true)
            }
            completion()
        }
    }
    
    private func updateSimilarEvents(completion: @escaping () -> Void) {
        if similarEvents != nil {
            completion()
            return
        }
        
        similarEventsService.fetchSimilarEvents(for: event.id) { events in
            self.similarEvents = events
            self.createSimilarEventsViews()
            completion()
        }
    }
    
    private func createSimilarEventsViews() {
        for similarEvent in similarEvents! {
            let eventView = EventView.initiateAndSetup(with: similarEvent, using: dateFormatterService, sourceOpenAction: openAction, isSimilar: true)
            descriptionsStackView.addArrangedSubview(eventView)
        }
        descriptionsStackView.isHidden = true
        stackView.addArrangedSubview(descriptionsStackView)
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
