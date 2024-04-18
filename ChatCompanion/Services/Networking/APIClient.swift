//
//  APIClient.swift
//  ChatCompanion
//
//  Created by Nazik on 6.04.2024.
//

import Foundation

class APIClient {
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    private func performRequest<T: Decodable>(with request: URLRequest, decode: Bool = true, completion: @escaping (Result<T, Error>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])))
                    return
                }
                
                // If no decoding is needed, return success with an empty result
                if !decode, T.self == Void.self {
                    completion(.success(Void() as! T))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])))
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchMessages(completion: @escaping (Result<[Message], Error>) -> Void) {
        let request = URLRequest(url: APIEndpoints.fetchMessages)
        performRequest(with: request, completion: completion)
    }
    
    func fetchCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        let request = URLRequest(url: APIEndpoints.fetchCurrentUser)
        performRequest(with: request, completion: completion)
    }
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let request = URLRequest(url: APIEndpoints.fetchUsers)
        performRequest(with: request, completion: completion)
    }
    
    func sendMessage(_ message: Message, completion: @escaping (Result<GenericAPIResponse, Error>) -> Void) {
        var request = URLRequest(url: APIEndpoints.sendMessage)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            let messageData = try encoder.encode(message)
            request.httpBody = messageData
        } catch {
            completion(.failure(error))
            return
        }
        
        performRequest(with: request, completion: completion)
    }
    
    func login(username: String, password: String, completion: @escaping (Result<GenericAPIResponse, Error>) -> Void) {
        var request = URLRequest(url: APIEndpoints.login)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginDetails = ["username": username, "password": password]
        
        do {
            let loginData = try JSONEncoder().encode(loginDetails)
            request.httpBody = loginData
        } catch {
            completion(.failure(error))
            return
        }
        
        performRequest(with: request, completion: completion)
    }
    
    func register(username: String, email: String, password: String, completion: @escaping (Result<GenericAPIResponse, Error>) -> Void) {
        var request = URLRequest(url: APIEndpoints.register)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let registrationDetails = ["username": username, "email": email, "password": password]

        do {
            let registrationData = try JSONEncoder().encode(registrationDetails)
            request.httpBody = registrationData
        } catch {
            completion(.failure(error))
            return
        }

        performRequest(with: request, completion: completion)
    }
}


struct GenericAPIResponse: Decodable {
    let success: Bool
    let message: String?
}

