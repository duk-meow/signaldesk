//
//  ChatView.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import SwiftUI

struct ChatView: View {
    let groupId: String
    @EnvironmentObject var chatStore: ChatStore
    @EnvironmentObject var groupStore: GroupStore
    @State private var messageText = ""
    
    var messages: [Message] {
        chatStore.getMessages(for: groupId)
    }
    
    var body: some View {
        VStack {
            // Messages list
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            
            // Input area
            HStack {
                TextField("Type a message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: messageText) { oldValue, newValue in
                        chatStore.sendTyping(groupId: groupId, isTyping: !newValue.isEmpty)
                    }
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                }
                .disabled(messageText.isEmpty)
            }
            .padding()
        }
        .navigationTitle(groupStore.activeGroup?.name ?? "Chat")
        .task {
            await chatStore.fetchMessages(groupId: groupId)
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        chatStore.sendMessage(groupId: groupId, content: messageText)
        messageText = ""
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(message.sender)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(message.content)
                .padding(10)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            
            Text(formatDate(message.createdAt))
                .font(.caption2)
                .foregroundColor(.gray)
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.timeStyle = .short
            displayFormatter.dateStyle = .short
            return displayFormatter.string(from: date)
        }
        return dateString
    }
}

#Preview {
    ChatView(groupId: "test")
        .environmentObject(ChatStore())
        .environmentObject(GroupStore())
}
