//
//  TaskService.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import Foundation

class TaskService {
    static let shared = TaskService()
    
    private init() {}
    
    // Placeholder for future task functionality
    func getTasks(projectId: String) async throws -> [TaskItem] {
        return []
    }
}
