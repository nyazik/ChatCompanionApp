//
//  UserViewModel.swift
//  ChatCompanion
//
//  Created by Nazik on 6.04.2024.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var currentUser: User?
    private var apiClient: APIClient
    private var cancellables = Set<AnyCancellable>()

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchCurrentUser() {
        apiClient.fetchCurrentUser { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.currentUser = user
                case .failure(let error):
                    print("Failed to fetch current user: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchUsers() {
        // Implement the network call to fetch users, update the 'users' property
        // Example:
        apiClient.fetchUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
