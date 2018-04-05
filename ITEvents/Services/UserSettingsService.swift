import Foundation
import CoreData
import UIKit

class UserSettingsService: IUserSettingsService {
    let entityName = "Settings"
    
    func fetchSettings(then completion: @escaping (UserSettings) -> Void) {
        let settings = getOrCreateSettings()
        var userSettings = UserSettings(isListLayoutSelected: true)
        let isList = settings.value(forKey: "isListLayoutSelected") as! Bool
        userSettings.isListLayoutSelected = isList
        completion(userSettings)
    }
    
    func save(settings: UserSettings) {
        let savedSettings = getOrCreateSettings()
        savedSettings.isListLayoutSelected = settings.isListLayoutSelected
        try? getContext().save()
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func getOrCreateSettings() -> Settings {
        let managedContext = getContext()
        let request: NSFetchRequest<Settings> = Settings.fetchRequest()
        let results = try? managedContext.fetch(request)
        if let result = results?.last {
            return result
        } else {
            let entity = Settings.entity()
            return Settings(entity: entity, insertInto: managedContext)
        }
    }
}
