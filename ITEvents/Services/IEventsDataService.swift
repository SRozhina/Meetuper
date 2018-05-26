typealias EventsDataServiceCallback = ([Event], Int) -> Void

protocol IEventsDataService {
    func fetchFavoriteEvents(then completion: @escaping EventsDataServiceCallback)
    
    func searchEvents(indexRange: Range<Int>, searchText: String, searchTags: [Tag], then completion: @escaping EventsDataServiceCallback)
    
    //TODO for dates from json https://useyourloaf.com/blog/swift-codable-with-custom-dates/
}
