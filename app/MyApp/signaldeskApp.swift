//
//  signaldeskApp.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import SwiftUI

@main
struct signaldeskApp: App {
    @StateObject private var authStore = AuthStore()
    @StateObject private var projectStore = ProjectStore()
    @StateObject private var groupStore = GroupStore()
    @StateObject private var chatStore = ChatStore()
    @StateObject private var uiStore = UIStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authStore)
                .environmentObject(projectStore)
                .environmentObject(groupStore)
                .environmentObject(chatStore)
                .environmentObject(uiStore)
        }
    }
}
