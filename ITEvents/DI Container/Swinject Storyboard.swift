import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc class func setup() {
        defaultContainer.register(IEventsStorage.self) { _ in
            return EventsStorageMockImpl()
        }.inObjectScope(.container)
        
        defaultContainer.register(IEventTagsStorage.self) { _ in
            return EventTagsStorageMockImpl()
        }.inObjectScope(.container)
        
        defaultContainer.register(ISimilarEventsStorage.self) { _ in
            return SimilarEventsStorageMockImpl()
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
                              eventDataService: r.resolve(IEventsStorage.self)!,
                              selectedEventService: r.resolve(ISelectedEventService.self)!,
                              userSettingsService: r.resolve(IUserSettingsService.self)!,
                              dateFormatterService: r.resolve(IDateFormatterService.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(FavoritesViewController.self) { r, c in
            c.presenter = r.resolve(IFavoritePresenter.self, argument: c as IFavoriveView)!
        }
        
        defaultContainer.register(IFullEventPresenter.self) { r, v in
            FullEventPresenter(view: v,
                               selectedEventService: r.resolve(ISelectedEventService.self)!,
                               dateFormatterService: r.resolve(IDateFormatterService.self)!,
                               similarEventsService: r.resolve(ISimilarEventsStorage.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(FullEventViewController.self) { r, c in
            c.presenter = r.resolve(IFullEventPresenter.self, argument: c as IFullEventView)!
        }
        
        defaultContainer.register(ISearchPresenter.self) { r, v in
            SearchPresenter(view: v,
                            eventDataService: r.resolve(IEventsStorage.self)!,
                            selectedEventService: r.resolve(ISelectedEventService.self)!,
                            userSettingsService: r.resolve(IUserSettingsService.self)!,
                            dateFormatterService: r.resolve(IDateFormatterService.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(SearchViewController.self) { r, c in
            c.presenter = r.resolve(ISearchPresenter.self, argument: c as ISearchView)!
        }
    }
}
