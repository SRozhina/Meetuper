import UIKit
import SafariServices

class FullEventViewController: UIViewController {
    @IBOutlet weak private var stackView: UIStackView!
    
    private let similarEventsService: ISimilarEventsDataService = SimilarEventsDataServiceMockImpl()
    var event: Event!
    private var similarEvents: [Event]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventView = EventView.initiateAndSetup(with: event)
        
        if let source = event.source, let url = event.url {
            let showEventSource = ShowEventSource.initiateAndSetup(with: source, and: url)
            showEventSource.showSourceButton.addTarget(self, action: #selector(openEventSource), for: .touchUpInside)
            eventView.addArrangedSubview(showEventSource)
        }
        
        stackView.addArrangedSubview(eventView)
        
        if event.similarEventsCount == 0 { return }
        
        let showMoreDescriptions = ShowMoreDescriptions.initiateAndSetup(with: event.similarEventsCount)
        showMoreDescriptions.showMoreDescriptionsButton.addTarget(self, action: #selector(showMoreButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(showMoreDescriptions)
    }
    
    @objc private func showMoreButtonTapped(_ sender: UIButton) {
        if similarEvents == nil {
            sender.isEnabled = false
            similarEventsService.fetchSimilarEvents(for: event.id) { events in
                self.similarEvents = events
                self.createSimilarEventsViews()
                self.changeTitle(for: sender)
                self.expandOrCollapseDescriptions()
                sender.isEnabled = true
            }
        } else {
            changeTitle(for: sender)
            expandOrCollapseDescriptions()
        }
    }
    
    private func createSimilarEventsViews() {
        let descriptionsStackView = UIStackView()
        descriptionsStackView.axis = .vertical
        descriptionsStackView.spacing = 15
        descriptionsStackView.tag = 123
        for similarEvent in similarEvents! {
            let eventView = EventView.initiateAndSetup(with: similarEvent)
            let sourceLabel = createLabelFor(source: similarEvent.source!)
            eventView.insertArrangedSubview(sourceLabel, at: 0)
            descriptionsStackView.addArrangedSubview(eventView)
        }
        descriptionsStackView.isHidden = true
        stackView.addArrangedSubview(descriptionsStackView)
    }
    
    private func expandOrCollapseDescriptions() {
        if let descriptionsStack = self.view.viewWithTag(123) as? UIStackView {
            UIView.animate(withDuration: 0.3) {
                descriptionsStack.isHidden = !descriptionsStack.isHidden
            }
        }
    }
    
    private func changeTitle(for button: UIButton) {
        if let descriptionsStack = self.view.viewWithTag(123) as? UIStackView {
            let title = ShowMoreDescriptions.getDescriptionFor(hidden: !descriptionsStack.isHidden, count: event.similarEventsCount)
            button.setTitle(title, for: .normal)
        }
    }
    
    @objc private func openEventSource() {
        let safariWebView = SFSafariViewController(url: event.url!)
        present(safariWebView, animated: true, completion: nil)
    }
    
    private func createLabelFor(source: EventSource) -> UILabel {
        let sourceLabel = UILabel()
        sourceLabel.text = "Event from \(source.name)"
        sourceLabel.font = UIFont.systemFont(ofSize: 12)
        sourceLabel.textAlignment = .center
        sourceLabel.textColor = UIColor(red: 0.63, green: 0.63, blue: 0.63, alpha: 1)
        return sourceLabel
    }
}
