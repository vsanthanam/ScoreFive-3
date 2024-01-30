// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FiveKit",
    products: [
        .library(
            name: "FiveKit",
            targets: ["FiveKit"]
        ),
    ],
    targets: [
        .target(
            name: "FiveKit",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "FiveKitTests",
            dependencies: [
                "FiveKit"
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
    ]
)
