//
//  APIEndpoints.swift
//  ChatCompanion
//
//  Created by Nazik on 6.04.2024.
//

import Foundation

struct APIEndpoints {
    static let baseURL = "https://yourapi.domain.com/"
    
    static var fetchMessages: URL {
        return URL(string: "\(baseURL)messages")!
    }
    static var fetchCurrentUser: URL {
        return URL(string: "\(baseURL)user/current")!
    }
    
    static var sendMessage: URL {
        return URL(string: "\(baseURL)send/message")!
    }
    
    static var fetchUsers: URL {
        return URL(string: "\(baseURL)api/users")!
    }
    
    static var login: URL {
        return URL(string: "\(baseURL)login")!
    }
    
    static var register: URL {
        return URL(string: "\(baseURL)register")!
    }
}
