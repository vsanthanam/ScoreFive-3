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

import FoundationExtensions
import SwiftData
import SwiftUI
import UIExtensions

struct RootScreen: View {

    // MARK: - Initializers

    init() {}

    // MARK: - View

    @ViewBuilder
    var body: some View {
        Group {
            if let activeRecord {
                RecordView(activeRecord: activeRecord)
            } else {
                HStack {
                    menuCard
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.secondarySystemBackground)
            }
        }
        .sheet(item: $sheet, id: \.rawValue) { sheet in
            switch sheet {
            case .newGame:
                NewGameScreen()
            case .loadGame:
                LoadGameScreen()
            case .more:
                MoreScreen()
            }
        }
        .onRecordStart { record in
            activeRecord = record
        }
        .onRecordEnd {
            activeRecord = nil
        }
        .acknowledgements {
            Acknowledgement(
                url: #URL("https://github.com/apple/swift-syntax"),
                name: "SwiftSyntax",
                id: "swift-syntax"
            )
            Acknowledgement(
                url: #URL("https://tuist.io"),
                name: "Tuist",
                id: "tuist"
            )
            Acknowledgement(
                url: #URL("https://mise.jdx.dev"),
                name: "Mise",
                id: "mise"
            )
            Acknowledgement(
                url: #URL("https://vsanthanam.github.io/SafariUI/"),
                name: "SafariUI",
                id: "safari-ui"
            )
            Acknowledgement(
                url: #URL("https://vsanthanam/github.io/SwiftExtensions"),
                name: "SwiftExtensions",
                id: "swift-extensions"
            )
        }

    }

    // MARK: - Private

    private enum Sheet: String, Equatable, Hashable, Sendable {
        case newGame
        case loadGame
        case more
    }

    @State
    private var activeRecord: Record?

    @State
    private var sheet: Sheet?

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
                sheet = .newGame
            } label: {
                Text("New Game")
                    .fontWeight(.semibold)
                    .frame(minWidth: buttonWidth)
            }
            .buttonStyle(.borderedProminent)
            if !records.isEmpty {
                Button {
                    sheet = .loadGame
                } label: {
                    Text("Load Game")
                        .fontWeight(.semibold)
                        .frame(minWidth: buttonWidth)
                }
                .buttonStyle(.bordered)
            }
            Button {
                sheet = .more
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
