// ScoreFive
// ScoreCardTests.swift
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

import CwlPreconditionTesting
@testable import FiveKit
import XCTest

final class ScoreCardTests: XCTestCase {

    func test_init_invalid_limit() {
        let e = catchBadInstruction {
            _ = ScoreCard(players: ["Foo", "Bar"], scoreLimit: 20)
        }
        XCTAssertNotNil(e)
    }

    func test_init_not_enough_players() {
        let e = catchBadInstruction {
            _ = ScoreCard(players: ["Foo"], scoreLimit: 250)
        }
        XCTAssertNotNil(e)
    }

    func test_init_not_duplicate_players() {
        let e = catchBadInstruction {
            _ = ScoreCard(players: ["Foo", "Foo"], scoreLimit: 250)
        }
        XCTAssertNotNil(e)
    }

    func test_init() {
        let card = ScoreCard(players: ["Foo", "Bar", "Baz"], scoreLimit: 101)
        XCTAssertEqual(card.players, ["Foo", "Bar", "Baz"])
        XCTAssertEqual(card.scoreLimit, 101)
    }
}
