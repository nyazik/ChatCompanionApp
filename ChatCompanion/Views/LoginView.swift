//
//  LoginView.swift
//  ChatCompanion
//
//  Created by Nazik on 7.04.2024.
//

import SwiftUI
import FirebaseAnalytics

struct LoginView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack {
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                viewModel.login()
            }) {
                Text("Log In")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
        }
        .padding()
        .analyticsScreen(name: "\(LoginView.self)")
        
        .onChange(of: viewModel.isAuthenticated, { oldValue, newValue in
            userViewModel.isAuthenticated = newValue
        })
    
        
    }
}

#Preview {
    LoginView(viewModel: MockLoginViewModel())
        .environmentObject(UserViewModel(apiClient: MockAPIClient()))
}
