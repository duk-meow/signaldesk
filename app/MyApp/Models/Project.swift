//
//  Project.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import Foundation

struct Project: Codable, Identifiable {
    let id: String
    let projectId: String
    let name: String
    let description: String?
    let owner: String?
    let members: [String]
    let accentColor: String?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case projectId, name, description, owner, members, accentColor, createdAt
    }
}
