//
//  MessageBubble.swift
//  ChatCompanion
//
//  Created by Nazik on 6.04.2024.
//

import SwiftUI

struct MessageBubble: View {
    let message: Message
    let isCurrentUser: Bool
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if isCurrentUser {
                Spacer()
            }
            Text(message.text)
                .padding()
                .background(isCurrentUser ? Color.blue : Color.gray)
                .cornerRadius(15)
                .foregroundColor(.white)
            if !isCurrentUser {
                Spacer()
            }
        }
        .transition(.scale)
    }
}


#Preview {
    VStack {
        MessageBubble(message: Message(id: "12", text: "Hi", userId: "122", timestamp: .now), isCurrentUser: false)
        
        MessageBubble(message: Message(id: "12", text: "Hello", userId: "122", timestamp: .now), isCurrentUser: true)
        
        MessageBubble(message: Message(id: "12", text: "How are you ?", userId: "122", timestamp: .now), isCurrentUser: false)
        
        MessageBubble(message: Message(id: "12", text: "I am good, what about you?", userId: "122", timestamp: .now), isCurrentUser: true)
    }
    .padding()
}
