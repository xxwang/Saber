// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "Saber",
    products: [
        .library(
            name: "Saber",
            targets: ["Saber"]
        ),
//        .executable(
//            name: "Saber",
//            targets: ["Saber"]
//        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Saber",
            dependencies: []),
        .testTarget(
            name: "SaberTests",
            dependencies: ["Saber"]),
    ]
)
