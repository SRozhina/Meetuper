import UIKit

class FullEventViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    
    private let eventDataService: IEventDataService = EventDataServiceMockImpl()
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let eventView = EventView.initiateAndSetup(with: event)
        stackView.addArrangedSubview(eventView)
        
        let descriptionsCount = 2
        let showMoreDescriptions = ShowMoreDescriptions.initiateAndSetup(with: descriptionsCount)
        showMoreDescriptions.showMoreDescriptionsButton.addTarget(self, action: #selector(expandOrCollapseDescriptions), for: .touchUpInside)
        eventView.addArrangedSubview(showMoreDescriptions)
        
        let descriptionsStackView = UIStackView()
        descriptionsStackView.axis = .vertical
        descriptionsStackView.spacing = 10
        descriptionsStackView.tag = 123
        for _ in 0..<descriptionsCount {
            let eventView = EventView.initiateAndSetup(with: event)
            descriptionsStackView.addArrangedSubview(eventView)
        }
        descriptionsStackView.isHidden = true
        eventView.addArrangedSubview(descriptionsStackView)
    }
    
    @objc func expandOrCollapseDescriptions(_ sender: UIButton) {
        if let descriptionsStack = self.view.viewWithTag(123) as? UIStackView {
            UIView.animate(withDuration: 0.3) {
                descriptionsStack.isHidden = !descriptionsStack.isHidden
            }
            let title = ShowMoreDescriptions.getDescriptionFor(hidden: descriptionsStack.isHidden, count: 2) //TODO get count from event
            sender.setTitle(title, for: .normal)
        }
    }
}
