import Foundation
import UIKit

class EventInfoView: UIView {
    @IBOutlet private weak var imageView: RoundedImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    private var dateFormatterService: IDateFormatterService?
    
    class func initiateAndSetup(with image: UIImage,
                                title: String,
                                dateInterval: DateInterval,
                                short: Bool,
                                using dateFormatterService: IDateFormatterService?) -> EventInfoView {
        let eventInfoView: EventInfoView = SharedUtils.createPanelView(nibName: "EventInfoView")
        eventInfoView.dateFormatterService = dateFormatterService
        eventInfoView.setup(with: image, title: title, dateInterval: dateInterval, short: short)
        return eventInfoView
    }
    
    private func setup(with image: UIImage, title: String, dateInterval: DateInterval, short: Bool) {
        imageView.image = image
        titleLabel.text = title
        dateLabel.text = dateFormatterService?.getFormattedDateStringFrom(dateInterval: dateInterval, short: short) ?? ""
    }
}
