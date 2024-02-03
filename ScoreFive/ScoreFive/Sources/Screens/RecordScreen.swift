// ScoreFive
// RecordScreen.swift
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
import SwiftUtilities

@MainActor
struct RecordView: View {

    // MARK: - Initializers

    init(activeRecord: Record) {
        self.activeRecord = activeRecord
    }

    // MARK: - View

    @MainActor
    @ViewBuilder
    var body: some View {
        VStack(spacing: 0.0) {
            toolbar
            playerNamesHeader
            Spacer()
                .frame(maxWidth: .infinity, minHeight: 1.0, maxHeight: 1.0)
            roundsList
            totalScoresFooter
        }
        .navigationTitle("Score Card")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
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
        .sheet(isPresented: $showingRecordDetail) {
            RecordDetailScreen(activeRecord: $activeRecord.scoreCard)
        }
    }

    // MARK: - Private

    @Bindable
    private var activeRecord: Record

    @State
    private var addingRound = false

    @State
    private var editingRound: ScoreCard.Round? = nil

    @State
    private var showingRecordDetail = false

    @Environment(\.endRecord)
    private var endRecord: EndRecordAction

    @ViewBuilder
    private var roundsList: some View {
        List {
            ForEach(activeRecord.scoreCard.rounds) { round in
                Button {
                    editingRound = round
                } label: {
                    RecordRow {
                        Text(activeRecord.scoreCard.startingPlayer(atIndex: activeRecord.scoreCard.rounds.firstIndex(of: round) ?? 0).playerSignpost)
                            .fontDesign(.monospaced)
                    } content: {
                        let scores = activeRecord.scoreCard.players
                            .map { player in
                                round[player]
                            }
                        let aliveScores = activeRecord.scoreCard.alivePlayers
                            .compactMap { player in
                                round[player]
                            }
                        EntriesView(
                            values: scores,
                            isWinner: { value in
                                value == aliveScores.min()
                            },
                            isLoser: { value in
                                value == aliveScores.max()
                            }
                        )
                    }
                    .background(((activeRecord.scoreCard.rounds.firstIndex(of: round) ?? 0) % 2 == 0) ? Color.systemBackground : Color.secondarySystemBackground)
                }
                .deleteDisabled(!activeRecord.scoreCard.canRemoveRound(id: round.id))
            }
            .onDelete { indexSet in
                for index in indexSet {
                    activeRecord.scoreCard.removeRound(atIndex: index)
                }
            }
            .listRowInsets(.init())
            .listRowSeparator(.hidden)
            .recordRowConfiguration(hasTopDivider: true, hasBottomDivider: true)
            if activeRecord.scoreCard.alivePlayers.count > 1 {
                addScoresButton
            }
        }
    }

    @MainActor
    @ViewBuilder
    private var addScoresButton: some View {
        Button {
            addingRound.toggle()
        } label: {
            RecordRow {
                Text(activeRecord.scoreCard.startingPlayer(atIndex: activeRecord.scoreCard.rounds.count).playerSignpost)
                    .frame(width: 44.0, height: 44.0)
                    .opacity(0.3)
            } content: {
                Text("Add Scores")
                    .opacity(0.3)
            }
            .recordRowConfiguration(hasTopDivider: true, hasBottomDivider: true)
        }
        .listRowInsets(.init())
        .listRowSeparator(.hidden)
    }

    @MainActor
    @ViewBuilder
    private var toolbar: some View {
        HStack {
            Button {
                withAnimation(.bouncy) {
                    endRecord()
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color.secondaryLabel)
                    .font(.title)
                    .padding(8)
            }
            Spacer()
            Text("ScoreFive")
                .fontWeight(.semibold)
            Spacer()
            Button {
                showingRecordDetail.toggle()
            } label: {
                Image(systemName: "ellipsis.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color.secondaryLabel)
                    .font(.title)
                    .padding(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 44.0)
    }

    @MainActor
    @ViewBuilder
    private var playerNamesHeader: some View {
        RecordRow {
            EntriesView(
                values: activeRecord.scoreCard.players,
                toString: \.playerSignpost,
                isEliminated: { player in
                    !activeRecord.scoreCard.alivePlayers.contains(player)
                },
                isAccented: { _ in
                    true
                }
            )
        }
        .recordRowConfiguration(hasTopDivider: true, hasBottomDivider: true)
    }

    @MainActor
    @ViewBuilder
    private var totalScoresFooter: some View {
        RecordRow {
            let scores = activeRecord.players.map(activeRecord.scoreCard.totalScore(forPlayer:))
            EntriesView(
                values: scores,
                isWinner: { value in
                    value == activeRecord.scoreCard.lowestScore
                },
                isLoser: { value in
                    value == activeRecord.scoreCard.highestScore
                },
                isAccented: { _ in
                    true
                }
            )
        }
        .recordRowConfiguration(hasTopDivider: true, hasBottomDivider: true)
    }

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
}

private extension ScoreCard {

    var lowestScore: Int {
        alivePlayers
            .compactMap { player in
                self[player]
            }
            .min() ?? 0
    }

    var highestScore: Int {
        alivePlayers
            .compactMap { player in
                self[player]
            }
            .max() ?? 0
    }

}

#Preview {
    RecordView(activeRecord: .init(scoreCard: .init(players: ["Player 1", "Player 2"], scoreLimit: 250)))
}
