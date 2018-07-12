extension Dictionary {
    /// Gets the value stored in the dictionary for the given key, or adds a
    /// new key-value pair (using valueFactory) if key does not exist.
    /// - Parameters:
    ///   - key: The key to associate with value.
    ///   - valueFactory: The function to create a new value if such doesn't exist yet.
    /// - Returns: The existing value that already presented in the dictionary,
    /// or a newly created value that was added (using valueFactory) to the dictionary
    mutating func getOrAddNewValue(key: Key, valueFactory: () -> Value) -> Value {
        var value: Value
        let existingValue = self[key]
        if existingValue != nil {
            value = existingValue!
        } else {
            value = valueFactory()
            self[key] = value
        }
        
        return value
    }
}
