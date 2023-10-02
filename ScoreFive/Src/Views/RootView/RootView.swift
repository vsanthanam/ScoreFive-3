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
            HStack(alignment: .center) {
                menuCard
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
            .sheet(isPresented: $showMore) {
                MoreView()
            }
            .navigationDestination(for: Record.self) { record in
                RecordView(activeRecord: record)
            }
        }
    }

    // MARK: - Private

    @ViewBuilder
    private var menuCard: some View {
        ZStack {
            Rectangle()
                .cornerRadius(cardCornerRadius)
                .foregroundColor(Color.secondarySystemGroupedBackground)
                .shadow(radius: 16)
            VStack {
                Image(systemName: "suit.spade")
                    .font(.largeTitle)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text("Score Five")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(24.0)
                Button {
                    showNewGame.toggle()
                } label: {
                    Text("New Game")
                        .fontWeight(.semibold)
                        .frame(minWidth: buttonWidth)
                }
                .buttonStyle(.borderedProminent)
                if !records.isEmpty {
                    Button {
                        showLoadGame.toggle()
                    } label: {
                        Text("Load Game")
                            .fontWeight(.semibold)
                            .frame(minWidth: buttonWidth)
                    }
                    .buttonStyle(.bordered)
                }
                Button {
                    showMore.toggle()
                } label: {
                    Text("More")
                        .fontWeight(.semibold)
                        .frame(minWidth: buttonWidth)
                }
                .buttonStyle(.bordered)
                Spacer()
                Image(systemName: "suit.spade")
                    .font(.largeTitle)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .rotationEffect(.degrees(180))
            }
            .buttonStyle(.borderedProminent)
        }
        .aspectRatio(CGSize(width: 25, height: 35), contentMode: .fit)
        .frame(maxHeight: 475.0)
    }

    @State
    private var pages = [Record]()

    @State
    private var showNewGame = false

    @State
    private var showLoadGame = false

    @State
    private var showMore = false

    @Query(sort: \Record.lastUpdated)
    private var records: [Record]

    @Environment(\.modelContext)
    private var modelContext: ModelContext

    @ScaledMetric(relativeTo: .body)
    private var cardCornerRadius = 16.0

    @ScaledMetric(relativeTo: .body)
    private var buttonWidth = 100.0
}

#Preview {
    RootView()
        .modelContainer(for: Record.self, inMemory: true)
}
