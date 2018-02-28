import Foundation

protocol ISimilarEventsDataService {
    func fetchSimilarEvents(for eventId: Int, then completion: @escaping ([Event]) -> Void)
}
