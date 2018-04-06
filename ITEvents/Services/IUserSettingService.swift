protocol IUserSettingsService {
    func fetchSettings() -> UserSettings
    
    func save(settings: UserSettings)
}
