//
//  Language.swift
//  Smile4Me
//
//  Created by Jeremy Taylor on 5/20/25.
//


enum Language: String, Codable, CaseIterable, Identifiable {
  case en, fr,cs, de, es, pt
  var id: Self { self }
  
  var full: String {
    switch self {
    case .en: return "English"
    case .fr: return "French"
    case .cs: return "Czech"
    case .de: return "German"
    case .es: return "Spanish"
    case .pt: return "Portuguese"
    }
  }
}
