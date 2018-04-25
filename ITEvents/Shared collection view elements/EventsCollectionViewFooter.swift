import UIKit

class EventsCollectionViewFooter: UICollectionReusableView {
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    func showFooter(withHeight height: CGFloat) {
        frame.size.height = height
        activityIndicator.startAnimating()
    }
    
    func hideFooter() {
        frame.size.height = 0
        activityIndicator.stopAnimating()
    }
}
