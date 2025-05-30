//
//  JokeView.swift
//  Smile4Me
//
//  Created by Jeremy Taylor on 5/20/25.
//

import SwiftUI

struct JokeView: View {
  let joke: Joke?
  let errorString: String
  @State private var deliveryRedacted = true
  var body: some View {
    VStack(alignment: .leading) {
      if !errorString.isEmpty {
        ContentUnavailableView {
          Text("😢")
            .font(.system(size: 100))
        } description: {
          Text(errorString)
            .font(.largeTitle)
        }
        .frame(maxWidth: .infinity, alignment: .center)
      } else {
        if let joke {
          HStack(alignment: .top) {
              Text(joke.category?.emoji ?? "🤪")
              .font(.system(size: 60))
            VStack(alignment: .leading) {
              switch joke.type {
              case .twopart:
                Text(joke.setup ?? "")
                Divider()
                HStack {
                  Text(joke.delivery ?? "")
                    .redacted(reason: deliveryRedacted ? .placeholder : [])
                  Button {
                    withAnimation {
                      deliveryRedacted.toggle()
                    }
                  } label: {
                    Image(systemName: deliveryRedacted ? "eye" : "eye.slash")
                  }
                }
              case .single:
                Text(joke.joke ?? "")
              case .dad:
                  Text(joke.joke ?? "")
              case .none:
                  Text(joke.joke ?? "")
              }
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
      Divider()
    }
    .font(.title2)
    .task(id: joke) {
      deliveryRedacted = true
    }
  }
}

#Preview("No Joke") {
  JokeView(joke: nil, errorString: "No joke for Programming - fr")
}

#Preview("Single") {
  JokeView(joke: .single, errorString: "")
}

#Preview("Twopart") {
  JokeView(joke: .twoPart, errorString: "")
}

#Preview("Dad") {
    JokeView(joke: .dad, errorString: "")
}
