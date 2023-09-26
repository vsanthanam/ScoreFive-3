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

    // MARK: - Initializers

    init(scoreCard: Binding<ScoreCard>, index: Int? = nil) {
        _scoreCard = scoreCard
        self.index = index
        if let index {
            title = "Edit Scores"
            _round = .init(initialValue: scoreCard.wrappedValue.rounds[index])
        } else {
            title = "Add Scores"
            _round = .init(initialValue: ScoreCard.Round(players: scoreCard.wrappedValue.alivePlayers))
        }
    }

    // MARK: - API

    @Binding
    var scoreCard: ScoreCard

    let index: Int?

    // MARK: - View

    @ViewBuilder
    var body: some View {
        NavigationStack {
            Form {
                ForEach(round.players, id: \.self) { player in
                    TextField(player, value: $round[player], format: .number)
                        .focused($focus, equals: player)
                        .keyboardType(.numberPad)
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
    }

    // MARK: - Private

    @State
    private var round: ScoreCard.Round

    @FocusState
    private var focus: String?

    @Environment(\.dismiss)
    private var dismiss: DismissAction

    private let title: String

}
