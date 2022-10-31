// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "Saber",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v14),
        .watchOS(.v7),
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
