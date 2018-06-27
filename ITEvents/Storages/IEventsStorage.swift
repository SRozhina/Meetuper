typealias EventRequestCallback = ([Event], Int) -> Void

protocol IEventsStorage {
    func searchEvents(indexRange: Range<Int>, searchText: String, searchTags: [Tag]) -> Cancelable<EventsResult>
    
    //TODO for dates from json https://useyourloaf.com/blog/swift-codable-with-custom-dates/
}
