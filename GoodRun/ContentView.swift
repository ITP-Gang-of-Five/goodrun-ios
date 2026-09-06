//
//  ContentView.swift
//  GoodRun
//
//  Created by Max Healey on 14/8/2026.
//

import SwiftUI

public enum AppScreen {
  case login
  case home
  case run
}

struct ContentView: View {
  @State private var currentScreen: AppScreen = .login

  var body: some View {
    switch currentScreen {
    case .login:
      LoginView(currentScreen: $currentScreen)
    case .home:
      HomeView()
    case .run:
      LoginView(currentScreen: $currentScreen)
    }
  }
}

#Preview {
  ContentView()
}
