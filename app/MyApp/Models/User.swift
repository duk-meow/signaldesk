//
//  User.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let avatar: String?
    let projects: [String]?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, email, avatar, projects, createdAt
    }
}
