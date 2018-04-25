typealias EventsDataServiceCallback = ([Event]) -> Void

protocol IEventsDataService {
    func fetchFavoriteEvents(then completion: @escaping EventsDataServiceCallback)
    
    //func searchEvents(by text: String, and tags: [Tag], then completion: @escaping ([Event]) -> Void)
    func searchEvents(indexRange: Range<Int>, parameters: SearchParameters, then completion: @escaping EventsDataServiceCallback)
    func fetchEvents(indexRange: Range<Int>, then completion: @escaping EventsDataServiceCallback)
    
    //TODO for dates from json https://useyourloaf.com/blog/swift-codable-with-custom-dates/
}
