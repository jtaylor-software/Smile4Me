//
//  ConfigurationAppIntent.swift
//  Smile4Me
//
//  Created by Jeremy Taylor on 5/30/25.
//


import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Joke Options" }
    static var description: IntentDescription { "Choose language and category" }

    @Parameter(title: "Language", default: nil)
    var language: LanguageEntity?
    
    @Parameter(title: "Category", default: nil)
    var category: CategoryEntity?
}

struct LanguageEntity: AppEntity {
    static var defaultQuery: LanguageQuery = LanguageQuery()
    
    var id: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(name: "Language")
        
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(id)")
    }
}

struct LanguageQuery: EntityQuery {
    func suggestedEntities() async throws -> [LanguageEntity] {
        Language.allCases.map { LanguageEntity(id: $0.full)}
    }
    
    func entities(for identifiers: [String]) async throws -> [LanguageEntity] {
        try await suggestedEntities().filter { identifiers.contains($0.id)}
    }
    
    func defaultResult() async -> LanguageEntity? {
        try? await suggestedEntities().first
    }
}

struct CategoryEntity: AppEntity {
    static var defaultQuery: CategoryQuery = CategoryQuery()
    
    var id: Language.RawValue
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(name: "Category")
        
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(id)")
    }
}

struct CategoryQuery: EntityQuery {
    func suggestedEntities() async throws -> [CategoryEntity] {
        Category.allCases.map { CategoryEntity(id: $0.rawValue)}
    }
    
    func entities(for identifiers: [String]) async throws -> [CategoryEntity] {
        try await suggestedEntities().filter { identifiers.contains($0.id)}
    }
    
    func defaultResult() async -> CategoryEntity? {
        try? await suggestedEntities().first
    }
}

