//
//  ChatCompanionApp.swift
//  ChatCompanion
//
//  Created by Nazik on 6.04.2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct ChatCompanionApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var viewModel = UserViewModel()
    let networkMonitor = NetworkMonitor()
    
    init() {
        networkMonitor.startMonitoring()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if viewModel.isAuthenticated, let currentUser = viewModel.currentUser {
                    ChatView(viewModel: ChatViewModel(currentUser: currentUser))
                } else {
                    LoginView(viewModel: LoginViewModel())
                        .environmentObject(viewModel)
                }
            }
        }
        
    }
}
