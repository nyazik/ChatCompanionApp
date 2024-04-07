//
//  TextInputField.swift
//  ChatCompanion
//
//  Created by Nazik on 6.04.2024.
//

import SwiftUI

struct TextInputField: View {
    @Binding var text: String
    let placeholder: String
    let onSend: () -> Void

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: onSend) {
                Text("Send")
            }
        }
    }
}
