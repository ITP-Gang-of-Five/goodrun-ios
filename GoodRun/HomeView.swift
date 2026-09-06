//
//  ContentView.swift
//  GoodRun
//
//  Created by Max Healey on 14/8/2026.
//

import SwiftUI
import WebKit

enum FilterSetting: String, CaseIterable, Identifiable {
  case all = "All"
  case urgent = "Urgent"
  case under30min = "Under 30 min"

  var id: Self { self }
}

struct HomeView: View {

  let runs = [
    Run(
      id: 1,
      name: "Medical Supply Run",
      size: .medium,
      toLocation: Location(name: "City Hospital", longitude: 0, latitude: 0),
      fromLocation: Location(name: "Central Warehouse", longitude: 0, latitude: 0),
      status: .high,
      createdBy: "John Doe",
      createdTime: Date(),
      urgency: .high,
      assignedTo: [101, 102],
      expiryTime: Date().addingTimeInterval(86400),
      completedTime: nil,
      notes: "Fragile equipment, deliver to 3rd floor."
    )
  ]

  @State
  var shownRuns: [Run] = []

  @State
  var selectedFilterOption = 0

  let url = URL(
    string:
      "https://www.google.com/maps/dir/-37.8013131,144.962132/The+University+of+Melbourne,+Parkville+VIC+3010/RMIT+University+-+Melbourne+City+Campus,+City+campus,+124+La+Trobe+St,+Melbourne+VIC+3000/MCG+Warm+Up+Cricket+Pitch,+Unnamed+Road,+East+Melbourne+VIC+3002/Flinders+Street,+Flinders+St,+Melbourne+VIC+3000/The+Duke+of+Wellington,+146+Flinders+St,+Melbourne+VIC+3000/42+Powell+St,+Yarraville+VIC+3013/@-37.751986,144.8744204,10.65z/data=!4m40!4m39!1m1!4e1!1m5!1m1!1s0x6ad642d45c07254b:0xeacb63e2b725ff6d!2m2!1d144.960974!2d-37.7983459!1m5!1m1!1s0x6ad642cb0a2ff0fb:0xed6e6acedcefb31c!2m2!1d144.9642712!2d-37.8086263!1m5!1m1!1s0x6ad643c342ebef09:0xf8dcfb282f88e324!2m2!1d144.9813889!2d-37.8194092!1m5!1m1!1s0x6ad642b6af832249:0xe39e415e49a7c44e!2m2!1d144.9670618!2d-37.8182711!1m5!1m1!1s0x6ad642b7b08f87f5:0xa94a6c9c48406886!2m2!1d144.9701206!2d-37.8164427!1m5!1m1!1s0x6ad667459b2774c9:0x67c824c1a270f2ac!2m2!1d144.88474!2d-37.8167404!3e2?entry=ttu&g_ep=EgoyMDI2MDgyNS4wIKXMDSoASAFQAw%3D%3D"
  )

  var body: some View {

    WebView(url: url)

    Text("Runs for you")
      .frame(maxWidth: .infinity, alignment: .leading)
      .font(Font.title)
      .padding()
    Text("\(runs.count) runs near you")
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal)

    NavigationStack {
      List(shownRuns) { run in
        NavigationLink(value: run) { RunView(run: run) }
      }
      .padding()
      .onAppear(perform: { shownRuns = runs })
    }
  }
}

struct WebView: UIViewRepresentable {

  var url: URL? = URL(string: "https://www.google.com")

  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }

  func updateUIView(_ webView: UIViewType, context: Context) {

    if let url = url {
      let request = URLRequest(url: url)
      webView.load(request)
    }

  }

}

#Preview {
  HomeView()
}
