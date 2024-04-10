//
//  UserListView.swift
//  ChatCompanion
//
//  Created by Nazik on 6.04.2024.
//

import SwiftUI
import FirebaseAnalytics


struct UserListView: View {
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        List(viewModel.users) { user in
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading) {
                    Text(user.name)
                        .fontWeight(.bold)
                }
            }
        }
        .onAppear {
            viewModel.fetchUsers()
        }
        .analyticsScreen(name: "\(UserListView.self)")
    }
}


#Preview {
    UserListView(viewModel: UserViewModel(apiClient: MockAPIClient()))
}
