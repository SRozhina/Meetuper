import Promises

protocol ISimilarEventsStorage {
    func fetchSimilarEvents(for eventId: Int) -> Promise<[Event]>
}
