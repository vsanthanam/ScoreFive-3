// ScoreFive
// PlayingCard.swift
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
import UIExtensions

struct PlayingCard<Content>: View where Content: View {

    // MARK: - Initializers

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    // MARK: - View

    @MainActor
    @ViewBuilder
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(16)
                .foregroundColor(Color.secondarySystemGroupedBackground)
                .shadow(radius: 16)
            VStack {
                #Symbol("suit.spade.fill")
                    .font(.largeTitle)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.accentColor)
                Spacer()
                content
                Spacer()
                #Symbol("suit.spade.fill")
                    .font(.largeTitle)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .rotationEffect(.degrees(180))
                    .foregroundStyle(Color.accentColor)
            }
        }
        .aspectRatio(CGSize(width: 25, height: 35), contentMode: .fit)
        .frame(maxHeight: 475.0)
    }

    @ViewBuilder
    let content: Content

}

#Preview {
    PlayingCard {
        Text("Card Content")
    }
}
