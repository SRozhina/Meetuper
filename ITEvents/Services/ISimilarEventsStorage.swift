import Foundation

protocol ISimilarEventsStorage {
    func fetchSimilarEvents(for eventId: Int, then completion: @escaping ([Event]) -> Void)
}
