//
//  Smile4MeWidget.swift
//  Smile4MeWidget
//
//  Created by Jeremy Taylor on 5/30/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> JokeEntry {
        JokeEntry(date: Date(), joke: Joke.single)
    }

    func getSnapshot(in context: Context, completion: @escaping (JokeEntry) -> ()) {
        let jokeManager = JokeManager()
        Task {
            let joke = try await jokeManager.getJoke()
            let entry = JokeEntry(date: Date(), joke: joke)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let jokeManager = JokeManager()
        var entries: [JokeEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            Task {
                let joke = try! await jokeManager.getJoke()
                let entry = JokeEntry(date: entryDate, joke: joke)
                entries.append(entry)
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        }
    }
}

struct JokeEntry: TimelineEntry {
    let date: Date
    let joke: Joke?
}

struct Smile4MeWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    var body: some View {
        if let joke = entry.joke {
            JokeView(joke: joke)
        } else {
            ContentUnavailableView {
                Text("😢")
                    .font(.system(size: family == .systemLarge ? 120 : 80))
            } description: {
                Text("No joke available")
                    .font(family == .systemLarge ? .largeTitle : .title2)
            }
        }
    }
}

struct Smile4MeWidget: Widget {
    let kind: String = "Smile4MeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
                Smile4MeWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Smile4Me")
        .description("Bring a smile to your face.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview("Medium Widget", as: .systemMedium) {
    Smile4MeWidget()
} timeline: {
    JokeEntry(date: .now, joke: Joke.single)
    JokeEntry(date: .now, joke: Joke.twoPart)
}

#Preview("Large Widget", as: .systemLarge) {
    Smile4MeWidget()
} timeline: {
    JokeEntry(date: .now, joke: Joke.single)
    JokeEntry(date: .now, joke: Joke.twoPart)
}
