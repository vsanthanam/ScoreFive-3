// swift-tools-version: 5.8
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [
            "SafariUI": .staticFramework,
            "SwiftUtilities": .staticFramework,
            "UIUtilities": .staticFramework,
        ],
        platforms: [.iOS]
    )
#endif

let package = Package(
    name: "ExternalPackages",
    dependencies: [
        .package(url: "https://github.com/vsanthanam/SafariUI", from: "3.0.0"),
        .package(url: "https://github.com/vsanthanam/SwiftUtilities", from: "0.0.0")
    ]
)
