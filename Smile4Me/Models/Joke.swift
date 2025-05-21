//
//  Joke.swift
//  Smile4Me
//
//  Created by Jeremy Taylor on 5/20/25.
//


struct Joke: Codable, Equatable {
  let id: Int
  let category: Category
  let type: JokeType
  let lang: Language
  let setup: String?
  let delivery: String?
  let joke: String?
  
  var fullJoke: String {
    switch type {
    case .single:
      return joke ?? ""
    case .twopart:
      return (setup ?? "") + "\n\n" + (delivery ?? "")
    }
  }
  
  static let single = Joke(
    id: 1,
    category: .Misc,
    type: .single,
    lang: .en,
    setup: nil,
    delivery: nil,
    joke: "Never date a baker. They are too kneady."
  )
  
  static let twoPart = Joke(
    id: 2,
    category: .Pun,
    type: .twopart,
    lang: .en,
    setup: "Which is faster? Hot or cold?",
    delivery: "Hot, because you can catch a cold.",
    joke: nil
  )
}
