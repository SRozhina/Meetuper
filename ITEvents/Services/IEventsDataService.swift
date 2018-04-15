protocol IEventsDataService {
    func fetchEvents(then completion: @escaping ([Event]) -> Void)
    
    func searchEventsBy(text: String, tags: [Tag], then completion: @escaping ([Event]) -> Void)
    
    //TODO for dates from json https://useyourloaf.com/blog/swift-codable-with-custom-dates/
}
