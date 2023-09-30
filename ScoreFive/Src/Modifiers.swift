// ScoreFive
// Modifiers.swift
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
import SwiftUI

private struct PlayerNamesListFormatterViewModifier: ViewModifier {

    // MARK: - API

    let formatter: ListFormatter

    // MARK: - ViewModifier

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .environment(\.playerNamesListFormatter, formatter)
    }

}

private struct RecordLastUpdatedDateFormatterViewModifier: ViewModifier {

    // MARK: - API

    let formatter: DateFormatter

    // MARK: - ViewModifier

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .environment(\.recordLastUpdatedDateFormatter, formatter)
    }

}

extension View {

    func playerNamesListFormatter(_ formatter: ListFormatter) -> some View {
        let modifier = PlayerNamesListFormatterViewModifier(formatter: formatter)
        return ModifiedContent(content: self, modifier: modifier)
    }

    func recordLastUpdatedDateFormatter(_ formatter: DateFormatter) -> some View {
        let modifier = RecordLastUpdatedDateFormatterViewModifier(formatter: formatter)
        return ModifiedContent(content: self, modifier: modifier)
    }

}
