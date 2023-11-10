// ScoreFive
// RecordRowConfigurationModifier.swift
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

    func recordRowConfiguration(
        hasTopDivider: Bool = false,
        hasBottomDivider: Bool = false
    ) -> some View {
        let configuration = RecordRowConfiguration(hasTopDivider: hasTopDivider, hasBottomDivider: hasBottomDivider)
        return recordRowConfiguration(configuration)
    }

    func recordRowConfiguration(
        _ configuration: RecordRowConfiguration
    ) -> some View {
        let modifier = RecordRowConfigurationViewModifier(configuration: configuration)
        return ModifiedContent(content: self, modifier: modifier)
    }
}

extension EnvironmentValues {

    var recordRowConfiguration: RecordRowConfiguration {
        get {
            self[RecordRowConfigurationEnvironmentKey.self]

        }
        set {
            self[RecordRowConfigurationEnvironmentKey.self] = newValue
        }
    }

}

private struct RecordRowConfigurationEnvironmentKey: EnvironmentKey {

    typealias Value = RecordRowConfiguration

    static let defaultValue: Value = .init(hasTopDivider: false, hasBottomDivider: false)

}

private struct RecordRowConfigurationViewModifier: ViewModifier {

    let configuration: RecordRowConfiguration

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .environment(\.recordRowConfiguration, configuration)
    }
}
