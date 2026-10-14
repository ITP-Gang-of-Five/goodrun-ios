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
    var model: LoginViewModel

    var body: some View {
        Text("GoodRun App Login")
        if model.loggingIn == .loading {
            ProgressView("Loggin in...")
        } else {
            Form {
                VStack {
                    Section {
                        TextField("Email or Username", text: $username)
                            .textContentType(.username)
                            .autocapitalization(.none)

                        SecureField("Password", text: $password)
                            .textContentType(.password)

                    }
                    if model.loggingIn == .error || model.loggingIn == .failure {
                        LoginErrorView()
                    }

                    Button("Login") {
                        Task {
                            await model.login()
                        }
                    }
                }
            }
        }

    }
}

#Preview {
    let model = LoginViewModel()
    LoginView(model: model)

}
