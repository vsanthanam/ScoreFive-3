// ScoreFive
// LoadGameScreen.swift
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
import UIExtensions

struct LoadGameScreen: View {

    // MARK: - View

    @MainActor
    @ViewBuilder
    var body: some View {
        NavigationStack {
            Group {
                if !allRecords.isEmpty {
                    List {
                        sortSection
                        recordListSection
                        if showAll || allRecords.count == incompleteRecords.count {
                            deleteAllSection
                        }
                    }
                } else {
                    ContentUnavailableView {
                        Label(
                            "No Games",
                            systemImage: "gamecontroller.fill"
                        )
                    } description: {
                        Text("Games you've started will appear here")
                    }
                }
            }
            .navigationTitle("Load Game")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .onAppear() {
            if visibleRecords.isEmpty {
                showAll.toggle()
            }
        }
        .confirmationDialog(
            "Are You Sure?",
            isPresented: $confirmDeleteAll,
            titleVisibility: .visible
        ) {
            Button("Cancel", role: .cancel) {
                confirmDeleteAll.toggle()
            }
            Button("Delete All", role: .destructive) {
                deleteAll()
            }
        } message: {
            Text("This action is irreversible. All score cards — including unfinished ones — will be immediately deleted forever.")
        }
        .animation(.default, value: visibleRecords)
        .onChange(of: visibleRecords) { lhs, rhs in
            if visibleRecords.isEmpty, !showAll {
                showAll = true
            }
        }
    }

    // MARK: - Private

    @State
    private var showAll = false

    @State
    private var confirmDeleteAll = false

    let pickerOptions = ["Last Updated", "Date Created"]

    @State
    private var sortByLastUpdatedPicker = "Last Updated"

    private var sortByLastUpdated: Bool {
        sortByLastUpdatedPicker == pickerOptions[0]
    }

    @Query(sort: \Record.lastUpdated, order: .reverse)
    private var allRecordsByLastUpdated: [Record]

    @Query(sort: \Record.createdOn, order: .reverse)
    private var allRecordsByCreatedOn: [Record]

    @Environment(\.modelContext)
    private var modelContext: ModelContext

    @Environment(\.dismiss)
    private var dismiss: DismissAction

    @Environment(\.startRecord)
    private var startRecord: StartRecordAction

    private var allRecords: [Record] {
        sortByLastUpdated ? allRecordsByLastUpdated : allRecordsByCreatedOn
    }

    private var incompleteRecords: [Record] {
        allRecords.filter { record in
            !record.isComplete
        }
    }

    private var visibleRecords: [Record] {
        showAll ? allRecords : incompleteRecords
    }

    private func selectRecord(_ record: Record) {
        startRecord(record)
        dismiss()
    }

    private func deleteAll() {
        allRecords
            .forEach(modelContext.delete)
    }

    @MainActor
    @ViewBuilder
    private var sortSection: some View {
        Section {
            if allRecords.count != incompleteRecords.count {
                Toggle("Show Complete Games", isOn: $showAll)
            }
            Picker("Sort", selection: $sortByLastUpdatedPicker) {
                ForEach(pickerOptions, id: \.self) { option in
                    Text(option)
                }
            }
        }
    }

    @MainActor
    @ViewBuilder
    private var recordListSection: some View {
        Section {
            ForEach(visibleRecords) { record in
                LoadGameRow(
                    record: record,
                    lastUpdated: sortByLastUpdated,
                    onSelect: selectRecord
                )
            }
            .onDelete { indexSet in
                for index in indexSet {
                    modelContext.delete(visibleRecords[index])
                }
            }
        }
    }

    @MainActor
    @ViewBuilder
    private var deleteAllSection: some View {
        Section {
            Button {
                confirmDeleteAll.toggle()
            } label: {
                Text("Delete All")
                    .foregroundStyle(Color.red)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    LoadGameScreen()
        .modelContainer(for: Record.self, inMemory: true)
}
