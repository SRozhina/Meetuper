import Foundation
import CoreData
import UIKit

class UserSettingsService: IUserSettingsService {
    let entityName = "Settings"
    func fetchSettings(then completion: @escaping (UserSettings) -> Void) {
        let managedContext = getContext()
        
        let settingsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let settings = try? managedContext.fetch(settingsFetch).first
        if let fetchedSettings = settings as? UserSettings {
            completion(fetchedSettings)
        } else {
            completion(UserSettings(currentLayoutState: .list))
        }
    }
    
    func save(settings: UserSettings) {
        let managedContext = getContext()
        let settingsEntity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let savedSettings = NSManagedObject(entity: settingsEntity, insertInto: managedContext)
        savedSettings.setValue(settings.currentLayoutState, forKey: "isListLayoutSelected")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
