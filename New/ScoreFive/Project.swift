import ProjectDescription

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project(
    name: "ScoreFive",
    organizationName: "com.varunsanthanam",
    packages: [
        .local(path: "Packages/FiveKit"),
        .remote(url: "git@github.com:vsanthanam/SafariUI.git", requirement: .upToNextMajor(from: "3.0.0")),
        .remote(url: "git@github.com:vsanthanam/SwiftUtilities.git", requirement: .upToNextMajor(from: "0.0.0"))
    ],
    targets: [
        Target(
            name: "ScoreFive",
            destinations: .iOS,
            product: .app,
            bundleId: "com.varunsanthanam.ScoreFive2",
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "3.0.0",
                "CFBundleVersion": "310"
            ]),
            sources: ["Targets/ScoreFive/Sources/**"],
            resources: ["Targets/ScoreFive/Resources/**"],
            entitlements: .file(path: "Targets/ScoreFive/ScoreFive.entitlements"),
            dependencies: [
                .package(product: "FiveKit", type: .runtime, condition: nil),
                .package(product: "SafariUI", type: .runtime, condition: nil),
                .package(product: "SwiftUtilities", type: .runtime, condition: nil),
                .package(product: "UIUtilities", type: .runtime, condition: nil)
            ]
        ),
        Target(
            name: "ScoreFiveTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.varunsanthanam.ScoreFiveTests",
            infoPlist: .default,
            sources: ["Targets/ScoreFiveTests/Sources/**"],
            resources: [],
            dependencies: [
                .target(name: "ScoreFive")
            ]
        ),
        Target(
            name: "ScoreFiveUITests",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "com.varunsanthanam.ScoreFiveUITests",
            infoPlist: .default,
            sources: ["Targets/ScoreFiveUITests/Sources/**"],
            resources: [],
            dependencies: [
                .target(name: "ScoreFive")
            ]
        )
    ]
)
