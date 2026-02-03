//
//  Group.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import Foundation

struct Group: Codable, Identifiable {
    let id: String
    let name: String
    let project: String
    let description: String?
    let isDefault: Bool?
    let isPrivate: Bool?
    let type: String?
    let members: [String]
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, project, description, isDefault, isPrivate, type, members, createdAt
    }
}
