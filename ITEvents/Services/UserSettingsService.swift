import Foundation

class UserSettingsService: IUserSettingsService {
    
    //TODO implement userdefaults storage and coredata storage, maybe realm storage
    private let settingsStorage: ISettingsStorage!
    private var _userSettings: UserSettings?
    
    init(settingsStorage: ISettingsStorage) {
        self.settingsStorage = settingsStorage
    }
    
    var userSettings: UserSettings? {
        get {
            if _userSettings == nil {
                _userSettings = settingsStorage.fetchSettings()
            }
            return _userSettings
        }
        set {
            _userSettings = newValue
            if _userSettings != nil {
                settingsStorage.saveSettings(settings: _userSettings!)
            }
        }
    }
}
