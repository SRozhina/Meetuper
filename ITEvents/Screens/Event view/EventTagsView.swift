import Foundation
import UIKit
import Reusable
import TagListView

class EventTagsView: UIView, NibLoadable {
    @IBOutlet private weak var tagListView: TagListView!
    private let gradientLayerColors = [
        UIColor(red: 0.25, green: 0.585, blue: 0.895, alpha: 100).cgColor,
        UIColor(red: 0.45, green: 0.78, blue: 0.95, alpha: 100).cgColor
    ]
    private let gradientLayerStartPoint = CGPoint(x: 0, y: 0)
    private let gradientLayerEndPoint = CGPoint(x: 1, y: 0)
    
    class func initiateAndSetup(with tags: [Tag], fontSize: CGFloat = 18) -> EventTagsView {
        let eventTagsView: EventTagsView = SharedUtils.createPanelView()
        eventTagsView.setup(with: tags, fontSize: fontSize)
        return eventTagsView
    }

    private func setup(with tags: [Tag], fontSize: CGFloat) {
        tagListView.textFont = UIFont.systemFont(ofSize: fontSize)
        for tag in tags {
            let tagView = tagListView.addTag(tag.name)
            let gradientLayer = getGradientLayer(for: tagView.frame)
            tagView.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    private func getGradientLayer(for frame: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientLayerColors
        gradientLayer.startPoint = gradientLayerStartPoint
        gradientLayer.endPoint = gradientLayerEndPoint
        gradientLayer.frame = frame
        return gradientLayer
    }
}
