// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "NewsAPI.org",
    products: [
        .library(
            name: "NewsAPI.org",
            targets: ["NewsAPI.org"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "NewsAPI.org",
            dependencies: []),
        .testTarget(
            name: "NewsAPI.orgTests",
            dependencies: ["NewsAPI.org"]),
    ]
)
