//
//  ContentView.swift
//  GoodRun
//
//  Created by Max Healey on 14/8/2026.
//

import SwiftUI

enum AppScreen: Hashable {
    case orders
    case run(runOrders: [Order])
}

struct ContentView: View {

    @State var loginModel = LoginViewModel()

    var body: some View {

        HStack {
            Text("Good Run")
                .font(.headline)
                .foregroundStyle(.secondary)
                .fontWeight(.bold)
            Text("MEDICAL PANTRY")
                .font(.subheadline)
                .fontWeight(.black)
        }
        switch loginModel.loggingIn {
        case .success:
            HomeView()
        default:
            LoginView(model: loginModel)
        }

    }
}

#Preview {
    ContentView()
}
