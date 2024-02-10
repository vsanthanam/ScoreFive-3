// ScoreFive
// AcknowledgementsScreen.swift
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
import SwiftExtensions
import SwiftUI

struct AcknowledgementsScreen: View {

    // MARK: - Initializers

    init() {}

    // MARK: - View

    @ViewBuilder
    var body: some View {
        List(acknowledgements) { acknowledgement in
            Button {
                safariURL = acknowledgement.url
            } label: {
                VStack(alignment: .leading) {
                    Text(acknowledgement.name)
                        .foregroundStyle(Color.label)
                    Text(acknowledgement.url.absoluteString)
                        .font(.caption)
                        .foregroundStyle(Color.secondaryLabel)
                }
            }
        }
        .safari(url: $safariURL)
        .navigationTitle("Acknowledgements")
    }

    @State
    private var safariURL: URL?

    @Environment(\.acknowledgements)
    private var acknowledgements: [Acknowledgement]
}

#Preview {
    AcknowledgementsScreen()
}
