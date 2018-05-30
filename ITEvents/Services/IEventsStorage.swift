typealias EventRequestCallback = ([Event], Int) -> Void

protocol IEventsStorage {
    func fetchFavoriteEvents(indexRange: Range<Int>, then completion: @escaping EventRequestCallback)
    
    func searchEvents(indexRange: Range<Int>, searchText: String, searchTags: [Tag], then completion: @escaping EventRequestCallback) -> Cancelation
    
    //TODO for dates from json https://useyourloaf.com/blog/swift-codable-with-custom-dates/
}
