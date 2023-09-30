// ScoreFive
// LoadGameView.swift
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

import SwiftData
import SwiftUI
import Utils

struct LoadGameView: View {

    // MARK: - API

    @Binding
    var pages: [Record]

    // MARK: - View

    @ViewBuilder
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Show All", isOn: $showAll.animation())
                }
                Section {
                    ForEach(visibleRecords) { record in
                        Row(record: record, onSelect: selectRecord)
                    }
                    .onDelete { indexSet in
                        withAnimation {
                            indexSet
                                .forEach { index in
                                    modelContext.delete(visibleRecords[index])
                                }
                        }
                    }
                }
            }
            .navigationTitle("Load Game")
        }
        .onChange(of: visibleRecords) { lhs, rhs in
            if rhs.isEmpty {
                dismiss()
            }
        }
    }

    // MARK: - Private

    @State
    private var showAll = false

    @Query(sort: \Record.lastUpdated, order: .reverse)
    private var allRecords: [Record]

    @Environment(\.modelContext)
    private var modelContext: ModelContext

    @Environment(\.dismiss)
    private var dismiss: DismissAction

    private var incompleteRecords: [Record] {
        allRecords.filter { record in
            !record.isComplete
        }
    }

    private var visibleRecords: [Record] {
        showAll ? allRecords : incompleteRecords
    }

    private func selectRecord(_ record: Record) {
        pages.append(record)
        dismiss()
    }

    private struct Row: View {

        // MARK: - API

        let record: Record

        let onSelect: (Record) -> Void

        // MARK: - View

        @ViewBuilder
        var body: some View {
            Button {
                onSelect(record)
            } label: {
                VStack(alignment: .leading) {
                    Text(playerNamesListFormatter.string(from: record.players) ?? "Unknown")
                        .foregroundStyle(Color.label)
                    Text(recordLastUpdatedDateFormatter.string(from: record.lastUpdated))
                        .font(.caption)
                        .foregroundStyle(Color.secondaryLabel)
                }
            }
        }

        // MARK: - Private

        @Environment(\.playerNamesListFormatter)
        private var playerNamesListFormatter: ListFormatter

        @Environment(\.recordLastUpdatedDateFormatter)
        private var recordLastUpdatedDateFormatter: DateFormatter

    }
}

#Preview {
    LoadGameView(pages: .constant([]))
        .modelContainer(for: Record.self, inMemory: true)
}
