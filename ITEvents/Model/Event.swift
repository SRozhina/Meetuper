import Foundation
import UIKit

struct Event {
    let id: Int
    let title: String
    let startDate: Date
    let endDate: Date
    let address: String
    let city: String
    let country: String
    let description: String
    let tags: [Tag]
    let image: UIImage
    let similarEventsCount: Int
    let source: EventSource?
    let url: URL?
}

struct Tag {
    let id: Int
    let name: String
}

struct EventSource {
    let id: Int
    let name: String
}
