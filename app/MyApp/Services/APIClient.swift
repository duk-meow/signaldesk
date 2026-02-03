//
//  APIClient.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import Foundation

class APIClient {
    static let shared = APIClient()
    
    private init() {}
    
    var token: String? {
        get { UserDefaults.standard.string(forKey: "token") }
        set { 
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: "token")
            } else {
                UserDefaults.standard.removeObject(forKey: "token")
            }
        }
    }
    
    private func request<T: Codable>(
        endpoint: String,
        method: String = "GET",
        body: Codable? = nil
    ) async throws -> T {
        guard let url = URL(string: "\(Config.apiURL)/api\(endpoint)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode == 401 {
            token = nil
            throw URLError(.userAuthenticationRequired)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // MARK: - Auth
    struct LoginRequest: Codable {
        let email: String
        let password: String
    }
    
    struct SignupRequest: Codable {
        let name: String
        let email: String
        let password: String
    }
    
    struct AuthResponse: Codable {
        let token: String
        let user: User
    }
    
    func login(email: String, password: String) async throws -> AuthResponse {
        return try await request(
            endpoint: "/auth/login",
            method: "POST",
            body: LoginRequest(email: email, password: password)
        )
    }
    
    func signup(name: String, email: String, password: String) async throws -> AuthResponse {
        return try await request(
            endpoint: "/auth/signup",
            method: "POST",
            body: SignupRequest(name: name, email: email, password: password)
        )
    }
    
    struct VerifyResponse: Codable {
        let user: User
    }
    
    func verifyToken() async throws -> VerifyResponse {
        return try await request(endpoint: "/auth/verify")
    }
    
    // MARK: - Projects
    struct ProjectsResponse: Codable {
        let projects: [Project]
    }
    
    struct ProjectResponse: Codable {
        let project: Project
    }
    
    struct CreateProjectRequest: Codable {
        let name: String
        let description: String?
    }
    
    struct JoinProjectRequest: Codable {
        let projectId: String
    }
    
    func getProjects() async throws -> ProjectsResponse {
        return try await request(endpoint: "/projects")
    }
    
    func getProject(id: String) async throws -> ProjectResponse {
        return try await request(endpoint: "/projects/\(id)")
    }
    
    func createProject(name: String, description: String?) async throws -> ProjectResponse {
        return try await request(
            endpoint: "/projects",
            method: "POST",
            body: CreateProjectRequest(name: name, description: description)
        )
    }
    
    func updateProject(id: String, name: String?, description: String?) async throws -> ProjectResponse {
        var updates: [String: String] = [:]
        if let name = name { updates["name"] = name }
        if let description = description { updates["description"] = description }
        
        return try await request(
            endpoint: "/projects/\(id)",
            method: "PUT",
            body: updates
        )
    }
    
    func deleteProject(id: String) async throws -> ProjectResponse {
        return try await request(endpoint: "/projects/\(id)", method: "DELETE")
    }
    
    func joinProject(projectId: String) async throws -> ProjectResponse {
        return try await request(
            endpoint: "/projects/join",
            method: "POST",
            body: JoinProjectRequest(projectId: projectId)
        )
    }
    
    // MARK: - Groups
    struct GroupsResponse: Codable {
        let groups: [Group]
    }
    
    struct GroupResponse: Codable {
        let group: Group
    }
    
    struct CreateGroupRequest: Codable {
        let name: String
        let description: String?
    }
    
    func getGroupsByProject(projectId: String) async throws -> GroupsResponse {
        return try await request(endpoint: "/projects/\(projectId)/groups")
    }
    
    func getGroup(groupId: String) async throws -> GroupResponse {
        return try await request(endpoint: "/groups/\(groupId)")
    }
    
    func createGroup(projectId: String, name: String, description: String?) async throws -> GroupResponse {
        return try await request(
            endpoint: "/projects/\(projectId)/groups",
            method: "POST",
            body: CreateGroupRequest(name: name, description: description)
        )
    }
    
    func updateGroup(groupId: String, updates: [String: Any]) async throws -> GroupResponse {
        // Note: For simplicity, you may need to create a specific struct for updates
        return try await request(endpoint: "/groups/\(groupId)", method: "PUT")
    }
    
    func deleteGroup(groupId: String) async throws -> GroupResponse {
        return try await request(endpoint: "/groups/\(groupId)", method: "DELETE")
    }
    
    // MARK: - Messages
    struct MessagesResponse: Codable {
        let messages: [Message]
    }
    
    func getMessages(groupId: String, page: Int = 1, limit: Int = 50) async throws -> MessagesResponse {
        return try await request(endpoint: "/groups/\(groupId)/messages?page=\(page)&limit=\(limit)")
    }
}
