//
//  JokeView.swift
//  Smile4MeWidgetExtension
//
//  Created by Jeremy Taylor on 5/30/25.
//

import SwiftUI

struct JokeView: View {
    let joke: Joke
    
    var body: some View {
        HStack(alignment: .top) {
            Text(joke.category?.emoji ?? "🤪") // Use Dad Joke as default because if this is nil, it's probably a Dad Joke
                .font(.system(size: 60))
                Text(joke.fullJoke)
                .font(.largeTitle)
                .lineLimit(nil)
                .minimumScaleFactor(0.2)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

