//
//  Message.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import Foundation

struct FileMeta: Codable {
    let name: String?
    let size: Int?
    let mime: String?
    let url: String?
}

struct Message: Codable, Identifiable {
    let id: String
    let group: String
    let sender: String
    let type: String
    let content: String
    let fileMeta: FileMeta?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case group, sender, type, content, fileMeta, createdAt
    }
}
