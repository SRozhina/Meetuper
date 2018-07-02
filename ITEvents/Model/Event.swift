import UIKit

struct Event: Equatable {
    let id: Int
    let title: String
    let dateInterval: DateInterval
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
