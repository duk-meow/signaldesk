//
//  GroupStore.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import Foundation
import SwiftUI

@MainActor
class GroupStore: ObservableObject {
    @Published var groups: [Group] = []
    @Published var activeGroupId: String?
    @Published var onlineUsers: [String] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let chatService = ChatService.shared
    private let projectService = ProjectService.shared
    private let socketService = SocketService.shared
    
    var activeGroup: Group? {
        groups.first { $0.id == activeGroupId }
    }
    
    func fetchGroups(projectId: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let fetchedGroups = try await projectService.getGroups(projectId: projectId)
            groups = fetchedGroups
            
            if activeGroupId == nil, let first = fetchedGroups.first {
                setActiveGroup(id: first.id)
            }
        } catch {
            errorMessage = "Failed to fetch groups: \(error.localizedDescription)"
        }
    }
    
    func createGroup(projectId: String, name: String, description: String?) async {
        do {
            let group = try await chatService.createGroup(projectId: projectId, name: name, description: description)
            groups.append(group)
        } catch {
            errorMessage = "Failed to create group: \(error.localizedDescription)"
        }
    }
    
    func deleteGroup(groupId: String) async {
        do {
            try await chatService.deleteGroup(groupId: groupId)
            groups.removeAll { $0.id == groupId }
            if activeGroupId == groupId {
                activeGroupId = groups.first?.id
            }
        } catch {
            errorMessage = "Failed to delete group: \(error.localizedDescription)"
        }
    }
    
    func setActiveGroup(id: String) {
        if let previousGroupId = activeGroupId {
            socketService.leaveGroup(groupId: previousGroupId)
        }
        activeGroupId = id
        socketService.joinGroup(groupId: id)
    }
    
    func getGroupsByProject(projectId: String) -> [Group] {
        return groups.filter { $0.project == projectId }
    }
}
