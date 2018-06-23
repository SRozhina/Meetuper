import UIKit
import TagListView

class SearchParametersViewController: UIViewController, ISearchParametersView {
    var presenter: ISearchParametersPresenter!

    @IBOutlet private weak var tagViewContainer: UIView!
    @IBOutlet private weak var selectedTagListView: TagListView!
    @IBOutlet private weak var otherTagListView: TagListView!
    
    private let gradientLayerColors = [
        UIColor(red: 0.25, green: 0.585, blue: 0.895, alpha: 100).cgColor,
        UIColor(red: 0.45, green: 0.78, blue: 0.95, alpha: 100).cgColor
    ]
    private let selectedGradientLayerColors = [
        UIColor(red: 0, green: 0.373, blue: 0.722, alpha: 100).cgColor,
        UIColor(red: 0.294, green: 0.67, blue: 0.87, alpha: 100).cgColor
    ]
    private let gradientLayerStartPoint = CGPoint(x: 0, y: 0)
    private let gradientLayerEndPoint = CGPoint(x: 1, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SharedUtils.decorateAsPanel(view: tagViewContainer)
        setupTagListViews()
        presenter.setup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.parametersSelectionFinished()
    }
    
    private func setupTagListViews() {
        selectedTagListView.delegate = self
        otherTagListView.delegate = self
        let tagsFont = UIFont.systemFont(ofSize: 18)
        selectedTagListView.textFont = tagsFont
        otherTagListView.textFont = tagsFont
    }
    
    func fillTagListViews(with selectedTags: [Tag], otherTags: [Tag]) {
        for tag in selectedTags {
            addTag(tag.name, to: selectedTagListView)
        }
        for tag in otherTags {
            addTag(tag.name, to: otherTagListView)
        }
    }
    
    private func addTag(_ tagName: String, to tagListView: TagListView) {
        let gradientColors = tagListView == selectedTagListView
            ? selectedGradientLayerColors
            : gradientLayerColors
        let tagView = tagListView.addTag(tagName)
        let gradientLayer = getGradientLayer(for: tagView.frame, and: gradientColors)
        tagView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func getGradientLayer(for frame: CGRect, and colors: [CGColor]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = gradientLayerStartPoint
        gradientLayer.endPoint = gradientLayerEndPoint
        gradientLayer.frame = frame
        return gradientLayer
    }
}

extension SearchParametersViewController: TagListViewDelegate {
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        presenter.removeTag(with: title)
        selectedTagListView.removeTagView(tagView)
        addTag(title, to: otherTagListView)
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if sender == selectedTagListView { return }
        presenter.selectTag(with: title)
        otherTagListView.removeTagView(tagView)
        addTag(title, to: selectedTagListView)
    }
}
