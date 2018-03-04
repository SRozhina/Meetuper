import UIKit

class FullEventViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    private let descriptionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    private let eventDataService: IEventDataService = EventDataServiceMockImpl()
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let eventView = EventView.initiateAndSetup(with: event)
        stackView.addArrangedSubview(eventView)
        
        let descriptionsCount = 2
        let showMoreEvents = ShowMoreEventsView.initiateAndSetup(with: descriptionsCount)
        showMoreEvents.showMoreEventsButton.addTarget(self, action: #selector(expandOrCollapseDescriptions), for: .touchUpInside)
        stackView.addArrangedSubview(showMoreEvents)
        
        for _ in 0..<descriptionsCount {
            let eventView = EventView.initiateAndSetup(with: event)
            let sourceLabel = createSourceLabel(text: "Event from Meetabit.com")
            eventView.insertArrangedSubview(sourceLabel, at: 0)
            descriptionsStackView.addArrangedSubview(eventView)
        }
        descriptionsStackView.isHidden = true
        stackView.addArrangedSubview(descriptionsStackView)
    }
    
    @objc func expandOrCollapseDescriptions(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.descriptionsStackView.isHidden = !self.descriptionsStackView.isHidden
        }
        let title = ShowMoreEventsView.getDescriptionFor(hidden: descriptionsStackView.isHidden, count: 2) //TODO get count from event
        sender.setTitle(title, for: .normal)
    }
    
    func createSourceLabel(text: String) -> UILabel {
        let sourceLabel = UILabel()
        sourceLabel.text = text
        sourceLabel.font = UIFont.systemFont(ofSize: 12)
        sourceLabel.textAlignment = .center
        sourceLabel.textColor = UIColor(red: 0.63, green: 0.63, blue: 0.63, alpha: 1)
        return sourceLabel
    }
}
