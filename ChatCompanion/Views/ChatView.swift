//
//  ChatView.swift
//  ChatCompanion
//
//  Created by Nazik on 6.04.2024.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.messages) { message in
                        MessageBubble(message: message, isCurrentUser: message.userId == viewModel.currentUser.id)
                    }
                }
            }
            TextInputField(text: $viewModel.newMessageText, placeholder: "", onSend: viewModel.sendMessage)
        }
        .padding()
        .onAppear(perform: {
            viewModel.fetchMessages()
        })
    }
}


#Preview {
    ChatView(viewModel: MockChatViewModel())
}
