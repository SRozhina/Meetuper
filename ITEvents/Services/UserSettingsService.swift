import Foundation
import CoreData
import UIKit

class UserSettingsService: IUserSettingsService {
    let entityName = "Settings"
    
    func fetchSettings() -> UserSettings {
        let settings = getOrCreateSettings()
        var userSettings = UserSettings(isListLayoutSelected: true)
        if let isList = settings.value(forKey: "isListLayoutSelected") as? Bool {
            userSettings.isListLayoutSelected = isList
        }
        return userSettings
    }
    
    func save(settings: UserSettings) {
        let savedSettings = getOrCreateSettings()
        savedSettings.isListLayoutSelected = settings.isListLayoutSelected
        getApp().saveContext()
    }
    
    private func getApp() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    private func getOrCreateSettings() -> Settings {
        let managedContext = getApp().persistentContainer.viewContext
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
