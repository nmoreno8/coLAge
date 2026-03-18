import SwiftUI
import FirebaseFirestore

struct ChatTabView: View {
    private let categories = ["Sports", "Nightlife", "Creativity"]
    @State private var chatInfo: [String: ChatInfo] = [:]
    @State private var isLoading = true
    @State private var showError = false
    @State private var errorMessage = ""
    
    struct ChatInfo {
        let lastMessage: String
        let lastMessageTime: Date
        let messageCount: Int
    }
    
    var body: some View {
        NavigationView {
            List(categories, id: \.self) { category in
                NavigationLink(destination: ChattingView(category: category)) {
                    HStack {
                        Image(systemName: getIcon(for: category))
                            .font(.title2)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(category)
                                .font(.headline)
                            
                            if let info = chatInfo[category] {
                                Text(info.lastMessage)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                                
                                Text(info.lastMessageTime, style: .time)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            } else {
                                Text("No messages yet")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Chat Categories")
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .task {
                await loadChatInfo()
            }
            .refreshable {
                await loadChatInfo()
            }
        }
    }
    
    private func getIcon(for category: String) -> String {
        switch category {
        case "Sports":
            return "figure.run"
        case "Nightlife":
            return "moon.stars.fill"
        case "Creativity":
            return "paintbrush.fill"
        default:
            return "message.fill"
        }
    }
    
    private func loadChatInfo() async {
        isLoading = true
        for category in categories {
            do {
                if let chatDoc = try await FirebaseManager.shared.getChatInfo(for: category) {
                    let data = chatDoc.data() ?? [:]
                    let lastMessage = data["lastMessage"] as? String ?? ""
                    let lastMessageTime = (data["lastMessageTime"] as? Timestamp)?.dateValue() ?? Date()
                    
                    // Get message count
                    let messages = try await FirebaseManager.shared.getMessages(from: chatDoc.documentID)
                    
                    chatInfo[category] = ChatInfo(
                        lastMessage: lastMessage,
                        lastMessageTime: lastMessageTime,
                        messageCount: messages.count
                    )
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
        isLoading = false
    }
}

#Preview {
    ChatTabView()
} 