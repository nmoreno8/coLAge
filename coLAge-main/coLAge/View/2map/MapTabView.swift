import SwiftUI

struct MapTabView: View {
    @EnvironmentObject private var appState: AppState
    var body: some View {
        NavigationView {
            VStack {
                MapView(topCategory: appState.topCategory)
            }
            .navigationTitle("Map")
        }
    }
}

#Preview {
    MapTabView()
} 
