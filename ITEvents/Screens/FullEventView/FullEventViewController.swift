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
    var event: Event!
    private var similarEvents: [Event]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventView = EventView.initiateAndSetup(with: event, sourceOpenAction: openAction)
        stackView.addArrangedSubview(eventView)
        
        if event.similarEventsCount == 0 { return }
        
        let showMoreEvents = ShowMoreEventsView.initiateAndSetup(with: event.similarEventsCount, showOrHideEventsAction: showMoreButtonTapped)
        stackView.addArrangedSubview(showMoreEvents)
    }
    
    private func showMoreButtonTapped(completion: @escaping () -> Void) {
        if similarEvents == nil {
            similarEventsService.fetchSimilarEvents(for: event.id) { events in
                self.similarEvents = events
                self.createSimilarEventsViews()
                self.expandOrCollapseEvents()
                completion()
            }
        } else {
            expandOrCollapseEvents()
            completion()
        }
    }
    
    private func createSimilarEventsViews() {
        for similarEvent in similarEvents! {
            let eventView = EventView.initiateAndSetup(with: similarEvent, sourceOpenAction: openAction)
            let sourceLabel = createSourceLabel(text: similarEvent.source!.name)
            eventView.insertArrangedSubview(sourceLabel, at: 0)
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
    
    private func createSourceLabel(text: String) -> UILabel {
        let sourceLabel = UILabel()
        sourceLabel.text = "Event from \(text)"
        sourceLabel.font = UIFont.systemFont(ofSize: 12)
        sourceLabel.textAlignment = .center
        sourceLabel.textColor = UIColor(red: 0.63, green: 0.63, blue: 0.63, alpha: 1)
        return sourceLabel
    }
    
    private func openAction(url: URL) {
        let safariWebView = SFSafariViewController(url: url)
        present(safariWebView, animated: true, completion: nil)
    }
}
