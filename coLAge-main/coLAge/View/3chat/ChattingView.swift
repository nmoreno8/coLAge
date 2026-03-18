import SwiftUI
import FirebaseFirestore

struct ChattingView: View {
    let category: String
    @State private var messages: [Message] = []
    @State private var newMessage: String = ""
    @State private var chatId: String?
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var lastMessageTime: Date?
    
    var body: some View {
        VStack {
            // Messages List
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            
            // Message Input
            HStack {
                TextField("Type a message...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                        .padding(.trailing)
                }
                .disabled(newMessage.isEmpty || isLoading)
            }
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
        }
        .navigationTitle(category)
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .task {
            chatId = categoryChatIds[category]
            await loadChat()
        }
        .onAppear {
            chatId = categoryChatIds[category]
            setupMessageListener()
        }
    }
    
    private func loadChat() async {
        isLoading = true
        do {
            chatId = try await FirebaseManager.shared.getOrCreateChat(for: category)
            await loadMessages()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        isLoading = false
    }
    
    private func setupMessageListener() {
        guard let chatId = chatId else { return }
        let db = Firestore.firestore()
        
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    errorMessage = error.localizedDescription
                    showError = true
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                messages = documents.compactMap { doc in
                    let data = doc.data()
                    return Message(
                        id: doc.documentID,
                        text: data["text"] as? String ?? "",
                        userId: data["uid"] as? String ?? "",
                        userEmail: data["userEmail"] as? String ?? "",
                        timestamp: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                    )
                }
                .sorted { $0.timestamp < $1.timestamp }
            }
    }
    
    private func loadMessages() async {
        guard let chatId = chatId else { return }
        do {
            let messageDocs = try await FirebaseManager.shared.getMessages(from: chatId)
            messages = messageDocs.compactMap { doc in
                let data = doc.data()
                return Message(
                    id: doc.documentID,
                    text: data["text"] as? String ?? "",
                    userId: data["uid"] as? String ?? "",
                    userEmail: data["userEmail"] as? String ?? "",
                    timestamp: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                )
            }
            .sorted { $0.timestamp < $1.timestamp }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    private func sendMessage() {
        guard let chatId = chatId, !newMessage.isEmpty else { return }
        Task {
            do {
                try await FirebaseManager.shared.sendMessage(to: chatId, text: newMessage)
                newMessage = ""
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}

struct Message: Identifiable {
    let id: String
    let text: String
    let userId: String
    let userEmail: String
    let timestamp: Date
}

struct MessageBubble: View {
    let message: Message
    @EnvironmentObject private var appState: AppState
    
    var isCurrentUser: Bool {
        message.userId == appState.uid
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if !isCurrentUser {
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.userEmail)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(message.text)
                        .padding(12)
                        .background(Color(.systemGray5))
                        .foregroundColor(.primary)
                        .cornerRadius(15)
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                Spacer()
            } else {
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("You")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(message.text)
                        .padding(12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    NavigationView {
        ChattingView(category: "Sports")
            .environmentObject(AppState())
    }
} 
