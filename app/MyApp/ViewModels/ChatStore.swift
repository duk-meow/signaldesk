//
//  ChatStore.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import Foundation
import SwiftUI

@MainActor
class ChatStore: ObservableObject {
    @Published var messages: [String: [Message]] = [:]
    @Published var typingUsers: [String: [String]] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let chatService = ChatService.shared
    private let socketService = SocketService.shared
    
    init() {
        setupSocketListeners()
    }
    
    func fetchMessages(groupId: String, page: Int = 1) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let fetchedMessages = try await chatService.getMessages(groupId: groupId, page: page, limit: 50)
            if page == 1 {
                messages[groupId] = fetchedMessages.reversed()
            } else {
                messages[groupId] = fetchedMessages.reversed() + (messages[groupId] ?? [])
            }
        } catch {
            errorMessage = "Failed to fetch messages: \(error.localizedDescription)"
        }
    }
    
    func sendMessage(groupId: String, content: String, type: String = "text") {
        socketService.sendMessage(groupId: groupId, content: content, type: type)
    }
    
    func sendTyping(groupId: String, isTyping: Bool) {
        socketService.sendTyping(groupId: groupId, isTyping: isTyping)
    }
    
    private func setupSocketListeners() {
        socketService.on(event: "new-message") { [weak self] data in
            guard let self = self,
                  let messageData = data as? [String: Any],
                  let jsonData = try? JSONSerialization.data(withJSONObject: messageData),
                  let message = try? JSONDecoder().decode(Message.self, from: jsonData) else {
                return
            }
            
            Task { @MainActor in
                if self.messages[message.group] == nil {
                    self.messages[message.group] = []
                }
                self.messages[message.group]?.append(message)
            }
        }
        
        socketService.on(event: "typing") { [weak self] data in
            guard let self = self,
                  let typingData = data as? [String: Any],
                  let groupId = typingData["groupId"] as? String,
                  let userId = typingData["userId"] as? String,
                  let isTyping = typingData["isTyping"] as? Bool else {
                return
            }
            
            Task { @MainActor in
                if self.typingUsers[groupId] == nil {
                    self.typingUsers[groupId] = []
                }
                
                if isTyping {
                    if !self.typingUsers[groupId]!.contains(userId) {
                        self.typingUsers[groupId]?.append(userId)
                    }
                } else {
                    self.typingUsers[groupId]?.removeAll { $0 == userId }
                }
            }
        }
    }
    
    func getMessages(for groupId: String) -> [Message] {
        return messages[groupId] ?? []
    }
    
    func clearMessages(for groupId: String) {
        messages[groupId] = nil
    }
}
