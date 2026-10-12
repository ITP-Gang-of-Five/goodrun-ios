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
        NavigationStack {
            HStack {
                Text("Good Run")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .fontWeight(.bold)
                Text("MEDICAL PANTRY")
                    .font(.subheadline)
                    .fontWeight(.black)
            }

            LoginView()
            }
        }
    }


#Preview {
  ContentView()
}
