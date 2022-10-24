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
    dependencies: [
        .package(url: "https://github.com/CoderMJLee/MJRefresh", from: "3.7.5"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", branch: "version6-xcode13"),
    ],
    targets: [
        .target(
            name: "Saber",
            dependencies: [
                "MJRefresh",
                "Kingfisher",
            ],
            path: "Sources/Saber"
        ),
        .testTarget(
            name: "SaberTests",
            dependencies: ["Saber"]
        ),
    ]
)
