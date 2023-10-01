// ScoreFive
// RecordViewRow.swift
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

import SwiftUI

struct RecordViewRow: View {

    // MARK: - Initializers

    init(signpost: String? = nil, entries: [RecordViewRow.Entry]) {
        self.signpost = signpost
        self.entries = entries
    }

    init(signpost: String? = nil, entries: [String]) {
        self.init(signpost: signpost, entries: entries.map { entry in
            Entry(content: entry)
        })
    }

    // MARK: - API

    let signpost: String?

    let entries: [Entry]

    struct Configuration {

        // MARK: - Initializers

        init(
            isAccented: Bool = false,
            hasTopDivider: Bool = false,
            hasBottomDivider: Bool = false
        ) {
            self.isAccented = isAccented
            self.hasTopDivider = hasTopDivider
            self.hasBottomDivider = hasBottomDivider
        }

        // MARK: - API

        let isAccented: Bool
        let hasTopDivider: Bool
        let hasBottomDivider: Bool
    }

    struct Entry: Hashable {

        // MARK: - Initializers

        init(
            content: String?,
            highlight: RecordViewRow.Entry.Highlight = .none,
            eliminated: Bool = false
        ) {
            self.content = content
            self.highlight = highlight
            self.eliminated = eliminated
        }

        // MARK: - API

        let content: String?

        let highlight: Highlight

        let eliminated: Bool

        enum Highlight: Hashable {

            // MARK: - Cases

            case none

            case winning

            case losing

            // MARK: - API

            var color: Color {
                switch self {
                case .none:
                    .label
                case .winning:
                    .green
                case .losing:
                    .red
                }
            }
        }
    }

    // MARK: - View

    @ViewBuilder
    var body: some View {
        VStack(spacing: .zero) {
            if configuration.hasTopDivider {
                Divider()
            }
            HStack(spacing: 0.0) {
                Text(signpost ?? "")
                    .foregroundStyle(Color.label)
                    .frame(width: rowHeight, height: rowHeight)
                HStack(spacing: 0.0) {
                    ForEach(entries.indices, id: \.self) { index in
                        let entry = entries[index]
                        Text(entry.content ?? "")
                            .foregroundStyle(entry.highlight.color)
                            .frame(maxWidth: .infinity)
                            .fontWeight(configuration.isAccented ? .bold : .regular)
                            .opacity(entry.eliminated ? 0.3 : 1.0)

                    }
                }
                .frame(maxWidth: .infinity)
            }
            if configuration.hasBottomDivider {
                Divider()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: rowHeight)
        .fontDesign(.monospaced)
    }

    // MARK: - Private

    @ScaledMetric(relativeTo: .body)
    private var rowHeight = 44.0

    @Environment(\.recordViewRowConfiguration)
    private var configuration: Configuration
}

#Preview(traits: .sizeThatFitsLayout) {
    RecordViewRow(signpost: "X", entries: [
        .init(content: "12", highlight: .none, eliminated: false),
        .init(content: "24", highlight: .losing, eliminated: false),
        .init(content: "0", highlight: .winning, eliminated: false)
    ])
}

#Preview(traits: .sizeThatFitsLayout) {
    RecordViewRow(signpost: "X", entries: [
        .init(content: "252", highlight: .none, eliminated: true),
        .init(content: "124", highlight: .losing, eliminated: false),
        .init(content: "80", highlight: .winning, eliminated: false),
        .init(content: "101", highlight: .none, eliminated: false)
    ])
    .recordViewRowConfiguration(isAccented: true, hasTopDivider: true, hasBottomDivider: true)
}
