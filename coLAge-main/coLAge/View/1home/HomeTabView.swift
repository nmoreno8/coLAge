import SwiftUI
import FirebaseAuth

struct HomeTabView: View {
    @EnvironmentObject private var appState: AppState
    @State private var showSignOutAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {                
                NavigationLink(destination: QuizView()) {
                    HStack {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.title2)
                        Text("Start Quiz")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSignOutAlert = true
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
            }
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    signOut()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
        .environmentObject(appState)
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            appState.isAuthCompleted = false
            appState.uid = ""
            appState.email = ""
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

#Preview {
    HomeTabView()
} 
