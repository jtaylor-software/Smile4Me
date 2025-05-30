//
//  ConfigurableWidgetProvider.swift
//  Smile4Me
//
//  Created by Jeremy Taylor on 5/30/25.
//


import WidgetKit
import SwiftUI

struct ConfigurableWidgetProvider: AppIntentTimelineProvider {
    let jokeManager = JokeManager()
    
    func placeholder(in context: Context) -> ConfigurableEntry {
        ConfigurableEntry(date: Date(), configuration: ConfigurationAppIntent(), joke: Joke.single)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> ConfigurableEntry {
        let joke = try? await jokeManager.getJoke()
        return ConfigurableEntry(date: Date(), configuration: configuration, joke: joke)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<ConfigurableEntry> {
        var entries: [ConfigurableEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let category = Category.allCases.first(where: {$0.rawValue == configuration.category?.id}) ?? .Any
        let language = Language.allCases.first(where: {$0.full == configuration.language?.id}) ?? .en
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            if category == .Dad {
                let joke = try? await jokeManager.getDadJoke()
                let entry = ConfigurableEntry(date: entryDate, configuration: configuration, joke: joke)
                entries.append(entry)
            } else {
                let joke = try? await jokeManager.getJoke(
                    category: category,
                    language: language
                )
                let entry = ConfigurableEntry(date: entryDate, configuration: configuration, joke: joke)
                entries.append(entry)
            }
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct ConfigurableEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let joke: Joke?
}

struct ConfigurableWidgetEntryView : View {
    var entry: ConfigurableWidgetProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        if let joke = entry.joke {
            JokeView(joke: joke)
        } else {
            let category = entry.configuration.category?.id ?? Category.Any.rawValue
            let language = entry.configuration.language?.id ?? Language.en.full
            ContentUnavailableView {
                Text("😢")
                    .font(.system(size: family == .systemLarge ? 120 : 80))
            } description: {
                Text("No joke available for \(category) in \(language).")
                    .font(family == .systemLarge ? .largeTitle : .title2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct ConfigurableWidget: Widget {
    let kind: String = "ConfigurableWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: ConfigurableWidgetProvider()) { entry in
            ConfigurableWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Configurable Smile4Me")
        .description(Text("Choose a language and category for your joke."))
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview("Medium Widget", as: .systemMedium) {
    ConfigurableWidget()
} timeline: {
    ConfigurableEntry(date: .now, configuration: ConfigurationAppIntent(), joke: Joke.single)
    ConfigurableEntry(date: .now, configuration: ConfigurationAppIntent(), joke: Joke.twoPart)
}

#Preview("Large Widget", as: .systemLarge) {
    ConfigurableWidget()
} timeline: {
    ConfigurableEntry(date: .now, configuration: ConfigurationAppIntent(), joke: Joke.single)
    ConfigurableEntry(date: .now, configuration: ConfigurationAppIntent(), joke: Joke.twoPart)
}
