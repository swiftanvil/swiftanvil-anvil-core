/// Actor-isolated key-value configuration store.
///
/// Use `AnvilConfiguration` to store and retrieve typed configuration values
/// safely across concurrency boundaries.
///
/// ```swift
/// let config = AnvilConfiguration()
/// await config.set("apiKey", value: "secret123")
/// let key: String? = await config.get("apiKey")
/// ```
public actor AnvilConfiguration {
    private var storage: [String: AnySendable] = [:]

    /// Creates an empty configuration store.
    public init() {}

    /// Store a value for the given key.
    public func set(_ key: String, value: some Sendable) {
        storage[key] = AnySendable(value)
    }

    /// Retrieve a value by key, typed to the expected type.
    public func get<T: Sendable>(_ key: String) -> T? {
        storage[key]?.value as? T
    }

    /// Remove a value by key.
    public func remove(_ key: String) {
        storage.removeValue(forKey: key)
    }

    /// All keys currently stored.
    public var keys: [String] {
        Array(storage.keys)
    }

    /// Remove all stored values.
    public func clear() {
        storage.removeAll()
    }
}

/// Type-erased Sendable wrapper for configuration storage.
private struct AnySendable: Sendable {
    let value: any Sendable

    init(_ value: some Sendable) {
        self.value = value
    }
}
