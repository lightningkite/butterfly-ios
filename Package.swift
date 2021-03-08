// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "LKButterfly",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "LKButterfly",
            targets: ["LKButterfly"]),
    ],
    dependencies: [
            .package()
//         .package(url: "https://github.com/lightningkite/butterfly-ios", from: "0.0.0"),
    ],
    targets: [
        .target(
            name: "LKButterfly",
            dependencies: []),
        .testTarget(
            name: "LKButterflyTests",
            dependencies: ["LKButterfly"]),
    ]
)