protocol IUserSettingsService {
    func fetchSettings(then completion: @escaping (UserSettings) -> Void)
    
    func save(settings: UserSettings)
}
