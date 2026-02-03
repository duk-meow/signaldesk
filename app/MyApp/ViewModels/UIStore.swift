//
//  UIStore.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import Foundation
import SwiftUI

@MainActor
class UIStore: ObservableObject {
    @Published var showCreateProject = false
    @Published var showCreateGroup = false
    @Published var showCreateDM = false
    @Published var showInviteMember = false
    @Published var showChannelSettings = false
    @Published var showEditProject = false
    @Published var selectedProjectForEdit: Project?
    @Published var selectedGroupForSettings: Group?
}
