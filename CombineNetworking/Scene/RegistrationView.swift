//
//  RegistrationView.swift
//  CombineNetworking
//
//  Created by Essam Fahmi on 18/01/2024.
//

import Foundation
import SwiftUI
import NetworkingKit

struct RegistrationView: View {
    // MARK: - Private Properties

    @StateObject private var viewModel = RegistrationViewModel(onboardingService: OnboardingServiceProvider())

    // MARK: - Body

    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Name", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Register") {
                viewModel.register()
            }
            .padding()
            
            if let result = viewModel.registrationResult {
                switch result {
                case .success(let username):
                    Text("Registration successful. User: \(username)")
                case .failure(let message):
                    Text("Registration failed. Error: \(message)")
                }
            }
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    RegistrationView()
}
