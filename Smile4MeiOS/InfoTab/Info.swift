//
//  Info.swift
//  Smile4Me
//
//  Created by Jeremy Taylor on 5/29/25.
//


struct Info: Codable {
    struct Jokes: Codable {
        let totalCount: Int
        let idRange: [String: [Int]]
        let safeJokes: [SafeJoke]
        var langCount: [String: Int] {
            idRange.mapValues { range in
                guard !range.isEmpty else { return 0 }
                return range.last! + 1
            }
        }
    }
    let jokes: Jokes
    struct SafeJoke: Codable {
        let lang: String
        let count: Int
    }
}