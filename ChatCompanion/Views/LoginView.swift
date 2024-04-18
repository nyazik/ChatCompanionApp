//
//  LoginView.swift
//  ChatCompanion
//
//  Created by Nazik on 7.04.2024.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var viewModel: LoginViewModel
    @State private var isLoading = false
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .disableAutocorrection(true)

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .disableAutocorrection(true)

            if isLoading {
                ProgressView()
                    .padding()
            } else {
                Button(action: {
                    isLoading = true
                    viewModel.login()
                }) {
                    Text("Log In")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(!viewModel.isFormValid)
                .padding()
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login Error"), message: Text(viewModel.loginError ?? "Unknown error"), dismissButton: .default(Text("OK")))
        }
        .onChange(of: viewModel.isAuthenticated) { newValue in
            userViewModel.isAuthenticated = newValue
            isLoading = false
        }
        .onChange(of: viewModel.loginError) { _ in
            isLoading = false
            showAlert = viewModel.loginError != nil
        }
    }
}

// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: MockLoginViewModel())
            .environmentObject(UserViewModel(apiClient: MockAPIClient()))
    }
}
