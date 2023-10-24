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
        ZStack {
            VStack(spacing: 0.0) {
                playerNamesHeader
                Spacer()
                    .frame(maxWidth: .infinity, minHeight: 1.0, maxHeight: 1.0)
                roundsList
                totalScoresFooter
            }
            .navigationTitle("Score Card")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.plain)
            HStack(spacing: 0.0) {
                Spacer()
                    .frame(maxWidth: 44.0, maxHeight: .infinity)
                Divider()
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .sheet(isPresented: $addingRound) {
            EditRoundView(
                scoreCard: $activeRecord.scoreCard,
                editingRound: nil,
                players: activeRecord.scoreCard.alivePlayers
            )
        }
        .sheet(item: $editingRound, id: \.self) { round in
            EditRoundView(
                scoreCard: $activeRecord.scoreCard,
                editingRound: round,
                players: round.players
            )
        }
    }

    // MARK: - Private

    @MainActor
    @ViewBuilder
    private var roundsList: some View {
        List {
            ForEach(activeRecord.scoreCard.rounds) { round in
                Button {
                    editingRound = round
                } label: {
                    RecordViewRow(
                        signpost: ((activeRecord.scoreCard.rounds.firstIndex(of: round) ?? 0) + 1).description,
                        entries: activeRecord.players
                            .map { player in
                                RecordViewRow.Entry(
                                    content: round[player]?.description,
                                    highlight: round.highlight(for: player),
                                    eliminated: !activeRecord.scoreCard.alivePlayers.contains(player)
                                )
                            }
                    )
                }
                .deleteDisabled(!activeRecord.scoreCard.canRemoveRound(id: round.id))
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    activeRecord.scoreCard.removeRound(atIndex: index)
                }
            }
            .listRowInsets(.init())
            .listRowSeparator(.hidden)
            .recordViewRowConfiguration(hasTopDivider: true)
            if activeRecord.scoreCard.alivePlayers.count > 1 {
                buildAddScoresButton
            }
        }
    }

    @MainActor
    @ViewBuilder
    private var buildAddScoresButton: some View {
        Button {
            addingRound.toggle()
        } label: {
            VStack(spacing: 0.0) {
                Divider()
                HStack(spacing: 0.0) {
                    Spacer()
                        .frame(width: 44.0, height: 44.0)
                    Text("Add Scores")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
            }
        }
        .listRowInsets(.init())
        .listRowSeparator(.hidden)
    }

    @MainActor
    @ViewBuilder
    private var playerNamesHeader: some View {
        RecordViewRow(entries: activeRecord.players.map { player in
            RecordViewRow.Entry(
                content: player.playerSignpost,
                highlight: .none
            )
        })
        .recordViewRowConfiguration(hasTopDivider: true, hasBottomDivider: true)
    }

    @MainActor
    @ViewBuilder
    private var totalScoresFooter: some View {
        RecordViewRow(entries: activeRecord.scoreCard.players.map { player in
            RecordViewRow.Entry(
                content: activeRecord.scoreCard[player].description,
                highlight: activeRecord.scoreCard.highlight(for: player),
                eliminated: !activeRecord.scoreCard.alivePlayers.contains(player)
            )
        })
        .recordViewRowConfiguration(isAccented: true, hasTopDivider: true)
    }

    @State
    private var addingRound = false

    @State
    private var editingRound: ScoreCard.Round? = nil
}

private extension String {
    var playerSignpost: String {
        let comps = split(separator: " ")
        if comps.count == 2, comps[0].lowercased() == "player", Int(comps[1]) != nil {
            return "P" + comps[1]
        } else {
            return first?.uppercased() ?? "X"
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

    func highlight(for player: String) -> RecordViewRow.Entry.Highlight {
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

private extension ScoreCard {

    private var lowestScore: Int {
        alivePlayers
            .compactMap { player in
                self[player]
            }
            .min() ?? 0
    }

    private var highestScore: Int {
        alivePlayers
            .compactMap { player in
                self[player]
            }
            .max() ?? 0
    }

    func highlight(for player: String) -> RecordViewRow.Entry.Highlight {
        guard !rounds.isEmpty, alivePlayers.contains(player) else {
            return .none
        }
        switch self[player] {
        case lowestScore:
            return .winning
        case highestScore:
            return .losing
        default:
            return .none
        }
    }

}

#Preview {
    RecordView(activeRecord: .init(scoreCard: .init(players: ["Player 1", "Player 2"], scoreLimit: 250)))
}
