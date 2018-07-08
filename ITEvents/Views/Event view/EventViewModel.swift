import Foundation
import UIKit

struct EventCollectionCellViewModel {
    let id: Int
    let title: String
    let shortDate: String
    let longDate: String
    let image: UIImage
}

//TODO move all Equatable to extensions to tests
struct EventViewModel: Equatable {
    let id: Int
    let title: String
    let date: String
    let image: UIImage
    let address: String
    let city: String
    let country: String
    let description: String
    let tags: [Tag]
    let sourceName: String?
    let url: URL?
}
