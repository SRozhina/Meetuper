import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc
    class func setup() {
        defaultContainer
            .register(IEventsStorage.self) { _ in EventsInMemoryStorage() }
            .inObjectScope(.container)
        
        defaultContainer
            .register(IEventTagsStorage.self) { _ in EventTagsInMemoryStorage() }
            .inObjectScope(.container)
        
        defaultContainer
            .register(ISimilarEventsStorage.self) { _ in SimilarEventsInMemoryStorage() }
            .inObjectScope(.container)
        
        defaultContainer
            .register(IDateFormatterService.self) { _ in DateFormatterService() }
            .inObjectScope(.container)
        
        defaultContainer
            .register(ISelectedEventService.self) { _ in SelectedEventService() }
            .inObjectScope(.container)
        
        defaultContainer
            .register(ISearchParametersService.self) { _ in  SearchParametersService() }
            .inObjectScope(.container)
        
        defaultContainer
            .register(IUserSettingsService.self) { _ in UserSettingsService() }
            .inObjectScope(.container)
        
        defaultContainer
            .register(IDebouncer.self) { _ in Debouncer() }
            .inObjectScope(.container)
        
        defaultContainer.register(IEventTagsStorage.self) { _ in EventTagsInMemoryStorage() }
        
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
                            eventsStorage: resolver.resolve(IEventsStorage.self)!,
                            selectedEventService: resolver.resolve(ISelectedEventService.self)!,
                            userSettingsService: resolver.resolve(IUserSettingsService.self)!,
                            dateFormatterService: resolver.resolve(IDateFormatterService.self)!,
                            tagsStorage: resolver.resolve(IEventTagsStorage.self)!,
                            searchParametersService: resolver.resolve(ISearchParametersService.self)!,
                            debouncer: resolver.resolve(IDebouncer.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(SearchViewController.self) { resolver, view in
            view.presenter = resolver.resolve(ISearchPresenter.self, argument: view as ISearchView)!
        }
        
        defaultContainer.register(ISearchParametersPresenter.self) { resolver, view in
            SearchParametersPresenter(view: view,
                                      searchParametersService: resolver.resolve(ISearchParametersService.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(SearchParametersViewController.self) { resolver, view in
            view.presenter = resolver.resolve(ISearchParametersPresenter.self,
                                              argument: view as ISearchParametersView)
        }
        
    }
}
