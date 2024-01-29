// ScoreFive
// ScoreCardExtensions.swift
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

extension ScoreCard {

    /// Necessary for CloudKit integration, but never actually used.
    static var placeholder: ScoreCard { .init(players: ["foo", "bar"], scoreLimit: 250, id: "placeholder") }

    func startingPlayer(atIndex index: Int) -> String {
        if index == 0 {
            return players[index % players.count]
        } else {
            let alivePlayers = dropLast(rounds.count - index).alivePlayers
            if alivePlayers == players {
                return players[index % players.count]
            } else {
                var player = startingPlayer(atIndex: index - 1)
                var playerIndex = players.firstIndex(of: player)!
                playerIndex += 1
                if playerIndex > players.count - 1 {
                    playerIndex = 0
                }
                player = players[playerIndex]
                while !alivePlayers.contains(player) {
                    playerIndex += 1
                    if playerIndex > players.count - 1 {
                        playerIndex = 0
                    }
                    player = players[playerIndex]
                }
                return player
            }
        }
    }

}
