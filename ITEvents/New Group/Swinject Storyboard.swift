import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc class func setup() {
        defaultContainer.register(IEventsDataService.self) { _ in
            return EventsDataServiceMockImpl()
        }.inObjectScope(.container)
        
        defaultContainer.register(IEventTagsDataService.self) { _ in
            return EventTagsDataServiceMockImpl()
        }.inObjectScope(.container)
        
        defaultContainer.register(ISimilarEventsDataService.self) { _ in
            return SimilarEventsDataServiceMockImpl()
        }.inObjectScope(.container)
        
        defaultContainer.register(IDateFormatterService.self) { _ in
            return DateFormatterService()
        }.inObjectScope(.container)

        defaultContainer.storyboardInitCompleted(FavoritesViewController.self) { r, c in
            c.eventDataService = r.resolve(IEventsDataService.self)!
            c.dateFormatterService = r.resolve(IDateFormatterService.self)!
        }
        
        defaultContainer.storyboardInitCompleted(FullEventViewController.self) { r, c in
            c.dateFormatterService = r.resolve(IDateFormatterService.self)!
            c.similarEventsService = r.resolve(ISimilarEventsDataService.self)!
        }
    }
}
