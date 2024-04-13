// ScoreFive
// LoadGameRow.swift
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

struct LoadGameRow: View {

    // MARK: - Initializers

    init(
        record: Record,
        lastUpdated: Bool = true,
        onSelect: @escaping (Record) -> Void
    ) {
        self.record = record
        self.lastUpdated = lastUpdated
        self.onSelect = onSelect
    }

    // MARK: - View

    @MainActor
    @ViewBuilder
    var body: some View {
        Button {
            onSelect(record)
        } label: {
            HStack {
                Image(systemName: record.isComplete ? "flag.checkered" : "clock")
                    .foregroundColor(Color.label)
                VStack(alignment: .leading) {
                    Text(playerNamesListFormatter.string(from: record.players) ?? "Unknown")
                        .foregroundStyle(Color.label)
                    Text(caption)
                        .font(.caption)
                        .foregroundStyle(Color.secondaryLabel)
                }
            }
        }
    }

    // MARK: - Private

    private let record: Record
    private let lastUpdated: Bool
    private let onSelect: (Record) -> Void

    @Environment(\.playerNamesListFormatter)
    private var playerNamesListFormatter: ListFormatter

    @Environment(\.recordLastUpdatedDateFormatter)
    private var recordLastUpdatedDateFormatter: DateFormatter

    private var caption: String {
        let dateString = recordLastUpdatedDateFormatter.string(from: lastUpdated ? record.lastUpdated : record.createdOn)
        if lastUpdated {
            return "Last updated at \(dateString)"
        } else {
            return "Created on \(dateString)"
        }
    }

}

#Preview {
    LoadGameRow(record: .init(scoreCard: .init(players: ["Dad", "Mom", "God", "Bro"], scoreLimit: 250))) { _ in }
}
