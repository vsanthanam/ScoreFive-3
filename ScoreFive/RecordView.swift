// ScoreFive
// RecordView.swift
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
import Utils

struct RecordView: View {

    // MARK: - API

    @Bindable
    var activeRecord: Record

    // MARK: - View

    @ViewBuilder
    var body: some View {
        VStack(spacing: 0.0) {
            RowView(entries: activeRecord.players.map { player in
                RowView.Entry(
                    content: player.playerSignpost,
                    highlight: .none
                )
            })
            .rowViewConfiguration(hasTopDivider: true, hasBottomDivider: true)
            Spacer()
                .frame(maxWidth: .infinity, minHeight: 2.0, maxHeight: 2.0)
            List {
                ForEach(activeRecord.game.rounds.indices, id: \.self) { index in
                    Button {
                        editingRound = index
                    } label: {
                        let round = activeRecord.game.rounds[index]
                        RowView(signpost: index.description,
                                entries: activeRecord.players
                                    .map { player in
                                        RowView.Entry(
                                            content: round[player]?.description,
                                            highlight: round.highlight(for: player)
                                        )
                                    })
                    }
                }
                .listRowInsets(.init())
                .listRowSeparator(.hidden)
                .rowViewConfiguration(hasTopDivider: true)
                Button {
                    addingRound.toggle()
                } label: {
                    Text("Add Scores")
                        .frame(maxWidth: .infinity)
                }
                .listRowInsets(.init())
                .listRowSeparator(.hidden)
            }
            RowView(entries: activeRecord.game.players.map { player in
                RowView.Entry(
                    content: activeRecord.game.totalScore(forPlayer: player).description
                )
            })
            .rowViewConfiguration(isAccented: true)
        }
        .navigationTitle("Score Card")
        .listStyle(.plain)
        .sheet(isPresented: $addingRound) {
            EditRoundView(
                scoreCard: $activeRecord.game,
                editingIndex: nil,
                players: activeRecord.game.alivePlayers
            )
        }
        .sheet(item: $editingRound, id: \.self) { index in
            EditRoundView(
                scoreCard: $activeRecord.game,
                editingIndex: index,
                players: activeRecord.game.rounds[index].players
            )
        }
    }

    // MARK: - Private

    @State
    private var addingRound = false

    @State
    private var editingRound: Int? = nil

}

private extension String {
    var playerSignpost: String {
        let comps = split(separator: " ")
        if comps.count == 2, comps[0].lowercased() == "player", Int(comps[1]) != nil {
            return "P" + comps[1]
        } else {
            return first?.lowercased() ?? "X"
        }
    }
}

private extension ScoreCard.Round {
    private var lowestScore: Int {
        players
            .compactMap { player in
                self[player]
            }
            .min() ?? 0
    }

    private var highestScore: Int {
        players
            .compactMap { player in
                self[player]
            }
            .max() ?? 50
    }

    func highlight(for player: String) -> RowView.Entry.Highlight {
        switch self[player] {
        case lowestScore:
            .winning
        case highestScore:
            .losing
        default:
            .none
        }

    }
}

#Preview {
    RecordView(activeRecord: .init(game: .init(players: ["Player 1", "Player 2"], scoreLimit: 250)))
}
