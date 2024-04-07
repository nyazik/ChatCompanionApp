//
//  StringExtensions.swift
//  ChatCompanion
//
//  Created by Nazik on 6.04.2024.
//

import Foundation

extension String {
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
