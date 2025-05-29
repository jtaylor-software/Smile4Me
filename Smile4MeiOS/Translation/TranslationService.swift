//
//  TranslationService.swift
//  Smile4MeiOS
//
//  Created by Jeremy Taylor on 5/29/25.
//

import Foundation
import Translation

@Observable
class TranslationService {
    var translatedText = ""
    var availableLanguages: [AvailableLanguage] = []
    
    init () {
        getSupporttedLanguages()
    }
    
    func getSupporttedLanguages() {
        Task { @MainActor in
            let supportedLanguages = await LanguageAvailability().supportedLanguages
            availableLanguages = supportedLanguages.map({ local in
                AvailableLanguage(locale: local)
            }).sorted()
        }
    }
    
    func translate(text: String, session: TranslationSession) async throws {
        let response = try await session.translate(text)
        translatedText = response.targetText
    }
}
