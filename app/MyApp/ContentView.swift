//
//  ContentView.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authStore: AuthStore
    
    var body: some View {
        Group {
            if authStore.isLoading {
                ProgressView("Loading...")
            } else if authStore.isAuthenticated {
                DashboardLayoutView()
            } else {
                AuthLayoutView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthStore())
}
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
