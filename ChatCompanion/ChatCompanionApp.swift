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
            if viewModel.isAuthenticated, let currentUser = viewModel.currentUser {
                ChatView(viewModel: ChatViewModel(currentUser: currentUser))
            } else {
                LoginView(viewModel: LoginViewModel())
                    .environmentObject(viewModel)
            }
        }
    }
}
