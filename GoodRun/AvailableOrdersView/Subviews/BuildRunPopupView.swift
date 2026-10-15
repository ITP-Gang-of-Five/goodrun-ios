import CoreLocation
import SwiftUI

struct BuildRunPopupView: View {
    let selectedOrders: [Order]
    @Binding var selectedOrderIDs: Set<String>
    @Binding var path: [AppScreen]

    var body: some View {
        HStack {
            Text("\(selectedOrders.count) selected")
                .font(.headline)
                .padding()

            Button("Clear") {
                selectedOrderIDs = []
            }

            NavigationLink(destination: RunView(runOrders: selectedOrders, path: _path)) {
                Text("Build run")
                    .frame(maxWidth: .infinity)
                    .backgroundStyle(.red)
                    .padding()

            }
            .buttonStyle(.automatic)
        }
    }
}
