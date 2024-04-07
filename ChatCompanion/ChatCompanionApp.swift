//
//  ChatCompanionApp.swift
//  ChatCompanion
//
//  Created by Nazik on 6.04.2024.
//

import SwiftUI

@main
struct ChatCompanionApp: App {
    @StateObject var viewModel = UserViewModel()
    let networkMonitor = NetworkMonitor()
    
    init() {
        networkMonitor.startMonitoring()
    }
    
    var body: some Scene {
        WindowGroup {
            if viewModel.isAuthenticated {
                ChatView(viewModel: ChatViewModel())
            } else {
                LoginView(viewModel: LoginViewModel())
            }
        }
    }
}
