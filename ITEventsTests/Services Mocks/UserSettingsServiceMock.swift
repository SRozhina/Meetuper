@testable import ITEvents

class UserSettingsServiceMock: IUserSettingsService {
    private var userSettings = UserSettings(isListLayoutSelected: true)
    
    func fetchSettings() -> UserSettings {
        return userSettings
    }
    
    func save(settings: UserSettings) {
        userSettings = settings
    }
}
