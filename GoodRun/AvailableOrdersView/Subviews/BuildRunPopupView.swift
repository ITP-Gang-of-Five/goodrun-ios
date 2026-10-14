import SwiftUI
import CoreLocation

struct BuildRunPopupView: View {
    let selectedOrders: [Order]
    @Binding var selectedOrderIDs: Set<String>
    
    
    var body: some View {
        HStack {
            Text("\(selectedOrders.count) selected")
                .font(.headline)
                .padding()
            
            Button("Clear") {
                selectedOrderIDs = []
            }
            
            NavigationLink(destination: RunView(runOrders: selectedOrders)) {
                Text("Build run")
                    .frame(maxWidth: .infinity)
                    .backgroundStyle(.red)
                    .padding()
                    
                }
            .buttonStyle(.automatic)
        }
    }
}

