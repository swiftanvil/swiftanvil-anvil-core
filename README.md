# AnvilCore

Shared infrastructure for the SwiftAnvil ecosystem.

## Features

- **AnvilLogger** — Structured logging with severity levels (`trace`, `debug`, `info`, `warn`, `error`)
- **AnvilConfiguration** — Actor-isolated key-value configuration store
- **AnvilTask** — `Sendable` concurrent task wrapper with UUID

## Usage

```swift
import AnvilCore

// Logging
let logger = AnvilLogger()
await logger.info("Starting operation")
await logger.error("Something went wrong", file: #file, line: #line)

// Configuration
let config = AnvilConfiguration()
await config.set("apiKey", value: "secret123")
let apiKey: String? = await config.get("apiKey")

// Tasks
let task = AnvilTask(label: "fetch-data") { try await fetchData() }
let data = try await task.value
```

## Platforms

- iOS 18+
- macOS 15+
- tvOS 18+
- watchOS 11+
- visionOS 2+

## Dependencies

None. Pure Swift standard library.
