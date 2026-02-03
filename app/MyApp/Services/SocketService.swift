//
//  SocketService.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import Foundation

class SocketService: NSObject {
    static let shared = SocketService()
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var isConnected = false
    private var messageHandlers: [String: [(Any) -> Void]] = [:]
    
    private override init() {
        super.init()
    }
    
    func connect(token: String) {
        guard !isConnected else { return }
        
        // Socket.IO URL with auth token
        var urlComponents = URLComponents(string: Config.socketURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "auth", value: token),
            URLQueryItem(name: "transport", value: "websocket")
        ]
        
        guard let url = urlComponents.url else { return }
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        isConnected = true
        
        print("Socket connecting...")
        receiveMessage()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        isConnected = false
        print("Socket disconnected")
    }
    
    func emit(event: String, data: [String: Any]) {
        guard isConnected else { return }
        
        let message: [String: Any] = [
            "event": event,
            "data": data
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: message),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            let message = URLSessionWebSocketTask.Message.string(jsonString)
            webSocketTask?.send(message) { error in
                if let error = error {
                    print("Socket send error: \(error)")
                }
            }
        }
    }
    
    func on(event: String, handler: @escaping (Any) -> Void) {
        if messageHandlers[event] == nil {
            messageHandlers[event] = []
        }
        messageHandlers[event]?.append(handler)
    }
    
    func off(event: String) {
        messageHandlers[event] = nil
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.handleMessage(text)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self?.handleMessage(text)
                    }
                @unknown default:
                    break
                }
                self?.receiveMessage()
                
            case .failure(let error):
                print("Socket receive error: \(error)")
                self?.isConnected = false
            }
        }
    }
    
    private func handleMessage(_ text: String) {
        guard let data = text.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let event = json["event"] as? String,
              let eventData = json["data"] else {
            return
        }
        
        messageHandlers[event]?.forEach { handler in
            handler(eventData)
        }
    }
    
    // Convenience methods
    func joinGroup(groupId: String) {
        emit(event: "join-group", data: ["groupId": groupId])
    }
    
    func leaveGroup(groupId: String) {
        emit(event: "leave-group", data: ["groupId": groupId])
    }
    
    func sendMessage(groupId: String, content: String, type: String = "text") {
        emit(event: "send-message", data: [
            "groupId": groupId,
            "content": content,
            "type": type
        ])
    }
    
    func sendTyping(groupId: String, isTyping: Bool) {
        emit(event: "typing", data: [
            "groupId": groupId,
            "isTyping": isTyping
        ])
    }
}

extension SocketService: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Socket connected")
        isConnected = true
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Socket closed")
        isConnected = false
    }
}
