import UIKit
import SafariServices

class FullEventViewController: UIViewController {
    @IBOutlet private weak var stackView: UIStackView!
    private let descriptionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    private let similarEventsService: ISimilarEventsDataService = SimilarEventsDataServiceMockImpl()
    private let dateFormatterService: IDateFormatterService = DateFormatterService()
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
        if similarEvents != nil {
            expandOrCollapseEvents()
            completion()
            return
        }
        similarEventsService.fetchSimilarEvents(for: event.id) { events in
            self.similarEvents = events
            self.createSimilarEventsViews()
            self.expandOrCollapseEvents()
            completion()
        }
    }
    
    private func createSimilarEventsViews() {
        for similarEvent in similarEvents! {
            let eventView = EventView.initiateAndSetup(with: similarEvent, using: dateFormatterService, sourceOpenAction: openAction)
            eventView.createSourceLabel()
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
