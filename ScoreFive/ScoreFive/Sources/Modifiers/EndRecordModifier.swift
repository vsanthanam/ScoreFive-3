// ScoreFive
// EndRecordModifier.swift
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

import SwiftUI

extension View {

    func onRecordEnd(_ onEnd: @escaping () -> Void) -> some View {
        let action = EndRecordAction(action: onEnd)
        let modifier = EndRecordViewModifier(endRecord: action)
        return ModifiedContent(content: self, modifier: modifier)
    }

}

struct EndRecordAction {

    fileprivate init(action: @escaping () -> Void) {
        self.action = action
    }

    private let action: () -> Void

    func callAsFunction() {
        action()
    }
}

struct EndRecordEnvironmentKey: EnvironmentKey {

    typealias Value = EndRecordAction

    static var defaultValue: Value = .init {}

}

extension EnvironmentValues {

    var endRecord: EndRecordAction {
        get { self[EndRecordEnvironmentKey.self] }
        set { self[EndRecordEnvironmentKey.self] = newValue }
    }

}

struct EndRecordViewModifier: ViewModifier {

    let endRecord: EndRecordAction

    @MainActor
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .environment(\.endRecord, endRecord)
    }

}
