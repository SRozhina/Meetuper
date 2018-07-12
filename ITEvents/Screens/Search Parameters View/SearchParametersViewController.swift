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
    private var tags: [Tag] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIViewUtils.decorateAsPanel(view: tagViewContainer)
        setupTagListViews()
        presenter.setup()
    }
    
    private func setupTagListViews() {
        selectedTagListView.delegate = self
        otherTagListView.delegate = self
        let tagsFont = UIFont.systemFont(ofSize: 18)
        selectedTagListView.textFont = tagsFont
        otherTagListView.textFont = tagsFont
    }
    
    func fill(with selectedTags: [Tag], otherTags: [Tag]) {
        clearTags()
        
        tags = selectedTags + otherTags
        for tag in selectedTags {
            addTag(tag.name, to: selectedTagListView)
        }
        for tag in otherTags {
            addTag(tag.name, to: otherTagListView)
        }
    }
    
    private func clearTags() {
        selectedTagListView.removeAllTags()
        otherTagListView.removeAllTags()
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
    
    @IBAction private func saveParameters(_ sender: Any) {
        presenter.saveSettings()
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchParametersViewController: TagListViewDelegate {
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        guard let tag = tags.first(where: { $0.name == title }) else { return }
        presenter.deselectTag(tag)
        selectedTagListView.removeTagView(tagView)
        addTag(title, to: otherTagListView)
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if sender == selectedTagListView { return }
        guard let tag = tags.first(where: { $0.name == title }) else { return }
        presenter.selectTag(tag)
        otherTagListView.removeTagView(tagView)
        addTag(title, to: selectedTagListView)
    }
}
