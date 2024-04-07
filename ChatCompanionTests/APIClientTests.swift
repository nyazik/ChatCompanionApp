//
//  APIClientTests.swift
//  ChatCompanionTests
//
//  Created by Nazik on 6.04.2024.
//

import XCTest
@testable import ChatCompanion

final class APIClientTests: XCTestCase {
    var sut: APIClient!
    var mockSession: MockURLSession!
    
    override func setUpWithError() throws {
        super.setUp()
        mockSession = MockURLSession()
        sut = APIClient(session: mockSession)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testFetchMessagesSuccess() {
        let mockMessagesJSON = """
            [
                {"id": "1", "text": "Hello, world!", "userId": "user123", "timestamp": 1683475200}
            ]
            """.data(using: .utf8)!
        
        mockSession.nextData = mockMessagesJSON
        mockSession.nextResponse = HTTPURLResponse(url: APIEndpoints.fetchMessages, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let expectation = self.expectation(description: "FetchMessages")
        var responseError: Error?
        var responseMessages: [Message]?
        
        sut.fetchMessages { result in
            switch result {
            case .success(let messages):
                responseMessages = messages
            case .failure(let error):
                responseError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            XCTAssertNil(responseError)
            XCTAssertNotNil(responseMessages)
            XCTAssertEqual(responseMessages?.count, 1)
        }
    }
    
    func testFetchCurrentUserSuccess() {
        let mockUserJSON = """
        {"id": "user123", "name": "John Doe", "avatarURL": "https://example.com/avatar.jpg"}
        """.data(using: .utf8)!
        
        mockSession.nextData = mockUserJSON
        mockSession.nextResponse = HTTPURLResponse(url: APIEndpoints.fetchCurrentUser, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let expectation = self.expectation(description: "FetchCurrentUser")
        var responseError: Error?
        var responseUser: User?
        
        sut.fetchCurrentUser { result in
            switch result {
            case .success(let user):
                responseUser = user
            case .failure(let error):
                responseError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            XCTAssertNil(responseError)
            XCTAssertNotNil(responseUser)
            XCTAssertEqual(responseUser?.id, "user123")
        }
    }
    
    func testLoginSuccess() {
        let loginSuccessJSON = """
        {
            "success": true,
            "message": "Login successful"
        }
        """.data(using: .utf8)!
        
        mockSession.nextData = loginSuccessJSON
        mockSession.nextResponse = HTTPURLResponse(url: APIEndpoints.login, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let expectation = self.expectation(description: "LoginSuccess")
        var responseError: Error?
        var loginSuccessResponse: GenericAPIResponse?
        
        sut.login(username: "testUser", password: "testPass") { result in
            switch result {
            case .success(let response):
                loginSuccessResponse = response
            case .failure(let error):
                responseError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            XCTAssertNil(responseError)
            XCTAssertNotNil(loginSuccessResponse)
            XCTAssertTrue(loginSuccessResponse?.success == true)
            XCTAssertEqual(loginSuccessResponse?.message, "Login successful")
        }
    }
    
    func testLoginFailure() {
        mockSession.nextData = nil
        mockSession.nextResponse = HTTPURLResponse(url: APIEndpoints.login, statusCode: 401, httpVersion: nil, headerFields: nil)
        mockSession.nextError = NSError(domain: "com.ChatCompanionTests", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])
        
        let expectation = self.expectation(description: "LoginFailure")
        var responseError: Error?
        var loginSuccessResponse: GenericAPIResponse?
        
        sut.login(username: "wrongUser", password: "wrongPass") { result in
            switch result {
            case .success(let response):
                loginSuccessResponse = response
            case .failure(let error):
                responseError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            XCTAssertNotNil(responseError)
            XCTAssertNil(loginSuccessResponse)
        }
    }
}
