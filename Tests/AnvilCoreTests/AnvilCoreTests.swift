import AnvilCore
import Testing

@Suite("AnvilLogger")
struct AnvilLoggerTests {
    @Test("logs entry at specified level")
    func logEntry() async {
        let logger = AnvilLogger()
        await logger.log(.info, "hello")
        let entries = await logger.allEntries
        #expect(entries.count == 1)
        #expect(entries[0].level == .info)
        #expect(entries[0].message == "hello")
    }

    @Test("convenience methods log correct levels")
    func convenienceLevels() async {
        let logger = AnvilLogger()
        await logger.trace("t")
        await logger.debug("d")
        await logger.info("i")
        await logger.warn("w")
        await logger.error("e")
        let entries = await logger.allEntries
        #expect(entries.map(\.level) == [.trace, .debug, .info, .warn, .error])
    }

    @Test("clear removes all entries")
    func testClear() async {
        let logger = AnvilLogger()
        await logger.info("msg")
        await logger.clear()
        let entries = await logger.allEntries
        #expect(entries.isEmpty)
    }

    @Test("captures file and line metadata")
    func metadata() async {
        let logger = AnvilLogger()
        await logger.info("test", file: "File.swift", line: 42)
        let entry = await logger.allEntries[0]
        #expect(entry.file == "File.swift")
        #expect(entry.line == 42)
    }
}

@Suite("AnvilConfiguration")
struct AnvilConfigurationTests {
    @Test("stores and retrieves string value")
    func stringValue() async {
        let config = AnvilConfiguration()
        await config.set("key", value: "value")
        let result: String? = await config.get("key")
        #expect(result == "value")
    }

    @Test("stores and retrieves int value")
    func intValue() async {
        let config = AnvilConfiguration()
        await config.set("count", value: 42)
        let result: Int? = await config.get("count")
        #expect(result == 42)
    }

    @Test("returns nil for missing key")
    func missingKey() async {
        let config = AnvilConfiguration()
        let result: String? = await config.get("missing")
        #expect(result == nil)
    }

    @Test("remove deletes key")
    func testRemove() async {
        let config = AnvilConfiguration()
        await config.set("key", value: "value")
        await config.remove("key")
        let result: String? = await config.get("key")
        #expect(result == nil)
    }

    @Test("keys returns all stored keys")
    func testKeys() async {
        let config = AnvilConfiguration()
        await config.set("a", value: 1)
        await config.set("b", value: 2)
        let keys = await config.keys
        #expect(keys.count == 2)
        #expect(keys.contains("a"))
        #expect(keys.contains("b"))
    }

    @Test("clear removes all values")
    func testClear() async {
        let config = AnvilConfiguration()
        await config.set("a", value: 1)
        await config.clear()
        let keys = await config.keys
        #expect(keys.isEmpty)
    }
}

@Suite("AnvilTask")
struct AnvilTaskTests {
    @Test("executes operation and returns value")
    func testValue() async throws {
        let task = AnvilTask(label: "add") { 2 + 2 }
        let result = try await task.value
        #expect(result == 4)
    }

    @Test("has unique id")
    func uniqueID() {
        let task1 = AnvilTask(label: "a") { 1 }
        let task2 = AnvilTask(label: "b") { 2 }
        #expect(task1.id != task2.id)
    }

    @Test("preserves label")
    func testLabel() {
        let task = AnvilTask(label: "my-task") { 42 }
        #expect(task.label == "my-task")
    }

    @Test("propagates errors")
    func errorPropagation() async throws {
        struct TestError: Error { }
        let task = AnvilTask(label: "fail") { () -> Int in
            throw TestError()
        }
        await #expect(throws: TestError.self) {
            _ = try await task.value
        }
    }
}
