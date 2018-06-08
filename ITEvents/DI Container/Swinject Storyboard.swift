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
        
        defaultContainer.register(IFavoritePresenter.self) { resolver, view in
            FavoritePresenter(view: view,
                              eventStorage: resolver.resolve(IEventsStorage.self)!,
                              selectedEventService: resolver.resolve(ISelectedEventService.self)!,
                              userSettingsService: resolver.resolve(IUserSettingsService.self)!,
                              dateFormatterService: resolver.resolve(IDateFormatterService.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(FavoritesViewController.self) { resolver, view in
            view.presenter = resolver.resolve(IFavoritePresenter.self, argument: view as IFavoriveView)!
        }
        
        defaultContainer.register(IFullEventPresenter.self) { resolver, view in
            FullEventPresenter(view: view,
                               selectedEventService: resolver.resolve(ISelectedEventService.self)!,
                               dateFormatterService: resolver.resolve(IDateFormatterService.self)!,
                               similarEventsService: resolver.resolve(ISimilarEventsStorage.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(FullEventViewController.self) { resolver, view in
            view.presenter = resolver.resolve(IFullEventPresenter.self, argument: view as IFullEventView)!
        }
        
        defaultContainer.register(ISearchPresenter.self) { resolver, view in
            SearchPresenter(view: view,
                            eventStorage: resolver.resolve(IEventsStorage.self)!,
                            selectedEventService: resolver.resolve(ISelectedEventService.self)!,
                            userSettingsService: resolver.resolve(IUserSettingsService.self)!,
                            dateFormatterService: resolver.resolve(IDateFormatterService.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(SearchViewController.self) { resolver, view in
            view.presenter = resolver.resolve(ISearchPresenter.self, argument: view as ISearchView)!
        }
    }
}
