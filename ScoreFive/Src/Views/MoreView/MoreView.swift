// ScoreFive
// MoreView.swift
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

import Macros
import SafariView
import StoreKit
import SwiftUI
import Utils

struct MoreView: View {

    // MARK: - View

    @ViewBuilder
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Label("Version", systemImage: "info.circle")
                        .badge("\(Bundle.main.shortVersion) (\(Bundle.main.build))")
                    Button(action: openSourceCode) {
                        HStack {
                            Label("Source Code", systemImage: "chevron.left.forwardslash.chevron.right")
                            Spacer()
                            Chevron()
                        }
                    }
                } header: {
                    Text("About")
                }
                Section {
                    Button {
                        safariURL = #Link("https://www.scorefive.app")
                    } label: {
                        HStack {
                            Label("Instructions", systemImage: "book")
                            Spacer()
                            Chevron()
                        }
                    }
                    Button {
                        openEmail()
                    } label: {
                        HStack {
                            Label("Email", systemImage: "envelope")
                            Spacer()
                            Chevron()
                        }
                    }
                } header: {
                    Text("Help")
                }
            }
            .labelStyle(CellStyle())
            .navigationTitle("More")
            .safari(url: $safariURL)
        }
    }

    @State
    private var safariURL: URL?

    private func openSourceCode() {
        UIApplication.shared.open(#Link("https://github.com/vsanthanam/ScoreFive-3"))
    }

    private func openEmail() {
        UIApplication.shared.open(#MailTo("talkto@vsanthanam.com"))
    }
}

#Preview {
    MoreView()
}

struct CellStyle: LabelStyle {

    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
                .foregroundStyle(Color.label)
        } icon: {
            configuration.icon
        }
    }
}
