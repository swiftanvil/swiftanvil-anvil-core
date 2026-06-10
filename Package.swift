// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AnvilCore",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2)
    ],
    products: [
        .library(name: "AnvilCore", targets: ["AnvilCore"])
    ],
    targets: [
        .target(
            name: "AnvilCore"
        ),
        .testTarget(
            name: "AnvilCoreTests",
            dependencies: ["AnvilCore"]
        )
    ],
    swiftLanguageModes: [.v6]
)
