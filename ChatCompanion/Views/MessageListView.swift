//
//  MessageListView.swift
//  ChatCompanion
//
//  Created by Nazik on 7.04.2024.
//

import SwiftUI

struct MessageListView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(chatViewModel.messages) { message in
                    MessageBubble(message: message, isCurrentUser: message.userId == chatViewModel.currentUser.id)
                        .padding(.horizontal)
                        .transition(.slide)
                }
            }
        }
    }
}


#Preview {
    MessageListView(chatViewModel: MockChatViewModel())
}
