//
//  InfoView.swift
//  Smile4MeiOS
//
//  Created by Jeremy Taylor on 5/29/25.
//

import SwiftUI
import Charts

struct InfoView: View {
    let jokeManager = JokeManager()
    @State private var info: Info?
    @State private var errorString = ""
    @State private var fetching = false
    @State private var chartItems: [ChartItem] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
               if fetching {
                    ProgressView()
               } else {
                   if let info {
                       VStack {
                           Text("\(info.jokes.totalCount) jokes")
                               .font(.largeTitle)
                           Chart {
                               ForEach(chartItems) { item in
                                   BarMark(
                                    x: .value("Language", item.lang),
                                    y: .value("Total", item.qty)
                                    )
                                   .position(by: .value("Type", item.jokeType.rawValue))
                                   .foregroundStyle(by: .value("Type", item.jokeType.rawValue))
                                   .annotation(position: .top, alignment: .center) {
                                       Text("\(item.qty)")
                                           .font(.caption)
                                   }
                               }
                           }
                       }
                       .padding()
                   } else {
                       Text(errorString)
                   }
               }
            }
            .navigationTitle("Joke Distribution")
            .task {
                await getInfo()
                buildChartInfo()
            }
        }
    }
    
    func getInfo() async {
        errorString = ""
        fetching.toggle()
        defer {
            fetching.toggle()
        }
        do {
          let info = try await jokeManager.getInfo()
            withAnimation {
                self.info = info
            }
        } catch {
            errorString = error.localizedDescription
        }
    }
    
    func buildChartInfo() {
        var chartItems: [ChartItem] = []
        if let info {
            for safeItem in info.jokes.safeJokes {
                let langName = Language(rawValue: safeItem.lang)!.full
                let safeChartItem = ChartItem(lang: langName, qty: safeItem.count, jokeType: .safe)
                chartItems.append(safeChartItem)
                let langTotal = info.jokes.langCount[safeItem.lang] ?? 0
                let unsafeCount = langTotal - safeItem.count
                let unsafeChartItem = ChartItem(lang: langName, qty: unsafeCount, jokeType: .unsafe)
                chartItems.append(unsafeChartItem)
            }
            self.chartItems = chartItems
        }
    }
}

#Preview {
    InfoView()
}
