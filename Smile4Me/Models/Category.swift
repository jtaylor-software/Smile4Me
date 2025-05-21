//
//  Category.swift
//  Smile4Me
//
//  Created by Jeremy Taylor on 5/20/25.
//


enum Category: String, Codable, CaseIterable, Identifiable {
  case `Any`, Programming, Misc, Dark, Pun, Spooky, Christmas
  var id: Self { self }
  
  var emoji: String {
    switch self {
    case .Any: return ""
    case .Programming: return "🤖"
    case .Misc: return "🎉"
    case .Dark: return "🌘"
    case .Pun: return "🥴"
    case .Spooky: return "👻"
    case .Christmas: return "🎅🏻"
    }
  }
}
