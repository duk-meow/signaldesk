//
//  AuthService.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import Foundation

class AuthService {
    static let shared = AuthService()
    private let api = APIClient.shared
    
    private init() {}
    
    func login(email: String, password: String) async throws -> (User, String) {
        let response = try await api.login(email: email, password: password)
        api.token = response.token
        return (response.user, response.token)
    }
    
    func signup(name: String, email: String, password: String) async throws -> (User, String) {
        let response = try await api.signup(name: name, email: email, password: password)
        api.token = response.token
        return (response.user, response.token)
    }
    
    func verifyToken() async throws -> User {
        let response = try await api.verifyToken()
        return response.user
    }
    
    func logout() {
        api.token = nil
    }
}
