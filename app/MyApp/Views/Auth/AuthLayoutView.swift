//
//  AuthLayoutView.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import SwiftUI

struct AuthLayoutView: View {
    @State private var showLogin = true
    
    var body: some View {
        VStack {
            Text("SignalDesk")
                .font(.largeTitle)
                .padding()
            
            if showLogin {
                LoginView()
            } else {
                SignupView()
            }
            
            Button(action: { showLogin.toggle() }) {
                Text(showLogin ? "Need an account? Sign up" : "Have an account? Log in")
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    AuthLayoutView()
        .environmentObject(AuthStore())
}
