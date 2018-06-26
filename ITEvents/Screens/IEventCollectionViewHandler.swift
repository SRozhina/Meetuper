import UIKit

protocol IEventCollectionViewHandler: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var isListLayoutSelected: Bool { get }
    
    var isLoadingIndicatorShown: Bool { get }
    
    func setEvents(_ newEvents: [EventCollectionCellViewModel])
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showBackgroundView()
    func hideBackgroundView() 
    
    func toggleListLayout(value isListLayout: Bool)
}
