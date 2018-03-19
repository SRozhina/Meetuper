import Foundation
import UIKit
import Reusable
import TagListView

class EventTagsView: UIView, NibLoadable {
    @IBOutlet private weak var tagListView: TagListView!
    private let leftColor = UIColor(red: 0.25, green: 0.585, blue: 0.895, alpha: 100).cgColor
    private let rightColor = UIColor(red: 0.45, green: 0.78, blue: 0.95, alpha: 100).cgColor
    
    class func initiateAndSetup(with tags: [Tag], fontSize: CGFloat = 18) -> EventTagsView {
        let eventTagsView: EventTagsView = SharedUtils.createPanelView()
        eventTagsView.setup(with: tags, fontSize: fontSize)
        return eventTagsView
    }

    private func setup(with tags: [Tag], fontSize: CGFloat) {
        tagListView.textFont = UIFont.systemFont(ofSize: fontSize)
        let tagNames = tags.map { $0.name }
        for name in tagNames {
            let tagView = tagListView.addTag(name)
            let gradientLayer = getGradientLayer(for: tagView.frame)
            tagView.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    private func getGradientLayer(for frame: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [leftColor, rightColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = frame
        return gradientLayer
    }
}
