//
//  SignupView.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var authStore: AuthStore
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 15) {
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if let error = authStore.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: {
                Task {
                    await authStore.signup(name: name, email: email, password: password)
                }
            }) {
                if authStore.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(authStore.isLoading || name.isEmpty || email.isEmpty || password.isEmpty)
        }
        .padding()
    }
}

#Preview {
    SignupView()
        .environmentObject(AuthStore())
}
