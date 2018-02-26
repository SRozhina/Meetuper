import Foundation
import UIKit

class EventView: UIView {
    @IBOutlet weak var stackView: UIStackView!
    
    class func initiateFromNib(with event: Event) -> EventView {
        let tempDescription = "19:10 - 19:40: “Svelte — «магический» фреймворк” Тим Маринин Поговорим про Svelte и подумаем зачем нам ещё один фреймворк, и что это значит, что в нём нет рантайма? 19:55 - 20:25: “ES2018?” Михаил Полубояринов 23–28 января 2018 г. прошел очередной митинг TC39, на котором обсуждалось то что пойдет в ES2018 и Михаилу хотелось бы поделиться с Вами результатами этого митинга. 20:40 - 21:20: “рефакторинг” Алексей Золотых Рефакторинг приложения является неотъемлемой частью разработки. В своем докладе я расскажу про практические аспекты этого процесса."
        
        let eventView = UINib(nibName: "EventView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventView
        
        let eventInfo = EventInfo.initiateFromNib()
        eventInfo.imageView.image = event.image
        eventInfo.titleLabel.text = event.title
        eventInfo.dateLabel.text = "21 February, 19:00-22:00" //TODO common date description for all project
        eventView.stackView.addArrangedSubview(eventInfo)

        
        let eventPlace1 = EventPlace.initiateFromNib()
        eventView.stackView.addArrangedSubview(eventPlace1)
        
        let eventDescription = EventDescription.initiateFromNib()
        eventDescription.descriptionLabel.text = tempDescription
        
        eventView.stackView.addArrangedSubview(eventDescription)
        return eventView
    }
}
