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

        defaultContainer.register(ISelectedEventService.self) { _ in
            return SelectedEventService()
        }.inObjectScope(.container)
        
        defaultContainer.register(IUserSettingsService.self) { _ in
            return UserSettingsService()
        }.inObjectScope(.container)
        
        defaultContainer.register(IFavoritePresenter.self) { r, v in
            FavoritePresenter(view: v,
                              eventDataService: r.resolve(IEventsDataService.self)!,
                              selectedEventService: r.resolve(ISelectedEventService.self)!,
                              userSettingsService: r.resolve(IUserSettingsService.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(FavoritesViewController.self) { r, c in
            c.dateFormatterService = r.resolve(IDateFormatterService.self)!
            c.presenter = r.resolve(IFavoritePresenter.self, argument: c as IFavoriveView)!
        }
        
        defaultContainer.register(IFullEventPresenter.self) { r, v in
            FullEventPresenter(view: v,
                               selectedEventService: r.resolve(ISelectedEventService.self)!,
                               dateFormatterService: r.resolve(IDateFormatterService.self)!,
                               similarEventsService: r.resolve(ISimilarEventsDataService.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(FullEventViewController.self) { r, c in
            c.presenter = r.resolve(IFullEventPresenter.self, argument: c as IFullEventView)!
        }
    }
}
