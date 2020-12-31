import XCTest
@testable import SAUpdatePrompt

final class MockAppVersionService: AppVersionServiceProtocol {
  
  var noResultsFailure: Bool = false
  var genericFailure: Bool = false
  var successfulResponse: Bool = false
  
  func check(for bundleIdentifier: String,
             completion: @escaping AppVersionCompletionClosure) {
    
    if noResultsFailure {
      completion(.failure(.noResults))
    }
    
    if genericFailure {
      let genericError = NSError(domain: "com.saupdateprompt.test", code: 20, userInfo: nil)
      completion(.failure(.generic(genericError)))
    }
    
    if successfulResponse {
      completion(.success(.init(version: "1.0.0", bundleId: "com.saupdateprompt.test", minimumOsVersion: "13.0")))
    }
    
  }
  
}

final class AppVersionServiceTests: XCTestCase {
  
  private let defaultExpectationHandler: XCWaitCompletionHandler = { (error) in
    if error != nil {
      XCTFail("Expectations Timeout")
    }
  }
  
  func testNoResultsFailures() {
    
    let testExpectation = expectation(description: "Waiting for noResults failure.")
    
    let sut = MockAppVersionService()
    sut.noResultsFailure = true
    
    sut.check(for: "com.saupdateprompt.test") { result in
      switch result {
      case let .failure(error):
        switch error {
        case .noResults: testExpectation.fulfill()
        default: return
        }
      default: return
      }
    }
    
    waitForExpectations(timeout: 5, handler: defaultExpectationHandler)
    
  }
  
  func testGenericFailure() {
    
    let testExpectation = expectation(description: "Waiting for generic failure.")
    
    let sut = MockAppVersionService()
    sut.genericFailure = true
    
    sut.check(for: "com.saupdateprompt.test") { result in
      switch result {
      case let .failure(error):
        switch error {
        case .generic: testExpectation.fulfill()
        default: return
        }
      default: return
      }
    }
    
    waitForExpectations(timeout: 5, handler: defaultExpectationHandler)
    
  }
  
  func testSuccessfulResponse() {
    
    let testExpectation = expectation(description: "Waiting for successful response.")
    
    let sut = MockAppVersionService()
    sut.successfulResponse = true
    
    sut.check(for: "com.saupdateprompt.test") { result in
      switch result {
      case .success: testExpectation.fulfill()
      default: return
      }
    }
    
    waitForExpectations(timeout: 5, handler: defaultExpectationHandler)
    
  }
  
}
