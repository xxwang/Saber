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
            targets: ["Saber", "Exts"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Saber",
            dependencies: [],
            path: "Sources/Saber"
        ),
        .target(
            name: "Exts",
            dependencies: [],
            path: "Sources/Exts"
        ),
        .testTarget(
            name: "SaberTests",
            dependencies: ["Saber"]
        ),
    ]
)
