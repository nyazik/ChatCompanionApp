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
