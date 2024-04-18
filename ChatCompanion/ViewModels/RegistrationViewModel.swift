//
//  RegistrationViewModel.swift
//  ChatCompanion
//
//  Created by Nazik on 12.04.2024.
//

import Foundation
import Combine

class RegistrationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    @Published var isRegistered: Bool = false
    @Published var registrationError: String? = nil
    
    private var apiClient: APIClient
    private var cancellables = Set<AnyCancellable>()
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }
    func register() {
        guard validateCredentials() else {
            return
        }
        
        apiClient.register(username: username, email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isRegistered = true
                    self?.registrationError = nil
                case .failure(let error):
                    self?.isRegistered = false
                    self?.registrationError = "Registration failed: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func validateCredentials() -> Bool {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty, password == passwordConfirmation else {
            registrationError = "Please check your input fields."
            return false
        }
        
        if !email.contains("@") {
            registrationError = "Invalid email format."
            return false
        }
        
        if password.count < 8 {
            registrationError = "Password must be at least 8 characters long."
            return false
        }
        
        return true
    }
}
