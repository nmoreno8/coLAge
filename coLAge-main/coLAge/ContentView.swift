//
//  ContentView.swift
//  coLAge
//
//  Created by Developer on 5/5/25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject private var appState: AppState
    @State private var email: String = "" // test1@colage.com
    @State private var password: String = "" // 1234567890
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isAuthenticated = false
    @State private var isRegistering = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Email Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Email:")
                    .font(.headline)
                TextField("Enter your email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
            }
            
            // Password Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Password:")
                    .font(.headline)
                SecureField("Enter your password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Action Button
            Button(action: {
                Task {
                    if isRegistering {
                        await handleRegistration()
                    } else {
                        await handleLogin()
                    }
                }
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(isRegistering ? "Register" : "Login")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .disabled(isLoading)
            
            // Toggle Button
            Button(action: {
                isRegistering.toggle()
            }) {
                Text(isRegistering ? "Already have an account? Login" : "Need an account? Register")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .alert("Status", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            isAuthenticated = FirebaseManager.shared.isUserSignedIn()
        }
    }
    
    private func handleLogin() async {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Please enter both email and password"
            showAlert = true
            return
        }
        
        isLoading = true
        
        do {
            let user = try await FirebaseManager.shared.signIn(email: email, password: password)
            // Store user information
            UserDefaults.standard.set(user.uid, forKey: "userUID")
            UserDefaults.standard.set(user.email, forKey: "userEmail")
            
            // Update app state
            appState.uid = user.uid
            appState.email = email
            appState.isAuthCompleted = true
            
            alertMessage = "Welcome back, \(user.email ?? "user")!"
            showAlert = true
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
        
        isLoading = false
    }
    
    private func handleRegistration() async {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Please enter both email and password"
            showAlert = true
            return
        }
        
        guard password.count >= 6 else {
            alertMessage = "Password must be at least 6 characters long"
            showAlert = true
            return
        }
        
        isLoading = true
        
        do {
            let user = try await FirebaseManager.shared.createUser(email: email, password: password)
            // Store user information
            UserDefaults.standard.set(user.uid, forKey: "userUID")
            UserDefaults.standard.set(user.email, forKey: "userEmail")
            
            // Update app state
            appState.uid = user.uid
            appState.email = email
            appState.isAuthCompleted = true
            
            alertMessage = "Account created successfully! Welcome, \(user.email ?? "user")!"
            showAlert = true
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
        
        isLoading = false
    }
}

#Preview {
    ContentView().environmentObject(AppState())
}
