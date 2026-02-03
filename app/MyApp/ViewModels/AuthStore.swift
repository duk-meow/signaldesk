//
//  AuthStore.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import Foundation
import SwiftUI

@MainActor
class AuthStore: ObservableObject {
    @Published var user: User?
    @Published var token: String?
    @Published var isAuthenticated = false
    @Published var isLoading = true
    @Published var errorMessage: String?
    
    private let authService = AuthService.shared
    private let socketService = SocketService.shared
    
    init() {
        checkAuth()
    }
    
    func checkAuth() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            guard let savedToken = APIClient.shared.token else {
                isAuthenticated = false
                return
            }
            
            do {
                let user = try await authService.verifyToken()
                self.user = user
                self.token = savedToken
                self.isAuthenticated = true
                socketService.connect(token: savedToken)
            } catch {
                APIClient.shared.token = nil
                isAuthenticated = false
            }
        }
    }
    
    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let (user, token) = try await authService.login(email: email, password: password)
            self.user = user
            self.token = token
            self.isAuthenticated = true
            socketService.connect(token: token)
        } catch {
            errorMessage = "Login failed: \(error.localizedDescription)"
        }
    }
    
    func signup(name: String, email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let (user, token) = try await authService.signup(name: name, email: email, password: password)
            self.user = user
            self.token = token
            self.isAuthenticated = true
            socketService.connect(token: token)
        } catch {
            errorMessage = "Signup failed: \(error.localizedDescription)"
        }
    }
    
    func logout() {
        authService.logout()
        socketService.disconnect()
        user = nil
        token = nil
        isAuthenticated = false
    }
}
