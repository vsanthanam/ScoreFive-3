// ScoreFive
// MoreScreen.swift
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

import SafariView
import StoreKit
import SwiftExtensions
import SwiftUI

@MainActor
struct MoreScreen: View {

    // MARK: - Initializers

    init() {}

    // MARK: - View

    @ViewBuilder
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        safariURL = #URL("https://www.scorefive.app")
                    } label: {
                        HStack {
                            Label(
                                "Instructions",
                                systemImage: "book"
                            )
                            Spacer()
                            Chevron()
                        }
                    }
                    Button {
                        openEmail()
                    } label: {
                        HStack {
                            Label(
                                "Contact Us",
                                systemImage: "envelope"
                            )
                            Spacer()
                            Chevron()
                        }
                    }
                } header: {
                    Text("Get Help")
                }
                Section {
                    Button {
                        leaveReview()
                    } label: {
                        Label(
                            "Leave Review",
                            systemImage: "star.bubble"
                        )
                    }
                    ShareLink(item: #URL("https://www.apple.com")) {
                        Label(
                            "Tell a Friend",
                            systemImage: "square.and.arrow.up"
                        )
                    }
                } header: {
                    Text("Support Us")
                }
                Section {
                    if let version = Bundle.main.shortVersion, let build = Bundle.main.version {
                        Label(
                            "Version",
                            systemImage: "info.circle"
                        )
                        .badge("\(version) (\(build))")
                    }
                    Button {
                        openSourceCode()
                    } label: {
                        HStack {
                            Label(
                                "Source Code",
                                systemImage: "chevron.left.forwardslash.chevron.right"
                            )
                            Spacer()
                            Chevron()
                        }
                    }
                    NavigationLink {
                        AcknowledgementsScreen()
                    } label: {
                        Label(
                            "Acknowledgements",
                            systemImage: "person.3"
                        )
                    }
                } header: {
                    Text("About")
                }
            }
            .labelStyle(.cell)
            .navigationTitle("More")
            .safari(url: $safariURL)
        }
    }

    @State
    private var safariURL: URL?

    @AppStorage("moreView.hasLeftReview")
    private var hasLeftReview = false

    @Environment(\.requestReview)
    private var requestReview: RequestReviewAction

    @Environment(\.openURL)
    private var openURL: OpenURLAction

    private func openSourceCode() {
        openURL(#URL("https://github.com/vsanthanam/ScoreFive-3"))
    }

    private func openEmail() {
        openURL(#URL("mailto:talkto@vsanthanam.com"))
    }

    private func leaveReview() {
        if !hasLeftReview {
            requestReview()
            hasLeftReview = true
        } else {
            openURL(#URL("https://www.apple.com"))
        }
    }
}

#Preview {
    MoreScreen()
}
