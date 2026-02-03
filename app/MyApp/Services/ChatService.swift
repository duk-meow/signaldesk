//
//  ChatService.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import Foundation

class ChatService {
    static let shared = ChatService()
    private let api = APIClient.shared
    
    private init() {}
    
    func getMessages(groupId: String, page: Int = 1, limit: Int = 50) async throws -> [Message] {
        let response = try await api.getMessages(groupId: groupId, page: page, limit: limit)
        return response.messages
    }
    
    func createGroup(projectId: String, name: String, description: String?) async throws -> Group {
        let response = try await api.createGroup(projectId: projectId, name: name, description: description)
        return response.group
    }
    
    func getGroup(groupId: String) async throws -> Group {
        let response = try await api.getGroup(groupId: groupId)
        return response.group
    }
    
    func deleteGroup(groupId: String) async throws {
        _ = try await api.deleteGroup(groupId: groupId)
    }
}
