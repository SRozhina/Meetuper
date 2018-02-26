import UIKit

class FullEventViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    
    private let eventDataService: IEventDataService = EventDataServiceMockImpl()
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let eventView = EventView.initiateFromNib(with: event)
        stackView.addArrangedSubview(eventView)
    }

}
