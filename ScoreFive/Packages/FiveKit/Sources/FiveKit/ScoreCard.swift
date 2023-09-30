// ScoreFive
// ScoreCard.swift
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

import Foundation

public struct ScoreCard: Equatable, Hashable, Sendable, Identifiable, Codable {

    // MARK: - Initializers

    public init(
        players: [String],
        scoreLimit: Int,
        id: ID? = nil
    ) {
        precondition(scoreLimit >= 50)
        precondition(players.count >= 2)
        precondition(players.count == Set(players).count)
        self.players = players
        self.scoreLimit = scoreLimit
        self.id = id ?? UUID().uuidString
    }

    // MARK: - API

    public private(set) var scoreLimit: Int

    public let players: [String]

    public var alivePlayers: [String] {
        players
            .filter { player in
                totalScore(forPlayer: player) < scoreLimit
            }
    }

    public private(set) var rounds = [Round]()

    public func canAddRound(_ round: Round) -> Bool {
        guard alivePlayers.count >= 2 else { return false }
        return alivePlayers
            .allSatisfy { player in
                round.players.contains(player)
            }
    }

    public mutating func addRound(_ round: Round) {
        precondition(canAddRound(round))
        rounds.append(round)
    }

    public func totalScore(forPlayer player: String) -> Int {
        rounds
            .filter { round in
                round.players.contains(player)
            }
            .compactMap { round in
                round.score(forPlayer: player)
            }
            .reduce(0, +)
    }

    public struct Round: Equatable, Hashable, Sendable, Identifiable, Codable {

        // MARK: - Initializers

        public init(players: [String], id: ID? = nil) {
            self.players = players
            self.id = id ?? UUID().uuidString
        }

        // MARK: - API

        public var isCompolete: Bool {
            guard players.count >= 2 else {
                return false
            }
            let zeroes = scores.values.filter { score in score == 0 }
            guard zeroes.count >= 1 else {
                return false
            }
            guard zeroes.count < players.count else {
                return false
            }
            return true
        }

        public let players: [String]

        public mutating func set(score: Int, forPlayer player: String) {
            precondition(players.contains(player))
            do {
                scores[player] = try validateScore(score)
            } catch {
                fatalError()
            }
        }

        public mutating func removeScore(forPlayer player: String) {
            precondition(players.contains(player))
            scores.removeValue(forKey: player)
        }

        public func score(forPlayer player: String) -> Int? {
            precondition(players.contains(player))
            return scores[player]
        }

        // MARK: - Subscript

        public subscript(_ player: String) -> Int? {
            get {
                score(forPlayer: player)
            }
            set {
                if let newValue {
                    set(score: newValue, forPlayer: player)
                } else {
                    removeScore(forPlayer: player)
                }

            }
        }

        // MARK: - Identifiable

        public typealias ID = String

        public let id: ID

        // MARK: - Private

        private var scores = [String: Int]()
    }

    // MARK: - Identifiable

    public typealias ID = String

    public let id: ID

}

@discardableResult
public func validateScore(_ score: Int) throws -> Int {
    guard isLegalScore(score) else {
        throw ScoreCardError.invalidScore
    }
    return score
}

public func isLegalScore(_ score: Int) -> Bool {
    score >= 0 && score <= 50
}

private enum ScoreCardError: Error {
    case invalidScore
}
