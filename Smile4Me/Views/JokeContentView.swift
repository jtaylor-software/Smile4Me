//
//  JokeContentView.swift
//  Smile4Me
//
//  Created by Jeremy Taylor on 5/20/25.
//

import SwiftUI

struct JokeContentView: View {
    let jokeManager = JokeManager()
    @State private var joke: Joke?
    @State private var category: Category = .Any
    @State private var language: Language = .en
    @State private var errorString = ""
    @State private var fetching = false
    @Environment(\.openURL) var openURL
    var body: some View {
        NavigationStack {
            ZStack {
                if fetching {
                    ProgressView()
                }
                ScrollView {
                    VStack {
                        HStack {
                            Picker("Language", selection: $language) {
                                ForEach(Language.allCases) { language in
                                    Text(language.full)
                                }
                            }
                            Picker("Category", selection: $category) {
                                ForEach(Category.allCases) { category in
                                Text("\(category)")
                                }
                            }
                        }
                        Button {
                            Task {
                                await getJoke()
                            }
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        JokeView(joke: joke, errorString: errorString)
                        HStack {
                            Spacer()
                            if let joke {
                                ShareLink(item: joke.fullJoke)
                            }
                        }
                        HStack(alignment: .top) {
                            if let joke {
                                Button("Report Joke") {
                                    let jokeToReport = "\(joke.id)\n\(joke.fullJoke)"
                                    let pasteboard = NSPasteboard.general
                                    pasteboard.declareTypes([.string], owner: nil)
                                    pasteboard.setString(jokeToReport, forType: .string)
                                    guard let url = URL(string: jokeManager.issueURL) else { return }
                                    openURL(url)
                                }
                                Text("You can report an unsafe joke.  The Joke id and content will be on your clipboard")
                                    .font(.caption)
                                    .lineLimit(nil)
                                    .foregroundStyle(.red)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }
            }
            .navigationTitle("Smile4Me")
        }
        .task {
            await getJoke()
        }
        .task(id: category) {
            await getJoke()
        }
        .task(id: language) {
            await getJoke()
        }
    }
    
    func getJoke() async {
        errorString = ""
        fetching = true
        defer {
            fetching = false
        }
        do {
            let joke = try await jokeManager.getJoke(
                category: category,
                language: language
            )
            withAnimation {
                self.joke = joke
            }
        } catch {
            errorString = "No joke for \(category) - \(language)"
        }
    }
}

#Preview {
    JokeContentView()
}
