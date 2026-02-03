//
//  ProjectStore.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import Foundation
import SwiftUI

@MainActor
class ProjectStore: ObservableObject {
    @Published var projects: [Project] = []
    @Published var activeProjectId: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let projectService = ProjectService.shared
    
    var activeProject: Project? {
        projects.first { $0.id == activeProjectId }
    }
    
    func fetchProjects() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            projects = try await projectService.getProjects()
            if activeProjectId == nil, let first = projects.first {
                activeProjectId = first.id
            }
        } catch {
            errorMessage = "Failed to fetch projects: \(error.localizedDescription)"
        }
    }
    
    func createProject(name: String, description: String?) async {
        do {
            let project = try await projectService.createProject(name: name, description: description)
            projects.append(project)
            activeProjectId = project.id
        } catch {
            errorMessage = "Failed to create project: \(error.localizedDescription)"
        }
    }
    
    func updateProject(id: String, name: String?, description: String?) async {
        do {
            let updated = try await projectService.updateProject(id: id, name: name, description: description)
            if let index = projects.firstIndex(where: { $0.id == id }) {
                projects[index] = updated
            }
        } catch {
            errorMessage = "Failed to update project: \(error.localizedDescription)"
        }
    }
    
    func deleteProject(id: String) async {
        do {
            try await projectService.deleteProject(id: id)
            projects.removeAll { $0.id == id }
            if activeProjectId == id {
                activeProjectId = projects.first?.id
            }
        } catch {
            errorMessage = "Failed to delete project: \(error.localizedDescription)"
        }
    }
    
    func joinProject(projectId: String) async {
        do {
            let project = try await projectService.joinProject(projectId: projectId)
            projects.append(project)
            activeProjectId = project.id
        } catch {
            errorMessage = "Failed to join project: \(error.localizedDescription)"
        }
    }
    
    func setActiveProject(id: String) {
        activeProjectId = id
    }
}
