// ScoreFive
// Project.swift
//
// MIT License
//
// Copyright (c) 2021 Varun Santhanam
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
//
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import ProjectDescription

let project = Project(
    name: "ScoreFive",
    organizationName: "com.varunsanthanam",
    options: .options(
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
    ),
    targets: [
        Target(
            name: "ScoreFive",
            destinations: .iOS,
            product: .app,
            bundleId: "com.varunsanthanam.ScoreFive2",
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "3.0.0",
                "CFBundleVersion": "310",
                "UILaunchScreen": [
                    "UILaunchScreen": [:]
                ]
            ]),
            sources: [
                "ScoreFive/Sources/**"
            ],
            resources: [
                "ScoreFive/Resources/**"
            ],
            entitlements: .file(
                path: "ScoreFive/ScoreFive.entitlements"
            ),
            dependencies: [
                .project(target: "FiveKit", path: "../FiveKit"),
                .external(name: "SwiftUtilities"),
                .external(name: "SafariView")
            ]
        ),
        Target(
            name: "ScoreFiveTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.varunsanthanam.ScoreFiveTests",
            infoPlist: .default,
            sources: [
                "ScoreFiveTests/Sources/**"
            ],
            resources: [],
            dependencies: [
                .target(
                    name: "ScoreFive"
                )
            ]
        ),
        Target(
            name: "ScoreFiveUITests",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "com.varunsanthanam.ScoreFiveUITests",
            infoPlist: .default,
            sources: [
                "ScoreFiveUITests/Sources/**"
            ],
            resources: [],
            dependencies: [
                .target(
                    name: "ScoreFive"
                )
            ]
        )
    ]
)
