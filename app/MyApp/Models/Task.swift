//
//  Task.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import Foundation

struct TaskItem: Codable, Identifiable {
    let id: String
    let title: String
    let description: String?
    let project: String
    let assignedTo: String?
    let status: String
    let priority: String?
    let dueDate: String?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, description, project, assignedTo, status, priority, dueDate, createdAt
    }
}
