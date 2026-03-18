import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class FirebaseManager {
    static let shared = FirebaseManager()
    
    private init() {}
    
    func signIn(email: String, password: String) async throws -> User {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return result.user
        } catch {
            throw error
        }
    }
    
    func createUser(email: String, password: String) async throws -> User {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            return result.user
        } catch {
            throw error
        }
    }
    
    // Helper function to check if user is already signed in
    func isUserSignedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    // Sign out function
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // Get or create chat for a category
    func getOrCreateChat(for category: String) async throws -> String {
        guard let chatId = categoryChatIds[category] else {
            throw NSError(domain: "FirebaseManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid category"])
        }
        
        let db = Firestore.firestore()
        let chatRef = db.collection("chats").document(chatId)
        
        // Check if chat exists
        let snapshot = try await chatRef.getDocument()
        if !snapshot.exists {
            // Create the chat if it doesn't exist
            let chatData: [String: Any] = [
                "category": category,
                "createdAt": FieldValue.serverTimestamp(),
                "lastMessage": "",
                "lastMessageTime": FieldValue.serverTimestamp(),
                "type": "group"
            ]
            try await chatRef.setData(chatData)
        }
        
        return chatId
    }
    
    // Send a message to a chat
    func sendMessage(to chatId: String, text: String) async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw NSError(domain: "FirebaseManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let db = Firestore.firestore()
        let messageRef = db.collection("chats")
            .document(chatId)
            .collection("messages")
            .document()
        
        let messageData: [String: Any] = [
            "uid": currentUser.uid,
            "text": text,
            "createdAt": FieldValue.serverTimestamp(),
            "userEmail": currentUser.email ?? ""
        ]
        
        try await messageRef.setData(messageData)
        
        // Update chat's last message
        try await db.collection("chats")
            .document(chatId)
            .updateData([
                "lastMessage": text,
                "lastMessageTime": FieldValue.serverTimestamp()
            ])
    }
    
    // Get messages from a chat
    func getMessages(from chatId: String) async throws -> [QueryDocumentSnapshot] {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "createdAt", descending: false)
            .getDocuments()
        
        return snapshot.documents
    }
    
    // Get chat info
    func getChatInfo(for category: String) async throws -> DocumentSnapshot? {
        guard let chatId = categoryChatIds[category] else { return nil }
        let db = Firestore.firestore()
        return try await db.collection("chats").document(chatId).getDocument()
    }
}
