import UIKit
import SafariServices

class FullEventViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
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
        let eventView = EventView.initiateAndSetup(with: event)
        
        if let source = event.source, let url = event.url {
            let showEventSource = ShowEventSourceView.initiateAndSetup(with: source, and: url)
            showEventSource.showSourceButton.addTarget(self, action: #selector(openEventSource), for: .touchUpInside)
            eventView.addArrangedSubview(showEventSource)
        }
        
        stackView.addArrangedSubview(eventView)
        
        if event.similarEventsCount == 0 { return }
        
        let showMoreEvents = ShowMoreEventsView.initiateAndSetup(with: event.similarEventsCount)
        showMoreEvents.showMoreEventsButton.addTarget(self, action: #selector(showMoreButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(showMoreEvents)
    }
    
    @objc private func showMoreButtonTapped(_ sender: UIButton) {
        if similarEvents == nil {
            sender.isEnabled = false
            similarEventsService.fetchSimilarEvents(for: event.id) { events in
                self.similarEvents = events
                self.createSimilarEventsViews()
                self.changeTitle(for: sender)
                self.expandOrCollapseEvents()
                sender.isEnabled = true
            }
        } else {
            changeTitle(for: sender)
            expandOrCollapseEvents()
        }
    }
    
    private func createSimilarEventsViews() {
        for similarEvent in similarEvents! {
            let eventView = EventView.initiateAndSetup(with: similarEvent)
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
    
    private func changeTitle(for button: UIButton) {
        let title = ShowMoreEventsView.getDescriptionFor(hidden: !descriptionsStackView.isHidden, count: event.similarEventsCount)
        button.setTitle(title, for: .normal)
    }
    
    @objc private func openEventSource() {
        let safariWebView = SFSafariViewController(url: event.url!)
        present(safariWebView, animated: true, completion: nil)
    }
    
    private func createSourceLabel(text: String) -> UILabel {
        let sourceLabel = UILabel()
        sourceLabel.text = "Event from \(text)"
        sourceLabel.font = UIFont.systemFont(ofSize: 12)
        sourceLabel.textAlignment = .center
        sourceLabel.textColor = UIColor(red: 0.63, green: 0.63, blue: 0.63, alpha: 1)
        return sourceLabel
    }
}
