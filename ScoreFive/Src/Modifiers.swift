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

private struct RowViewConfigurationViewModifier: ViewModifier {

    // MARK: - Initializers

    init(configuration: RecordViewRow.Configuration) {
        rowViewConfiguration = configuration
        isAccented = nil
        hasTopDivider = nil
        hasBottomDivider = nil
    }

    init(
        isAccented: Bool?,
        hasTopDivider: Bool?,
        hasBottomDivider: Bool?
    ) {
        rowViewConfiguration = nil
        self.isAccented = isAccented
        self.hasTopDivider = hasTopDivider
        self.hasBottomDivider = hasBottomDivider
    }

    // MARK: - API

    let rowViewConfiguration: RecordViewRow.Configuration?

    let isAccented: Bool?

    let hasTopDivider: Bool?

    let hasBottomDivider: Bool?

    // MARK: - ViewModifier

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .environment(\.recordViewRowConfiguration, newConfiguration)
    }

    // MARK: - Private

    @Environment(\.recordViewRowConfiguration)
    private var existingConfiguration: RecordViewRow.Configuration

    private var newConfiguration: RecordViewRow.Configuration {
        rowViewConfiguration ?? .init(
            isAccented: isAccented ?? existingConfiguration.isAccented,
            hasTopDivider: hasTopDivider ?? existingConfiguration.hasTopDivider,
            hasBottomDivider: hasBottomDivider ?? existingConfiguration.hasTopDivider
        )
    }

}

private struct AsNavigationLinkViewModifier: ViewModifier {

    @ViewBuilder
    func body(content: Content) -> some View {
        NavigationLink {
            EmptyView()
        } label: {
            content
        }
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

    func recordViewRowConfiguration(_ configuration: RecordViewRow.Configuration) -> some View {
        let modifier = RowViewConfigurationViewModifier(configuration: configuration)
        return ModifiedContent(content: self, modifier: modifier)
    }

    func recordViewRowConfiguration(
        isAccented: Bool? = nil,
        hasTopDivider: Bool? = nil,
        hasBottomDivider: Bool? = nil
    ) -> some View {
        let modifier = RowViewConfigurationViewModifier(
            isAccented: isAccented,
            hasTopDivider: hasTopDivider,
            hasBottomDivider: hasBottomDivider
        )
        return ModifiedContent(content: self, modifier: modifier)
    }

    func asLink() -> some View {
        let modifier = AsNavigationLinkViewModifier()
        return ModifiedContent(content: self, modifier: modifier)
    }

}
