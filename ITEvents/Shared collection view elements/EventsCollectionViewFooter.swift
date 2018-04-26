import UIKit

class EventsCollectionViewFooter: UICollectionReusableView {
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    func showFooter() {
        isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideFooter() {
        isHidden = true
        activityIndicator.stopAnimating()
    }
}
