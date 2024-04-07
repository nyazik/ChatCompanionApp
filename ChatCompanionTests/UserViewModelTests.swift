//
//  UserViewModelTests.swift
//  ChatCompanionTests
//
//  Created by Nazik on 6.04.2024.
//

import XCTest
@testable import ChatCompanion

class UserViewModelTests: XCTestCase {
    var viewModel: UserViewModel!
    var apiClientMock: APIClientMock!
    
    override func setUp() {
        super.setUp()
        apiClientMock = APIClientMock()
        viewModel = UserViewModel(apiClient: apiClientMock)
    }
    
    override func tearDown() {
        viewModel = nil
        apiClientMock = nil
        super.tearDown()
    }
    
    func testFetchUsersSuccess() {
        // Given
        let users: [User] = [
            User(id: "1", name: "John Doe", avatarURL: "https://example.com/avatar1.jpg"),
        ]
        apiClientMock.mockUsers = users
        let expectation = XCTestExpectation(description: "fetchUsers")

        // When
        viewModel.fetchUsers()

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
            XCTAssertEqual(self.viewModel.users, users, "Users should be fetched successfully.")
        }

        wait(for: [expectation], timeout: 1.5)
    }

}
