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
  @State var loginVsSignup: Bool = true
  let apiservice = ApiRequestsService(apiurl: "/")

  var body: some View {
    Text("GoodRun App Login")
    Form {
      VStack {
        Section {
          TextField("Email or Username", text: $username)
            .textContentType(.username)
            .autocapitalization(.none)

          SecureField("Password", text: $password)
            .textContentType(.password)

        }

        NavigationLink(destination: AvailableOrdersView()) {
          Text("Login")
            .frame(maxWidth: .infinity)
            .backgroundStyle(.blue)
            .padding()
        }.buttonStyle(.automatic)

      }
    }
  }

}

#Preview {
  NavigationStack {
    LoginView()
  }
}
