import UIKit
import  Foundation
import DisplaySwitcher

class EventCollectionViewCell: UICollectionViewCell, IEventCollectionViewCell {
    @IBOutlet private weak var eventTitleListLabel: UILabel!
    @IBOutlet private weak var eventImage: UIGradientImageView!
    @IBOutlet private weak var eventDateListLabel: UILabel!
    
    @IBOutlet weak var eventImageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventImageTopConstraint: NSLayoutConstraint!
    var eventImageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var eventImageAspectRatioConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var eventTitleGridLabel: UILabel!
    @IBOutlet weak var eventDateGridLabel: UILabel!
    
    private let titleFontSize: CGFloat = 20
    private let dateFontSize: CGFloat = 14
    private let imageMargin: CGFloat = 10
    private let cornerRadius: CGFloat = 14
    
    private static let locale = Locale(identifier: "en_GB")
    private var listFormat = DateFormatter.dateFormat(fromTemplate: "dMMMM HH:mm", options: 0, locale: locale)
    private var gridFormat = DateFormatter.dateFormat(fromTemplate: "dMMM HH:mm", options: 0, locale: locale)
    private var timeFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: locale)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.10
        layer.shadowOffset = CGSize(width: 0.5, height: 10)
        layer.shadowRadius = 8
        layer.masksToBounds = false
        eventImage.clipsToBounds = true
        eventImage.layer.cornerRadius = cornerRadius
        eventImageTrailingConstraint = NSLayoutConstraint(item: eventImage,
                                                          attribute: .trailing,
                                                          relatedBy: .equal,
                                                          toItem: self,
                                                          attribute: .trailing,
                                                          multiplier: 1,
                                                          constant: 0)
    }
    
    func setupListLayout() {
        eventImageTopConstraint.constant = imageMargin
        eventImageBottomConstraint.constant = imageMargin
        eventImageLeadingConstraint.constant = imageMargin
        
        eventImageTrailingConstraint.isActive = false
        eventImageAspectRatioConstraint.isActive = true
        
        eventImage.hideGradient()
        eventDateGridLabel.alpha = 0
        eventTitleGridLabel.alpha = 0
    }
    
    func setupGridLayout() {
        eventImageTrailingConstraint.isActive = true
        eventImageAspectRatioConstraint.isActive = false
        
        eventImageTopConstraint.constant = 0
        eventImageBottomConstraint.constant = 0
        eventImageLeadingConstraint.constant = 0
        eventImageTrailingConstraint.constant = 0
    }
    
    private func transitGridLayout(_ progress: CGFloat) {
        setLabelsOpacity(to: 1 - progress)
        let reverseProgress = 1 - progress
        
        eventTitleGridLabel.font = eventTitleGridLabel.font.withSize(titleFontSize * progress)
        eventDateGridLabel.font = eventDateGridLabel.font.withSize(dateFontSize * progress)
        
        eventImageTopConstraint.constant *= reverseProgress
        eventImageBottomConstraint.constant *= reverseProgress
        eventImageLeadingConstraint.constant *= reverseProgress
        eventImageTrailingConstraint.constant *= reverseProgress
    }
    
    private func setLabelsOpacity(to alpha: CGFloat) {
        let reverceAlpha = 1 - alpha
        
        eventDateListLabel.alpha = alpha
        eventTitleListLabel.alpha = alpha
        
        eventTitleGridLabel.alpha = reverceAlpha
        eventDateGridLabel.alpha = reverceAlpha
    }
    
    private func transitListLayout(_ progress: CGFloat) {
        setLabelsOpacity(to: progress)
        
        eventTitleGridLabel.font = eventTitleGridLabel.font.withSize(titleFontSize * alpha)
        eventDateGridLabel.font = eventDateGridLabel.font.withSize(dateFontSize * alpha)
    }
    
    override func willTransition(from oldLayout: UICollectionViewLayout, to newLayout: UICollectionViewLayout) {
        super.willTransition(from: oldLayout, to: newLayout)
        
        guard let oldDisplaySwitchLayout = oldLayout as? DisplaySwitchLayout else { return }
        let oldLatoutState = getLatoutState(oldDisplaySwitchLayout)
        if oldLatoutState == .list {
            // list -> grid
            eventImage.showGradient()
        } else {
            // grid -> list
            setupListLayout()
        }
    }
    
    private func getLatoutState(_ layout: DisplaySwitchLayout) -> LayoutState {
        let mirror = Mirror(reflecting: layout)
        let layoutStatePair = mirror.children.first { $0.label == "layoutState" }!
        return layoutStatePair.value as! LayoutState
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? DisplaySwitchLayoutAttributes,
            attributes.transitionProgress > 0 {
            if attributes.layoutState == .grid {
                transitGridLayout(attributes.transitionProgress)
            } else {
                transitListLayout(attributes.transitionProgress)
            }
        }
    }
    
    func setupCellWith(_ event: Event) {
        setTitle(event.title)
        setDate(from: event.startDate, to: event.endDate)
        setImage(event.image)
    }
    
    private func setTitle(_ title: String) {
        eventTitleListLabel.text = title
        eventTitleGridLabel.text = title
    }
    
    private func setDate(from start: Date, to end: Date) {
        eventDateListLabel.text = getListLabelDate(start: start, end: end)
        eventDateGridLabel.text = getGridLabelDate(start: start, end: end)
    }

    private func hasSameDay(start: Date, end: Date) -> Bool {
        return Calendar.current.isDate(start, equalTo: end, toGranularity: .day)
    }
    
    private func getListLabelDate(start: Date, end: Date) -> String {
        let dateFormatter = DateFormatter()
        let sameDay = hasSameDay(start: start, end: end)
        let separator = sameDay ? "-" : " - "
        dateFormatter.dateFormat = listFormat
        let beginDate = dateFormatter.string(from: start)
        dateFormatter.dateFormat = sameDay ? timeFormat : listFormat
        let endDate = dateFormatter.string(from: end)
        return "\(beginDate)\(separator)\(endDate)"
    }
    
    private func getGridLabelDate(start: Date, end: Date) -> String {
        let dateFormatter = DateFormatter()
        let sameDay = hasSameDay(start: start, end: end)
        let separator = sameDay ? "-" : " - "
        dateFormatter.dateFormat = gridFormat
        let beginDate = dateFormatter.string(from: start)
        dateFormatter.dateFormat = sameDay ? timeFormat : gridFormat
        let endDate = dateFormatter.string(from: end)
        return "\(beginDate)\(separator)\(endDate)"
    }
    
    private func setImage(_ image: UIImage) {
        eventImage.image = image
    }
}
