import UIKit
import  Foundation
import DisplaySwitcher
import Reusable

class EventCollectionViewCell: UICollectionViewCell, IEventCollectionViewCell, NibReusable {
    @IBOutlet private weak var titleListLabel: UILabel!
    @IBOutlet private weak var dateListLabel: UILabel!
    @IBOutlet private weak var titleGridLabel: UILabel!
    @IBOutlet private weak var dateGridLabel: UILabel!
    @IBOutlet private weak var image: UIGradientImageView!

    @IBOutlet private weak var imageBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet private var imageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private var imageAspectRatioConstraint: NSLayoutConstraint!
    
    @IBOutlet private var titleListTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private var dateListTrailingConstraint: NSLayoutConstraint!
    
    private let titleFontSize: CGFloat = 20
    private let dateFontSize: CGFloat = 14
    private let imageMargin: CGFloat = 10
    private let cornerRadius: CGFloat = 14
    
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
        image.clipsToBounds = true
        image.layer.cornerRadius = cornerRadius
        imageTrailingConstraint.priority = .required
    }
    
    func setupListLayout() {
        imageTopConstraint.constant = imageMargin
        imageBottomConstraint.constant = imageMargin
        imageLeadingConstraint.constant = imageMargin
        
        imageTrailingConstraint.isActive = false
        imageAspectRatioConstraint.isActive = true
        
        titleListTrailingConstraint.isActive = true
        dateListTrailingConstraint.isActive = true
        
        setLabelsOpacity(to: 1)
        image.setGradientOpacity(to: 0)
    }
    
    private func startListLayoutTransition() {
        setupListLayout()
    }
    
    func setupGridLayout() {
        imageTopConstraint.constant = 0
        imageBottomConstraint.constant = 0
        imageLeadingConstraint.constant = 0
        
        imageAspectRatioConstraint.isActive = false
        imageTrailingConstraint.isActive = true
        
        titleListTrailingConstraint.isActive = false
        dateListTrailingConstraint.isActive = false
        
        setLabelsOpacity(to: 0)
        image.setGradientOpacity(to: 1)
    }
    
    private func transitGridLayout(_ progress: CGFloat) {
        let reverseProgress = 1 - progress
        
        setLabelsOpacity(to: reverseProgress)
        
        titleGridLabel.font = titleGridLabel.font.withSize(titleFontSize * progress)
        dateGridLabel.font = dateGridLabel.font.withSize(dateFontSize * progress)
        
        imageTopConstraint.constant *= reverseProgress
        imageBottomConstraint.constant *= reverseProgress
        imageLeadingConstraint.constant *= reverseProgress
        
        image.setGradientOpacity(to: progress)
        
        if progress > 0.9 {
            toggleListConstraintActive(value: false)
        }
    }
    
    private func setLabelsOpacity(to alpha: CGFloat) {
        let reverceAlpha = 1 - alpha
        
        dateListLabel.alpha = alpha
        titleListLabel.alpha = alpha
        
        titleGridLabel.alpha = reverceAlpha
        dateGridLabel.alpha = reverceAlpha
    }
    
    private func transitListLayout(_ progress: CGFloat) {
        setLabelsOpacity(to: progress)
        
        titleGridLabel.font = titleGridLabel.font.withSize(titleFontSize * alpha)
        dateGridLabel.font = dateGridLabel.font.withSize(dateFontSize * alpha)
        
        image.setGradientOpacity(to: 1 - progress)
        
        if progress > 0.2 {
            toggleListConstraintActive(value: true)
        }
    }
    
    override func willTransition(from oldLayout: UICollectionViewLayout, to newLayout: UICollectionViewLayout) {
        super.willTransition(from: oldLayout, to: newLayout)
        
        guard let oldDisplaySwitchLayout = oldLayout as? DisplaySwitchLayout else { return }
        if oldDisplaySwitchLayout.layoutState == .list {
            // list -> grid
        } else {
            // grid -> list
            startListLayoutTransition()
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? DisplaySwitchLayoutAttributes, attributes.transitionProgress > 0 else { return }
        if attributes.layoutState == .grid {
            transitGridLayout(attributes.transitionProgress)
        } else {
            transitListLayout(attributes.transitionProgress)
        }
    }
    
    private func toggleListConstraintActive(value: Bool) {
        titleListTrailingConstraint.isActive = value
        dateListTrailingConstraint.isActive = value
        titleListLabel.isHidden = !value
        dateListLabel.isHidden = !value
    }
    
    func setup(with event: EventCollectionCellViewModel) {
        setTitle(event.title)
        setDate(for: event.shortDate, and: event.longDate)
        setImage(event.image)
    }
    
    private func setTitle(_ title: String) {
        titleListLabel.text = title
        titleGridLabel.text = title
    }
    
    private func setDate(for shortDate: String, and longDate: String) {
        dateListLabel.text = longDate
        dateGridLabel.text = shortDate
    }
    
    private func setImage(_ image: UIImage) {
        self.image.image = image
    }
}
