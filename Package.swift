// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "Saber",
    platforms: [
        .iOS(.v13),
        .macOS(.v12),
        .tvOS(.v12),
        .watchOS(.v5),
    ],
    products: [
        .library(
            name: "Saber",
            targets: ["Saber"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Saber",
            dependencies: [],
            path: "Sources/Saber"
        ),
        .testTarget(
            name: "SaberTests",
            dependencies: ["Saber"]
        ),
    ]
)
