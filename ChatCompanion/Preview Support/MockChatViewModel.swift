//
//  MockChatViewModel.swift
//  ChatCompanion
//
//  Created by Stebin Alex on 09/04/24.
//

import Foundation

class MockChatViewModel: ChatViewModel {
     
    init() {
        super.init(apiClient: MockAPIClient(), currentUser: MockAPIClient.sampleUsers.first!)
    }
    
    override func fetchMessages() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            if let currentUser = self?.currentUser {
                self?.messages = [
                    Message(id: "1", text: "Hello", userId: currentUser.id, timestamp: Date()),
                    Message(id: "2", text: "Hi", userId: MockAPIClient.sampleUsers[1].id, timestamp: Date()),
                    Message(id: "3", text: "Hello guys", userId: MockAPIClient.sampleUsers[2].id, timestamp: Date()),
                ]
            }
        }
    }
    
    override func sendMessage() {
        let newMessage = Message(id: UUID().uuidString, text: newMessageText, userId: currentUser.id, timestamp: Date())
        messages.append(newMessage)
        newMessageText = ""
    }
    
}
