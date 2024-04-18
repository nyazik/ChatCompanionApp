//
//  RegistrationViewModelTests.swift
//  ChatCompanionTests
//
//  Created by Nazik on 12.04.2024.
//

import XCTest
@testable import ChatCompanion

class RegistrationViewModelTests: XCTestCase {
    var viewModel: RegistrationViewModel!
    var mockAPIClient: MockAPIClient!

    override func setUpWithError() throws {
        super.setUp()
        mockAPIClient = MockAPIClient()
        viewModel = RegistrationViewModel(apiClient: mockAPIClient)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockAPIClient = nil
        super.tearDown()
    }
}

// MockAPIClient to simulate network responses
class MockAPIClient: APIClient {
    var shouldReturnError = false

    override func register(username: String, email: String, password: String, completion: @escaping (Result<GenericAPIResponse, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Registration failed"])))
        } else {
            completion(.success(GenericAPIResponse(success: true, message: "Registration successful")))
        }
    }
}

extension RegistrationViewModelTests {
    func testRegistrationSuccess() {
        // Setup
        viewModel.username = "testUser"
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        viewModel.passwordConfirmation = "password123"
        
        let expectation = self.expectation(description: "RegistrationSuccess")
        
        // Execute
        viewModel.register()
        
        // Assertions
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Async handling
            XCTAssertTrue(self.viewModel.isRegistered)
            XCTAssertNil(self.viewModel.registrationError)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }

    func testRegistrationFailure_PasswordMismatch() {
        // Setup
        viewModel.username = "testUser"
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        viewModel.passwordConfirmation = "differentPassword"
        
        // Execute
        viewModel.register()
        
        // Assertions
        XCTAssertFalse(viewModel.isRegistered)
        XCTAssertNotNil(viewModel.registrationError)
        XCTAssertEqual(viewModel.registrationError, "Please check your input fields.")
    }

    func testRegistrationFailure_InvalidEmail() {
        // Setup
        viewModel.username = "testUser"
        viewModel.email = "testexample.com" // Invalid email
        viewModel.password = "password123"
        viewModel.passwordConfirmation = "password123"
        
        // Execute
        viewModel.register()
        
        // Assertions
        XCTAssertFalse(viewModel.isRegistered)
        XCTAssertNotNil(viewModel.registrationError)
        XCTAssertEqual(viewModel.registrationError, "Invalid email format.")
    }

    func testRegistrationFailure_ShortPassword() {
        // Setup
        viewModel.username = "testUser"
        viewModel.email = "test@example.com"
        viewModel.password = "pass" // Too short
        viewModel.passwordConfirmation = "pass"
        
        // Execute
        viewModel.register()
        
        // Assertions
        XCTAssertFalse(viewModel.isRegistered)
        XCTAssertNotNil(viewModel.registrationError)
        XCTAssertEqual(viewModel.registrationError, "Password must be at least 8 characters long.")
    }
}
