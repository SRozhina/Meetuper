import Foundation
import UIKit

struct Event {
    let title: String
    let startDate: Date
    let endDate: Date
    let address: String
    let city: String
    let country: String
    let description: String
    let tags: [Tag]
    let image: UIImage
}

struct Tag {
    let id: Int
    let name: String
}
