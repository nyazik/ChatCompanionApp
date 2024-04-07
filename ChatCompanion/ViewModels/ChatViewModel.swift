//
//  ChatViewModel.swift
//  ChatCompanion
//
//  Created by Nazik on 6.04.2024.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    private var apiClient: APIClient
    @Published var currentUser: User?
    private var cancellables = Set<AnyCancellable>()
    @Published var newMessageText: String = ""
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchMessages() {
        apiClient.fetchMessages { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let messages):
                    self?.messages = messages
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func sendMessage() {
        let newMessage = Message(id: UUID().uuidString, text: newMessageText, userId: currentUser?.id ?? "unknown", timestamp: Date())
        
        apiClient.sendMessage(newMessage) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let genericResponse):
                    // Check the success field in the GenericAPIResponse
                    if genericResponse.success {
                        self?.messages.append(newMessage)
                        self?.newMessageText = ""
                    } else {
                        // If success is false, handle accordingly, e.g., show an alert to the user
                        // You can use the message from the GenericAPIResponse for more information
                    }
                case .failure(let error):
                    // Handle the error, e.g., show an alert to the user
                    print(error.localizedDescription)
                }
            }
        }
    }
}
