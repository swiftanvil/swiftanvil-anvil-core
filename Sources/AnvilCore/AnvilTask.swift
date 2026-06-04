import Foundation

/// A `Sendable` concurrent task wrapper with a unique identifier.
///
/// Use `AnvilTask` to represent units of work that can cross actor boundaries.
/// Each task has a UUID and a human-readable label.
///
/// ```swift
/// let task = AnvilTask(label: "fetch-user", operation: { try await api.user(id: 1) })
/// let user = try await task.value
/// ```
public struct AnvilTask<T: Sendable>: Sendable {
    /// Unique identifier for this task.
    public let id: UUID

    /// Human-readable label describing the task.
    public let label: String

    private let operation: @Sendable () async throws -> T

    /// Create a new task with a label and operation.
    public init(
        id: UUID = UUID(),
        label: String,
        operation: @escaping @Sendable () async throws -> T
    ) {
        self.id = id
        self.label = label
        self.operation = operation
    }

    /// Execute the task and return its result.
    public var value: T {
        get async throws {
            try await operation()
        }
    }
}
