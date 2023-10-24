// ScoreFive
// RecordViewRow.swift
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

struct Entries<T>: View {

    init(
        values: [T],
        toString: @escaping (T) -> String,
        isWinner: @escaping (T) -> Bool = { _ in false },
        isLoser: @escaping (T) -> Bool = { _ in false },
        isEliminated: @escaping (T) -> Bool = { _ in false },
        isAccented: @escaping (T) -> Bool = { _ in false }
    ) {
        self.values = values
        self.toString = toString
        self.isWinner = isWinner
        self.isLoser = isLoser
        self.isEliminated = isEliminated
        self.isAccented = isAccented
    }

    init(
        values: [T],
        toString: @escaping (T) -> String = \.description,
        isWinner: @escaping (T) -> Bool = { _ in false },
        isLoser: @escaping (T) -> Bool = { _ in false },
        isEliminated: @escaping (T) -> Bool = { _ in false },
        isAccented: @escaping (T) -> Bool = { _ in false }
    ) where T: CustomStringConvertible {
        self.values = values
        self.toString = toString
        self.isWinner = isWinner
        self.isLoser = isLoser
        self.isEliminated = isEliminated
        self.isAccented = isAccented
    }

    init<Value>(
        values: [Value?],
        toString: @escaping (Value) -> String,
        isWinner: @escaping (Value) -> Bool = { _ in false },
        isLoser: @escaping (Value) -> Bool = { _ in false },
        isEliminated: @escaping (Value) -> Bool = { _ in false },
        isAccented: @escaping (Value) -> Bool = { _ in false }
    ) where T == Value? {
        self.values = values
        self.toString = { value in
            value.map(toString) ?? ""
        }
        self.isWinner = { value in
            value.map(isWinner) ?? false
        }
        self.isLoser = { value in
            value.map(isLoser) ?? false
        }
        self.isEliminated = { value in
            value.map(isEliminated) ?? false
        }
        self.isAccented = { value in
            value.map(isAccented) ?? false
        }
    }

    init<Value>(
        values: [Value?],
        toString: @escaping (Value) -> String = \.description,
        isWinner: @escaping (Value) -> Bool = { _ in false },
        isLoser: @escaping (Value) -> Bool = { _ in false },
        isEliminated: @escaping (Value) -> Bool = { _ in false },
        isAccented: @escaping (Value) -> Bool = { _ in false }
    ) where T == Value?, Value: CustomStringConvertible {
        self.values = values
        self.toString = { value in
            value.map(toString) ?? ""
        }
        self.isWinner = { value in
            value.map(isWinner) ?? false
        }
        self.isLoser = { value in
            value.map(isLoser) ?? false
        }
        self.isEliminated = { value in
            value.map(isEliminated) ?? false
        }
        self.isAccented = { value in
            value.map(isAccented) ?? false
        }
    }

    @ViewBuilder
    var body: some View {
        HStack(spacing: 0.0) {
            ForEach(values.indices, id: \.self) { index in
                let value = values[index]
                Text(toString(value))
                    .foregroundStyle(color(for: value))
                    .frame(maxWidth: .infinity)
                    .fontWeight(isAccented(value) ? .semibold : .regular)
                    .opacity(isEliminated(value) ? 0.3 : 1.0)
            }
            .fontDesign(.monospaced)
        }
    }

    private let values: [T]

    private let toString: (T) -> String

    private let isWinner: (T) -> Bool

    private let isLoser: (T) -> Bool

    private let isEliminated: (T) -> Bool

    private let isAccented: (T) -> Bool

    private func color(for value: T) -> Color {
        if isWinner(value) {
            return .green
        } else if isLoser(value) {
            return .red
        } else {
            return .label
        }
    }

}

struct RecordViewRow<Signpost, Content>: View where Signpost: View, Content: View {

    init(@ViewBuilder content: () -> Content) where Signpost == Spacer {
        signpost = Spacer()
        self.content = content()
    }

    init(
        @ViewBuilder signpost: () -> Signpost,
        @ViewBuilder content: () -> Content
    ) {
        self.signpost = signpost()
        self.content = content()
    }

    @ViewBuilder
    let signpost: Signpost

    @ViewBuilder
    let content: Content

    @ScaledMetric
    var rowHeight = 44.0

    @Environment(\.recordViewRowConfiguration)
    var configuration: RecordViewRowConfiguration

    @ViewBuilder
    var body: some View {
        VStack(spacing: 0.0) {
            if configuration.hasTopDivider {
                Divider()
            }
            HStack(spacing: 0.0) {
                signpost
                    .frame(width: rowHeight, height: rowHeight)
                Divider()
                content
                    .frame(maxWidth: .infinity)
            }
            if configuration.hasBottomDivider {
                Divider()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: rowHeight)
    }
}

struct RecordViewRowConfiguration: Equatable, Hashable, Sendable {
    let hasTopDivider: Bool
    let hasBottomDivider: Bool
}

struct RecordViewRowConfigurationEnvironmentKey: EnvironmentKey {

    typealias Value = RecordViewRowConfiguration

    static let defaultValue: Value = .init(hasTopDivider: false, hasBottomDivider: false)

}

extension EnvironmentValues {

    var recordViewRowConfiguration: RecordViewRowConfiguration {
        get {
            self[RecordViewRowConfigurationEnvironmentKey.self]
        }
        set {
            self[RecordViewRowConfigurationEnvironmentKey.self] = newValue
        }
    }

}

struct RecordViewRowConfigurationViewModifier: ViewModifier {

    let configuration: RecordViewRowConfiguration

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .environment(\.recordViewRowConfiguration, configuration)
    }
}

extension View {

    func recordViewRowConfiguration(
        hasTopDivider: Bool = false,
        hasBottomDivider: Bool = false
    ) -> some View {
        let configuration = RecordViewRowConfiguration(hasTopDivider: hasTopDivider, hasBottomDivider: hasBottomDivider)
        return recordViewRowConfiguration(configuration)
    }

    func recordViewRowConfiguration(
        _ configuration: RecordViewRowConfiguration
    ) -> some View {
        let modifier = RecordViewRowConfigurationViewModifier(configuration: configuration)
        return ModifiedContent(content: self, modifier: modifier)
    }
}
