//
//  MockLoginViewModel.swift
//  ChatCompanion
//
//  Created by Stebin Alex on 09/04/24.
//

import Foundation

class MockLoginViewModel: LoginViewModel {
    
    override func login() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isAuthenticated = true
            self?.loginError = nil
        }
    }
    
    
}
