// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ExternalDependencies",
    dependencies: [
        .package(
            url: "https://github.com/vsanthanam/SafariUI",
            from: "3.0.0"
        ),
        .package(
            url: "https://github.com/vsanthanam/SwiftExtensions",
            from: "0.0.7"
        ),
        .package(
            url: "https://github.com/mattgallagher/CwlPreconditionTesting.git",
            from: "2.2.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.0.0"
        )
    ]
)
