import UIKit
import  Foundation
import DisplaySwitcher

class EventCollectionViewCell: UICollectionViewCell, IEventCollectionViewCell {
    @IBOutlet private weak var eventTitleListLabel: UILabel!
    @IBOutlet private weak var eventImage: UIGradientImageView!
    @IBOutlet private weak var eventDateListLabel: UILabel!
    @IBOutlet private weak var eventBackgroundView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    
    @IBOutlet weak var eventImageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventImageTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var eventTitleGridLabel: UILabel!
    @IBOutlet weak var eventDateGridLabel: UILabel!
    
    let titleFontSize: CGFloat = 20
    let dateFontSize: CGFloat = 14
    
    private static let locale = Locale(identifier: "en_GB")
    private var listFormat = DateFormatter.dateFormat(fromTemplate: "dMMMM HH:mm", options: 0, locale: locale)
    private var gridFormat = DateFormatter.dateFormat(fromTemplate: "dMMM HH:mm", options: 0, locale: locale)
    private var timeFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: locale)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    func commonInit() {
        eventBackgroundView.layer.cornerRadius = 14

        shadowView.layer.cornerRadius = 14
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.10
        shadowView.layer.shadowOffset = CGSize(width: 0.5, height: 10)
        shadowView.layer.shadowRadius = 8
        
        eventImage.clipsToBounds = true
    }
    
    func setupListLayout() {
        eventImageTopConstraint.constant = 10
        eventImageBottomConstraint.constant = 10
        eventImageLeadingConstraint.constant = 10
        eventImage.layer.cornerRadius = 14
        
        eventImage.hideGradient()
        eventDateGridLabel.alpha = 0
        eventTitleGridLabel.alpha = 0
    }
    
    func setupGridLayout() {
        eventImage.layer.cornerRadius = 0
        eventImageTopConstraint.constant = 0
        eventImageBottomConstraint.constant = 15
        eventImageLeadingConstraint.constant = 0
        eventBackgroundView.clipsToBounds = true
        
        eventImage.showGradient()
        eventDateListLabel.alpha = 0
        eventTitleListLabel.alpha = 0
    }
    
    private func transitGridLayout(_ progress: CGFloat) {
        let alpha = 1 - progress * 1.5
        
        eventDateListLabel.alpha = alpha
        eventTitleListLabel.alpha = alpha
        eventDateGridLabel.alpha = progress
        eventTitleGridLabel.alpha = progress
        
        eventTitleGridLabel.font = eventTitleGridLabel.font.withSize(titleFontSize * progress)
        eventDateGridLabel.font = eventDateGridLabel.font.withSize(dateFontSize * progress)
    }
    
    private func transitListLayout(_ progress: CGFloat) {
        let alpha = 1 - progress * 1.5
        
        eventDateListLabel.alpha = progress
        eventTitleListLabel.alpha = progress
        eventTitleGridLabel.alpha = alpha
        eventDateGridLabel.alpha = alpha
        
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
    
    func getLatoutState(_ layout: DisplaySwitchLayout) -> LayoutState {
        let mirror = Mirror(reflecting: layout)
        let layoutStatePair = mirror.children.first { $0.label == "layoutState" }!
        return layoutStatePair.value as! LayoutState
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? DisplaySwitchLayoutAttributes,
            attributes.transitionProgress > 0 {
            print(attributes.transitionProgress)
            if attributes.layoutState == .grid {
                transitGridLayout(attributes.transitionProgress)
            } else {
                transitListLayout(attributes.transitionProgress)
            }
        }
    }
    
    func setImageAlpha(_ alpha: CGFloat) {
        eventImage.alpha = alpha
    }
    
    func setTitle(_ title: String) {
        eventTitleListLabel.text = title
        eventTitleGridLabel.text = title
    }
    
    func setDate(from start: Date, to end: Date) {
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
    
    func setImage(_ image: UIImage) {
        eventImage.image = image
    }
}
