//
//  ChatCompanionTests.swift
//  ChatCompanionTests
//
//  Created by Nazik on 6.04.2024.
//

import XCTest
@testable import ChatCompanion

class ChatViewModelTests: XCTestCase {
    var viewModel: ChatViewModel!
    var apiClientMock: APIClientMock!
    
    let currentUser: User = User(id: "1", name: "Nazik", avatarURL: "https://yourapi.domain.com/images/nazik")
    
    override func setUp() {
        super.setUp()
        apiClientMock = APIClientMock()
        viewModel = ChatViewModel(apiClient: apiClientMock, currentUser: currentUser)
    }
    
    override func tearDown() {
        viewModel = nil
        apiClientMock = nil
        super.tearDown()
    }
    
    func testCheckCurrentUser() throws {
        XCTAssertNotNil(viewModel.currentUser, "Current user from viewModel is nil")
        XCTAssertEqual(viewModel.currentUser, currentUser, "Current user from viewModel is not the same")
    }
    
    func testFetchMessagesSuccess() throws {
        let expectation = XCTestExpectation(description: "fetchMessages")
        
        viewModel.fetchMessages()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertFalse(self.viewModel.messages.isEmpty)
    }
    
    func testFetchMessagesFailure() {
        apiClientMock.shouldReturnError = true
        
        viewModel.fetchMessages()
        
        let expectation = XCTestExpectation(description: "fetchMessagesFailure")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertTrue(self.viewModel.messages.isEmpty, "Messages array should be empty after a fetch failure.")
    }
    
    func testSendMessageSuccess() {
        // Setup
        let initialMessageCount = viewModel.messages.count
        viewModel.newMessageText = "Test Message"
        apiClientMock.sendMessageSuccess = true // Ensure mock is set for success
        
        // Expectation
        let expectation = XCTestExpectation(description: "sendMessageSuccess")
        
        viewModel.sendMessage()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Verify
        XCTAssertEqual(viewModel.messages.count, initialMessageCount + 1, "A new message should be added to messages.")
        XCTAssertTrue(viewModel.newMessageText.isEmpty, "newMessageText should be cleared after sending.")
    }
    
    func testSendMessageFailure() {
        // Setup
        let initialMessageCount = viewModel.messages.count
        viewModel.newMessageText = "Failed Message"
        apiClientMock.sendMessageSuccess = false // Simulate failure response
        
        // Expectation
        let expectation = XCTestExpectation(description: "sendMessageFailure")
        
        viewModel.sendMessage()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Verify
        XCTAssertEqual(viewModel.messages.count, initialMessageCount, "No new message should be added on failure.")
        // Optionally check if an error handling mechanism, like showing an alert, was triggered
    }
}

class APIClientMock: APIClient {
    var shouldReturnError = false
    var sendMessageSuccess = true
    var mockUsers: [User] = []
    
    override func fetchMessages(completion: @escaping (Result<[Message], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch messages"])))
        } else {
            let mockMessages = [
                Message(id: "1", text: "Mock Message 1", userId: "user123", timestamp: Date()),
                Message(id: "2", text: "Mock Message 2", userId: "user456", timestamp: Date()),
            ]
            completion(.success(mockMessages))
        }
    }
    
    override func sendMessage(_ message: Message, completion: @escaping (Result<GenericAPIResponse, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "API Error", code: 400, userInfo: nil)))
        } else {
            let response = GenericAPIResponse(success: sendMessageSuccess, message: "Mock response")
            completion(.success(response))
        }
    }
    
    override func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "API Error", code: 400, userInfo: nil)))
        } else {
            completion(.success(mockUsers))
        }
    }
}

class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    var nextResponse: URLResponse?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nextData, nextResponse, nextError)
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    override func resume() {
    }
}
