import XCTest
@testable import SAUpdatePrompt

final class NetworkTests: XCTestCase {
  
  private let defaultExpectationHandler: XCWaitCompletionHandler = { (error) in
    if error != nil {
      XCTFail("Expectations Timeout")
    }
  }
  
  func testBundleIdentifierDoesNotExist() {
    
    let checkExpectation = expectation(description: "Waiting for failure result.")
    
    Network.check(for: "com.laudeon.Sage",
                  currentVersion: "1.0.0") { result in
      switch result {
      case let .failure(error):
        switch error {
        case .noResults: checkExpectation.fulfill()
        default: return
        }
      default: return
      }
    }
    
    waitForExpectations(timeout: 5, handler: defaultExpectationHandler)
    
  }
  
  func testCurrentVersionIsLessThanAvailable() {
    
    let checkExpectation = expectation(description: "Waiting for check result")
    
    Network.check(for: "co.laudeon.Sage",
                  currentVersion: "1.0.0") { result in
      switch result {
      case .success:
        checkExpectation.fulfill()
      default: return
      }
      
    }
    
    waitForExpectations(timeout: 5, handler: defaultExpectationHandler)
    
  }
  
}
