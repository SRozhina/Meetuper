protocol IEventsStorage {
    func fetchEvents(then completion: @escaping ([Event]) -> Void)
    
    func searchEvents(by text: String, and tags: [Tag], then completion: @escaping ([Event]) -> Void)
    
    //TODO for dates from json https://useyourloaf.com/blog/swift-codable-with-custom-dates/
}
