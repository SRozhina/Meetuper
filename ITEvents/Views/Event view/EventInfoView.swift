import Foundation
import UIKit
import Reusable

class EventInfoView: UIView, NibLoadable {
    @IBOutlet private weak var imageView: RoundedImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    class func initiateAndSetup(with image: UIImage,
                                title: String,
                                date: String) -> EventInfoView {
        let eventInfoView: EventInfoView = UIViewUtils.createPanelView()
        eventInfoView.setup(with: image, title: title, date: date)
        return eventInfoView
    }
    
    private func setup(with image: UIImage, title: String, date: String) {
        imageView.image = image
        titleLabel.text = title
        dateLabel.text = date
    }
}
