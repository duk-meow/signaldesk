//
//  InviteView.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import SwiftUI

struct InviteView: View {
    let projectId: String
    
    var body: some View {
        VStack {
            Text("Invite to Project")
                .font(.largeTitle)
            
            Text("Project ID: \(projectId)")
                .font(.headline)
                .padding()
            
            Text("Share this project ID with others to invite them")
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    InviteView(projectId: "test123")
}
