typealias EventsStorageCallback = ([Event], Int) -> Void

protocol IEventsStorage {
    func fetchFavoriteEvents(then completion: @escaping EventsStorageCallback)
    
    func searchEvents(indexRange: Range<Int>, searchText: String, searchTags: [Tag], then completion: @escaping EventsStorageCallback)
    
    //TODO for dates from json https://useyourloaf.com/blog/swift-codable-with-custom-dates/
}
