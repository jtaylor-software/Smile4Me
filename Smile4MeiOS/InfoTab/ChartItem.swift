//
//  ChartItem.swift
//  Smile4MeiOS
//
//  Created by Jeremy Taylor on 5/29/25.
//

import Foundation

struct ChartItem: Identifiable {
    enum JokeType: String {
        case safe, unsafe
    }
    var id = UUID()
    let lang: String
    let qty: Int
    let jokeType: JokeType
}
