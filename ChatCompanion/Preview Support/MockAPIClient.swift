//
//  MockAPIClient.swift
//  ChatCompanion
//
//  Created by Stebin Alex on 09/04/24.
//

import Foundation

class MockAPIClient: APIClient {
    
    static let sampleUsers: [User] = [
        User(id: "1", name: "Nazik", avatarURL: "https://yourapi.domain.com/images/nazik"),
        User(id: "2", name: "Stebin", avatarURL: "https://yourapi.domain.com/images/stebin"),
        User(id: "3", name: "John", avatarURL: "https://yourapi.domain.com/images/john")
    ]
    
    override func fetchUsers(completion: @escaping (Result<[User], any Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            completion(.success(MockAPIClient.sampleUsers))
        }
    }
    
    override func fetchCurrentUser(completion: @escaping (Result<User, any Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let user = MockAPIClient.sampleUsers.first {
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "", code: 0)))
            }
        }
    }
    
}
