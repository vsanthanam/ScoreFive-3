// ScoreFive
// RecordDetailScreen.swift
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

struct RecordDetailScreen: View {

    // MARK: - Initializers

    init(scoreCard: Binding<ScoreCard>) {
        _scoreCard = scoreCard
        _scoreLimit = .init(initialValue: scoreCard.wrappedValue.scoreLimit)
    }

    // MARK: - View

    @MainActor
    @ViewBuilder
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField(
                        "Score Limit",
                        value: $scoreLimit.animation(),
                        format: .number
                    )
                } header: {
                    Text("Score Limit")
                } footer: {
                    if let scoreLimit,
                       scoreLimit != scoreCard.scoreLimit,
                       !scoreCard.canSetScoreLimit(to: scoreLimit) {
                        Text("Cannot update the score limit to \(scoreLimit)")
                            .foregroundStyle(Color.red)
                    } else {
                        EmptyView()
                    }
                }
                if let scoreLimit,
                   scoreCard.canSetScoreLimit(to: scoreLimit),
                   scoreLimit != scoreCard.scoreLimit {
                    Button(action: updateScoreLimit) {
                        Text("Change Score Limit")
                            .frame(maxWidth: .infinity)
                    }
                }
                Section {
                    if let averageScore {
                        Text("Average Score")
                            .badge(averageScore)
                    }
                    if let averageNonZeroScore {
                        Text("Average (Non-Zero)")
                            .badge(averageNonZeroScore)
                    }
                    if let worstNonFiftyScore {
                        Text("Worst Score (Non-Fifty)")
                            .badge(worstNonFiftyScore)
                    }
                } header: {
                    Text("Stats")
                }
            }
            .navigationTitle("Game Details")
        }
    }

    // MARK: - Private

    @Binding
    private var scoreCard: ScoreCard

    @State
    private var scoreLimit: Int?

    @Environment(\.dismiss)
    private var dismiss: DismissAction

    private var averageScore: String? {
        guard !scoreCard.rounds.isEmpty else {
            return nil
        }
        let total = scoreCard.rounds
            .flatMap(\.scores)
            .reduce(0, +)

        let count = scoreCard.rounds
            .map(\.scores.count)
            .reduce(0, +)

        let average = Decimal(total) / Decimal(count)
        return Decimal.FormatStyle.number.precision(.fractionLength(2)).format(average)
    }

    private var averageNonZeroScore: String? {
        guard !scoreCard.rounds.isEmpty else {
            return nil
        }
        let total = scoreCard.rounds
            .flatMap(\.scores)
            .filter { score in
                score != 0
            }
            .reduce(0, +)

        let count = scoreCard.rounds
            .flatMap(\.scores)
            .filter { score in
                score != 0
            }
            .count

        let average = Decimal(total) / Decimal(count)
        return Decimal.FormatStyle.number.precision(.fractionLength(2)).format(average)
    }

    private var worstNonFiftyScore: String? {
        scoreCard.rounds
            .flatMap(\.scores)
            .filter { score in
                score != 50
            }
            .max()?.description
    }

    private func updateScoreLimit() {
        if let scoreLimit {
            scoreCard.setScoreLimit(to: scoreLimit)
        }
        dismiss()
    }
}
