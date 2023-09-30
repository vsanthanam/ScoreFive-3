// ScoreFive
// EditRoundView.swift
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
import SwiftUI

struct EditRoundView: View {

    // MARK: - API

    @Binding
    var scoreCard: ScoreCard

    let editingRound: ScoreCard.Round?

    let players: [String]

    // MARK: - View

    @ViewBuilder
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    ForEach(players, id: \.self) { player in
                        TextField(player, value: $scores.animation()[player], format: .number)
                            .focused($focus, equals: player)
                            .keyboardType(.numberPad)
                    }
                } footer: {
                    if !areScoresLegal {
                        Text("Scores must be between 0 and 50")
                            .foregroundStyle(Color.red)
                    } else if !containsAllScores {
                        Text("Enter a score for every player")
                    } else if !hasWinner {
                        Text("At least one player must have a score of 0")
                    } else if !hasLoser {
                        Text("At least one player must have a score greater than 0")
                    } else if !canSave {
                        Text("Cannot change an existing score by this much. Delete newer scores first.")
                            .foregroundStyle(Color.red)
                    } else {
                        EmptyView()
                    }
                }
                if canSave {
                    Section {
                        Button(action: save) {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if let editingRound {
                players.forEach { player in
                    scores[player] = editingRound[player]
                }
            }
            focus = players[0]
        }
    }

    // MARK: - Private

    @FocusState
    private var focus: String?

    @Environment(\.dismiss)
    private var dismiss: DismissAction

    @State
    private var scores: [String: Int] = [:]

    private var title: String {
        editingRound == nil ? "Add Scores" : "Edit Scores"
    }

    private var containsAllScores: Bool {
        scores.values.count == players.count
    }

    private var areScoresLegal: Bool {
        scores.values.allSatisfy(isLegalScore)
    }

    private var hasWinner: Bool {
        scores.values.contains(0)
    }

    private var hasLoser: Bool {
        !scores.values.filter { score in score != 0 }.isEmpty
    }

    private var canSave: Bool {
        guard containsAllScores, areScoresLegal, hasWinner, hasLoser else {
            return false
        }
        if let editingRound {
            var newRound = ScoreCard.Round(players: players, id: editingRound.id)
            players.forEach { player in
                newRound[player] = scores[player]
            }
            return scoreCard.canReplaceRound(id: editingRound.id, withRound: newRound)
        } else {
            return true
        }
    }

    private func save() {
        var round = ScoreCard.Round(players: players)
        for player in players {
            round[player] = scores[player]
        }
        if let editingRound {
            scoreCard.replaceRound(id: editingRound.id, withRound: round)
        } else {
            scoreCard.addRound(round)
        }
        dismiss()
    }

}
