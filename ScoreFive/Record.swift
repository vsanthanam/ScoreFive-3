// ScoreFive
// Record.swift
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
import Foundation
import SwiftData

@Model
final class Record {

    init(game: ScoreCard) {
        gameData = try! JSONEncoder().encode(game)
        players = game.players
        isComplete = game.alivePlayers.count < 2
        lastUpdated = .now
    }

    var game: ScoreCard {
        get {
            try! JSONDecoder().decode(ScoreCard.self, from: gameData)
        }
        set {
            let data = try! JSONEncoder().encode(newValue)
            gameData = data
            lastUpdated = .now
            players = newValue.players
            isComplete = newValue.alivePlayers.count < 2
        }
    }

    private(set) var lastUpdated: Date

    private var gameData: Data

    private(set) var players: [String]

    private(set) var isComplete: Bool

}
