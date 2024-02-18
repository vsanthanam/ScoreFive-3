// ScoreFive
// AcknowledgementsModifier.swift
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

import CollectionExtensions
import SwiftUI

extension View {

    func acknowledgements(_ acknowledgements: [Acknowledgement]) -> some View {
        let modifier = AcknowledgementsViewModifier(acknowledgements: acknowledgements)
        return ModifiedContent(content: self, modifier: modifier)
    }

    func acknowledgements(@ArrayBuilder<[Acknowledgement]> _ acknowledgements: () -> [Acknowledgement]) -> some View {
        let modifier = AcknowledgementsViewModifier(acknowledgements: acknowledgements())
        return ModifiedContent(content: self, modifier: modifier)
    }

}

extension EnvironmentValues {

    var acknowledgements: [Acknowledgement] {
        get {
            self[AcknowledgementsEnvironmentKey.self]
        }
        set {
            self[AcknowledgementsEnvironmentKey.self] = newValue
        }
    }
}

private struct AcknowledgementsEnvironmentKey: EnvironmentKey {

    // MARK: - EnvironmentKey

    typealias Value = [Acknowledgement]

    static let defaultValue: [Acknowledgement] = []
}

private struct AcknowledgementsViewModifier: ViewModifier {

    // MARK: - Initializers

    init(acknowledgements: [Acknowledgement]) {
        self.acknowledgements = acknowledgements
    }

    // MARK: - ViewModifier

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .environment(\.acknowledgements, acknowledgements)
    }

    // MARK: - Private

    private let acknowledgements: [Acknowledgement]

}
