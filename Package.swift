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
        // Saber
        .target(
            name: "Saber",
            dependencies: [],
            path: "Sources/Saber"
        ),
//        // Saber
//        .target(
//            name: "Saber",
//            dependencies: ["Extensions", "Utils"],
//            path: "Sources/Saber"
//        ),
//
//        // Extensions
//        .target(
//            name: "Extensions",
//            dependencies: ["Utils"],
//            path: "Sources/Extensions"
//        ),
//
//        // Shared
//        .target(
//            name: "Shared",
//            dependencies: [],
//            path: "Sources/Shared"
//        ),
//
//        // Utils
//        .target(
//            name: "Utils",
//            dependencies: ["Shared", "Extensions"],
//            path: "Sources/Utils"
//        ),
//
        // SaberTests
        .testTarget(
            name: "SaberTests",
            dependencies: ["Saber"]
        ),
    ]
)
