//
//  Smile4MeApp.swift
//  Smile4Me
//
//  Created by Jeremy Taylor on 5/20/25.
//

import SwiftUI
import LaunchAtLogin

@main
struct Smile4MeApp: App {
  var body: some Scene {
    MenuBarExtra("Smile4Me", image: "MenuBarIcon") {
      VStack(alignment: .leading) {
        JokeContentView()
        Divider()
        HStack {
          LaunchAtLogin.Toggle()
          Spacer()
          Button("Quit") {
            NSApplication.shared.terminate(nil)
          }.keyboardShortcut("q")
        }
      }
      .padding()
      .frame(width: 400, height: 400)
    }
    .menuBarExtraStyle(.window)
  }
}
