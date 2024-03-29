// ScoreFive
// NewGameScreen.swift
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

import FiveKit
import SwiftData
import SwiftUI

struct NewGameScreen: View {

    // MARK: - View

    @MainActor
    @ViewBuilder
    var body: some View {
        NavigationStack {
            Form {
                scoreLimitSection
                playersSection
                if players.count < 8 {
                    addPlayerSection
                }
                if validScoreLimit, validPlayerNames {
                    startGameSection
                }
            }
            .navigationTitle("New Game")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    if focus == .scoreLimit {
                        Spacer()
                        Button("Next") {
                            focus = .player(0)
                        }
                    }
                }
            }
        }
        .onAppear {
            focus = .scoreLimit
        }
        .interactiveDismissDisabled(changesEntered)
    }

    // MARK: - Private

    private enum Focus: Equatable, Hashable, Sendable {
        case scoreLimit
        case player(_ index: Int)
    }

    private struct Player: Equatable, Hashable, Identifiable {
        init(name: String = "", id: String? = nil) {
            self.name = name
            self.id = id ?? UUID().uuidString
        }

        var name: String
        let id: String
    }

    @State
    private var scoreLimit: Int? = 250

    @State
    private var players: [Player] = [.init(), .init()]

    @State
    private var activeRecord: Record?

    @FocusState
    private var focus: Focus?

    @Environment(\.dismiss)
    private var dismiss: DismissAction

    @Environment(\.startRecord)
    private var startRecord: StartRecordAction

    @Environment(\.modelContext)
    private var modelContext: ModelContext

    @MainActor
    @ViewBuilder
    private var scoreLimitSection: some View {
        Section {
            TextField(
                "Score Limit",
                value: $scoreLimit.animation(),
                format: .number
            )
            .focused($focus, equals: .scoreLimit)
            .keyboardType(.numberPad)
        } header: {
            Text("Score Limit")
        } footer: {
            if validScoreLimit {
                EmptyView()
            } else {
                Text("Score limit must be >= 50")
                    .foregroundStyle(Color.red)
            }
        }
    }

    @MainActor
    @ViewBuilder
    private var playersSection: some View {
        Section {
            ForEach(players) { player in
                let index = players.firstIndex(of: player)!
                TextField("Player \(index + 1)", text: $players.animation()[index].name)
                    .focused($focus, equals: .player(index))
                    .submitLabel(player == players.last ? .done : .next)
                    .onSubmit {
                        if player == players.last {
                            focus = nil
                        } else {
                            focus = .player(index + 1)
                        }
                    }
            }
            .onDelete { indexSet in
                withAnimation {
                    players.remove(atOffsets: indexSet)
                }
            }
            .deleteDisabled(players.count == 2)
        } header: {
            Text("Player Names")
        } footer: {
            if validPlayerNames {
                EmptyView()
            } else {
                Text("Player names must be unique")
                    .foregroundStyle(Color.red)
            }
        }
    }

    @MainActor
    @ViewBuilder
    private var addPlayerSection: some View {
        Section {
            Button {
                withAnimation {
                    addPlayer()
                }
            } label: {
                Text("Add Player")
                    .frame(maxWidth: .infinity)
            }
        }
    }

    @MainActor
    @ViewBuilder
    private var startGameSection: some View {
        Section {
            Button(action: startGame) {
                Text("Start Game")
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var validScoreLimit: Bool {
        guard let scoreLimit else { return false }
        return scoreLimit >= 50
    }

    private var validPlayerNames: Bool {
        let names = players.compactMap(\.name.nilIfEmpty?.localizedLowercase)
        return names.count == Set(names).count
    }

    private var changesEntered: Bool {
        scoreLimit != 250 || players.map(\.name) != ["", ""]
    }

    private func addPlayer() {
        players.append(.init())
    }

    private func startGame() {
        let names = players.indices
            .map { index in
                let name = players[index].name
                guard name != "" else {
                    return "Player \(index + 1)"
                }
                return name
            }
        let card = ScoreCard(players: names, scoreLimit: scoreLimit ?? 50)
        let record = Record(scoreCard: card)
        modelContext.insert(record)
        startRecord(record)
        dismiss()
    }

}

#Preview {
    NewGameScreen()
        .modelContainer(for: Record.self, inMemory: true)
}
