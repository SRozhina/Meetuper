protocol ISettingsStorage {
    func fetchSettings() -> UserSettings
    func saveSettings(settings: UserSettings) 
}
