import UIKit
import SafariServices

class FullEventViewController: UIViewController {
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var similarEventsService: ISimilarEventsDataService!
    var dateFormatterService: IDateFormatterService!
    
    var event: Event!
    private var similarEvents: [Event]?
    private var collapsed: Bool = true
    
    //TODO service for user settings
    
    private lazy var descriptionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let eventView = EventView.initiateAndSetup(with: event, using: dateFormatterService)
        
        if let source = event.source, let url = event.url {
            addEventSourceButton(in: eventView, for: source, url: url)
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
    
    private func addEventSourceButton(in stackView: UIStackView, for source: EventSource, url: URL) {
        let showEventSource = ShowEventSource.initiateAndSetup(with: source, and: url)
        showEventSource.showSourceButton.addTarget(self, action: #selector(openEventSource), for: .touchUpInside)
        stackView.addArrangedSubview(showEventSource)
    }
    
    private func createSimilarEventsViews() {
        for similarEvent in similarEvents! {
            let eventView = EventView.initiateAndSetup(with: similarEvent, using: dateFormatterService)
            addEventSourceButton(in: eventView, for: similarEvent.source!, url: similarEvent.url!)
            let sourceLabel = createLabelFor(source: similarEvent.source!)
            eventView.insertArrangedSubview(sourceLabel, at: 0)
            descriptionsStackView.addArrangedSubview(eventView)
        }
        descriptionsStackView.isHidden = true
        stackView.addArrangedSubview(descriptionsStackView)
    }
    
    private func expandOrCollapseDescriptions() {
        let scrollYOffset = stackView.frame.height
        UIView.animate(withDuration: 0.3, animations: {
            self.descriptionsStackView.isHidden = !self.descriptionsStackView.isHidden
            if self.scrollView.contentOffset.y < scrollYOffset, self.collapsed {
                self.scrollView.setContentOffset(CGPoint(x: 0, y: self.stackView.frame.height), animated: true)
            }
        }, completion: { _ in
            self.collapsed = !self.collapsed
        })
    }
    
    private func changeTitle(for button: UIButton) {
        let title = ShowMoreDescriptions.getDescriptionFor(hidden: !descriptionsStackView.isHidden, count: event.similarEventsCount)
        button.setTitle(title, for: .normal)
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
