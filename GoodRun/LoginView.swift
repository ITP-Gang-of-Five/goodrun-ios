//
//  LoginView.swift
//  GoodRun
//
//  Created by Max Healey on 20/8/2026.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @Binding var currentScreen: AppScreen
    @State var loginVsSignup: Bool = true
    let apiservice = ApiRequestsService(apiurl: "/")
    
    var body: some View {
        Form {
            VStack {
                Section {
                    TextField("Email or Username", text: $username)
                        .textContentType(.username)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                    
                }
                Section {
                    Button("Login") {
                        currentScreen = AppScreen.home
                    }

                    .clipShape(.capsule)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                }
            }
        }
    }
}


#Preview {
  var state = AppScreen.login
  LoginView(currentScreen: .constant(.login))
}
