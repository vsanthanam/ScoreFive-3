// ScoreFive
// RootScreen.swift
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

struct RootScreen: View {

    // MARK: - Initializers

    init() {}

    // MARK: - View

    @ViewBuilder
    var body: some View {
        Group {
            if let activeRecord {
                RecordView(activeRecord: activeRecord)
                    .environment(\.endRecord, EndRecord {
                        self.activeRecord = nil
                    })
            } else {
                HStack {
                    menuCard
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.secondarySystemBackground)
            }
        }
        .sheet(isPresented: $showNewGame) {
            NewGameScreen { record in
                activeRecord = record
            }
        }
        .sheet(isPresented: $showLoadGame) {
            LoadGameScreen { record in
                activeRecord = record
            }
        }
        .sheet(isPresented: $showMore) {
            MoreScreen()
        }
    }

    // MARK: - Private

    @State
    private var activeRecord: Record?

    @State
    private var showNewGame = false

    @State
    private var showLoadGame = false

    @State
    private var showMore = false

    @Query(sort: \Record.lastUpdated)
    private var records: [Record]

    @Environment(\.modelContext)
    private var modelContext: ModelContext

    @ScaledMetric(relativeTo: .body)
    private var cardCornerRadius = 16.0

    @ScaledMetric(relativeTo: .body)
    private var buttonWidth = 100.0

    @MainActor
    @ViewBuilder
    private var menuCard: some View {
        PlayingCard {
            Text("Score Five")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(24.0)
            Button {
                showNewGame.toggle()
            } label: {
                Text("New Game")
                    .fontWeight(.semibold)
                    .frame(minWidth: buttonWidth)
            }
            .buttonStyle(.borderedProminent)
            if !records.isEmpty {
                Button {
                    showLoadGame.toggle()
                } label: {
                    Text("Load Game")
                        .fontWeight(.semibold)
                        .frame(minWidth: buttonWidth)
                }
                .buttonStyle(.bordered)
            }
            Button {
                showMore.toggle()
            } label: {
                Text("More")
                    .fontWeight(.semibold)
                    .frame(minWidth: buttonWidth)
            }
            .buttonStyle(.bordered)
        }
    }

}

#Preview {
    RootScreen()
        .modelContainer(for: Record.self, inMemory: true)
}

struct EndRecord {

    fileprivate init(action: @escaping () -> Void) {
        self.action = action
    }

    private let action: () -> Void

    func callAsFunction() {
        action()
    }
}

struct StartRecord {

    fileprivate init(action: @escaping (Record) -> Void) {
        self.action = action
    }

    private let action: (Record) -> Void

    func callAsFunction(_ record: Record) {
        action(record)
    }
}

struct EndRecordEnvironmentKey: EnvironmentKey {

    typealias Value = EndRecord

    static var defaultValue: Value = .init {}

}

struct StartRecordEnvironmentKey: EnvironmentKey {

    typealias Value = StartRecord

    static var defaultValue: Value = .init { _ in }

}

extension EnvironmentValues {

    var endRecord: EndRecord {
        get { self[EndRecordEnvironmentKey.self] }
        set { self[EndRecordEnvironmentKey.self] = newValue }
    }

    var startRecord: StartRecord {
        get { self[StartRecordEnvironmentKey.self] }
        set { self[StartRecordEnvironmentKey.self] = newValue }
    }

}
