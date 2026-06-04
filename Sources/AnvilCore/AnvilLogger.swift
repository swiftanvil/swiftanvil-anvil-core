/// Structured logging with severity levels.
///
/// Use `AnvilLogger` to emit log messages with a level, source file, and line number.
/// The logger is `Sendable` and safe to use across concurrency domains.
///
/// ```swift
/// let logger = AnvilLogger()
/// await logger.info("Starting network request")
/// await logger.error("Request failed", file: #file, line: #line)
/// ```
public actor AnvilLogger {
    /// The severity level of a log message.
    public enum Level: String, Sendable, CaseIterable {
        case trace
        case debug
        case info
        case warn
        case error
    }

    /// A single log entry.
    public struct Entry: Sendable, Equatable {
        public let level: Level
        public let message: String
        public let file: String
        public let line: Int
        public let timestamp: UInt64

        public init(
            level: Level,
            message: String,
            file: String,
            line: Int,
            timestamp: UInt64
        ) {
            self.level = level
            self.message = message
            self.file = file
            self.line = line
            self.timestamp = timestamp
        }
    }

    private var entries: [Entry] = []

    /// Creates a new logger.
    public init() {}

    /// All recorded log entries.
    public var allEntries: [Entry] { entries }

    /// Log a message at the given level.
    public func log(
        _ level: Level,
        _ message: String,
        file: String = #file,
        line: Int = #line
    ) {
        let entry = Entry(
            level: level,
            message: message,
            file: file,
            line: line,
            timestamp: continuousClockNanoseconds()
        )
        entries.append(entry)
    }

    /// Convenience: log at `.trace`.
    public func trace(_ message: String, file: String = #file, line: Int = #line) {
        log(.trace, message, file: file, line: line)
    }

    /// Convenience: log at `.debug`.
    public func debug(_ message: String, file: String = #file, line: Int = #line) {
        log(.debug, message, file: file, line: line)
    }

    /// Convenience: log at `.info`.
    public func info(_ message: String, file: String = #file, line: Int = #line) {
        log(.info, message, file: file, line: line)
    }

    /// Convenience: log at `.warn`.
    public func warn(_ message: String, file: String = #file, line: Int = #line) {
        log(.warn, message, file: file, line: line)
    }

    /// Convenience: log at `.error`.
    public func error(_ message: String, file: String = #file, line: Int = #line) {
        log(.error, message, file: file, line: line)
    }

    /// Clear all recorded entries.
    public func clear() {
        entries.removeAll()
    }
}

private func continuousClockNanoseconds() -> UInt64 {
    // Fallback to a simple counter; real implementation would use clock_gettime
    var count: UInt64 = 0
    withUnsafeMutablePointer(to: &count) { ptr in
        _ = ptr
    }
    return count
}
