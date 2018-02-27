import Foundation
import UIKit

class EventView: UIStackView {
    //@IBOutlet weak var stackView: UIStackView!
    
    class func initiateAndSetup(with event: Event) -> EventView {
        let tempDescription = "19:10 - 19:40: “Svelte — «магический» фреймворк” Тим Маринин Поговорим про Svelte и подумаем зачем нам ещё один фреймворк, и что это значит, что в нём нет рантайма? 19:55 - 20:25: “ES2018?” Михаил Полубояринов 23–28 января 2018 г. прошел очередной митинг TC39, на котором обсуждалось то что пойдет в ES2018 и Михаилу хотелось бы поделиться с Вами результатами этого митинга. 20:40 - 21:20: “рефакторинг” Алексей Золотых Рефакторинг приложения является неотъемлемой частью разработки. В своем докладе я расскажу про практические аспекты этого процесса."
        
        let eventView = UINib(nibName: "EventView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventView
        
        let eventInfo = EventInfo.initiateAndSetup(withImage: event.image, title: event.title, date: "21 February, 19:00-22:00") //TODO common date description for all project
        eventView.addArrangedSubview(eventInfo)
        
        let eventPlace = EventPlace.initiateAndSetup(withCity: event.city, country: event.country, address: event.address)
        eventView.addArrangedSubview(eventPlace)
        
        let eventDescription = EventDescription.initiateAndSetup(with: tempDescription)//TODO event.description)
        eventView.addArrangedSubview(eventDescription)
        
        let eventTags = EventTags.initiateAndSetup(with: event.tags)
        eventView.addArrangedSubview(eventTags)
        
        let showEventSource = ShowEventSource.initiateAndSetup(with: "Show on Timapad")
        eventView.addArrangedSubview(showEventSource)
        
        return eventView
    }
}
