//
//  LoginViewModel.swift
//  ChatCompanion
//
//  Created by Nazik on 7.04.2024.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var loginError: String? = nil
    private var apiClient: APIClient
    private var cancellables = Set<AnyCancellable>()
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }
    
    func login() {
        apiClient.login(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isAuthenticated = true
                    self?.loginError = nil
                case .failure(let error):
                    self?.isAuthenticated = false
                    self?.loginError = "Login failed: \(error.localizedDescription)"
                }
            }
        }
    }
}
