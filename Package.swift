// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Tuist",
    dependencies: [
        .package(
            url: "https://github.com/vsanthanam/SafariUI",
            from: "3.0.0"
        ),
        .package(
            url: "https://github.com/vsanthanam/SwiftExtensions",
            from: "0.0.5"
        )
    ]
)
