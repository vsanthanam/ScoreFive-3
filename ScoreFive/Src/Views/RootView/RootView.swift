// ScoreFive
// RootView.swift
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

import SwiftData
import SwiftUI

struct RootView: View {

    // MARK: - View

    @ViewBuilder
    var body: some View {
        NavigationStack(path: $pages) {
            HStack {
                ZStack {
                    Rectangle()
                        .cornerRadius(cardCornerRadius)
                        .foregroundColor(Color.secondarySystemGroupedBackground)
                        .shadow(radius: 16)
                    VStack {
                        Text("Score Five")
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)
                            .fontWeight(.bold)
                            .padding(24.0)
                        Button("New Game") {
                            showNewGame.toggle()
                        }
                        if !records.isEmpty {
                            Button("Load Game") {
                                showLoadGame.toggle()
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: cardWidth, maxHeight: cardHeight)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .background(Color.secondarySystemBackground)
            .sheet(isPresented: $showNewGame) {
                NewGameView { record in
                    pages.append(record)
                }
            }
            .sheet(isPresented: $showLoadGame) {
                LoadGameView() { record in
                    pages.append(record)
                }
            }
            .navigationDestination(for: Record.self) { record in
                RecordView(activeRecord: record)
            }
        }
    }

    @State
    private var pages = [Record]()

    // MARK: - Private

    @State
    private var showNewGame = false

    @State
    private var showLoadGame = false

    @Query(sort: \Record.lastUpdated)
    private var records: [Record]

    @Environment(\.modelContext)
    private var modelContext: ModelContext

    @ScaledMetric(relativeTo: .body)
    private var cardWidth = 343.0

    @ScaledMetric(relativeTo: .body)
    private var cardHeight = 490.0

    @ScaledMetric(relativeTo: .body)
    private var cardCornerRadius = 16.0
}

#Preview {
    RootView()
        .modelContainer(for: Record.self, inMemory: true)
}
