//
//  DashboardView.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var projectStore: ProjectStore
    
    var body: some View {
        VStack {
            Text("Dashboard")
                .font(.largeTitle)
            
            if let project = projectStore.activeProject {
                Text("Active Project: \(project.name)")
                    .font(.headline)
                    .padding()
            }
            
            Text("Welcome to SignalDesk")
                .padding()
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(ProjectStore())
}
