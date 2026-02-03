//
//  ProjectService.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import Foundation

class ProjectService {
    static let shared = ProjectService()
    private let api = APIClient.shared
    
    private init() {}
    
    func getProjects() async throws -> [Project] {
        let response = try await api.getProjects()
        return response.projects
    }
    
    func getProject(id: String) async throws -> Project {
        let response = try await api.getProject(id: id)
        return response.project
    }
    
    func createProject(name: String, description: String?) async throws -> Project {
        let response = try await api.createProject(name: name, description: description)
        return response.project
    }
    
    func updateProject(id: String, name: String?, description: String?) async throws -> Project {
        let response = try await api.updateProject(id: id, name: name, description: description)
        return response.project
    }
    
    func deleteProject(id: String) async throws {
        _ = try await api.deleteProject(id: id)
    }
    
    func joinProject(projectId: String) async throws -> Project {
        let response = try await api.joinProject(projectId: projectId)
        return response.project
    }
    
    func getGroups(projectId: String) async throws -> [Group] {
        let response = try await api.getGroupsByProject(projectId: projectId)
        return response.groups
    }
}
