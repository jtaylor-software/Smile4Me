//
//  StartTabView.swift
//  Smile4MeiOS
//
//  Created by Jeremy Taylor on 5/29/25.
//

import SwiftUI

struct StartTabView: View {
    var body: some View {
        TabView {
            Tab("Jokes", systemImage: "face.smiling") {
                JokeContentView()
            }
            Tab("Info", systemImage: "info.circle") {
                InfoView()
            }
        }
    }
}

#Preview {
    StartTabView()
}
