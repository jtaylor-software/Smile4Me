//
//  Joke.swift
//  Smile4Me
//
//  Created by Jeremy Taylor on 5/20/25.
//

enum JokeID: Hashable {
    case int(Int)
    case string(String)
    
}

struct Joke: Codable, Equatable {
  let id: JokeID
  let category: Category?
  var type: JokeType?
  let lang: Language?
  let setup: String?
  let delivery: String?
  let joke: String?
    
  
  var fullJoke: String {
    switch type {
    case .single:
      return joke ?? ""
    case .twopart:
      return (setup ?? "") + "\n\n" + (delivery ?? "")
    case .dad:
        return joke ?? ""
    case .none:
        return ""
    }
      
  }
  
  static let single = Joke(
    id: JokeID.int(1),
    category: .Misc,
    type: .single,
    lang: .en,
    setup: nil,
    delivery: nil,
    joke: "Never date a baker. They are too kneady."
  )
  
  static let twoPart = Joke(
    id: JokeID.int(2),
    category: .Pun,
    type: .twopart,
    lang: .en,
    setup: "Which is faster? Hot or cold?",
    delivery: "Hot, because you can catch a cold.",
    joke: nil
  )
    static let dad = Joke(
        id: JokeID.int(3),
        category: .Dad,
        type: .dad,
        lang: nil,
        setup: nil,
        delivery: nil,
        joke: "“My Dog has no nose.” How does he smell?” “Awful”"
    )
}

extension JokeID: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intVal = try? container.decode(Int.self) {
            self = .int(intVal)
        } else if let stringVal = try? container.decode(String.self) {
            self = .string(stringVal)
        } else {
            throw DecodingError.typeMismatch(
                JokeID.self,
                DecodingError.Context(codingPath: decoder.codingPath,
                                      debugDescription: "Expected String or Int for JokeID.")
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .int(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
}
