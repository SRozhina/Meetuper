protocol IUserSettingsStorage {
    func fetchSettings(then completion: @escaping (UserSettings) -> Void)
    func saveSettings(settings: UserSettings) 
}
