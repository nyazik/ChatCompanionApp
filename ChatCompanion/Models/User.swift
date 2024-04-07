//
//  User.swift
//  ChatCompanion
//
//  Created by Nazik on 6.04.2024.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let avatarURL: String
    
    // Implement the equatable method to compare User instances
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.avatarURL == rhs.avatarURL
    }
}
