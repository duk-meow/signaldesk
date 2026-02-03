//
//  DashboardLayoutView.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import SwiftUI

struct DashboardLayoutView: View {
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var projectStore: ProjectStore
    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var chatStore: ChatStore
    
    var body: some View {
        NavigationSplitView {
            VStack {
                // Projects sidebar
                List {
                    Section("Projects") {
                        ForEach(projectStore.projects) { project in
                            Button(action: {
                                projectStore.setActiveProject(id: project.id)
                                Task {
                                    await groupStore.fetchGroups(projectId: project.id)
                                }
                            }) {
                                HStack {
                                    Text(project.name)
                                    if projectStore.activeProjectId == project.id {
                                        Spacer()
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    }
                    
                    Section("Groups") {
                        if let projectId = projectStore.activeProjectId {
                            ForEach(groupStore.getGroupsByProject(projectId: projectId)) { group in
                                Button(action: {
                                    groupStore.setActiveGroup(id: group.id)
                                    Task {
                                        await chatStore.fetchMessages(groupId: group.id)
                                    }
                                }) {
                                    HStack {
                                        Text(group.name)
                                        if groupStore.activeGroupId == group.id {
                                            Spacer()
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                Button("Logout") {
                    authStore.logout()
                }
                .padding()
            }
            .navigationTitle("SignalDesk")
        } detail: {
            if let groupId = groupStore.activeGroupId {
                ChatView(groupId: groupId)
            } else {
                Text("Select a group")
            }
        }
        .task {
            await projectStore.fetchProjects()
            if let projectId = projectStore.activeProjectId {
                await groupStore.fetchGroups(projectId: projectId)
            }
        }
    }
}

#Preview {
    DashboardLayoutView()
        .environmentObject(AuthStore())
        .environmentObject(ProjectStore())
        .environmentObject(GroupStore())
        .environmentObject(ChatStore())
}
