//
//  Message.swift
//  ChatCompanion
//
//  Created by Nazik on 6.04.2024.
//

import Foundation

struct Message: Identifiable, Codable {
    let id: String
    let text: String
    let userId: String
    let timestamp: Date
}
