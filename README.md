# Meetuper

[![Build Status](https://travis-ci.com/SRozhina/Meetuper.svg?branch=master)](https://travis-ci.com/SRozhina/Meetuper)

Mobile app for service that aggregates IT events (meet-ups and conferences) from different sources in one place. So users don’t need to search for it using different sites and tools.
The service will consist of three parts: Mobile app, Backend and Web app
I am responsible for mobile app and [AVykhrystyuk](https://github.com/AVykhrystyuk) is responsible for other parts. 

About the service we are building:
Our goal to is to provide user ability to easily find interesting IT events (meet-ups and conferences).
The system will be free of all kind of courses, webinars and not related to IT events.
The service should allow to add (publish) new IT events specifying the event description, location, date and related to event tech themes (tags). 
Also there should be a flexible way of searching events by location, technology, or key words. User could select favorite themes and receive notifications about newly published events. So no need to frequently check the if there is a new interesting event is published.
 
About Mobile app:
For now my app uses mocks API because the backend part is under development yet. But API schema is already defined.
The app contains 3 tabs: Favorites, Search and Settings. 
Favorites shows events for themes (tags) selected as favorites (in Settings).
Search main function is searching events :smile: You could search by key words, themes and cities.
Settings allows to change current city, favorite themes and app layout (table/grid). 
In future there will be one more tab where events’ organizators could create new events. 
The app is under development.

For the app I use: 
- Architecture: MVP with ViewModels
- DI: Swinject
- UI elements: Tab bar controller, Collection view controller, Scroll view, Stack view, Search bar
- Libraries: TagListView, Reusable (for convenient work with static strings), Promises (for async operations), GCD (to simulate async operations), NotificationCenter (for notify views about changes)
