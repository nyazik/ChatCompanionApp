//
//  Logger.swift
//  ChatCompanion
//
//  Created by Nazik on 7.04.2024.
//

import SwiftUI

class Logger {
    static func log(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
}
