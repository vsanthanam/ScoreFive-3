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

/// ScoreCard is a data structure used to keep track of scores while playing a game of five
public struct ScoreCard: Equatable, Hashable, Sendable, Identifiable, Codable {

    // MARK: - Initializers

    /// Create a ScoreCard
    /// - Parameters:
    ///   - players: The ordered list of players
    ///   - scoreLimit: The score limit
    ///   - id: A unique identifier
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

    /// The score limit, used to determin when players are eliminated
    public private(set) var scoreLimit: Int

    /// The players, in playing order
    public let players: [String]

    /// The players, in playing order, who have yet to be eliminated
    public var alivePlayers: [String] {
        players
            .filter { player in
                totalScore(forPlayer: player) < scoreLimit
            }
    }

    /// The rounds in this s core card
    public private(set) var rounds = [Round]()

    /// Whether or not the score limit can be changed to a new value
    /// - Parameter scoreLimit: The new proposed score limit
    /// - Returns: Whether or not the change is legal
    public func canSetScoreLimit(
        to scoreLimit: Int
    ) -> Bool {
        let maxScore = alivePlayers
            .map { player in
                totalScore(forPlayer: player)
            }
            .max() ?? 0
        return scoreLimit > maxScore && scoreLimit >= 50
    }

    /// Change the score limit of the score lcard
    /// - Parameter scoreLimit: The new score limit
    public mutating func setScoreLimit(
        to scoreLimit: Int
    ) {
        precondition(canSetScoreLimit(to: scoreLimit))
        self.scoreLimit = scoreLimit
    }

    /// Whether or not a proposed round can be added to the score card
    /// - Parameter round: The propsed new round
    /// - Returns: `true` if the round can be added, otherwise `false`
    public func canAddRound(
        _ round: Round
    ) -> Bool {
        guard alivePlayers.count >= 2, round.isComplete else { return false }
        return alivePlayers == round.players
    }

    /// Add a round to the score card
    /// - Parameter round: The new round
    public mutating func addRound(
        _ round: Round
    ) {
        precondition(canAddRound(round))
        rounds.append(round)
    }

    /// Create a new score card with an additional round
    /// - Parameter round: The new round
    /// - Returns: The new score card
    public func withRound(
        _ round: Round
    ) -> ScoreCard {
        var copy = self
        copy.addRound(round)
        return copy
    }

    /// Whether or not a round at a provided index can be removed from the game
    /// - Parameter index: The index you wish to remove
    /// - Returns: `true` if the round can be removed, or `false` if it cannot be removed (or if no such index exists)
    public func canRemoveRound(
        atIndex index: Int
    ) -> Bool {
        guard rounds.indices.last != index else {
            return true
        }
        var copy = self
        copy.rounds.remove(at: index)
        return alivePlayers == copy.alivePlayers
    }

    /// Remove the round at the provided index
    /// - Parameter index: The index
    public mutating func removeRound(
        atIndex index: Int
    ) {
        precondition(canRemoveRound(atIndex: index))
        rounds.remove(at: index)
    }

    /// Create a score card without the round at the provided index
    /// - Parameter index: The index of the round you wish to exclude.
    /// - Returns: The score card, minus the round at the provided index.
    public func withoutRound(
        atIndex index: Int
    ) -> ScoreCard {
        var copy = self
        copy.removeRound(atIndex: index)
        return copy
    }

    /// Whether or not a round with the provided ID can be removed from the score card
    /// - Parameter id: The ID of the round you wish to remove
    /// - Returns: `true` if the round can be removed, or `false` if it cannot be removed (or if no such round exists)
    public func canRemoveRound(
        id: String
    ) -> Bool {
        guard let round = rounds.filter({ round in round.id == id }).first,
              let index = rounds.firstIndex(of: round) else {
            return false
        }
        return canRemoveRound(atIndex: index)
    }

    /// Remove the round with the provided ID from the score card.
    /// - Parameter id: The ID of the round you wish to remove.
    public mutating func removeRound(
        id: String
    ) {
        precondition(canRemoveRound(id: id))
        guard let round = rounds.filter({ round in round.id == id }).first,
              let index = rounds.firstIndex(of: round) else {
            fatalError()
        }
        removeRound(atIndex: index)
    }

    /// Creatre a score card without the round with the provided ID
    /// - Parameter id: The ID of the round you wish to exclude
    /// - Returns: The score card, minus the round with the provided ID.
    public func withoutRound(
        id: String
    ) -> ScoreCard {
        var copy = self
        copy.removeRound(id: id)
        return copy
    }

    /// Whether or not the round at the provided index can be replaced with the provided round
    /// - Parameters:
    ///   - index: The index of the round you wish to replace
    ///   - round: The new round use instead
    /// - Returns: `true` if the replacement is possible, otherwise `false` if it is not (or if no such round exists to be replaced)
    public func canReplaceRound(
        atIndex index: Int,
        withRound round: Round
    ) -> Bool {
        guard rounds.indices.contains(index), rounds[index].players == round.players, round.isComplete else {
            return false
        }
        guard rounds.indices.last != index else {
            return true
        }
        var copy = self
        copy.rounds[index] = round
        return copy.alivePlayers == alivePlayers
    }

    /// Replace the round at the provided index with the provided round
    /// - Parameters:
    ///   - index: The index of the round you wish to replace
    ///   - round: The round to use instead
    public mutating func replaceRound(
        atIndex index: Int,
        withRound round: Round
    ) {
        precondition(canReplaceRound(atIndex: index, withRound: round))
        var newRound = Round(players: round.players, id: round.id)
        for player in round.players {
            newRound[player] = round[player]
        }
        rounds[index] = newRound
    }

    public func replacingRound(
        atIndex index: Int,
        withRound round: Round
    ) -> ScoreCard {
        var copy = self
        copy.replaceRound(atIndex: index, withRound: round)
        return copy
    }

    /// Whether or not the round with the provided ID can be replaced with the provided round
    /// - Parameters:
    ///   - id: The ID of the round you wish to replace
    ///   - round: The round to use instead
    /// - Returns: `true` if the replacement is possible, otherwise `false` if it is not (or if no such round exists to be replaced)
    public func canReplaceRound(
        id: String,
        withRound round: Round
    ) -> Bool {
        guard let old = rounds.filter({ round in round.id == id }).first,
              let index = rounds.firstIndex(of: old) else {
            return false
        }
        return canReplaceRound(atIndex: index, withRound: round)
    }

    /// Replace the round at the provided ID with the provided round
    /// - Parameters:
    ///   - id: The ID of the round you wish to replace
    ///   - round: The round to use instead
    public mutating func replaceRound(
        id: String,
        withRound round: Round
    ) {
        precondition(canReplaceRound(id: id, withRound: round))
        guard let old = rounds.filter({ round in round.id == id }).first,
              let index = rounds.firstIndex(of: old) else {
            fatalError()
        }
        replaceRound(atIndex: index, withRound: round)
    }

    public func replacingRound(
        id: String,
        withRound round: Round
    ) -> ScoreCard {
        var copy = self
        copy.replaceRound(id: id, withRound: round)
        return self
    }

    public func dropLast(
        _ k: Int = 1
    ) -> ScoreCard {
        precondition(rounds.count >= k)
        var copy = self
        copy.rounds = Array(rounds.dropLast(k))
        return copy
    }

    /// The total score for a given player
    /// - Parameter player: The player you want to get the score for
    /// - Returns: The total score for that player
    public func totalScore(
        forPlayer player: String
    ) -> Int {
        precondition(players.contains(player))
        return rounds
            .filter { round in
                round.players.contains(player)
            }
            .compactMap { round in
                round.score(forPlayer: player)
            }
            .reduce(0, +)
    }

    // MARK: - Subscript

    public subscript(_ player: String) -> Int {
        totalScore(forPlayer: player)
    }

    public subscript(_ index: Int) -> Round {
        get {
            rounds[index]
        }
        set {
            replaceRound(atIndex: index, withRound: newValue)
        }
    }

    /// A round in a game of five
    public struct Round: Equatable, Hashable, Sendable, Identifiable, Codable {

        // MARK: - Initializers

        /// Create a round with ordered players and an optional ID
        /// - Parameters:
        ///   - players: The players who participated in the round
        ///   - id: The unique identifier of this round
        public init(players: [String], id: ID? = nil) {
            self.players = players
            self.id = id ?? UUID().uuidString
        }

        // MARK: - API

        /// Whether or not the round contains legal scores for every player
        public var isComplete: Bool {
            guard players.count >= 2 else {
                return false
            }
            let zeroes = scoreMap.values.filter { score in score == 0 }
            guard zeroes.count >= 1 else {
                return false
            }
            guard zeroes.count < players.count else {
                return false
            }
            return true
        }

        /// The players participating in this round
        public let players: [String]

        /// All the scores contained in the round
        public var scores: [Int] {
            players
                .compactMap { player in
                    self[player]
                }
        }

        /// Set the score for a given player
        /// - Parameters:
        ///   - score: The score
        ///   - player: The player
        public mutating func set(
            score: Int,
            forPlayer player: String
        ) {
            precondition(players.contains(player))
            do {
                scoreMap[player] = try validateScore(score)
            } catch {
                fatalError()
            }
        }

        public mutating func removeScore(forPlayer player: String) {
            precondition(players.contains(player))
            scoreMap.removeValue(forKey: player)
        }

        public func score(forPlayer player: String) -> Int? {
            precondition(players.contains(player))
            return scoreMap[player]
        }

        // MARK: - Subscript

        public subscript(_ player: String) -> Int? {
            get {
                guard players.contains(player) else { return nil }
                return score(forPlayer: player)
            }
            set {
                guard players.contains(player) else { return }
                if let newValue {
                    set(score: newValue, forPlayer: player)
                } else {
                    removeScore(forPlayer: player)
                }

            }
        }

        // MARK: - Identifiable

        public typealias ID = String

        public var id: ID

        // MARK: - Private

        private var scoreMap = [String: Int]()
    }

    // MARK: - Identifiable

    public typealias ID = String

    public var id: ID

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
